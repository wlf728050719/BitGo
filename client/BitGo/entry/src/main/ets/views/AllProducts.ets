import { GlobalVariable } from '../global/GlobalVariable'
import ProductModel from '../model/ProductModel'
import ProductSaleInfoBar from './components/myProducts/ProductSaleInfoBar'
import { router } from '@kit.ArkUI'

@Component
struct AllProducts {
  @State allProducts: ProductModel[] = []

  async aboutToAppear(): Promise<void> {
    this.allProducts = await GlobalVariable.getInstance().getProductsBySellerId(GlobalVariable.getInstance().getUser().id);
  }

  build() {
    Scroll() {
      Column({space:10}) {
        if (this.allProducts.length > 0) {
          Text('商品共计:'+this.allProducts.length+'件')
            .fontSize(12)
            .width('100%')
          ForEach(this.allProducts, (item: ProductModel) => {
            ProductSaleInfoBar({ product: item })
          })
        } else {
          Text('当前未发布过商品').fontSize(12).fontColor(Color.Gray)
          Button('去发布')
            .onClick(() => {
              router.pushUrl({
                url: 'pages/Index',
                params: {
                  currentIndex: 2
                }
              })
            })
            .backgroundColor(Color.Red)
            .fontColor(Color.White)
            .width('25%')
        }
      }
    }
    .padding(10)
    .width('100%')
    .height('100%')
  }
}

export default AllProducts;