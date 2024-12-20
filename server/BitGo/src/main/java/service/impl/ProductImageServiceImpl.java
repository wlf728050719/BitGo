package service.impl;

import dao.ProductImageDao;
import dao.impl.ProductImageDaoImpl;
import domain.info.Result;

import domain.info.impl.dao.ProductImageDaoInfo;
import domain.info.impl.service.ProductImageServiceInfo;
import service.ProductImageService;

public class ProductImageServiceImpl implements ProductImageService {
    private final ProductImageDao productImageDao=new ProductImageDaoImpl();

    private Result changeToProductImageServiceResult(Result result) {
        switch ((ProductImageDaoInfo)result.getInfo())
        {
            case SUCCESS:return new Result(ProductImageServiceInfo.SUCCESS,result.getValue());
            case EMPTY_RESULT:return new Result(ProductImageServiceInfo.EMPTY_RESULT,null);
            default:return new Result(ProductImageServiceInfo.OTHER_ERROR,null);
        }
    }
    private ProductImageServiceInfo changeToProductImageServiceInfo(ProductImageDaoInfo info) {
        switch (info)
        {
            case SUCCESS:return ProductImageServiceInfo.SUCCESS;
            case EMPTY_RESULT:return ProductImageServiceInfo.EMPTY_RESULT;
            default:return ProductImageServiceInfo.OTHER_ERROR;
        }
    }
    @Override
    public Result getImagesByProductId(int productId) {
        return changeToProductImageServiceResult(productImageDao.getImagesByProductId(productId));
    }

    @Override
    public ProductImageServiceInfo createProductImages(int productId, String[] images) {
        return changeToProductImageServiceInfo(productImageDao.createProductImages(productId, images));
    }
}
