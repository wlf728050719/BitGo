package service;

import domain.info.Result;

public interface ProductService {

    Result getRandomProducts(int number);

    Result getProductById(int id);

    Result getProductByKeyword(String keyword, int number);

    Result getProductsByTypeId(int typeId, int number);

    Result getProductsBySellerId(int sellerId);

    Result publishProduct(String name, String description, double price, String location, int typeId, int sellerId);
}
