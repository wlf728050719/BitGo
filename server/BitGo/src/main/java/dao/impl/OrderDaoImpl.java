package dao.impl;

import dao.OrderDao;
import domain.Order;
import domain.info.Result;
import domain.info.impl.dao.OrderDaoInfo;
import domain.mapper.OrderMapper;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import util.JDBCUtil;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class OrderDaoImpl implements OrderDao {
    private static final JdbcTemplate jdbcTemplate = new JdbcTemplate(JDBCUtil.getDataSource());

    private OrderDaoInfo executeUpdate(String sql, Object... args) {
        try {
            jdbcTemplate.update(sql, args);
        } catch (DuplicateKeyException e) {
            return OrderDaoInfo.DUPLICATE_KEY;
        } catch (NullPointerException e) {
            return OrderDaoInfo.INFO_MISSING;
        } catch (Exception e) {
            e.printStackTrace();
            return OrderDaoInfo.OTHER_ERROR;
        }
        return OrderDaoInfo.SUCCESS;
    }

    private Result executeQuery(String sql, boolean isList, Object... args) {
        try {
            if (isList) {
                List<Order> orders = jdbcTemplate.query(sql, new OrderMapper(), args);
                return new Result(OrderDaoInfo.SUCCESS, orders);
            } else {
                Order order = jdbcTemplate.queryForObject(sql, new OrderMapper(), args);
                return new Result(OrderDaoInfo.SUCCESS, order);
            }
        } catch (EmptyResultDataAccessException e) {
            return new Result(OrderDaoInfo.EMPTY_RESULT, null);
        } catch (NullPointerException e) {
            return new Result(OrderDaoInfo.INFO_MISSING, null);
        } catch (Exception e) {
            e.printStackTrace();
            return new Result(OrderDaoInfo.OTHER_ERROR, null);
        }
    }

    @Override
    public OrderDaoInfo createOrder(int buyerId, int productId, int amount, String phone, String shippingAddress, String recipientName) {
        String sql = "insert into orders(buyer_id,product_id,amount,phone,shipping_address,recipient_name) values(?,?,?,?,?,?)";
        return executeUpdate(sql, buyerId, productId, amount, phone, shippingAddress, recipientName);
    }

    @Override
    public Result getOrderById(int id) {
        String sql = "select * from orders where id = ?";
        return executeQuery(sql, false, id);
    }

    @Override
    public Result getOrdersByBuyerIdAndSearchWord(int buyerId, String searchWord) {
        String sql;
        if(searchWord!=null && !searchWord.isEmpty()){
            Pattern productId_pattern = Pattern.compile("productId\\s*[:=]\\s*(\\d+)");
            Matcher productId_matcher = productId_pattern.matcher(searchWord);
            if (productId_matcher.find()) {
                searchWord = productId_matcher.group(1);
                sql = "select * from orders where buyer_id = ? and product_id = ?";
                return executeQuery(sql, true, buyerId, searchWord);
            }
            Pattern orderId_pattern = Pattern.compile("orderId\\s*[:=]\\s*(\\d+)");
            Matcher orderId_matcher = orderId_pattern.matcher(searchWord);
            if (orderId_matcher.find()) {
                searchWord = orderId_matcher.group(1);
                sql = "select * from orders where buyer_id = ? and id = ?";
                return executeQuery(sql, true, buyerId, searchWord);
            }
        }
        sql = "SELECT o.*\n" +
                "FROM orders o\n" +
                "JOIN products p ON o.product_id = p.id\n" +
                "WHERE o.buyer_id = ? AND (p.NAME LIKE ? OR p.description LIKE ?);";
        searchWord = "%" + searchWord + "%";
        return executeQuery(sql, true, buyerId, searchWord, searchWord);
    }

    @Override
    public Result getOrdersBySellerIdAndSearchWord(int sellerId, String searchWord) {
        String sql;
        if(searchWord!=null && !searchWord.isEmpty()){
            Pattern productId_pattern = Pattern.compile("productId\\s*[:=]\\s*(\\d+)");
            Matcher productId_matcher = productId_pattern.matcher(searchWord);
            if (productId_matcher.find()) {
                searchWord = productId_matcher.group(1);
                sql = "SELECT o.*\n" +
                        "FROM orders o \n" +
                        "JOIN products p ON o.product_id = p.id \n" +
                        "WHERE p.seller_id = ? AND p.id = ?";
                return executeQuery(sql, true, sellerId, searchWord);
            }
            Pattern orderId_pattern = Pattern.compile("orderId\\s*[:=]\\s*(\\d+)");
            Matcher orderId_matcher = orderId_pattern.matcher(searchWord);
            if (orderId_matcher.find()) {
                searchWord = orderId_matcher.group(1);
                sql = "SELECT o.*\n" +
                        "FROM orders o \n" +
                        "JOIN products p ON o.product_id = p.id \n" +
                        "WHERE p.seller_id = ? AND o.id = ?";
                return executeQuery(sql, true, sellerId, searchWord);
            }
        }
        sql = "SELECT o.*\n" +
                "FROM orders o \n" +
                "JOIN products p ON o.product_id = p.id \n" +
                "WHERE p.seller_id = ? AND (p.NAME LIKE ? OR p.description LIKE ?)";
        searchWord = "%" + searchWord + "%";
        return executeQuery(sql, true, sellerId, searchWord, searchWord);
    }

    @Override
    public OrderDaoInfo changeOrderStatus(int id, Order.Status status) {
        String sql = "update orders set status = ? where id = ?";
        return executeUpdate(sql, status.toString().toLowerCase(), id);
    }

    @Override
    public OrderDaoInfo changeOrderBaseInfo(int id, int amount, String phone, String shippingAddress, String recipientName) {
        String sql = "update orders set amount=?, phone=?, shipping_address=?, recipient_name=? where id = ?";
        return executeUpdate(sql, amount, phone, shippingAddress, recipientName, id);
    }
}
