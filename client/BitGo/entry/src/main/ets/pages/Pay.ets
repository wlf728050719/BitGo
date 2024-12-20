import { BankIcon, Constant } from '../global/Constant';
import { GlobalVariable } from '../global/GlobalVariable';
import OrderModel, { OrderStatus } from '../model/OrderModel';
import { router } from '@kit.ArkUI';
import ProductModel from '../model/ProductModel';

@Component
@Entry
struct Pay{
  @State price:number=0
  @State order:OrderModel = OrderModel.getDefaultOrderModel();

  async aboutToAppear(): Promise<void> {
    const params = router.getParams()
    if (params != null) {
      this.order = OrderModel.copy((params as object)['order'] as OrderModel);
      let product:ProductModel = await GlobalVariable.getInstance().getProductById(this.order.productId);
      this.price = product.price*this.order.amount;
    }
  }
  build() {
    Column({space:10}){
      Row(){
        Blank();
        Image($r('app.media.ic_public_close'))
          .height('90%')
          .colorFilter(Constant.BackGroundColor)
          .onClick(()=>{
            router.pushUrl({
              url:'pages/BrowseOrder',
              params:{
                currentIndex:1
              }
            })
          })
      }
      .width('100%')
      .height('5%')
      Row(){Text(this.price.toString()).fontSize(40).fontWeight(FontWeight.Bolder)}
      Column(){
        ForEach(Constant.BankIcons,(item:BankIcon)=>{
          if(GlobalVariable.getInstance().matchIDCard(item.bank))
          {
            Row(){
              Image($r(item.icon))
                .width('5%')
                .height('60%')
              Text(item.bank)
                .fontSize(10)
                .fontColor(Color.Gray)
                .padding({left:10})
            }
            .width('100%')
            .height('5%')
            .padding({
              left:5,
              right:5
            })
            Divider()
              .height(2)
          }
        })
        Row(){
          Text('添加其他银行卡')
            .fontSize(10)
            .fontColor(Color.Gray)
          Image($r('app.media.ic_public_arrow_right'))
            .height('90%')
        }
        .width('100%')
        .height('6%')
        .padding(10)
      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius('5%')
      Column(){
        Row(){
          Image($r('app.media.ic_public_close'))
            .height('80%')
          Text('微信支付')
            .fontSize(10)
            .fontColor(Color.Gray)
        }
        .width('100%')
        .height('5%')
        .padding({
          left: 5,
          right: 5
        })
        Row(){
          Image($r('app.media.ic_public_close'))
            .height('80%')
          Text('好友代付')
            .fontSize(10)
            .fontColor(Color.Gray)
        }
        .width('100%')
        .height('5%')
        .padding({
          left:5,
          right:5
        })
      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius('5%')
      Row(){
        Blank()
        Button('确认付款')
          .fontColor(Color.White)
          .fontSize(15)
          .backgroundColor(Color.Red)
          .width('80%')
          .onClick(()=>{
            GlobalVariable.getInstance().changeOrderStatus(this.order.id,OrderStatus.PREPARED)
            router.pushUrl({
              url:'pages/BrowseBuyOrder',
              params:{
                currentIndex:2
              }
            })
          })
        Blank()
      }
      .width('100%')
      .height('10%')
      .position({bottom:5})
    }
    .width('100%')
    .height('100%')
    .padding(10)
    .backgroundColor(Constant.BackGroundColor)
  }
}