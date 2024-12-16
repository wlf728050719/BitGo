package service.impl;

import dao.ProductDao;
import dao.impl.ProductDaoImpl;

import domain.info.Info;
import domain.info.Result;
import domain.info.impl.dao.ProductDaoInfo;
import domain.info.impl.service.ProductServiceInfo;
import service.ProductService;

public class ProductServiceImpl implements ProductService {
    private final ProductDao productDao=new ProductDaoImpl();

    private Result changeToProductServiceResult(Result result) {
        switch ((ProductDaoInfo)result.getInfo())
        {
            case SUCCESS:return new Result(ProductServiceInfo.SUCCESS,result.getValue());
            case EMPTY_RESULT:return new Result(ProductServiceInfo.EMPTY_RESULT,null);
            default:return new Result(ProductServiceInfo.OTHER_ERROR,null);
        }
    }
    private ProductServiceInfo changeToProductServiceInfo(Info info) {
        switch ((ProductDaoInfo)info)
        {
            case SUCCESS:return ProductServiceInfo.SUCCESS;
            case EMPTY_RESULT:return ProductServiceInfo.EMPTY_RESULT;
            default:return ProductServiceInfo.OTHER_ERROR;
        }
    }
    @Override
    public Result getRandomProducts(int number) {
        return changeToProductServiceResult(productDao.getRandomProducts(number));
    }
    @Override
    public Result getProductById(int id) {
        return changeToProductServiceResult(productDao.getProductById(id));
    }
    @Override
    public Result getProductByKeyword(String keyword, int number) {
        return changeToProductServiceResult(productDao.getProductsByKeyword(keyword, number));
    }
    @Override
    public Result getProductsByTypeId(int typeId, int number) {
        return changeToProductServiceResult(productDao.getProductsByTypeId(typeId,number));
    }

    @Override
    public Result getProductsBySellerId(int sellerId) {
        return changeToProductServiceResult(productDao.getProductsBySellerId(sellerId));
    }

    @Override
    public Result publishProduct(String name, String description, double price, String location, int typeId, int sellerId)
    {
        Result result = productDao.createProduct(name,description,price,location,typeId,sellerId);
        ProductServiceInfo info = changeToProductServiceInfo(result.getInfo());
        return new Result(info,result.getValue());
    }

}
