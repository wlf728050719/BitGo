import ProductModel from '../../../model/ProductModel'

@Component
struct ProductBaseInfoBar
{
  @Prop product:ProductModel
  @Prop score:number
  @Prop saleAmount:number
  build() {
    Row({space:10})
    {
      Image($r(this.product.images[0]))
        .height("80%")
      Column({space:5})
      {
        Text(this.product.name).width("100%").fontSize(12)
        Text('价格:'+this.product.price.toString()).width("100%").fontSize(10)
        Text("销量:"+this.saleAmount).width("100%").fontSize(10)
        Text("评分:"+this.score).width("100%").fontSize(10)
      }
    }
  }
}
export default ProductBaseInfoBar;