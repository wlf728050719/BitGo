import CommentBar from './components/comment/CommentBar'
import CommentModel from '../model/CommentModel'
import { GlobalVariable } from '../global/GlobalVariable'

@Component
struct CommentSection {
  scroller: Scroller = new Scroller()
  @State timeSorted:boolean = false
  @State scoreSorted:boolean = false
  @State isShowGoTopButton: boolean = false
  @State comments:CommentModel[] = [];
  @Prop product_id:number;

  async aboutToAppear(): Promise<void> {
    this.comments = await GlobalVariable.getInstance().getOriginalComments(this.product_id);
  }
  build() {
    Column() {
      Text('共'+this.comments.length+'条评论')
        .width("100%")
        .fontSize(10)
      Row({space:5}){
        Column(){
          Row(){
            Image($r('app.media.ic_public_view_list_filled'))
              .height(15)
            Text('时间排序')
              .fontSize(10)
          }
          .border({
            width:1,
            color:this.timeSorted?'#ffffcaca':'#f1f3f5'
          })
          .borderRadius(10)
          .padding(2)
          .backgroundColor(this.timeSorted?'#ffffcaca':'#f1f3f5')
          .onClick(() => {
            this.comments.sort((a, b) => a.date.getTime() - b.date.getTime()); // 按时间排序
            this.scoreSorted=false
            this.timeSorted=true
          })
        }
        Column(){
          Row(){
            Image($r('app.media.ic_public_view_list_filled'))
              .height(15)
            Text('分数排序')
              .fontSize(10)
          }
          .border({
            width:1,
            color:this.scoreSorted?'#ffffcaca':'#f1f3f5'
          })
          .borderRadius(10)
          .padding(2)
          .backgroundColor(this.scoreSorted?'#ffffcaca':'#f1f3f5')
          .onClick(() => {
            this.comments.sort((a, b) => b.score - a.score); // 按分数高低排序
            this.scoreSorted=true
            this.timeSorted=false
          })
        }
      }
      .width('100%')
      .margin({
        top:5,
        bottom:5
      })
      ForEach(this.comments, (item: CommentModel) => {
        CommentBar({ commentModel: item })
      })
    }
  }
}
export default CommentSection