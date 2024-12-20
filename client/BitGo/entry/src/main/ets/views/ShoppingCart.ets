import GoodPick, { ProductsController } from './components/common/GoodPick'
import { router } from '@kit.ArkUI'
import ProductBar from './components/shoppingCart/ProductBar'
import {ProductInShoppingCart} from '../model/ProductInShoppingCart'
import {GlobalVariable} from '../global/GlobalVariable'
import ProductModel, { ProductType } from '../model/ProductModel'
import BuySelectedProductsDialog from './components/shoppingCart/BuySelectedProductsDialog'

function sumPrice(products:ProductInShoppingCart[]){
  let result:number=0;
  for(let i =0;i<products.length;i++)
    result+=products[i].productModel.price*products[i].num
  return result;
}
function isEmpty(products:ProductInShoppingCart[]){
  let result=true;
  for(let item of products)
  {
    if(item.num>0)
    {
      result=false;
      break;
    }
  }
  return result;
}
@Component
struct ShoppingCart {
  @State selectedAll:boolean=false;
  @State productsInShoppingCart:ProductInShoppingCart[] =[]
  @State selectedProductsInShoppingCart:ProductInShoppingCart[] = []
  @State sum:number=0
  @State showBuyProductsDialog:boolean=false
  private productsController:ProductsController =new ProductsController();
  @State isLoading:boolean = false;
  closeBuyProductDialog()
  {
    this.showBuyProductsDialog=false
  }
  setSelectAllStatus(status:boolean)
  {
    this.selectedAll=status;
  }
  changeNum(product:ProductModel,target:number){
    GlobalVariable.getInstance().setProductsInShoppingCart(product,target);
    this.productsInShoppingCart=GlobalVariable.getInstance().getProductsInShoppingCart();
    for(let i=0;i<this.selectedProductsInShoppingCart.length;i++)
    {
      if(product.equal(this.selectedProductsInShoppingCart[i].productModel))
      {
        this.selectedProductsInShoppingCart.splice(i,1);
        break;
      }
    }
    this.sum=sumPrice(this.selectedProductsInShoppingCart)
    this.selectedAll=false
  }
  addSelectedProduct(productInShoppingCart:ProductInShoppingCart)
  {
    this.selectedProductsInShoppingCart.push(productInShoppingCart)
    this.sum=sumPrice(this.selectedProductsInShoppingCart)
  }
  removeSelectedProduct(productInShoppingCart:ProductInShoppingCart)
  {
    for(let i=0;i<this.selectedProductsInShoppingCart.length;i++)
    {
      if(this.selectedProductsInShoppingCart[i].productModel.equal(productInShoppingCart.productModel))
      {
        this.selectedProductsInShoppingCart.splice(i,1)
      }
    }
    this.sum=sumPrice(this.selectedProductsInShoppingCart)
  }
  removeProductsFromShoppingCart(products:ProductInShoppingCart[])
  {
    for (let item of products){
      for(let i=0;i<this.productsInShoppingCart.length;i++)
      {
        if(this.productsInShoppingCart[i].productModel.equal(item.productModel))
        {
          this.productsInShoppingCart.splice(i,1)
        }
      }
    }
  }
  inSelectedProducts(productInShoppingCart:ProductInShoppingCart){
    for(let item of this.selectedProductsInShoppingCart)
    {
      if(item.productModel.equal(productInShoppingCart.productModel))
        return true;
    }
    return false;
  }
  aboutToAppear(): void {
    this.productsInShoppingCart=GlobalVariable.getInstance().getProductsInShoppingCart();
    this.sum=sumPrice(this.selectedProductsInShoppingCart)
  }
  build() {
    Column() {
      Column() {
        Scroll() {
          Column() {
            Text('购物车')
              .width('100%')
              .fontSize(20)
              .fontWeight(600)
            if(isEmpty(this.productsInShoppingCart))
            {
              Column() {
                Image($r('app.media.convemptyCart'))
                  .width(100)
                Text('购物车空荡荡')
                  .fontColor('#666')
                  .padding({
                    top: 20,
                    bottom: 10
                  })
                Text('为辛苦的自己去挑选几件商品吧')
                  .fontColor('#666')
                  .fontSize(13)
                Button('去购物')
                  .padding({
                    left: 40,
                    right: 40
                  })
                  .backgroundColor('#cf0a2c')
                  .margin({
                    top: 20
                  })
                  .onClick(() => {
                    router.pushUrl({
                      url: 'pages/Index'
                    })
                  })
              }
              .margin({
                top: 40
              })
            }
            else {
              Column({space:5}){
                ForEach(this.productsInShoppingCart,(item:ProductInShoppingCart)=>{
                  ProductBar({
                    selected:this.selectedAll?true:this.inSelectedProducts(item),
                    productInShoppingCart:item,
                    changeNum:(product:ProductModel,target:number)=>{this.changeNum(product,target)},
                    addSelectedProduct:(productInShoppingCart:ProductInShoppingCart)=>{this.addSelectedProduct(productInShoppingCart)},
                    removeSelectedProduct:(productsInShoppingCart:ProductInShoppingCart)=>{this.removeSelectedProduct(productsInShoppingCart)},
                    setSelectAllStatus:(status:boolean)=>{this.setSelectAllStatus(status)}
                  }
                    )
                })
              }.margin({
                top:10
              })
            }
            GoodPick({productsController:this.productsController,isLoading:this.isLoading})
          }
        }
        .scrollBar(BarState.Off)
        .onScrollEdge(()=>{
          this.productsController.loadData(ProductType.ALL);
        })
      }
      .height('100%')
      .width('100%')
      .padding(15)
      .backgroundColor('#f1f3f5')
      if(this.productsInShoppingCart.length>0)
      {
        Row(){
          Checkbox({name:'allSelect',group:'checkGroup1'})
            .select(this.selectedAll)
            .selectedColor(Color.Red)
            .height('30%')
            .margin({left:15})
            .onChange((value: boolean) => {
              this.selectedAll=value
            })
          Text('全选')
            .fontSize(12)
          Blank()
          Text('合计:').fontSize(12).margin({right:5})
          Text('￥'+this.sum.toString())
            .fontColor(Color.Red)
            .fontSize(15)
          Button('结算')
            .fontColor(Color.White)
            .backgroundColor(Color.Red)
            .height('60%')
            .width('25%')
            .margin({
              left:10,
              right:15
            })
            .onClick(()=>{
              this.showBuyProductsDialog=true
            })
        }
        .backgroundColor('#fff1f1f1')
        .width('100%')
        .height('8%')
        .position({
          left:0,
          bottom:0
        })
      }
      if(this.showBuyProductsDialog)
        BuySelectedProductsDialog({
          selectedProducts:this.selectedProductsInShoppingCart,
          closeBuyProductDialog:()=>{this.closeBuyProductDialog()},
          removeProductsFromShoppingCart:(products:ProductInShoppingCart[])=>{this.removeProductsFromShoppingCart(products)}
        })
          .position({
            left:0,
            bottom:0
          })
    }
  }
}

export default ShoppingCart