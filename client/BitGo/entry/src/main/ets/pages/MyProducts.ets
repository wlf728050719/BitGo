import AllProducts from '../views/AllProducts'
import { router } from '@kit.ArkUI'

@Entry
@Component
struct MyProducts{
  @State currentIndex:number=0
  menus:string[] =['全部商品','统计信息']
  @Builder
  TabBarBuilder(item:string,index: number) {
    Column(){
      Text(item)
        .fontColor(index === this.currentIndex ? '#ca141d' : '#808182')
    }
  }
  @Builder
  TabEachBuilder(index: number) {
    if (index === 0) {
      AllProducts()
    } else if (index === 1) {

    }
  }
  build() {
    Column(){
      Row(){
        Image($r('app.media.ic_public_back'))
          .width('5%')
          .colorBlend(Color.Gray)
          .onClick(()=>{
            router.pushUrl({
              url:'pages/Index',
              params:{
                currentIndex:4
              }
            })
          })
        Text('我的商品')
          .fontSize(18)
      }
      .width('100%')
      .height('5%')
      Tabs({ barPosition: BarPosition.Start, index: this.currentIndex }) {
        ForEach(this.menus, (item:string,index: number) => {
          TabContent() {
            this.TabEachBuilder(index)
          }
          .tabBar(this.TabBarBuilder(item,index))
        })
      }
      .animationDuration(0)
      .barBackgroundColor(Color.White)
      .onChange((index: number) => {
        this.currentIndex = index
      })
    }
  }
}