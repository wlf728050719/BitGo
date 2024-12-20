import { GlobalVariable } from '../../../global/GlobalVariable'
import Info from '../../../model/Info'
import OrderModel from '../../../model/OrderModel'
import ProductModel from '../../../model/ProductModel'
import { promptAction } from '@kit.ArkUI'

@Component
struct BuyProductDialog {
  closeBuyProductDialog = () => {
  }
  @Prop product:ProductModel
  @State recipientName:string=''
  @State shippingAddress:string=''
  @State phone:string=''
  @State num:number=1
  @Prop changeOrder:boolean
  @Prop originOrder:OrderModel
  aboutToAppear(): void {
    if (this.changeOrder)
    {
      this.recipientName=this.originOrder.recipientName;
      this.shippingAddress=this.originOrder.shippingAddress;
      this.phone=this.originOrder.phone;
      this.num=this.originOrder.amount;
    }
  }
  build() {
    Column() {
      Row() {
        Text('填写订单')
        Blank()
        Image($r('app.media.ic_public_arrow_right'))
          .height('60%')
          .onClick(()=>{
            this.closeBuyProductDialog();
          })
      }
      .width('100%')
      .height('10%')
      .backgroundColor('#ffeaeaea')
      Row(){
        Image($r(this.product.images[0]))
          .width('40%')
        Column(){
          Text(this.product.name)
            .fontSize(15)
            .margin({
              top:5
            })
            .width('100%')
          Text(this.product.description)
            .fontSize(12)
            .fontColor(Color.Gray)
            .margin({
              top:2
            })
            .width('100%')
          Blank()
        }
        .height('80%')
        .width('70%')
      }
      .width('100%')
      .height('40%')
      Row(){
        Blank()
        Text('数量:')
          .fontSize(12)
        Image($r('app.media.ic_public_arrow_left'))
          .width('5%')
          .margin({
            left:10
          })
          .onClick(()=>{if(this.num>1)this.num--})
        Text(this.num.toString())
          .backgroundColor('#ffefefef')
          .textAlign(TextAlign.Center)
          .width(30)
          .borderRadius(8)
        Image($r('app.media.ic_public_arrow_right'))
          .margin({
            right:10
          })
          .width('5%')
          .onClick(()=>{if(this.num<99)this.num++})
        Text('总计:'+this.num*this.product.price)
          .fontColor(Color.Red)
          .fontSize(20)
        Blank()
      }
      .width('100%')
      .height('10%')
      .margin({
        bottom:10
      })
      .width('100%')
      .height('10%')
      Column({space:10}){
        Row(){
          Text('收货人:')
            .fontSize(12)
          Blank()
          TextInput({placeholder:'填写收货人姓名',text:this.recipientName})
            .placeholderFont({size:12})
            .placeholderColor(Color.Gray)
            .onChange((value:string)=>{
              this.recipientName=value;
            })
            .width('80%')
        }
        .width('100%')
        Row(){
          Text('手机号:')
            .fontSize(12)
          Blank()
          TextInput({placeholder:'填写收货人手机号',text:this.phone})
            .placeholderFont({size:12})
            .placeholderColor(Color.Gray)
            .onChange((value:string)=>{
              this.phone=value
            })
            .width('80%')
        }
        .width('100%')
        Row(){
          Text('地址:')
            .fontSize(12)
          Blank()
          TextInput({placeholder:'选择收货地址',text:this.shippingAddress})
            .placeholderFont({size:12})
            .placeholderColor(Color.Gray)
            .onChange((value:string)=>{
              this.shippingAddress=value
            })
            .width('80%')
        }
        .width('100%')
        Button(this.changeOrder?'修改信息':'提交订单')
          .backgroundColor(Color.Red)
          .fontColor(Color.White)
          .fontSize(12)
          .width('80%')
          .height('15%')
          .onClick(async () => {
            if(this.shippingAddress.length<1)
              this.getUIContext().showAlertDialog({
                message:'地址不能为空',
                confirm:{
                  value:'确认',
                  action:()=>{}
                }
              })
            else {
              if(this.changeOrder)
                await GlobalVariable.getInstance().changeOrderBaseInfo(this.originOrder.id,this.num,this.recipientName,this.phone,this.shippingAddress);
              else
              {let info:Info = await GlobalVariable.getInstance().createOrder(this.product,this.num,this.recipientName,this.phone,this.shippingAddress);
                promptAction.showDialog({ message: info.message, buttons: [{ text: '确认', color: '#000000' }] })
              }
              this.closeBuyProductDialog();
            }
          })
      }
      .padding(10)
      .width('100%')
      .height('40%')
    }
    .width('100%')
    .height('70%')
    .backgroundColor(Color.White)
  }
}

export default BuyProductDialog