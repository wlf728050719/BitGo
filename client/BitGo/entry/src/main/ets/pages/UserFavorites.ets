import { GlobalVariable } from '../global/GlobalVariable'
import { UserFavoriteModel } from '../model/UserFavoriteModel'
import CommonCss from '../style/commonCss'
import { router } from '@kit.ArkUI'
import FavoriteBar from '../views/components/favorite/FavoriteBar'

@Entry
@Component
struct UserFavorites{
  @State userFavorites:UserFavoriteModel[]=[]
  async aboutToAppear(){
    this.userFavorites = await GlobalVariable.getInstance().getUserFavoritesByUserId();
  }
  build() {
    Column(){
      Row()
      {
        Image($r('app.media.ic_public_arrow_left'))
          .height("80%")
          .onClick(()=>{
            router.back()
          })
        Text('我的收藏')
      }
      .width("100%")
      .height("5%")
      Scroll()
      {
        Column({space:10})
        {
          ForEach(this.userFavorites,(item:UserFavoriteModel)=> {
            FavoriteBar({productId:item.productId})
          })
        }
        .width("100%")
        .height("100%")
      }
      .padding(10)
      .backgroundColor(CommonCss.BG_COLOR)
      .width("100%")
      .height("100%")
    }
  }
}