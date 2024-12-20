import OrderModel, { OrderStatus } from '../../../model/OrderModel'
import CommonCss from '../../../style/commonCss'
import { router } from '@kit.ArkUI'
import ProductModel from '../../../model/ProductModel'
import { GlobalVariable } from '../../../global/GlobalVariable'

@Component
struct BuyOrderBar{
  @Prop order:OrderModel
  @State product:ProductModel=ProductModel.getDefaultProductModel();

  async aboutToAppear(): Promise<void> {
    this.product = await GlobalVariable.getInstance().getProductById(this.order.productId);
  }
  build() {
    Column(){
      Row(){
        Text('华为手机专卖店')
          .fontSize(12)
        Image($r('app.media.ic_public_arrow_right'))
          .fillColor(Color.Gray)
          .height('90%')
        Blank()
        if(this.order.status===OrderStatus.PENDING)
        {
          Text('待付款').fontSize(12).margin({right:10})
        }
        else if(this.order.status==OrderStatus.PREPARED)
        {
          Text('待发货').fontSize(12).margin({right:10})
        }
        else if(this.order.status===OrderStatus.SHIPPED)
        {
          Text('待收货').fontSize(12).margin({right:10})
        }
        else if(this.order.status===OrderStatus.DELIVERED)
        {
          Text('已完成').fontSize(12).margin({right:10})
        }
        else if(this.order.status===OrderStatus.CANCELED)
        {
          Text('已取消').fontSize(12).margin({right:10}).fontColor(Color.Red)
        }
      }
      .width('100%')
      .height('8%')
      Divider()
        .height(2)
        .color(Color.Gray)
      Row()
      {
        Image($r(this.product.images[0]))
          .width('30%')
        Column({ space: 5 }) {
          Text(this.product.name).fontSize(15).width('100%')
          Text(this.product.description).width('100%').fontColor(Color.Gray).fontSize(12)
          Text('单价:￥' + this.product.price).fontColor(Color.Black).fontWeight(FontWeight.Bold).fontSize(12).width('100%')
          Row() {
            Text('数目:' + this.order.amount).fontColor(Color.Black).fontSize(12)
            Blank()
            Text('总价:￥' + this.order.amount*this.product.price).fontColor(Color.Red).fontWeight(FontWeight.Bold).fontSize(12)
          }.width('100%')
        }
        .width('70%')
      }
      .width('100%')
      .height('50%')
      Row({space:5}){
        Blank()
        if(this.order.status===OrderStatus.PENDING)
        {
          Button('取消订单').width('30%').height('8%').backgroundColor(CommonCss.BG_COLOR).fontColor(Color.Black).fontSize(12).fontWeight(FontWeight.Normal)
            .onClick(()=>{
              GlobalVariable.getInstance().changeOrderStatus(this.order.id,OrderStatus.CANCELED)
              router.pushUrl({
                url:'pages/BrowseBuyOrder',
                params:{
                  currentIndex:5
                }
              })
            })
          Button('修改订单').width('30%').height('8%').backgroundColor(CommonCss.BG_COLOR).fontColor(Color.Black).fontSize(12).fontWeight(FontWeight.Normal)
            .onClick(()=>{
              router.pushUrl({
                url:'pages/Product',
                params:{
                  changeOrder:true,
                  originOrder:OrderModel.copy(this.order),
                }
              })
            })
          Button('去支付').width('30%').height('8%').backgroundColor(CommonCss.BG_COLOR).fontColor(Color.Red).fontSize(12).fontWeight(FontWeight.Normal)
            .onClick(()=>{
              router.pushUrl({
                url:'pages/Pay',
                params:{
                  order:OrderModel.copy(this.order)
                }
              })
            })
        }
        else if(this.order.status==OrderStatus.PREPARED)
        {
          Button('我要催单').width('30%').height('8%').backgroundColor(CommonCss.BG_COLOR).fontColor(Color.Black).fontSize(12).fontWeight(FontWeight.Normal)
          Button('联系卖家').width('30%').height('8%').backgroundColor(CommonCss.BG_COLOR).fontColor(Color.Black).fontSize(12).fontWeight(FontWeight.Normal)
        }
        else if(this.order.status===OrderStatus.SHIPPED)
        {
          Button('退款/售后').width('30%').height('8%').backgroundColor(CommonCss.BG_COLOR).fontColor(Color.Black).fontSize(12).fontWeight(FontWeight.Normal)
          Button('确认收货').width('30%').height('8%').backgroundColor(CommonCss.BG_COLOR).fontColor(Color.Red).fontSize(12).fontWeight(FontWeight.Normal)
            .onClick(async ()=>{
              await GlobalVariable.getInstance().changeOrderStatus(this.order.id,OrderStatus.DELIVERED)
              router.pushUrl({
                url:'pages/BrowseBuyOrder',
                params:{
                  currentIndex:4
                }
              })
            })
        }
        else if(this.order.status===OrderStatus.DELIVERED)
        {
          Button('查看发票').width('30%').height('8%').backgroundColor(CommonCss.BG_COLOR).fontColor(Color.Black).fontSize(12).fontWeight(FontWeight.Normal)
          Button('评价').width('30%').height('8%').backgroundColor(CommonCss.BG_COLOR).fontColor(Color.Black).fontSize(12).fontWeight(FontWeight.Normal)
            .onClick(()=>{
              router.pushUrl({
                url:'pages/WriteComment',
                params:{
                  order:OrderModel.copy(this.order)
                }
              })
            })
          Button('再次购买').width('30%').height('8%').backgroundColor(CommonCss.BG_COLOR).fontColor(Color.Red).fontSize(12).fontWeight(FontWeight.Normal)
            .onClick(()=>{
              router.pushUrl({
                url:'pages/Product',
                params:{
                  productId:this.order.productId
                }
              })
            })
        }
        else if(this.order.status===OrderStatus.CANCELED)
        {
          Button('删除订单').width('30%').height('8%').backgroundColor(CommonCss.BG_COLOR).fontColor(Color.Black).fontSize(12).fontWeight(FontWeight.Normal)
          Button('再次购买').width('30%').height('8%').backgroundColor(CommonCss.BG_COLOR).fontColor(Color.Red).fontSize(12).fontWeight(FontWeight.Normal)
            .onClick(()=>{
              router.pushUrl({
                url:'pages/Product',
                params:{
                  productId:this.order.productId
                }
              })
            })
        }
      }
      .width('100%')
      .margin({
        bottom:10
      })
      Column({space:5})
      {
        Divider()
          .height(2)
          .color(Color.Gray)
        Row(){
          Text('订单编号:').fontColor(Color.Gray).fontSize(12)
          Blank()
          Text(this.order.id.toString()).fontSize(12)
        }
        .width('100%')
        Row(){
          Text('发货地址:').fontColor(Color.Gray).fontSize(12)
          Blank()
          Text(this.product.location.toString()).fontSize(12)
        }
        .width('100%')
        Row(){
          Text('收货地址:').fontColor(Color.Gray).fontSize(12)
          Blank()
          Text(this.order.shippingAddress.toString()).fontSize(12)
        }
        .width('100%')
        Row(){
          Text('收货人:').fontColor(Color.Gray).fontSize(12)
          Blank()
          Text(this.order.recipientName).fontSize(12)
        }
        .width('100%')
        Row(){
          Text('收货电话:').fontColor(Color.Gray).fontSize(12)
          Blank()
          Text(this.order.phone.toString()).fontSize(12)
        }
        .width('100%')
        Row(){
          Text('订单时间:').fontColor(Color.Gray).fontSize(12)
          Blank()
          Text(this.order.date.toLocaleString()).fontSize(12)
        }
        .width('100%')
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor(Color.White)
    .padding(20)
  }
}
export default BuyOrderBar
