import CommonCss from '../style/commonCss'
import CommentSection from '../views/CommentSection'
import ProductModel, { ProductType } from '../model/ProductModel'
import GoodPick, { ProductsController } from '../views/components/common/GoodPick'
import { promptAction, router } from '@kit.ArkUI'
import AddToShoppingCartDialog from '../views/components/product/AddToShoppingCart'
import BuyProductDialog from '../views/components/product/BuyProductDialog'
import OrderModel from '../model/OrderModel'
import { GlobalVariable } from '../global/GlobalVariable'
import Info from '../model/Info'
import { UserFavoriteModel } from '../model/UserFavoriteModel'

@Entry
@Component
struct Product {
  @State productModel: ProductModel = ProductModel.getDefaultProductModel();
  @State showComments: boolean = false
  @State wish: boolean = false
  @State isShowGoTopButton: boolean = false
  @State showAddToShoppingCartDialog: boolean = false
  @State showBuyProductDialog: boolean = false
  @State changeOrder: boolean = false
  @State originOrder: OrderModel = OrderModel.getDefaultOrderModel();
  @State presentOrder: OrderModel = OrderModel.getDefaultOrderModel();
  @State showPayDialog: boolean = false
  @State isLoading: boolean = false;
  @State stock: number = 0;
  @State saleAmount: number = 0;
  scroller: Scroller = new Scroller()
  private productsController: ProductsController = new ProductsController();

  async aboutToAppear(): Promise<void> {
    const params = router.getParams()
    if (params != null) {
      let productId: number = 0;
      this.changeOrder = (params as object)['changeOrder']
      if (this.changeOrder) {
        this.originOrder = OrderModel.copy((params as object)['originOrder'] as OrderModel);
        productId = this.originOrder.productId;
        this.showBuyProductDialog = true
      } else {
        productId = (params as object)['productId'] as number;
      }
      this.productModel = ProductModel.copy(await GlobalVariable.getInstance().getProductById(productId));
      this.stock = await GlobalVariable.getInstance().getStockByProductId(productId);
      this.saleAmount = await GlobalVariable.getInstance().getSaleAmountByProductId(productId);
    }
    console.log("Open Product Page,product:"+this.productModel.toString())
    if(GlobalVariable.getInstance().getLoginState())
    {
      let temp:UserFavoriteModel = await GlobalVariable.getInstance().getUserFavoriteByUserIdAndProductId(this.productModel.id)
      this.wish=(temp!=null&&temp.id>0)
      if(this.wish)
        console.log('wish')
      else
        console.log('no wish')
    }
  }

  closeAddToShoppingCartDialog() {
    this.showAddToShoppingCartDialog = false;
  }

  closeBuyProductDialog() {
    this.showBuyProductDialog = false;
  }

  build() {
    Column() {
      Scroll(this.scroller) {
        Column() {
          Swiper() {
            ForEach(this.productModel.images, (item: string) => {
              Image($r(item))
                .objectFit(ImageFit.Contain)
                .width('100%')
            })
          }
          .autoPlay(true)
          .indicator(
            Indicator.dot()
              .selectedColor('#cf0a2c')
          )

          Column() {
            Divider()
              .height(2)
              .color(Color.Gray)
            Row() {
              Text(this.productModel.name)
                .fontSize(16)
                .fontWeight(600)
              Blank()
              Text('库存:' + this.stock)
                .fontSize(12)
                .width("15%")
              Text('已售:' + this.saleAmount)
                .fontSize(12)
                .width("15%")
            }.width('100%')

            Text(this.productModel.description)
              .fontSize(12)
              .fontColor('#666')
              .margin({
                top: 5
              })
          }.alignItems(HorizontalAlign.Start)

          Divider()
            .height(2)
            .color(Color.Gray)
            .margin({
              top: 5,
              bottom: 5
            })
          Scroll() {
            Row({ space: 10 }) {
              ForEach(this.productModel.tags, (item: string) => {
                Text(item)
                  .fontColor(Color.Brown)
                  .fontSize(12)
                  .border({
                    width: 1,
                    color: Color.Brown
                  })
                  .borderRadius(2)
              })
            }
          }
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)

          Divider()
            .height(2)
            .color(Color.Gray)
            .margin({
              top: 5,
              bottom: 5
            })
          Row() {
            Image($r('app.media.truck'))
              .height(12)
            Text('预计5小时内发货')
              .fontSize(12)
              .fontColor(Color.Green)
            Blank()
            Image($r('app.media.ic_statusbar_gps'))
              .height(15)
              .colorBlend(Color.Brown)
            Text('发货地址:' + this.productModel.location)
              .fontSize(12)
          }.width('100%')

          Divider()
            .height(2)
            .color(Color.Gray)
            .margin({
              top: 5,
              bottom: 5
            })
          Text('顺丰包邮 退货包运费 7天无理由退货 48小时发货')
            .fontSize(12)
            .width('100%')
          Divider()
            .height(2)
            .color(Color.Gray)
            .margin({
              top: 5,
              bottom: 5
            })
          //评论区
          Row() {
            Text('商品评论')
            Blank()
            Image($r('app.media.ic_public_arrow_right'))
              .height('80%')
          }
          .height(30)
          .width('100%')
          .backgroundColor('#f1f3f5')
          .padding({
            left: 10,
            right: 10
          })
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            this.showComments = !this.showComments
          })

          if (this.showComments) {
            CommentSection({ product_id: this.productModel.id });
          }
          //其他推荐
          GoodPick({ productsController: this.productsController, showBorder: true, isLoading: this.isLoading })
        }.padding(10)
      }
      .scrollBar(BarState.Off)
      .onWillScroll(() => {
        const scrollYOffset = this.scroller.currentOffset().yOffset
        this.isShowGoTopButton = scrollYOffset > 500 ? true : false
      })
      .onScrollEdge(() => {
        this.productsController.loadData(ProductType.ALL);
      })

      if (this.isShowGoTopButton) Button({ type: ButtonType.Circle, stateEffect: true }) {
        Image($r('app.media.ic_public_backtotop'))
          .width(20)
          .fillColor('#666')
      }
      .width(35)
      .height(35)
      .backgroundColor('#fff')
      .shadow({
        radius: 3,
        color: '#666',
        offsetX: 2,
        offsetY: 2
      })
      .position({
        bottom: 10,
        right: 10
      })
      .onClick(() => {
        this.scroller.scrollEdge(Edge.Top)
      })

      Button({ type: ButtonType.Circle, stateEffect: true }) {
        Image($r('app.media.ic_public_back'))
          .width(20)
          .fillColor('#666')
      }
      .width(35)
      .height(35)
      .backgroundColor('#fff')
      .shadow({
        radius: 3,
        color: '#666',
        offsetX: 2,
        offsetY: 2
      })
      .position({
        top: 10,
        left: 10
      })
      .onClick(() => {
        router.back()
      })

      //底部菜单
      Row({ space: 5 }) {
        Column() {
          Image($r('app.media.ic_public_home_filled'))
            .onClick(() => {
              router.pushUrl({
                url: 'pages/BrowseStore',
                params:{
                  sellerId:this.productModel.sellerId
                }
              })
            })
            .height('50%')
            .fillColor('#808182')
          Text('店铺')
            .fontColor('#808182')
            .fontSize(12)
        }
        .margin({
          left: 2
        })

        Column() {
          Image($r('app.media.ic_public_favor_filled'))
            .onClick(async () => {
              if(GlobalVariable.getInstance().getLoginState())
              {
                let info:Info = Info.getErrorInfo();
                if(this.wish)
                  info = await GlobalVariable.getInstance().removeUserFavorite(this.productModel.id);
                else
                  info = await GlobalVariable.getInstance().addUserFavorite(this.productModel.id);
                if(info.result)
                  this.wish = !this.wish
                else
                  promptAction.showDialog({ message:info.message, buttons: [{text: '确认', color: '#000000'}]})
              }
              else
                promptAction.showDialog({ message: '请先登录', buttons: [{text: '确认', color: '#000000'}]})
            })
            .height('50%')
            .fillColor(this.wish ? Color.Red : '#808182')
          Text('收藏')
            .fontColor(this.wish ? Color.Red : '#808182')
            .fontSize(12)
        }
        .margin({
          left: 2
        })

        Column() {
          Image($r('app.media.ic_public_appstore'))
            .onClick(() => {
              router.pushUrl({
                url: 'pages/Index',
                params: {
                  currentIndex: 3
                }
              })
            })
            .height('50%')
            .fillColor('#808182')
          Text('购物车')
            .fontColor('#808182')
            .fontSize(12)
        }
        .margin({
          left: 2,
          right: 5
        })

        Button('加入购物车')
          .backgroundColor(Color.Orange)
          .width('30%')
          .height('65%')
          .fontSize(12)
          .onClick(() => {
            this.showAddToShoppingCartDialog = true;
          })
          .margin({
            right: 5
          })
        Button('立即购买')
          .backgroundColor(Color.Red)
          .width('30%')
          .height('65%')
          .fontSize(12)
          .onClick(() => {
            this.showBuyProductDialog = true
          })
          .margin({ right: 2 })
      }
      .position({
        left: 0,
        bottom: 0
      })
      .padding(5)
      .width('100%')
      .height('8%')
      .backgroundColor(CommonCss.BG_COLOR)

      if (this.showAddToShoppingCartDialog) {
        AddToShoppingCartDialog({
          product: this.productModel,
          closeAddToShoppingCartDialog: () => {
            this.closeAddToShoppingCartDialog();
          }
        })
          .position({
            left: 0,
            bottom: 0
          })
      }
      if (this.showBuyProductDialog) {
        BuyProductDialog({
          product: this.productModel,
          changeOrder: this.changeOrder,
          originOrder: this.originOrder,
          closeBuyProductDialog: () => {
            this.closeBuyProductDialog();
          }
        })
          .position({
            left: 0,
            bottom: 0
          })
      }
    }.width("100%")
  }
}