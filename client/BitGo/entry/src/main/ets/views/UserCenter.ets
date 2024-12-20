import GoodPick, { ProductsController } from './components/common/GoodPick'
import { promptAction, router } from '@kit.ArkUI'
import CommonCss from '../style/commonCss'
import { ProductType } from '../model/ProductModel';
import { GlobalVariable } from '../global/GlobalVariable';
import Info from '../model/Info';
import loading1 from './components/loading/loading1';
@Component
struct SettingButton
{
  @Prop content:string
  @Prop imagePath:string
  build() {
    Row()
    {
      Row(){
        Image($r(this.imagePath)).height("80%")
        Text(this.content)
          .fontSize(15)
      }
      Image($r('app.media.ic_public_arrow_right'))
        .height("80%")
    }
    .backgroundColor(Color.White)
    .justifyContent(FlexAlign.SpaceBetween)
    .width("100%")
    .height("8%")
    .padding(10)
  }
}

@Component
struct UserCenter {
  @State cw: number=0;
  private productsController: ProductsController = new ProductsController();
  @State isLoading: boolean = false;
  @State isLogin: boolean = false;
  @State showSetting:boolean = false;
  @State showUrlSetting:boolean = false;
  @State ip:string=''
  @State port:string=''
  aboutToAppear(): void {
    this.isLogin = GlobalVariable.getInstance().getLoginState();
  }

  build() {
    Column(){
      Scroll() {
        Column() {
          Row({ space: 12 }) {
            Image($r('app.media.ic_public_settings'))
              .width(25)
              .onClick(()=>{
                this.showSetting = true
              })
            Image($r('app.media.ic_public_comments'))
              .width(25)
          }
          .width('100%')
          .justifyContent(FlexAlign.End)
          .margin({ right: 20, top: 15 })
          .height("5%")

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
          .height("10%")
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
          .height("10%")
          .padding({ left: 25, right: 25 })
          .margin({ top: 10 })
          .justifyContent(FlexAlign.SpaceAround)

          // 我的订单
          Column() {
            Column() {

              Row() {
                Text('买家服务')
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
                    url: 'pages/BrowseBuyOrder',
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
                  Text('购物车')
                    .fontSize(12)
                    .margin(6)
                }
                .layoutWeight(1)
                .onClick(() => {

                })

                Column() {
                  Image($r('app.media.ic_public_settings'))
                    .width(30)
                  Text('我的收藏')
                    .fontSize(12)
                    .margin(6)
                }
                .layoutWeight(1)
                .onClick(() => {
                  if(GlobalVariable.getInstance().getLoginState())
                    router.pushUrl({
                      url:"pages/UserFavorites"
                    })
                  else
                    promptAction.showDialog({ message: '请先登录', buttons: [{ text: '确认', color: '#000000' }] })
                })
                Column() {
                  Image($r('app.media.ic_public_comments'))
                    .width(30)
                  Text('浏览记录')
                    .fontSize(12)
                    .margin(6)
                }
                .layoutWeight(1)
                .onClick(() => {
                })

                Column() {
                  Image($r('app.media.ic_public_comments'))
                    .width(30)
                  Text('售后申请')
                    .fontSize(12)
                    .margin(6)
                }
                .layoutWeight(1)
                .onClick(() => {

                })

                Column() {
                  Image($r('app.media.ic_public_comments'))
                    .width(30)
                  Text('我的聊天')
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
          .height("20%")
          .margin({ top: 20 })
          .alignItems(HorizontalAlign.Start)

          // 我的服务
          Column() {
            Column() {

              Row() {
                Text('卖家服务')
                  .fontSize(18)
                  .fontWeight(700)
                Blank()
                Row() {
                  Text('我的商品')
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
                  Text('发布商品')
                    .fontSize(12)
                    .margin(6)
                }
                .layoutWeight(1)
                .onClick(() => {
                  router.pushUrl({
                    url:"pages/Index",
                    params:{
                      currentIndex:2
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
                .onClick(()=>{
                  router.pushUrl({
                    url: 'pages/MyProducts',
                    params: {
                      currentIndex: 1
                    }
                  })
                })

                Column() {
                  Image($r('app.media.ic_public_comments'))
                    .width(30)
                  Text('订单管理')
                    .fontSize(12)
                    .margin(6)
                }
                .onClick(()=>{
                  router.pushUrl({
                    url: 'pages/BrowseSellOrder',
                    params: {
                      currentIndex: 0
                    }
                  })
                })
                .layoutWeight(1)

                Column() {
                  Image($r('app.media.ic_public_comments'))
                    .width(30)
                  Text('售后处理')
                    .fontSize(12)
                    .margin(6)
                }
                .layoutWeight(1)

                Column() {
                  Image($r('app.media.ic_public_comments'))
                    .width(30)
                  Text('我的聊天')
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
          .height("20%")
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
      if(this.showSetting)
      {
        Row()
        {
          Column()
          {
            Row()
            {
              Text('设置')
                .fontSize(18)
            }
            .justifyContent(FlexAlign.Center)
            .backgroundColor(Color.White)
            .width("100%")
            .height("8%")
            Scroll(){
              Column(){
                SettingButton({content:'修改账号信息',imagePath:''})
                  .margin({top:10,bottom:10})
                  .onClick(()=>{
                    router.pushUrl({
                      url:"pages/ChangeUserInfo"
                    })
                  })
                SettingButton({content:'免密支付设置',imagePath:''})
                SettingButton({content:'消息接受设置',imagePath:''})
                  .margin({bottom:10})
                SettingButton({content:'长辈版',imagePath:''})
                SettingButton({content:'未成年人模式',imagePath:''})
                SettingButton({content:'界面设置',imagePath:''})
                  .margin({bottom:10})
                SettingButton({content:'常见问题',imagePath:''})
                SettingButton({content:'意见反馈',imagePath:''})
                  .margin({bottom:10})
                SettingButton({content:'清除缓存',imagePath:''})
                SettingButton({content:'个人信息共享清单',imagePath:''})
                SettingButton({content:'个人信息收集清单',imagePath:''})
                SettingButton({content:'关于BitGo',imagePath:''})
                  .margin({bottom:10})
                Button('切换账号')
                  .type(ButtonType.Normal)
                  .width("100%")
                  .backgroundColor(Color.White)
                  .fontColor(Color.Black)
                  .margin({bottom:10})
                Button('退出登录')
                  .type(ButtonType.Normal)
                  .width("100%")
                  .backgroundColor(Color.White)
                  .fontColor(Color.Red)
                  .margin({bottom:10})
                  .onClick(async () => {
                    let info: Info = await GlobalVariable.getInstance().logout();
                    this.showSetting=false;
                    promptAction.showDialog({ message: info.message, buttons: [{ text: '确认', color: '#000000' }] })
                    if (info.result) {
                      this.isLogin = false;
                    }
                  })
                Text('网络诊断')
                  .fontSize(12)
                  .fontColor(Color.Blue)
                  .decoration({
                    type:TextDecorationType.Underline
                  })
                  .onClick(()=>{
                    this.showUrlSetting=true;
                  })
                Row()
                  .width("100%")
                  .height("15%")
              }
            }
            .scrollBar(BarState.Off)
          }
          .backgroundColor(CommonCss.BG_COLOR)
          .width("50%")
          .height("100%")
          Column(){}
          .width("50%")
          .height("100%")
          .backgroundColor(Color.Transparent)
          .onClick(()=>{
            this.showSetting=false;
          })
        }
        .position({
          top:0,
          left:0
        })
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
      if(this.showUrlSetting)
      {
        Column({space:10})
        {
          Text('网络设置')
          TextInput({placeholder:'IP'})
            .onChange((value:string)=>{
              this.ip = value;
            })
            .width("100%")
          TextInput({placeholder:'PORT'})
            .onChange((value:string)=>{
              this.port = value;
            })
            .width("100%")
          Button('确认')
            .onClick(()=>{
              GlobalVariable.getInstance().setUrl(this.ip,this.port);
              this.showUrlSetting=false;
            })
            .width("100%")
          Text('取消')
            .onClick(()=>{
              this.showUrlSetting=false;
            })
            .decoration({
              type:TextDecorationType.Underline
            })
            .fontColor(Color.Red)
        }
        .padding(10)
        .backgroundColor(CommonCss.BG_COLOR)
        .border({
          width:1,
          color:Color.Gray
        })
        .position({
          left:"20%",
          top:"30%"
        })
        .borderRadius("5%")
        .width("60%")
        .height("40%")
      }
    }
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.cw = new Number(newValue.width).valueOf()
    })
  }
}

export default UserCenter