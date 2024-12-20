package dao;

import domain.info.Result;
import domain.info.impl.dao.ProductImageDaoInfo;

public interface ProductImageDao {
    Result getImagesByProductId(int productId);
    ProductImageDaoInfo createProductImages(int productId, String[] images);
}
