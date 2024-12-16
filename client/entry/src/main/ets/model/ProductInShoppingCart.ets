import ProductModel from './ProductModel'
@Observed
export class ProductInShoppingCart
{
  productModel:ProductModel;
  num:number;

  static copy(origin:ProductInShoppingCart)
  {
    return new ProductInShoppingCart(ProductModel.copy(origin.productModel),origin.num);
  }
  constructor(productModel: ProductModel, num: number) {
    this.productModel = productModel;
    this.num = num;
  }
}