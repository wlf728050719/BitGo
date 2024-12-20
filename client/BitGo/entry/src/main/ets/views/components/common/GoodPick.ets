import { router } from '@kit.ArkUI'
import { GlobalVariable } from '../../../global/GlobalVariable'
import ProductModel, { ProductType } from '../../../model/ProductModel'

export class ProductsController{
  loadData=(type:ProductType)=>{}
  freshData=(type:ProductType)=>{}
}
@Component
struct GoodPick {
  @State products:ProductModel[] = [];
  @Prop type:ProductType = ProductType.ALL
  @Prop showBorder:boolean = false
  @Link isLoading:boolean;
  productsController:ProductsController = new ProductsController();

  loadData = async (type: ProductType) => {
    this.isLoading = true;
    const newProducts = await GlobalVariable.getInstance().getSeveralProductsFromOneType(12, type);
    await Promise.all(newProducts.map((product): Promise<void> => GlobalVariable.getInstance().loadProductImages(product)));
    this.products = this.products.concat(newProducts);
    this.isLoading=false;
  }

  freshData=(type:ProductType)=>{
    this.products=[];
    this.loadData(type);
  }
  aboutToAppear(): void {
    this.freshData(this.type)
    if(this.productsController)
    {
      this.productsController.loadData=this.loadData;
      this.productsController.freshData=this.freshData;
    }
  }
  build() {
    Column() {
      Text('好物精选')
        .fontSize(16)
        .fontWeight(600)
        .width('100%')
        .margin({
          bottom: 12
        })
      Flex({
        wrap: FlexWrap.Wrap,
        justifyContent: FlexAlign.SpaceBetween
      }) {
        ForEach(this.products, (item:ProductModel,index:number) => {
          Column() {
            Image($r(item.images[0]))
              .width(120)
            Column(){
              Text(item.name)
                .fontSize(14)
              Text(item.description)
                .fontSize(12)
                .fontColor('#666')
                .margin({top: 6, bottom:6})
                .textOverflow({
                  overflow: TextOverflow.Ellipsis
                })
                .maxLines(1)

              Text('￥'+item.price)
                .fontSize(14)
                .fontWeight(600)
            }
            .alignItems(HorizontalAlign.Start)
          }
          .width('49%')
          .backgroundColor('#fff')
          .margin({ bottom: 6 })
          .border({
            width:this.showBorder?1:0,
            color:Color.Gray
          })
          .borderRadius(12)
          .padding(8)
          .onClick(()=>{
            router.pushUrl({
              url:'pages/Product',
              params:{
                productId:this.products[index].id
              }
            })
          })
        })
      }
      if(this.isLoading)
      {
        Row() {}
        .width("100%")
        .height("20%")
      }
    }
    .margin({
      top: 20,
      bottom: 20
    })
  }
}

export default GoodPick