import { router } from '@kit.ArkUI'

@Component
struct HomeHeader {
  @State searchValue:string = ''
  searchProducts=(value:string)=>{}
  build() {
    Row({space: 10}) {
      Image($r('app.media.logo_red'))
        .width(80)
      Row() {
        Image($r('app.media.ic_public_search'))
          .width(22)
          .fillColor('#5c5c5d')
          .onClick(()=>{
            this.searchProducts(this.searchValue);
          })
        TextInput({
          placeholder: '请输入',
          text:this.searchValue
        })
          .backgroundColor(Color.Transparent)
          .onChange((value:string)=>{
            this.searchValue=value
          })
      }
      .backgroundColor('#e5e7e9')
      .borderRadius(20)
      .layoutWeight(1)
      .padding({
        left: 10,
        right: 10
      })

      Image($r('app.media.ic_public_comments'))
        .width(28)
      Text('登录')
        .fontSize(16)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/Login'
          })
        })
    }
    .width('100%')
    .height(58)
    .backgroundColor('#f1f3f5')
    .padding({
      left: 10,
      right: 10
    })
  }
}

export default HomeHeader