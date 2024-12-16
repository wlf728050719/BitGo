import GoodPick, { ProductsController } from './components/common/GoodPick'
import { promptAction, router } from '@kit.ArkUI'
import CommonCss from '../style/commonCss'
import { ProductType } from '../model/ProductModel';
import { GlobalVariable } from '../global/GlobalVariable';
import Info from '../model/Info';

@Component
struct UserCenter {
  private productsController: ProductsController = new ProductsController();
  @State isLoading: boolean = false;
  @State isLogin: boolean = false;

  aboutToAppear(): void {
    this.isLogin = GlobalVariable.getInstance().getLoginState();
  }

  build() {
    Scroll() {
      Column() {
        Row({ space: 12 }) {
          Image($r('app.media.ic_public_settings'))
            .width(25)
          Image($r('app.media.ic_public_comments'))
            .width(25)
        }
        .width('100%')
        .justifyContent(FlexAlign.End)
        .margin({ right: 20, top: 15 })

        // 用户基础信息
        Row() {
          Image($r('app.media.ic_header_logo'))
            .width(50)
            .borderRadius(25)
            .margin({ left: 20, right: 10 })
          if (this.isLogin) {
            Column() {
              Text(GlobalVariable.getInstance().getUser().username)
                .fontWeight(600)
                .margin({
                  bottom:10
                })
                .width("100%")
              Row({space:10}) {
                Text('隐私协议')
                  .fontColor(Color.Gray)
                  .fontSize(10)
                Text("修改信息")
                  .onClick(()=>{

                  })
                  .fontColor(Color.Gray)
                  .fontSize(10)
                Text("退出登录")
                  .onClick(async () => {
                    let info: Info = await GlobalVariable.getInstance().logout();
                    promptAction.showDialog({ message: info.message, buttons: [{ text: '确认', color: '#000000' }] })
                    if (info.result) {
                      this.isLogin = false;
                    }
                  })
                  .fontColor(Color.Red)
                  .fontSize(10)
                  .decoration({
                    type:TextDecorationType.Underline
                  })
              }
              .width("100%")
            }
          } else {
            Text('登录/注册')
              .fontWeight(600)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/Login'
                })
              })
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Top)

        Row() {
          Column() {
            Text('--')
              .fontColor('#666')
            Row() {
              Text('积分')
                .fontSize(12)
                .fontColor('#666')
              Image($r('app.media.ic_public_arrow_right'))
                .width(10)
                .fillColor('#666')
            }
          }

          Column() {
            Text('--')
              .fontColor('#666')
            Row() {
              Text('积分')
                .fontSize(12)
                .fontColor('#666')
              Image($r('app.media.ic_public_arrow_right'))
                .width(10)
                .fillColor('#666')
            }
          }

          Column() {
            Text('--')
              .fontColor('#666')
            Row() {
              Text('积分')
                .fontSize(12)
                .fontColor('#666')
              Image($r('app.media.ic_public_arrow_right'))
                .width(10)
                .fillColor('#666')
            }
          }
        }
        .width('100%')
        .padding({ left: 25, right: 25 })
        .margin({ top: 10 })
        .justifyContent(FlexAlign.SpaceAround)

        // 我的订单
        Column() {
          Column() {

            Row() {
              Text('我的订单')
                .fontSize(18)
                .fontWeight(700)
              Blank()
              Row() {
                Text('全部订单')
                  .fontSize(14)
                  .fontColor('#ff9b9a9a')
                Image($r('app.media.ic_public_arrow_right'))
                  .width(18)
                  .fillColor('#ff9b9a9a')
              }
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/BrowseOrder',
                  params: {
                    currentIndex: 0
                  }
                })
              })
            }
            .width('100%')
            .margin({ bottom: 15 })

            Row() {
              Column() {
                Image($r('app.media.ic_public_settings'))
                  .width(30)
                Text('待付款')
                  .fontSize(12)
                  .margin(6)
              }
              .layoutWeight(1)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/BrowseOrder',
                  params: {
                    currentIndex: 1
                  }
                })
              })

              Column() {
                Image($r('app.media.ic_public_settings'))
                  .width(30)
                Text('待收货')
                  .fontSize(12)
                  .margin(6)
              }
              .layoutWeight(1)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/BrowseOrder',
                  params: {
                    currentIndex: 2
                  }
                })
              })

              Column() {
                Image($r('app.media.ic_public_comments'))
                  .width(30)
                Text('已完成')
                  .fontSize(12)
                  .margin(6)
              }
              .layoutWeight(1)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/BrowseOrder',
                  params: {
                    currentIndex: 3
                  }
                })
              })

              Column() {
                Image($r('app.media.ic_public_comments'))
                  .width(30)
                Text('已取消')
                  .fontSize(12)
                  .margin(6)
              }
              .layoutWeight(1)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/BrowseOrder',
                  params: {
                    currentIndex: 4
                  }
                })
              })

              Column() {
                Image($r('app.media.ic_public_comments'))
                  .width(30)
                Text('评论')
                  .fontSize(12)
                  .margin(6)
              }
              .layoutWeight(1)
            }
            .width('100%')
          }
          .margin({ left: 15, right: 15 })
          .backgroundColor('#fff')
          .borderRadius(15)
          .padding(15)

        }
        .width('100%')
        .margin({ top: 20 })
        .alignItems(HorizontalAlign.Start)

        // 我的服务
        Column() {
          Column() {

            Row() {
              Text('我的商品')
                .fontSize(18)
                .fontWeight(700)
              Blank()
              Row() {
                Text('查看详情')
                  .fontSize(14)
                  .fontColor('#ff9b9a9a')
                Image($r('app.media.ic_public_arrow_right'))
                  .width(18)
                  .fillColor('#ff9b9a9a')
              }
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/MyProducts',
                  params: {
                    currentIndex: 0
                  }
                })
              })
            }
            .width('100%')
            .margin({ bottom: 15 })

            Row() {
              Column() {
                Image($r('app.media.ic_public_settings'))
                  .width(30)
                Text('全部商品')
                  .fontSize(12)
                  .margin(6)
              }
              .layoutWeight(1)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/MyProducts',
                  params: {
                    currentIndex: 0
                  }
                })
              })


              Column() {
                Image($r('app.media.ic_public_settings'))
                  .width(30)
                Text('统计信息')
                  .fontSize(12)
                  .margin(6)
              }
              .layoutWeight(1)

              Column() {
                Image($r('app.media.ic_public_comments'))
                  .width(30)
                Text('待付款')
                  .fontSize(12)
                  .margin(6)
              }
              .layoutWeight(1)

              Column() {
                Image($r('app.media.ic_public_comments'))
                  .width(30)
                Text('全部订单')
                  .fontSize(12)
                  .margin(6)
              }
              .layoutWeight(1)

              Column() {
                Image($r('app.media.ic_public_comments'))
                  .width(30)
                Text('待付款')
                  .fontSize(12)
                  .margin(6)
              }
              .layoutWeight(1)
            }
            .width('100%')
          }
          .margin({ left: 15, right: 15 })
          .backgroundColor('#fff')
          .borderRadius(15)
          .padding(15)

        }
        .width('100%')
        .margin({ top: 20 })
        .alignItems(HorizontalAlign.Start)

        // 精选好物
        GoodPick({ productsController: this.productsController, isLoading: this.isLoading })
          .margin({ left: 15, right: 15 })

      }.backgroundColor(CommonCss.BG_COLOR)
    }
    .scrollBar(BarState.Off)
    .onScrollEdge(() => {
      this.productsController.loadData(ProductType.ALL);
    })
  }
}

export default UserCenter