package dao.impl;

import dao.InventoryDao;

import domain.info.Result;
import domain.info.impl.dao.InventoryDaoInfo;


import org.springframework.dao.DuplicateKeyException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;

import util.JDBCUtil;

public class InventoryDaoImpl implements InventoryDao {
    private static final JdbcTemplate jdbcTemplate = new JdbcTemplate(JDBCUtil.getDataSource());

    private InventoryDaoInfo executeUpdate(String sql, Object... args) {
        try {
            jdbcTemplate.update(sql, args);
        } catch (DuplicateKeyException e) {
            return InventoryDaoInfo.DUPLICATE_KEY;
        } catch (NullPointerException e) {
            return InventoryDaoInfo.INFO_MISSING;
        } catch (Exception e) {
            e.printStackTrace();
            return InventoryDaoInfo.OTHER_ERROR;
        }
        return InventoryDaoInfo.SUCCESS;
    }

    private Result executeQuery(String sql,Object... args) {
        try {
            int  number = jdbcTemplate.queryForObject(sql,Integer.class,args);
            return new Result(InventoryDaoInfo.SUCCESS,number);
        } catch (EmptyResultDataAccessException e) {
            return new Result(InventoryDaoInfo.EMPTY_RESULT, null);
        } catch (NullPointerException e) {
            return new Result(InventoryDaoInfo.INFO_MISSING, null);
        } catch (Exception e) {
            e.printStackTrace();
            return new Result(InventoryDaoInfo.OTHER_ERROR, null);
        }
    }

    @Override
    public Result getStockByProductId(int id) {
        String sql = "SELECT stock FROM inventory WHERE product_id = ?";
        return executeQuery(sql,id);
    }

    @Override
    public Result getSaleAmountByProductId(int id) {
        String sql = "SELECT sale_amount FROM inventory WHERE product_id = ?";
        return executeQuery(sql,id);
    }

    @Override
    public  InventoryDaoInfo setStockByProductId(int id, int amount) {
        String sql =(getStockByProductId(id).getInfo()==InventoryDaoInfo.EMPTY_RESULT)?
                "insert into inventory(stock,product_id) values(?,?)" :
                "UPDATE inventory SET stock = ? WHERE product_id = ?";
        return executeUpdate(sql,amount,id);
    }

    @Override
    public InventoryDaoInfo setSaleAmountByProductId(int id, int amount) {
        String sql = "UPDATE inventory SET sale_amount = ? WHERE product_id = ?";
        return executeUpdate(sql,amount,id);
    }
}
