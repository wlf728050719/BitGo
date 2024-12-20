import { OrderStatus } from '../model/OrderModel'
import CommonCss from '../style/commonCss'
import BuyOrder from '../views/BuyOrder'
import { router } from '@kit.ArkUI'

export class Controller{
  search = async (value: string) => {
  }
}
@Entry
@Component
struct BrowseBuyOrder{
  private controller0:Controller=new Controller();
  private controller1:Controller=new Controller();
  private controller2:Controller=new Controller();
  private controller3:Controller=new Controller();
  private controller4:Controller=new Controller();
  private controller5:Controller=new Controller();
  @State searchWord:string=''
  aboutToAppear(): void {
    const params = router.getParams()
    if (params != null)
      this.currentIndex = (params as object)['currentIndex']
  }
  @State currentIndex:number=0
  menus:string[] =['全部','待付款','待发货','待收货','已完成','已取消']
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
      BuyOrder({showAll:true,controller:this.controller0})
    }else if (index === 1) {
      BuyOrder({showAll:false,selectedStatus:OrderStatus.PENDING,controller:this.controller1})
    }else if (index === 2) {
      BuyOrder({showAll:false,selectedStatus:OrderStatus.PREPARED,controller:this.controller2})
    } else if (index === 3) {
      BuyOrder({showAll:false,selectedStatus:OrderStatus.SHIPPED,controller:this.controller3})
    } else if (index === 4) {
      BuyOrder({showAll:false,selectedStatus:OrderStatus.DELIVERED,controller:this.controller4})
    } else {
      BuyOrder({showAll:false,selectedStatus:OrderStatus.CANCELED,controller:this.controller5})
    }
  }
  build() {
    Column(){
      Row(){
        Image($r('app.media.ic_public_arrow_left'))
          .width('5%')
          .fillColor(Color.Gray)
          .onClick(()=>{
            router.pushUrl({
              url:'pages/Index',
              params:{
                currentIndex:4
              }
            })
          })
        Row() {
          Image($r('app.media.ic_public_search'))
            .width('8%')
            .fillColor('#5c5c5d')
            .onClick(async ()=>{
              switch (this.currentIndex)
              {
                case 0:this.controller0.search(this.searchWord);break;
                case 1:this.controller1.search(this.searchWord);break;
                case 2:this.controller2.search(this.searchWord);break;
                case 3:this.controller3.search(this.searchWord);break;
                case 4:this.controller4.search(this.searchWord);break;
                case 5:this.controller5.search(this.searchWord);break;
              }
            })
          TextInput({
            placeholder: '搜索我的订单'
          })
            .placeholderFont({size:12})
            .backgroundColor(Color.Transparent)
            .fontSize(12)
            .onChange((value:string)=>{
              this.searchWord=value;
            })
        }
        .backgroundColor('#e5e7e9')
        .borderRadius('50%')
        .layoutWeight(1)
        .padding({
          left: 10,
          right:20
        })
        .margin({
          left:5,
          right:5
        })
        Image($r('app.media.ic_public_view_list_filled'))
          .width('10%')
          .fillColor(Color.Gray)
          .width('5%')
        Text('筛选')
          .fontSize(12)
      }
      .width('100%')
      .height('5%')
      .margin(10)
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
        switch (this.currentIndex)
        {
          case 0:this.controller0.search(this.searchWord);break;
          case 1:this.controller1.search(this.searchWord);break;
          case 2:this.controller2.search(this.searchWord);break;
          case 3:this.controller3.search(this.searchWord);break;
          case 4:this.controller4.search(this.searchWord);break;
          case 5:this.controller5.search(this.searchWord);break;
        }
      })
    }
    .backgroundColor(CommonCss.BG_COLOR)
    .width('100%')
    .height('100%')
  }
}