import ProductModel from '../../../model/ProductModel'
import { router } from '@kit.ArkUI'
import { GlobalVariable } from '../../../global/GlobalVariable'
import CommonCss from '../../../style/commonCss'

@Component
struct ProductSaleInfoBar{
  @Prop product:ProductModel
  @State stock:number=0;
  @State saleAmount:number=0;
  @State score:number=0;

  async aboutToAppear(): Promise<void> {
    this.stock = await GlobalVariable.getInstance().getStockByProductId(this.product.id);
    this.saleAmount = await GlobalVariable.getInstance().getSaleAmountByProductId(this.product.id);
    this.score = await GlobalVariable.getInstance().getAvgScoreByProductId(this.product.id);
  }
  build() {
    Column(){
      Row()
      {
        Text(this.product.name)
        Blank()
        Text('查看详情')
          .fontColor(Color.Gray)
          .fontSize(12)
        Image($r('app.media.ic_public_arrow_right'))
          .height('80%')
          .onClick(()=>{
            router.pushUrl({
              url:'pages/Product',
              params:{
                productId:this.product.id
              }
            })
          })
      }
      .width('100%')
      .height('15%')
      .margin({
        bottom:10
      })
      Row()
      {
        Image($r(this.product.images[0]))
          .width('30%')
        Column(){
          Text('商品单价:'+this.product.price).width("100%").fontSize(12).fontColor(Color.Gray)
          Text('库存:'+this.stock).width("100%").fontSize(12).fontColor(Color.Gray)
          Text('销售总量:'+this.saleAmount).width("100%").fontSize(12).fontColor(Color.Gray)
          Text('商品评分:'+this.score).width("100%").fontSize(12).fontColor(Color.Gray)
        }
        .width("70%")
        .margin({
          left:5
        })
      }
      .width('100%')
      Row({space:5})
      {
        Blank()
        Button('下架商品').width('25%').height('10%').backgroundColor(CommonCss.BG_COLOR).fontColor(Color.Black).fontSize(12).fontWeight(FontWeight.Normal)
        Button('修改信息').width('25%').height('10%').backgroundColor(CommonCss.BG_COLOR).fontColor(Color.Black).fontSize(12).fontWeight(FontWeight.Normal)
        Button('所有订单').width('25%').height('10%').backgroundColor(CommonCss.BG_COLOR).fontColor(Color.Black).fontSize(12).fontWeight(FontWeight.Normal)
          .onClick(()=>{
            router.pushUrl({
              url:"pages/BrowseSellOrder",
              params:{
                currentIndex:0,
                searchWord:"productId:"+this.product.id
              }
            })
          })
      }
      .width("100%")
      .margin({
        top:10
      })
    }
    .width('100%')
    .height('30%')
    .border({
      width:2,
      color:Color.Gray
    })
    .padding(5)
    .borderRadius(10)
    .backgroundColor(Color.White)
  }
}
export default ProductSaleInfoBar
