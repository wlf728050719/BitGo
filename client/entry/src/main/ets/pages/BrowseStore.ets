import ProductModel from '../model/ProductModel';
import { router } from '@kit.ArkUI';
import { GlobalVariable } from '../global/GlobalVariable';
import CommonCss from '../style/commonCss';
import ProductBaseInfoBar from '../views/components/store/ProductBaseInfoBar';

@Entry
@Component
struct BrowseStore {
  @State sellerId: number = 0;
  @State products: ProductModel[] = [];
  @State scores: number[] = [];
  @State saleAmounts:number[] =[]
  @State storeName: string = ''
  @State currentIndex: number = 0;
  @State searchValue: string = '';
  menus: string[] = ['热销商品', '好评商品']

  findTopThreeSales(): number[] {
    const indices = this.saleAmounts.map((amount, index) => index);
    indices.sort((a, b) => this.saleAmounts[b] - this.saleAmounts[a]);
    return indices.slice(0, Math.min(4, indices.length));
  }

  @Builder
  TabBarBuilder(item: string, index: number) {
    Column() {
      Text(item)
        .fontColor(index === this.currentIndex ? '#ca141d' : '#808182')
    }
  }

  @Builder
  TabEachBuilder(index: number) {
    Row({ space: 5 }) {
      Column() {
        Text(index == 0 ? '销量第二' : '好评第二').fontSize(12)
        if(this.findTopThreeSales().length>2)
        {
          Image($r(this.products[this.findTopThreeSales()[1]].images[0]))
            .height("70%")
          Text(this.products[this.findTopThreeSales()[1]].name)
            .fontSize(10)
            .height("10%")
        }
        else
          Text('暂无商品')
      }
      .margin({ top: 20 })
      .backgroundColor(Color.White)
      .width("30%")
      .height("80%")

      Column() {
        Text(index == 0 ? '销量第一' : '好评第一').fontSize(15)
        if(this.findTopThreeSales().length>1)
        {
          Image($r(this.products[this.findTopThreeSales()[0]].images[0]))
            .height("70%")
          Text(this.products[this.findTopThreeSales()[0]].name)
            .fontSize(12)
            .height("10%")
        }
        else
          Text('暂无商品')
      }
      .backgroundColor(Color.White)
      .width("40%")
      .height("90%")

      Column() {
        Text(index == 0 ? '销量第三' : '好评第三').fontSize(12)
        if(this.findTopThreeSales().length>3)
        {
          Image($r(this.products[this.findTopThreeSales()[2]].images[0]))
            .height("70%")
          Text(this.products[this.findTopThreeSales()[2]].name)
            .fontSize(10)
            .height("10%")
        }
        else
          Text('暂无商品')
      }.margin({ top: 20 })
      .width("30%")
      .height("80%")
      .backgroundColor(Color.White)
    }
    .width("100%")
    .height("100%")
  }

  async aboutToAppear(): Promise<void> {
    const params = router.getParams()
    if (params != null) {
      this.sellerId = (params as object)['sellerId'];
      this.storeName = await GlobalVariable.getInstance().getUsernameById(this.sellerId);
      this.products = await GlobalVariable.getInstance().getProductsBySellerId(this.sellerId);
      for (let item of this.products) {
        let score: number = await GlobalVariable.getInstance().getAvgScoreByProductId(item.id);
        let saleAmount:number = await GlobalVariable.getInstance().getSaleAmountByProductId(item.id);
        this.scores.push(score);
        this.saleAmounts.push(saleAmount)
      }
    }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_header_logo'))
          .height("80%")
        Column() {
          Text(this.storeName)
            .fontWeight(600)
            .width("100%")
          Text('商品数目:' + this.products.length + '件')
            .width("100%")
            .fontSize(10)
        }
      }
      .padding(5)
      .width("100%")
      .height("10%")

      Tabs({ barPosition: BarPosition.Start, index: this.currentIndex }) {
        ForEach(this.menus, (item: string, index: number) => {
          TabContent() {
            this.TabEachBuilder(index)
          }
          .tabBar(this.TabBarBuilder(item, index))
        })
      }
      .height("25%")
      .width("100%")
      .barBackgroundColor(Color.Red)
      .barHeight("20%")
      .animationDuration(0)
      .barBackgroundColor(Color.White)
      .onChange((index: number) => {
        this.currentIndex = index
      })
      Row() {
        Image($r('app.media.ic_public_search'))
          .width(22)
          .fillColor('#5c5c5d')
          .onClick(() => {

          })
        TextInput({
          placeholder: '请输入',
          text: this.searchValue
        })
          .backgroundColor(Color.Transparent)
          .onChange((value: string) => {
            this.searchValue = value
          })
      }
      .height("5%")
      .width("95%")
      .backgroundColor('#e5e7e9')
      .borderRadius(20)
      .layoutWeight(1)
      .margin({
        left:10,
        right:10,
        top:5
      })

      Scroll() {
        Column({space:10}) {
          ForEach(this.products,(item:ProductModel,index:number)=>{
            ProductBaseInfoBar({product:ProductModel.copy(item),score:this.scores[index],saleAmount:this.saleAmounts[index]})
              .width("100%")
              .height("20%")
              .backgroundColor(Color.White)
          })
        }
      }
      .width("100%")
      .height("60%")
      .padding(10)
    }
    .width("100%")
    .height("100%")
    .backgroundColor(CommonCss.BG_COLOR)
  }
}