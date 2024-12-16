package dao.impl;

import com.mysql.jdbc.Statement;
import dao.ProductDao;
import domain.Product;
import domain.info.Info;
import domain.info.Result;
import domain.info.impl.dao.ProductDaoInfo;
import domain.mapper.ProductRowMapper;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import util.JDBCUtil;

import java.sql.PreparedStatement;
import java.util.List;

public class ProductDaoImpl implements ProductDao {

    private static final JdbcTemplate jdbcTemplate = new JdbcTemplate(JDBCUtil.getDataSource());

    private ProductDaoInfo executeUpdate(String sql, Object... args) {
        try {
            jdbcTemplate.update(sql, args);
        } catch (DuplicateKeyException e) {
            return ProductDaoInfo.DUPLICATE_KEY;
        } catch (NullPointerException e) {
            return ProductDaoInfo.INFO_MISSING;
        } catch (Exception e) {
            e.printStackTrace();
            return ProductDaoInfo.OTHER_ERROR;
        }
        return ProductDaoInfo.SUCCESS;
    }

    private Result executeQuery(String sql,boolean isList,Object... args) {
        try {
            if(isList)
            {
                List<Product> products = jdbcTemplate.query(sql, new ProductRowMapper(),args);
                return new Result(ProductDaoInfo.SUCCESS,products);
            }
            else
            {
                Product product = jdbcTemplate.queryForObject(sql, new ProductRowMapper(), args);
                return new Result(ProductDaoInfo.SUCCESS, product);
            }
        } catch (EmptyResultDataAccessException e) {
            return new Result(ProductDaoInfo.EMPTY_RESULT, null);
        } catch (NullPointerException e) {
            return new Result(ProductDaoInfo.INFO_MISSING, null);
        } catch (Exception e) {
            e.printStackTrace();
            return new Result(ProductDaoInfo.OTHER_ERROR, null);
        }
    }
    @Override
    public Result createProduct(String name, String description, double price, String location, int typeId, int sellerId) {
        try {

            String sql = "INSERT INTO products(name, description, price, location, type_Id, seller_Id) VALUES (?, ?, ?, ?, ?, ?)";
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(connection -> {
                PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, name);
                ps.setString(2, description);
                ps.setDouble(3, price);
                ps.setString(4, location);
                ps.setInt(5, typeId);
                ps.setInt(6, sellerId);
                return ps;
            }, keyHolder);
            return new Result(ProductDaoInfo.SUCCESS, keyHolder.getKey().intValue());
        }catch (DuplicateKeyException e) {
            return new Result(ProductDaoInfo.DUPLICATE_KEY, null);
        }catch (NullPointerException e) {
            return new Result(ProductDaoInfo.INFO_MISSING, null);
        }catch (Exception e) {
            e.printStackTrace();
            return new Result(ProductDaoInfo.OTHER_ERROR, null);
        }
    }
    @Override
    public Result getRandomProducts(int number) {
        String sql = "select * from products order by rand() limit ?";
        return executeQuery(sql,true,number);
    }
    @Override
    public Result getProductById(int id) {
        String sql = "select * from products where id=?";
        return executeQuery(sql,false,id);
    }
    @Override
    public Result getProductsByKeyword(String keyword, int number) {
        String sql = "select * from products where name like ? or description like ? order by rand() limit ?";
        keyword = "%" + keyword + "%";
        return executeQuery(sql,true,keyword,keyword,number);
    }
    @Override
    public Result getProductsByTypeId(int typeId, int number) {
        String sql = "select * from products where type_id=? order by rand() limit ?";
        return executeQuery(sql,true,typeId,number);
    }
    @Override
    public Result getProductsBySellerId(int sellerId) {
        String sql = "select * from products where seller_id=?";
        return executeQuery(sql,true,sellerId);
    }

}
