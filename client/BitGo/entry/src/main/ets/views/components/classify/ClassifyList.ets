import { ProductType } from '../../../model/ProductModel'
import GoodPick, { ProductsController } from '../common/GoodPick'

@Component
struct ClassifyList {
  @Prop currentCategory: number = 0
  @State isLoading:boolean=false;
  private productsController: ProductsController = new ProductsController();

  aboutToAppear(): void {
    console.log(this.currentCategory.toString())
    this.changeType(this.currentCategory)
  }
  getProductTypeByIndex(index: number): ProductType {
    const values = Object.values(ProductType);
    if (index >= 0 && index < values.length) {
      return values[index] as ProductType;
    }
    return ProductType.ALL
  }

  changeType(index:number)
  {
    this.currentCategory = index
    this.productsController.freshData(this.getProductTypeByIndex(this.currentCategory))
  }
  build() {
    Row() {
      Row() {
        // 左侧菜单
        List() {
          ForEach(Object.values(ProductType), (item: ProductType, index: number) => {
            ListItem() {
              Text(item)
                .fontSize(14)
                .fontColor(this.currentCategory === index ? '#ca141d' : '#666')
                .padding({ left: 16 })
                .border({
                  width: { left: 2 },
                  color: this.currentCategory === index ? '#ca141d' : Color.Transparent
                })
            }
            .margin({
              top: 15,
              bottom: 15
            })
            .onClick(() => {
                this.changeType(index)
            })
          })
        }
        .width(100)
        .height('100%')
        .scrollBar(BarState.Off)

        List() {
          GoodPick({ productsController: this.productsController,type:this.getProductTypeByIndex(this.currentCategory),isLoading:this.isLoading})
        }
        .height('100%')
        .layoutWeight(1)
        .padding({ right: 15 })
      }
    }
    .height('100%')
    .width('100%')
  }
}

export default ClassifyList