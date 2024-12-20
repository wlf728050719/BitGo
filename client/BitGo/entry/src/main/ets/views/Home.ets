import HomeBanner from './components/home/HomeBanner';
import HomeClassify from './components/home/HomeClassify';
import HomeRecommend from './components/home/HomeRecommend';
import HomeSubarea from './components/home/HomeSubarea';
import HomeTab from './components/home/HomeTab';
import HomeWelfare from './components/home/HomeWelfare';
import HomeHeader from './components/home/HomeHeader';
import GoodPick, { ProductsController } from './components/common/GoodPick'
import SearchProducts from './SearchProducts';
import { ProductType } from '../model/ProductModel';
import loading1 from './components/loading/loading1';

@Component
struct Home {
  scroller: Scroller = new Scroller()
  // 是否展示回到顶部按钮
  @State isShowGoTopButton: boolean = false
  private productsController:ProductsController =new ProductsController();
  @State search:boolean = false
  @State searchValue:string = ''
  @State isLoading:boolean = false;
  @State cw:number = 0
  searchProducts(value:string)
  {
    console.log('搜索:'+value)
    if(value.length>0)
    {
      this.search=true
      this.searchValue = value
    }
    else
    {
      this.search=false
      this.searchValue=''
    }
  }
  aboutToAppear(): void {
    // this.scroller.scrollTo({ xOffset: 0, yOffset: 100 })
  }

  onPageShow(): void {
    // this.scroller.scrollTo({ xOffset: 0, yOffset: 800 })
  }

  build() {
    Column() {
      // 头部
      if(!this.search)
        HomeHeader({searchProducts:(value:string)=>{this.searchProducts(value);}})
      Column(){
        if(this.search)
        {
          Scroll(){
            SearchProducts({searchWords:this.searchValue});
          }
        }
        else
        {
          // 内容主题
          Scroll(this.scroller) {
            Column() {
              HomeTab()
              HomeBanner()
              HomeClassify()
              HomeWelfare()
              HomeRecommend()
              HomeSubarea()
              HomeSubarea()
              HomeSubarea()
              GoodPick({productsController:this.productsController,isLoading:this.isLoading})
            }
            .width('100%')
            .margin({ bottom: 15 })
          }
          .width('100%')
          .layoutWeight(1)
          .onWillScroll(() => {
            const scrollYOffset = this.scroller.currentOffset().yOffset
            this.isShowGoTopButton = scrollYOffset > 100 ? true : false
          })
          .onScrollEdge((side)=>{
            if(side==Edge.Bottom)
              this.productsController.loadData(ProductType.ALL);
          })
          if(this.isShowGoTopButton) Button({ type: ButtonType.Circle, stateEffect: true }) {
            Image($r('app.media.ic_public_backtotop'))
              .width(20)
              .fillColor('#666')
          }
          .width(35)
          .height(35)
          .backgroundColor('#fff')
          .shadow({
            radius: 3,
            color: '#666',
            offsetX: 2,
            offsetY: 2
          })
          .position({
            bottom: 10,
            right: 10
          })
          .onClick(() => {
            this.scroller.scrollEdge(Edge.Top)
            this.productsController.freshData(ProductType.ALL);
          })
        }
      }
      if (this.isLoading) {
       loading1({w:this.cw*0.3})
        .position({
          top: "40%",
          right: "35%"
        })
        .height("10%")
        .width("30%")
      }
    }
    .width('100%')
    .height('100%')
    .linearGradient({
      angle: 180, // 渐变角度，设置为180，即为从上往下渐变
      colors: [['#fefefe', 0], ['#f2f4f5', 1]]
    })
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.cw = new Number(newValue.width).valueOf()
    })
  }
}

export default Home