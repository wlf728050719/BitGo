export enum ProductType {
  ALL = '全部商品',
  COUPONS = '优惠券码',//1
  HOME = '家居生活',//2
  BEAUTY = '美容彩妆',//3
  BABY = '母婴用品',//4
  DIGITAL = '数码产品',//5
  CLOTHING = '服饰鞋帽',//6
  SPORTS = '运动户外',//7
  TOYS = '模玩动漫',//8
  PETS = '宠物花卉',//9
  APPLIANCES = '家用电器',//10
  BAGS = '包表首饰',//11
  BOOKS = '图书音像',//12
  OFFICE = '办公文具',//13
  CRAFTS = '手工艺品',//14
  ANTIQUES = '古玩收藏'//15
}
export function productTypeToNumber(type: ProductType): number {
  switch (type) {
    case ProductType.ALL:
      return 0;
    case ProductType.COUPONS:
      return 1;
    case ProductType.HOME:
      return 2;
    case ProductType.BEAUTY:
      return 3;
    case ProductType.BABY:
      return 4;
    case ProductType.DIGITAL:
      return 5;
    case ProductType.CLOTHING:
      return 6;
    case ProductType.SPORTS:
      return 7;
    case ProductType.TOYS:
      return 8;
    case ProductType.PETS:
      return 9;
    case ProductType.APPLIANCES:
      return 10;
    case ProductType.BAGS:
      return 11;
    case ProductType.BOOKS:
      return 12;
    case ProductType.OFFICE:
      return 13;
    case ProductType.CRAFTS:
      return 14;
    case ProductType.ANTIQUES:
      return 15;
    default:
      throw new Error('Invalid ProductType');
  }
}

export function numberToProductType(num: number): ProductType {
  switch (num) {
    case 0:
      return ProductType.ALL;
    case 1:
      return ProductType.COUPONS;
    case 2:
      return ProductType.HOME;
    case 3:
      return ProductType.BEAUTY;
    case 4:
      return ProductType.BABY;
    case 5:
      return ProductType.DIGITAL;
    case 6:
      return ProductType.CLOTHING;
    case 7:
      return ProductType.SPORTS;
    case 8:
      return ProductType.TOYS;
    case 9:
      return ProductType.PETS;
    case 10:
      return ProductType.APPLIANCES;
    case 11:
      return ProductType.BAGS;
    case 12:
      return ProductType.BOOKS;
    case 13:
      return ProductType.OFFICE;
    case 14:
      return ProductType.CRAFTS;
    case 15:
      return ProductType.ANTIQUES;
    default:
      throw new Error('Invalid number for ProductType');
  }
}
class ProductModel{
  id:number
  name:string
  price:number
  description:string
  location:string
  tags:string[]
  images:string[]
  type:ProductType
  sellerId:number
  equal(other:ProductModel){
    return this.id==other.id;
  }
  public static getDefaultProductModel()
  {
    return new ProductModel(0,"",0,"","",[],[],ProductType.ALL,0);
  }
  static copy(origin:ProductModel)
  {
    return new ProductModel(origin.id,origin.name,origin.price,origin.description,origin.location,origin.tags,origin.images,origin.type,origin.sellerId);
  }

  constructor(id: number, name: string, price: number, description: string, location: string, tags: string[],
    images: string[], type: ProductType,sellerId:number) {
    this.id = id
    this.name = name
    this.price = price
    this.description = description
    this.location = location
    this.tags = tags
    this.images = images
    this.type = type
    this.sellerId = sellerId;
  }


  toString(): string {
    return `Product ID: ${this.id}, Name: ${this.name}, Price: ${this.price}, Description: ${this.description}, Location: ${this.location}, Tags: [${this.tags.join(', ')}], Images: [${this.images.join(', ')}]`;
  }
}
export default ProductModel
