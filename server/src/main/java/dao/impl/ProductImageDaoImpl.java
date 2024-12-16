package dao.impl;

import dao.ProductImageDao;
import domain.ProductImage;
import domain.info.Result;
import domain.info.impl.dao.ProductImageDaoInfo;
import domain.mapper.ProductImageRowMapper;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import util.JDBCUtil;

import java.util.List;

public class ProductImageDaoImpl implements ProductImageDao {

    private static final JdbcTemplate jdbcTemplate = new JdbcTemplate(JDBCUtil.getDataSource());

    private ProductImageDaoInfo executeUpdate(String sql, Object... args) {
        try {
            jdbcTemplate.update(sql, args);
        } catch (DuplicateKeyException e) {
            return ProductImageDaoInfo.DUPLICATE_KEY;
        } catch (NullPointerException e) {
            return ProductImageDaoInfo.INFO_MISSING;
        } catch (Exception e) {
            e.printStackTrace();
            return ProductImageDaoInfo.OTHER_ERROR;
        }
        return ProductImageDaoInfo.SUCCESS;
    }

    private Result executeQuery(String sql, boolean isList,Object... args) {
        try {
            if(isList)
            {
                List<ProductImage> images = jdbcTemplate.query(sql, new ProductImageRowMapper(),args);
                return new Result(ProductImageDaoInfo.SUCCESS,images);
            }
            else
            {
                ProductImage image = jdbcTemplate.queryForObject(sql, new ProductImageRowMapper(), args);
                return new Result(ProductImageDaoInfo.SUCCESS,image);
            }
        } catch (EmptyResultDataAccessException e) {
            return new Result(ProductImageDaoInfo.EMPTY_RESULT, null);
        } catch (NullPointerException e) {
            return new Result(ProductImageDaoInfo.INFO_MISSING, null);
        } catch (Exception e) {
            e.printStackTrace();
            return new Result(ProductImageDaoInfo.OTHER_ERROR, null);
        }
    }


    @Override
    public Result getImagesByProductId(int productId) {
        String sql = "select * from product_images where product_id=?";
        return executeQuery(sql,true,productId);
    }

    @Override
    public ProductImageDaoInfo createProductImages(int productId, String[] images) {
        for (String image : images) {
            String sql = "insert into product_images(product_id,image_url) values(?,?)";
            ProductImageDaoInfo info = executeUpdate(sql,productId,image);
            if(info!=ProductImageDaoInfo.SUCCESS)
                return info;
        }
        return ProductImageDaoInfo.SUCCESS;
    }
}
