import { GlobalVariable } from '../../../global/GlobalVariable';
import ProductModel from '../../../model/ProductModel'
import { router } from '@kit.ArkUI';

@Component
struct FavoriteBar
{
  @State product:ProductModel=ProductModel.getDefaultProductModel();
  @Prop productId:number
  @Prop time:Date
  @State saleAmount:number = 0;
  @State stock:number = 0;
  @State score:number = 0;
  async aboutToAppear() {
    this.product = await GlobalVariable.getInstance().getProductById(this.productId);
    this.stock = await GlobalVariable.getInstance().getStockByProductId(this.productId);
    this.saleAmount = await GlobalVariable.getInstance().getStockByProductId(this.productId);
    this.score = await GlobalVariable.getInstance().getAvgScoreByProductId(this.productId);
  }
  build() {
    Row({space:10}){
      Image($r(this.product.images[0]))
        .width("25%")
      Column({space:5})
      {
        Row()
        {
          Text(this.product.name)
            .width("40%")
            .fontSize(12)
          Row(){
            Text('查看详情')
              .fontSize(10)
              .fontColor(Color.Gray)
            Image($r('app.media.ic_public_arrow_right'))
              .width("20%")
          }
          .width("30%")
          .onClick(()=>{
            router.pushUrl({
              url:'pages/Product',
              params:{
                productId:this.product.id
              }
            })
          })
        }
        .width("100%")
        .justifyContent(FlexAlign.SpaceBetween)

        Text('商品价格:'+this.product.price)
          .width("100%")
          .fontSize(12)
        Text('商品销量:'+this.saleAmount)
          .width("100%")
          .fontSize(12)
        Text('商品库存:'+this.stock)
          .width("100%")
          .fontSize(12)
        Text('商品评分'+this.score)
          .width("100%")
          .fontSize(12)
      }
      .width("60%")
      .height("80%")
    }
    .borderRadius(10)
    .border({
      width:1,
      color:Color.Gray
    })
    .backgroundColor(Color.White)
    .width("100%")
    .height("20%")
    .padding(10)
  }
}
export default FavoriteBar