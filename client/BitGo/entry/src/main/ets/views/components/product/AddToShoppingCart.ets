import { GlobalVariable } from '../../../global/GlobalVariable'
import ProductModel from '../../../model/ProductModel'
@Component
struct AddToShoppingCartDialog {
  closeAddToShoppingCartDialog = () => {
  }
  @Prop product:ProductModel
  @State num:number = 1
  build() {
    Column() {
      Row() {
        Text('加入购物车')
        Blank()
        Image($r('app.media.ic_public_arrow_right'))
          .height('80%')
      }
      .width('100%')
      .height('20%')
      .backgroundColor('#ffeaeaea')
      Row(){
        Image($r(this.product.images[0]))
          .height('90%')
          .width('40%')
        Column(){
          Text(this.product.name)
            .fontSize(15)
            .margin({
              top:5
            })
          Text(this.product.description)
            .fontSize(12)
            .fontColor(Color.Gray)
            .margin({
              top:2
            })
          Blank()
          Row(){
            Image($r('app.media.ic_public_arrow_left'))
              .height('80%')
              .margin({
                left:30
              })
              .onClick(()=>{if(this.num>1)this.num--})
            Text(this.num.toString())
              .backgroundColor('#ffefefef')
              .textAlign(TextAlign.Center)
              .width(30)
              .borderRadius(8)
            Image($r('app.media.ic_public_arrow_right'))
              .height('80%')
              .margin({
                right:10
              })
              .onClick(()=>{if(this.num<99)this.num++})
            Text('总计:'+this.num*this.product.price)
              .fontColor(Color.Red)
              .fontSize(20)
          }
          .width('100%')
          .height('20%')
          .margin({
            bottom:10
          })
        }
        .height('100%')
        .width('60%')
      }
      .width('100%')
      .height('60%')
      Row(){
        Button('确认')
          .type(ButtonType.Normal)
          .backgroundColor(Color.Yellow)
          .fontColor(Color.Black)
          .fontSize(12)
          .width('50%')
          .height('100%')
          .onClick(()=>{
            this.closeAddToShoppingCartDialog();
            GlobalVariable.getInstance().addProductToShoppingCart(this.product,this.num);
          })
        Button('取消')
          .type(ButtonType.Normal)
          .backgroundColor(Color.Red)
          .fontColor(Color.White)
          .fontSize(12)
          .width('50%')
          .height('100%')
          .onClick(()=>{
            this.closeAddToShoppingCartDialog();
          })
      }
      .width('100%')
      .height('20%')
    }
    .width('100%')
    .height('30%')
    .backgroundColor(Color.White)
  }
}

export default AddToShoppingCartDialog