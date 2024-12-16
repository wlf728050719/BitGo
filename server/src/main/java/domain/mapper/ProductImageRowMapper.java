package domain.mapper;

import domain.ProductImage;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class ProductImageRowMapper implements RowMapper<ProductImage> {
    @Override
    public ProductImage mapRow(ResultSet rs, int rowNum) throws SQLException {
        ProductImage productImage = new ProductImage();
        productImage.setId(rs.getInt("id"));
        productImage.setProductId(rs.getInt("product_id"));
        productImage.setImageUrl(rs.getString("image_url"));
        return productImage;
    }
}
