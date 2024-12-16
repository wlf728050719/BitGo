package dao;

import domain.info.Result;

public interface ProductDao {
    Result createProduct(String name, String description, double price,String location,int typeId,int sellerId);

    Result getRandomProducts(int number);

    Result getProductById(int id);

    Result getProductsByKeyword(String keyWord, int number);

    Result getProductsByTypeId(int typeId, int number);

    Result getProductsBySellerId(int sellerId);

}
