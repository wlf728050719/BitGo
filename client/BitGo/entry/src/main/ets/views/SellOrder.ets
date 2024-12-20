import { GlobalVariable } from '../global/GlobalVariable'
import OrderModel, { OrderStatus } from '../model/OrderModel'
import { router } from '@kit.ArkUI'
import { Controller } from '../pages/BrowseBuyOrder'
import SellOrderBar from './components/order/SellOrderBar'

@Component
struct SellOrder {
  @State orders: OrderModel[] = []
  @Prop showAll: boolean = true
  @Prop selectedStatus: OrderStatus = OrderStatus.PENDING
  @Link searchWord:string
  private controller:Controller = new Controller();
  async aboutToAppear(): Promise<void> {
    if (GlobalVariable.getInstance().getLoginState()) {
      if(this.controller)
      {
        this.controller.search= async (value:string)=>{
          if (this.showAll) {
            this.orders = await GlobalVariable.getInstance().getSellOrdersContainsSearchWord(value);
          } else {
            this.orders = await GlobalVariable.getInstance().getSellOrdersByStatusAndSearchWord(this.selectedStatus,value);
          }
        }
        await this.controller.search(this.searchWord);
      }
    }
  }

  build() {
    Scroll() {
      if (GlobalVariable.getInstance().getLoginState()) {
        if (this.orders.length > 0) {
          Column({ space: 10 }) {
            ForEach(this.orders, (item: OrderModel) => {
              SellOrderBar({ order: item })
                .height("70%")
            })
            Text('已经到底了')
              .fontColor(Color.Gray)
              .fontSize(10)
              .height("20%")
          }
          .width('100%')
        } else {
          Column({ space: 10 }) {
            Text('订单空空如也')
              .fontSize(12)
              .fontColor(Color.Gray)
            Button('去购物')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/Index',
                  params: {
                    currentIndex: 1
                  }
                })
              })
              .backgroundColor(Color.Red)
              .fontColor(Color.White)
          }
          .height("55%")
          .width("100%")
          .margin({
            top: "45%"
          })
        }
      } else {
        Column({ space: 10 }) {
          Text('请先登录后再查看订单')
            .fontSize(12)
            .fontColor(Color.Gray)
          Button('登录')
            .onClick(() => {
              router.pushUrl({
                url: 'pages/Login'
              })
            })
            .backgroundColor(Color.Red)
            .fontColor(Color.White)
            .width("40%")
        }
        .height("55%")
        .width("100%")
        .margin({
          top: "45%"
        })
      }
    }
    .height("100%")
    .width('100%')
    .padding(10)
  }
}

export default SellOrder;