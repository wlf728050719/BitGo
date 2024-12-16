import { GlobalVariable } from '../../../global/GlobalVariable';
import CommentModel, { CommentType } from '../../../model/CommentModel'
import OrderModel from '../../../model/OrderModel';

@Component
struct CommentBar {
  @Prop commentModel: CommentModel
  @State showAll: boolean = false;
  @State allComments: CommentModel[] = []
  private scoreList: number[] = [1, 2, 3, 4, 5]
  @State order:OrderModel = OrderModel.getDefaultOrderModel();
  @State username:string="xxx"

  async aboutToAppear(): Promise<void> {
    this.order = await GlobalVariable.getInstance().getOrderById(this.commentModel.orderId);
    this.username = await GlobalVariable.getInstance().getUsernameById(this.order.buyerId);
  }
  build() {
    Column() {
      Column({ space: 10 }) {
        Row() {
          Image($r('app.media.ic_header_logo'))
            .width(20)
            .height(20)
            .borderRadius(10)
            .margin({
              right: 5
            })
          Text(this.username)
            .fontSize(15)
        }
        .width('100%')
        Row({space:4})
        {
          Text('购买数量: '+this.order.amount)
            .fontSize(8)
            .fontColor(Color.Gray)
          Text('购买时间: '+this.order.date.toLocaleString())
            .fontSize(8)
            .fontColor(Color.Gray)
        }
        .width("100%")
        Divider()
          .height(2)
          .color(Color.Gray)
        Text(this.commentModel.description)
          .lineHeight(12)
          .fontSize(12)
          .maxLines(5)
          .textOverflow({
            overflow: TextOverflow.Ellipsis
          })
          .height(40)
          .width('100%')
        Row() {
          ForEach(this.scoreList, (item: number, index) => {
            if (item <= this.commentModel.score) {
              Image($r('app.media.ic_public_highlightsed'))
                .width(15)
                .height(15)
                .colorBlend(Color.Yellow)
            } else {
              Image($r('app.media.ic_public_highlightsed'))
                .width(15)
                .height(15)
                .colorBlend(Color.Gray)
            }
          })
          Text(this.commentModel.date.toLocaleString())
            .fontSize(10)
            .fontColor(Color.Gray)
            .margin({
              left: 10
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.End)
      }
      .width("100%")
      .height("20%")
      Text(this.showAll?'收起回复评论':'展开回复评论')
        .onClick(async () => {
          this.showAll = !this.showAll
          if(this.showAll)
            this.allComments = await GlobalVariable.getInstance().getAllComments(this.commentModel.id);
        })
        .decoration({
          type:TextDecorationType.Underline
        })
        .fontColor(Color.Gray)
        .fontSize(8)
        .margin({
          top:5,
          bottom:10
        })
      if (this.showAll) {
        ForEach(this.allComments, (item: CommentModel) => {
          if (item.type != CommentType.ORIGINAL) {
            Column({space:10})
            {
              Text(item.type==CommentType.FOLLOW?'用户追评':'商家回复')
                .width("100%")
                .fontSize(15)
              Divider()
                .height(2)
                .color(Color.Gray)
              Text(item.description)
                .lineHeight(12)
                .fontSize(12)
                .maxLines(5)
                .textOverflow({
                  overflow: TextOverflow.Ellipsis
                })
                .height(40)
                .width('100%')
              Text(item.date.toLocaleString())
                .fontSize(10)
                .fontColor(Color.Gray)
                .margin({
                  left: 10
                })
            }
            .width("100%")
          }
        })
      }
    }
    .padding(20)
    .border({
      width: 2
    })
    .borderRadius(10)
    .borderColor('#f1f3f5')
    .margin({
      top: 5,
      left: 5,
      right: 5
    })
  }
}

export default CommentBar