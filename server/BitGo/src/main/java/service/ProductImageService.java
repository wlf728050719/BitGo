package service;

import domain.info.Result;
import domain.info.impl.service.ProductImageServiceInfo;

public interface ProductImageService {
    public Result getImagesByProductId(int productId);
    public ProductImageServiceInfo createProductImages(int productId, String[] images);
}
