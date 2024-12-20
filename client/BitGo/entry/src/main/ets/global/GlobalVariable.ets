import { ProductInShoppingCart } from '../model/ProductInShoppingCart'
import ProductModel, { ProductType, productTypeToNumber } from '../model/ProductModel'
import OrderModel, { OrderStatus, orderStatusToString } from '../model/OrderModel'
import { Bank } from './Constant';
import UserModel from '../model/UserModel';
import { http } from '@kit.NetworkKit';
import CommentModel  from '../model/CommentModel';
import Info from '../model/Info';
import Result from '../model/Result';
import PreferencesUtil from '../util/PreferencesUtil';
import { UserFavoriteModel } from '../model/UserFavoriteModel';

export class GlobalVariable {
  private static instance: GlobalVariable;
  private token: string = "";
  private IDCards: Bank[] = [Bank.ICBC, Bank.CCB, Bank.BOC, Bank.ABC, Bank.BCOM]
  private user: UserModel = UserModel.getDefaultUserModel();
  private url: string = "192.168.56.1:80/BitGo";
  private loginState: boolean = false;
  private productsInShoppingCart: ProductInShoppingCart[] = [];

  public setUrl(ip:string,port:string)
  {
    this.url = ip+':'+port+'/BitGo'
  }
  public static getInstance(): GlobalVariable {
    if (!GlobalVariable.instance) {
      GlobalVariable.instance = new GlobalVariable();
    }
    return GlobalVariable.instance;
  }

  public getUser() {
    return this.user;
  }

  public async getUsernameById(id:number):Promise<string> {
    let method="getUsernameById";
    try {
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(this.url + "/userInfoGet", {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
          },
          extraData:JSON.stringify({method,id}),
          usingProtocol: http.HttpProtocol.HTTP1_1
        }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("GetUsernameByIdResponse:"+data.result.toString());
      let username:string = JSON.parse(data.result.toString());
      return username;
    } catch (error) {
      console.error("GetUsernameByIdError:" + error);
      return "";
    }
  }
  public async changeUserName(username:string):Promise<Info>
  {
    try {
      let method:string = "changeUsername"
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(
          this.url + "/userInfoSet",
          {
            method: http.RequestMethod.POST,
            header: {
              'Content-Type': 'application/json',
              'Authorization':this.token
            },
            extraData: JSON.stringify({method,username})
          }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("ChangeUserNameResponse:"+data.result.toString());
      let info:Info = JSON.parse(data.result.toString());
      return info;
    } catch (err) {
      console.error("ChangeUserNameError:"+err);
      return Info.getErrorInfo();
    }
  }
  public async changePassword(password:string):Promise<Info>
  {
    try {
      let method:string = "changePassword"
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(
          this.url + "/userInfoSet",
          {
            method: http.RequestMethod.POST,
            header: {
              'Content-Type': 'application/json',
              'Authorization':this.token
            },
            extraData: JSON.stringify({method,password})
          }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("ChangePasswordResponse:"+data.result.toString());
      let info:Info = JSON.parse(data.result.toString());
      return info;
    } catch (err) {
      console.error("ChangePasswordError:"+err);
      return Info.getErrorInfo();
    }
  }
  public async changeEmail(oldEmail:string,newEmail:string,oldEmailCheckCode:string,newEmailCheckCode:string):Promise<Info>
  {
    try {
      let method:string = "changeEmail"
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(
          this.url + "/userInfoSet",
          {
            method: http.RequestMethod.POST,
            header: {
              'Content-Type': 'application/json',
              'Authorization':this.token
            },
            extraData: JSON.stringify({method,oldEmail,newEmail,oldEmailCheckCode,newEmailCheckCode})
          }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("ChangeEmailResponse:"+data.result.toString());
      let info:Info = JSON.parse(data.result.toString());
      return info;
    } catch (err) {
      console.error("ChangeEmailError:"+err);
      return Info.getErrorInfo();
    }
  }
  public getLoginState(): boolean {
    return this.loginState;
  }

  public setLoginState(newState: boolean) {
    this.loginState=newState;
  }

  public async getProductsBySellerId(sellerId:number):Promise<ProductModel[]> {
    try {
      let method:string = "getProductsBySellerId";
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(
          this.url + "/productGet",
          {
            method: http.RequestMethod.POST,
            header: {
              'Content-Type': 'application/json'
            },
            extraData: JSON.stringify({method,sellerId})
          }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("GetProductsBySellerIdResponse:"+data.result.toString());
      let obj:object = JSON.parse(data.result.toString());
      let value:ProductModel[] = (obj as object)?.["value"];
      for(let product of value)
      {
        product.tags=[];
        await this.loadProductImages(product);
      }
      return value;
    } catch (err) {
      console.error("GetProductsBySellerIdError:"+err);
      let products:ProductModel[]=[]
      return products;
    }
  }

  public async emailCheck(email:string):Promise<Info> {
    try {
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(
          this.url + "/checkCode",
          {
            method: http.RequestMethod.POST,
            header: {
              'Content-Type': 'application/json'
            },
            extraData: JSON.stringify({email})
          }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("EmailCheckResponse:"+data.result.toString());
      let info:Info = JSON.parse(data.result.toString());
      return info;
    } catch (err) {
      console.error("EmailCheckError:"+err);
      return Info.getErrorInfo();
    }
  }

  public async register(account:string,username: string, password: string,email:string,code:string):Promise<Info> {
    try {
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(
          this.url + "/register",
          {
            method: http.RequestMethod.POST,
            header: {
              'Content-Type': 'application/json'
            },
            extraData: JSON.stringify({account,username,password,email,code})
          }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("RegisterResponse:"+data.result.toString());
      let info:Info = JSON.parse(data.result.toString());
      return info;
    } catch (err) {
      console.error("RegisterError:"+err)
      return Info.getErrorInfo();
    }
  }

  public async login(account: string, password: string):Promise<Info> {
    try {
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(
          this.url + "/login",
          {
            method: http.RequestMethod.POST,
            header: {
              'Content-Type': 'application/json'
            },
            extraData: JSON.stringify({account,password})
          }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("LoginResponse:"+data.result.toString());
      let obj:object = JSON.parse(data.result.toString());
      try {
        let result:Result = (obj as object)?.["result"];
        if(result.info.result)
        {
          this.user = result.value as UserModel;
          this.token = (obj as object)?.["token"];
          this.setLoginState(true);
        }
        return result.info;
      }catch (err)
      {
        let info:Info = (obj as object)?.["info"];
        return info;
      }
    } catch (err) {
      console.error("LoginError:"+err)
      return Info.getErrorInfo();
    }
  }

  public async logout() {
    let id:number = this.getUser().id;
    try {
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(
          this.url + "/logout",
          {
            method: http.RequestMethod.POST,
            header: {
              'Content-Type': 'application/json'
            },
            extraData: JSON.stringify({id})
          }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("LogoutResponse:"+data.result.toString());
      let info:Info = JSON.parse(data.result.toString());
      if(info.result)
      {
        this.user = new UserModel(0,'','','');
        this.token='';
        this.setLoginState(false);
      }
      return info;
    } catch (err) {
      console.error("LogoutError:"+err)
      return Info.getErrorInfo();
    }
  }

  public async publishProduct(name: string, price: number, description: string, location: string, images: string[],
    type: ProductType, stock: number): Promise<Info> {
    let method:string = "publishProduct";
    let typeId:number = productTypeToNumber(type);
    try {
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(
          this.url + "/productSet",
          {
            method: http.RequestMethod.POST,
            header: {
              'Content-Type': 'application/json',
              'Authorization':this.token
            },
            extraData: JSON.stringify({method,name,price,description,location,typeId})
          }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("PublishProductResponse:"+data.result.toString());
      let obj:object = JSON.parse(data.result.toString());
      let createProductInfo:Info = (obj as object)?.["info"];
      let productId:number = (obj as object)?.["value"];
      if(createProductInfo.result)
      {
        let createProductImageInfo:Info = await this.uploadProductImages(productId,images);
        if(createProductImageInfo.result)
        {
          let setStockByProductIdInfo:Info = await this.setStockByProductId(productId,stock);
          return setStockByProductIdInfo;
        }
        return createProductImageInfo;
      }
      else
        return createProductInfo;
    } catch (err) {
      console.error("PublishProductError:"+err)
      return Info.getErrorInfo();
    }
  }

  public async uploadProductImages(productId:number,_images:string[]):Promise<Info> {
    const images: string = _images.join(",");
    let method:string = "createProductImages"
    try {
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(
          this.url + "/productImageSet",
          {
            method: http.RequestMethod.POST,
            header: {
              'Content-Type': 'application/json',
              'Authorization':this.token
            },
            extraData: JSON.stringify({method,productId,images})
          }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("UploadProductImagesResponse:"+data.result.toString());
      let info:Info = JSON.parse(data.result.toString());
      return info;
    } catch (err) {
      console.error("UploadProductImagesError:"+err)
      return Info.getErrorInfo();
    }
  }

  public async loadProductImages(product: ProductModel) {
    let id:number = product.id;
    try {
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(this.url + "/productImageGet", {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
          },
          extraData:JSON.stringify({id}),
          usingProtocol: http.HttpProtocol.HTTP1_1
        }
          , (err, data) => {
            httpRequest.off('headersReceive');
            httpRequest.destroy();
            if (!err) {
              resolve(data);
            } else {
              reject(data);
            }
          });
      });
      console.log("LoadProductImagesResponse:"+data.result.toString());
      let urls:string[] = JSON.parse(data.result.toString());
      product.images = urls;
    } catch (error) {
      console.log("LoadProductImagesError:" + error);
    }
  }

  public async getSeveralProductsFromAllTypes(number: number): Promise<ProductModel[]> {
    try {
      let method:string = "getRandomProducts";
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(
          this.url + "/productGet",
          {
            method: http.RequestMethod.POST,
            header: {
              'Content-Type': 'application/json'
            },
            extraData: JSON.stringify({method,number})
          }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("GetSeveralProductsFromAllTypesResponse:"+data.result.toString());
      let obj:object = JSON.parse(data.result.toString());
      let value:ProductModel[] = (obj as object)?.["value"];
      for(let product of value)
      {
        product.tags=[];
        await this.loadProductImages(product);
      }
      return value;
    } catch (err) {
      console.error("GetSeveralProductsFromAllTypesError:"+err);
      let products:ProductModel[]=[]
      return products;
    }
  }

  public async getSeveralProductsFromOneType(number: number, type: ProductType): Promise<ProductModel[]> {
    if(type==ProductType.ALL)
      return await this.getSeveralProductsFromAllTypes(number);
    else
    {
      let typeId = productTypeToNumber(type);
      try {
        let method:string = "getProductsByTypeId";
        let httpRequest = http.createHttp();
        let data = await new Promise<http.HttpResponse>((resolve, reject) => {
          httpRequest.request(
            this.url + "/productGet",
            {
              method: http.RequestMethod.POST,
              header: {
                'Content-Type': 'application/json'
              },
              extraData: JSON.stringify({method,number,typeId})
            }, (err, data) => {
            httpRequest.off('headersReceive');
            httpRequest.destroy();
            if (!err) {
              resolve(data);
            } else {
              reject(data);
            }
          });
        });
        console.log("GetSeveralProductsFromOneTypeResponse:"+data.result.toString());
        let obj:object = JSON.parse(data.result.toString());
        let value:ProductModel[] = (obj as object)?.["value"];
        for(let product of value)
        {
          product.tags=[];
          await this.loadProductImages(product);
        }
        return value;
      } catch (err) {
        console.error("GetSeveralProductsFromOneTypeError:"+err);
        let products:ProductModel[]=[]
        return products;
      }
    }
  }

  public async getProductsByKeyword(keyword: string, number: number):Promise<ProductModel[]> {
    try {
      let method:string = "getProductsByKeyword";
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(
          this.url + "/productGet",
          {
            method: http.RequestMethod.POST,
            header: {
              'Content-Type': 'application/json'
            },
            extraData: JSON.stringify({method,number,keyword})
          }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("GetProductsByKeywordResponse:"+data.result.toString());
      let obj:object = JSON.parse(data.result.toString());
      let value:ProductModel[] = (obj as object)?.["value"];
      for(let product of value)
      {
        product.tags=[];
        await this.loadProductImages(product);
      }
      return value;
    } catch (err) {
      console.error("GetProductsByKeywordError:"+err);
      let products:ProductModel[]=[]
      return products;
    }
  }

  public async getProductById(id: number): Promise<ProductModel>{
    let method="getProductById";
    try {
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(this.url + "/productGet", {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
          },
          extraData:JSON.stringify({method,id}),
          usingProtocol: http.HttpProtocol.HTTP1_1
        }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("GetProductByIdResponse:"+data.result.toString());
      let obj:object = JSON.parse(data.result.toString());
      let product:ProductModel= (obj as object)?.["value"];
      product.tags=[];
      await this.loadProductImages(product);
      return product;
    } catch (error) {
      console.error("GetProductByIdError:" + error);
      return ProductModel.getDefaultProductModel();
    }
  }

  public async getStockByProductId(productId:number):Promise<number> {
    try {
      let method:string ="getStockByProductId";
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(
          this.url + "/inventoryGet",
          {
            method: http.RequestMethod.POST,
            header: {
              'Content-Type': 'application/json'
            },
            extraData: JSON.stringify({method,productId})
          }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("GetStockByProductIdResponse:"+data.result.toString());
      let obj:object = JSON.parse(data.result.toString());
      let value:number = (obj as object)?.["value"];
      return value;
    } catch (err) {
      console.error("GetStockByProductIdError:"+err)
      return 0;
    }
  }

  public async setStockByProductId(productId:number,stock:number):Promise<Info>{
    let method:string = "setStockByProductId"
    try {
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(
          this.url + "/inventorySet",
          {
            method: http.RequestMethod.POST,
            header: {
              'Content-Type': 'application/json',
              'Authorization':this.token
            },
            extraData: JSON.stringify({method,productId,stock})
          }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("SetStockByProductIdResponse:"+data.result.toString());
      let info:Info = JSON.parse(data.result.toString());
      return info;
    } catch (err) {
      console.error("SetStockByProductIdError:"+err)
      return Info.getErrorInfo();
    }
  }

  public async getSaleAmountByProductId(productId:number):Promise<number>{
    try {
      let method:string ="getSaleAmountByProductId";
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(
          this.url + "/inventoryGet",
          {
            method: http.RequestMethod.POST,
            header: {
              'Content-Type': 'application/json'
            },
            extraData: JSON.stringify({method,productId})
          }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("GetSaleAmountByProductIdResponse:"+data.result.toString());
      let obj:object = JSON.parse(data.result.toString());
      let value:number = (obj as object)?.["value"];
      return value;
    } catch (err) {
      console.error("GetSaleAmountByProductIdError:"+err)
      return 0;
    }
  }

  public async createOrder(product: ProductModel, amount: number, recipientName: string, phone: string,
    shippingAddress: string):Promise<Info> {
    let productId:number = product.id;
    try {
      let method:string ="createOrder";
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(
          this.url + "/orderSet",
          {
            method: http.RequestMethod.POST,
            header: {
              'Content-Type': 'application/json',
              'Authorization':this.token
            },
            extraData: JSON.stringify({method,productId,amount,phone,shippingAddress,recipientName})
          }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("CreateOrderResponse:"+data.result.toString());
      let info:Info = JSON.parse(data.result.toString());
      return info;
    } catch (err) {
      console.error("CreateOrderError:"+err)
      return Info.getErrorInfo();
    }
  }

  public async getBuyOrdersContainsSearchWord(searchWord:string): Promise<OrderModel[]> {
    try {
      let userId:number=this.getUser().id;
      let method:string ="getBuyOrdersContainsSearchWord";
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(
          this.url + "/orderGet",
          {
            method: http.RequestMethod.POST,
            header: {
              'Content-Type': 'application/json',
              'Authorization':this.token
            },
            extraData: JSON.stringify({method,userId,searchWord})
          }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("GetBuyOrdersContainsSearchWordResponse:"+data.result.toString());
      let orders:OrderModel[] =[]
      let obj:object = JSON.parse(data.result.toString());
      let value:object[] = (obj as object)?.["value"];
      for(let temp of value)
      {
        let order:OrderModel = OrderModel.parseObject(temp);
        orders.push(order);
      }
      console.log(orders.length.toString())
      return orders;
    } catch (err) {
      console.error("GetBuyOrdersContainsSearchWordError:"+err)
      let orders:OrderModel[] = [];
      return orders;
    }
  }
  public async getSellOrdersContainsSearchWord(searchWord:string): Promise<OrderModel[]> {
    try {
      let userId:number=this.getUser().id;
      let method:string ="getSellOrdersContainsSearchWord";
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(
          this.url + "/orderGet",
          {
            method: http.RequestMethod.POST,
            header: {
              'Content-Type': 'application/json',
              'Authorization':this.token
            },
            extraData: JSON.stringify({method,userId,searchWord})
          }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("GetSellOrdersContainsSearchWordResponse:"+data.result.toString());
      let orders:OrderModel[] =[]
      let obj:object = JSON.parse(data.result.toString());
      let value:object[] = (obj as object)?.["value"];
      for(let temp of value)
      {
        let order:OrderModel = OrderModel.parseObject(temp);
        orders.push(order);
      }
      console.log(orders.length.toString())
      return orders;
    } catch (err) {
      console.error("GetSellOrdersContainsSearchWordError:"+err)
      let orders:OrderModel[] = [];
      return orders;
    }
  }
  public async getOrderById(id:number):Promise<OrderModel> {
    try {
      let method:string ="getOrderById";
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(
          this.url + "/orderGet",
          {
            method: http.RequestMethod.POST,
            header: {
              'Content-Type': 'application/json',
            },
            extraData: JSON.stringify({method,id})
          }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("GetOrderByIdResponse:"+data.result.toString());
      let obj:object = JSON.parse(data.result.toString());
      let value:object = (obj as object)?.["value"];
      let order:OrderModel = OrderModel.parseObject(value);
      return order;
    } catch (err) {
      console.error("GetOrderByIdError:"+err)
      return OrderModel.getDefaultOrderModel();
    }
  }

  public async getBuyOrdersByStatusAndSearchWord(status: OrderStatus,searchWord:string) {
    let result: OrderModel[] = []
    let orders:OrderModel[] = await this.getBuyOrdersContainsSearchWord(searchWord);
    for (let item of orders) {
      if (item.status === status) {
        result.push(item)
      }
    }
    return result;
  }
  public async getSellOrdersByStatusAndSearchWord(status: OrderStatus,searchWord:string) {
    let result: OrderModel[] = []
    let orders:OrderModel[] = await this.getSellOrdersContainsSearchWord(searchWord);
    for (let item of orders) {
      if (item.status === status) {
        result.push(item)
      }
    }
    return result;
  }
  public async changeOrderStatus(id:number, _status: OrderStatus) {
    let method:string="changeOrderStatus";
    let status:string=orderStatusToString(_status);
    try {
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(this.url + "/orderSet", {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Authorization': this.token,
          },
          extraData: JSON.stringify({method,id,status}),
          usingProtocol: http.HttpProtocol.HTTP1_1
        }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("ChangeOrderStatusResponse:"+data.result.toString());
    } catch (error) {
      console.log("ChangeOrderStatusError:" + error);
    }
  }

  public async changeOrderBaseInfo(id: number, amount: number, recipientName: string, phone: string, shippingAddress: string) {
    let method:string="changeOrderBaseInfo";
    try {
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(this.url + "/orderSet", {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Authorization': this.token,
          },
          extraData: JSON.stringify({method,id,amount,recipientName,phone,shippingAddress}),
          usingProtocol: http.HttpProtocol.HTTP1_1
        }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("ChangeOrderBaseInfoResponse:"+data.result.toString());
    } catch (error) {
      console.log("ChangeOrderBaseInfoError:" + error);
    }
  }

  public async createOriginalComment(orderId:number,description:string,score:number) {
    let method:string="createOriginalComment";
    try {
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(this.url + "/commentSet", {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Authorization':this.token,
          },
          extraData: JSON.stringify({method,orderId,description,score}),
          usingProtocol: http.HttpProtocol.HTTP1_1
        }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("CreateOriginalCommentResponse:"+data.result.toString())
    } catch (error) {
      console.log("CreateOriginalCommentError:" + error);
    }
  }

  public async createFollowComment(orderId:number,description:string,lastId:number)
  {
    let method:string="createFollowComment";
    try {
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(this.url + "/commentSet", {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Authorization':this.token,
          },
          extraData: JSON.stringify({method,orderId,description,lastId}),
          usingProtocol: http.HttpProtocol.HTTP1_1
        }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("CreateFollowCommentResponse:"+data.result.toString())
    } catch (error) {
      console.log("CreateFollowCommentError:" + error);
    }
  }
  public async createReplyComment(orderId:number,description:string,lastId:number)
  {
    let method:string="createReplyComment";
    try {
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(this.url + "/commentSet", {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Authorization':this.token,
          },
          extraData: JSON.stringify({method,orderId,description,lastId}),
          usingProtocol: http.HttpProtocol.HTTP1_1
        }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("CreateReplyCommentResponse:"+data.result.toString())
    } catch (error) {
      console.log("CreateReplyCommentError:" + error);
    }
  }
  public async getOriginalComments(productId:number):Promise<CommentModel[]>{
    let comments:CommentModel[] = []
    let method:string="getOriginalComments";
    try {
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(this.url + "/commentGet", {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
          },
          extraData:JSON.stringify({method,productId}),
          usingProtocol: http.HttpProtocol.HTTP1_1
        }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("GetOriginalCommentsResponse:"+data.result.toString())
      let obj:object = JSON.parse(data.result.toString());
      let value:object[] = (obj as object)?.["value"];
      for(let temp of value)
      {
        let comment:CommentModel = CommentModel.parseObject(temp);
        comments.push(comment);
      }
    } catch (error) {
      console.log("GetOriginalCommentsError:" + error);
    }
    return comments;
  }

  public async getAllCommentsByOrderId(id:number):Promise<CommentModel[]>{
    let comments:CommentModel[] = []
    let method:string = "getAllCommentsByOrderId";
    try {
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(this.url + "/commentGet", {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json'
          },
          extraData: JSON.stringify({method,id}),
          usingProtocol: http.HttpProtocol.HTTP1_1
        }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("GetAllCommentsByOrderIdResponse:"+data.result.toString())
      let obj:object = JSON.parse(data.result.toString());
      let value:object[] = (obj as object)?.["value"];
      for(let temp of value)
      {
        let comment:CommentModel = CommentModel.parseObject(temp);
        comments.push(comment);
      }
    } catch (error) {
      console.log("GetAllCommentsByOrderIdError:" + error);
    }
    return comments;
  }

  public async getAllComments(id:number):Promise<CommentModel[]>{
    let comments:CommentModel[] = []
    let method:string="getAllComments";
    try {
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(this.url + "/commentGet", {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
          },
          extraData:JSON.stringify({method,id}),
          usingProtocol: http.HttpProtocol.HTTP1_1
        }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("GetAllCommentsResponse:"+data.result.toString())
      let obj:object = JSON.parse(data.result.toString());
      let value:object[] = (obj as object)?.["value"];
      for(let temp of value)
      {
        let comment:CommentModel = CommentModel.parseObject(temp);
        comments.push(comment);
      }

    } catch (error) {
      console.log("GetAllCommentsError:" + error);
    }
    return comments;
  }
  public async changeScoreByOrderId(orderId:number,score:number):Promise<Info>
  {
    let method:string="changeScoreByOrderId";
    try {
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(this.url + "/commentSet", {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Authorization':this.token,
          },
          extraData:JSON.stringify({method,orderId,score}),
          usingProtocol: http.HttpProtocol.HTTP1_1
        }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("ChangeScoreByOrderIdResponse:"+data.result.toString())
      let info:Info = JSON.parse(data.result.toString());
      return info;
    } catch (error) {
      console.log("ChangeScoreByOrderIdError:" + error);
      return Info.getErrorInfo();
    }
  }
  public async getAvgScoreByProductId(id:number):Promise<number>
  {
    let method="getAvgScoreByProductId";
    try {
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(this.url + "/commentGet", {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
          },
          extraData:JSON.stringify({method,id}),
          usingProtocol: http.HttpProtocol.HTTP1_1
        }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("GetAvgScoreByProductIdResponse:"+data.result.toString());
      let avgScore:number = JSON.parse(data.result.toString());
      return avgScore;
    } catch (error) {
      console.error("GetAvgScoreByProductIdError:" + error);
      return 5;
    }
  }

  public matchIDCard(bank: Bank) {
    for (let item of this.IDCards) {
      if (item === bank) {
        return true;
      }
    }
    return false;
  }

  public getProductsInShoppingCart() {
    return this.productsInShoppingCart;
  }

  public addProductToShoppingCart(product: ProductModel, num: number) {
    if (num > 0) {
      let presentNum: number = 0;
      for (let item of this.productsInShoppingCart) {
        if (item.productModel.equal(product)) {
          presentNum = item.num;
          break;
        }
      }
      this.setProductsInShoppingCart(product, presentNum + num);
    } else {
      console.error('添加数目小于0')
    }
  }

  public setProductsInShoppingCart(product: ProductModel, targetNum: number) {
    if (targetNum >= 0) {
      let exist: boolean = false
      for (let i = 0; i < this.productsInShoppingCart.length; i++) {
        if (this.productsInShoppingCart[i].productModel.equal(product)) {
          if (targetNum == 0) {
            this.productsInShoppingCart.splice(i, 1);
          } else {
            this.productsInShoppingCart[i].num = targetNum;
          }
          exist = true;
          break;
        }
      }
      if (!exist) {
        this.productsInShoppingCart.push(new ProductInShoppingCart(product, targetNum));
      }
    } else {
      console.error('更改数目小于0');
    }
  }

  public async addUserFavorite(productId:number):Promise<Info>
  {
    let method="addUserFavorite";
    let userId:number = this.getUser().id;
    try {
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(this.url + "/userFavoriteSet", {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Authorization':this.token,
          },
          extraData:JSON.stringify({method,productId,userId}),
          usingProtocol: http.HttpProtocol.HTTP1_1
        }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("addUserFavoriteResponse:"+data.result.toString());
      let info:Info = JSON.parse(data.result.toString());
      return info;
    } catch (error) {
      console.error("addUserFavoriteError:" + error);
      return Info.getErrorInfo()
    }
  }
  public async removeUserFavorite(productId:number):Promise<Info>
  {
    let method="removeUserFavorite";
    let userId:number = this.getUser().id;
    try {
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(this.url + "/userFavoriteSet", {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Authorization':this.token,
          },
          extraData:JSON.stringify({method,productId,userId}),
          usingProtocol: http.HttpProtocol.HTTP1_1
        }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("removeUserFavoriteResponse:"+data.result.toString());
      let info:Info = JSON.parse(data.result.toString());
      return info;
    } catch (error) {
      console.error("removeUserFavoriteError:" + error);
      return Info.getErrorInfo()
    }
  }
  public async getUserFavoritesByUserId():Promise<UserFavoriteModel[]>
  {
    let method="getUserFavoritesByUserId";
    let userId:number = this.getUser().id;
    try {
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(this.url + "/userFavoriteGet", {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json'
          },
          extraData:JSON.stringify({method,userId}),
          usingProtocol: http.HttpProtocol.HTTP1_1
        }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("getUserFavoritesByUserIdResponse:"+data.result.toString());
      let obj:object = JSON.parse(data.result.toString());
      let value:UserFavoriteModel[] = (obj as object)?.["value"];
      return value;
    } catch (error) {
      console.error("getUserFavoritesByUserIdError:" + error);
      return [];
    }
  }
  public async getUserFavoriteByUserIdAndProductId(productId:number):Promise<UserFavoriteModel>
  {
    let method="getUserFavoriteByUserIdAndProductId";
    let userId:number = this.getUser().id;
    try {
      let httpRequest = http.createHttp();
      let data = await new Promise<http.HttpResponse>((resolve, reject) => {
        httpRequest.request(this.url + "/userFavoriteGet", {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json'
          },
          extraData:JSON.stringify({method,userId,productId}),
          usingProtocol: http.HttpProtocol.HTTP1_1
        }, (err, data) => {
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          if (!err) {
            resolve(data);
          } else {
            reject(data);
          }
        });
      });
      console.log("getUserFavoriteByUserIdAndProductIdResponse:"+data.result.toString());
      let obj:object = JSON.parse(data.result.toString());
      let value:UserFavoriteModel = (obj as object)?.["value"];
      return value;
    } catch (error) {
      console.error("getUserFavoriteByUserIdAndProductIdError:" + error);
      return UserFavoriteModel.getDefaultUserFavoriteModel();
    }
  }
  private constructor() {
  }
}