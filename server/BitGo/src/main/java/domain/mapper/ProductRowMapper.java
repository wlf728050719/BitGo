package domain.mapper;

import domain.Product;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class ProductRowMapper implements RowMapper<Product> {
    @Override
    public Product mapRow(ResultSet rs, int rowNum) throws SQLException {
        Product product = new Product();
        product.setId(rs.getInt("id"));
        product.setName(rs.getString("name"));
        product.setDescription(rs.getString("description"));
        product.setPrice(rs.getDouble("price"));
        product.setLocation(rs.getString("location"));
        product.setTypeId(rs.getInt("type_id"));
        product.setDate(rs.getTimestamp("date"));
        product.setSellerId(rs.getInt("seller_id"));
        return product;
    }
}
