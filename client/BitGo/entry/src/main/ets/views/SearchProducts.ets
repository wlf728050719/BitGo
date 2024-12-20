import ProductModel from '../model/ProductModel'
import { router } from '@kit.ArkUI'
import { Constant } from '../global/Constant'
import { GlobalVariable } from '../global/GlobalVariable'

@Component
struct SearchProducts{
  @State searchedProducts:ProductModel[] = []
  @Prop searchWords:string="";
  async aboutToAppear(): Promise<void> {
    const products = await GlobalVariable.getInstance().getProductsByKeyword(this.searchWords,10);
    await Promise.all(products.map((product): Promise<void> => GlobalVariable.getInstance().loadProductImages(product)));
    this.searchedProducts =products;
  }
  build() {
     Column() {
        Row() {
          Image($r('app.media.ic_public_arrow_left'))
            .onClick(() => {
              router.pushUrl({
                url: 'pages/Index'
              })
            })
            .height('60%')
            .colorFilter(Constant.BackGroundColor)
          Text('筛选结果(' + this.searchedProducts.length + ')')
        }.width('100%').height('10%').backgroundColor(Constant.BackGroundColor)

        if (this.searchedProducts.length > 0) {
          Flex({
            wrap: FlexWrap.Wrap,
            justifyContent: FlexAlign.SpaceBetween
          }) {
            ForEach(this.searchedProducts, (item: ProductModel, index: number) => {
              Column() {
                Image($r(item.images[0]))
                  .width(120)
                Column() {
                  Text(item.name)
                    .fontSize(14)
                  Text(item.description)
                    .fontSize(12)
                    .fontColor('#666')
                    .margin({ top: 6, bottom: 6 })
                    .textOverflow({
                      overflow: TextOverflow.Ellipsis
                    })
                    .maxLines(1)

                  Text('￥' + item.price)
                    .fontSize(14)
                    .fontWeight(600)
                }
                .alignItems(HorizontalAlign.Start)
              }
              .width('49%')
              .backgroundColor('#fff')
              .margin({ bottom: 6 })
              .borderRadius(12)
              .padding(8)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/Product',
                  params: {
                    productId: this.searchedProducts[index].id
                  }
                })
              })
            })
          }
        } else
          Text('无符合要求产品').height('100%')
      }
      .width('100%')
      .padding(10)
    }
}
export default SearchProducts