import ProductModel from '../model/ProductModel'
import CommonCss from '../style/commonCss';
import { router } from '@kit.ArkUI';
import { GlobalVariable } from '../global/GlobalVariable';
import OrderModel from '../model/OrderModel';
import CommentModel, { CommentType } from '../model/CommentModel';

@Entry
@Component
struct WriteComment {
  @State score: number = 5;
  @State content: string = ""
  private scoreList: number[] = [1, 2, 3, 4, 5]
  @State order: OrderModel = OrderModel.getDefaultOrderModel();
  @State productModel: ProductModel = ProductModel.getDefaultProductModel();
  @State comments: CommentModel[] = [];
  @State type: CommentType = CommentType.ORIGINAL
  @State isWriting: boolean = false;

  async aboutToAppear(): Promise<void> {
    const params = router.getParams()
    if (params != null) {
      this.order = OrderModel.copy((params as object)['order'] as OrderModel);
      this.productModel = await GlobalVariable.getInstance().getProductById(this.order.productId);
      this.comments = await GlobalVariable.getInstance().getAllCommentsByOrderId(this.order.id);
      if (this.type != CommentType.REPLY) {
        if (this.comments.length > 0) {
          this.type = CommentType.FOLLOW;
          this.score = this.comments[0].score;
        } else {
          this.type = CommentType.ORIGINAL;
        }
      }
      console.log(this.type.toString());
    }
  }

  build() {
    Column({ space: 15 }) {
      Row() {
        Image($r("app.media.ic_public_arrow_left"))
          .height("80%")
          .onClick(() => {
            router.back();
          })
        Text("商品评论")
          .fontSize(20)
      }
      .margin({
        top: 5,
        bottom: 10
      })
      .height("5%")
      .width("100%")

      Row({ space: 10 }) {
        Image($r(this.productModel.images[0]))
          .width("30%")
          .height("80%")
          .margin({
            left: 10,
            right: 10
          })
        Column({ space: 5 }) {
          Text(this.productModel.name)
            .width("100%")
          Text(this.productModel.description)
            .fontSize(10)
            .fontColor(Color.Gray)
            .width("100%")
          Text('￥' + this.productModel.price.toString())
            .fontColor(Color.Red)
            .fontSize(15)
            .width("100%")
          Row({ space: 15 }) {
            Text("商品详情")
              .border({
                width: 1,
                color: CommonCss.BG_COLOR
              })
              .onClick(() => {
                router.pushUrl(
                  {
                    url: 'pages/Product',
                    params: {
                      productId: this.productModel.id
                    }
                  }
                )
              })
              .borderRadius("50%")
              .fontSize(10)
              .padding(4)
              .backgroundColor(CommonCss.BG_COLOR)
            Text("联系商家")
              .border({
                width: 1,
                color: CommonCss.BG_COLOR
              })
              .borderRadius("50%")
              .fontSize(10)
              .padding(4)
              .backgroundColor(CommonCss.BG_COLOR)
            Text("申请退款")
              .border({
                color: Color.Red,
                width: 1
              })
              .borderRadius("50%")
              .fontSize(10)
              .fontColor(Color.White)
              .padding(4)
              .backgroundColor(Color.Red)
          }
          .width("100%")
        }
      }
      .width("100%")
      .height("30%")
      .backgroundColor(Color.White)
      .borderRadius("5%")

      Row() {
        Text("商品评分:")
          .margin({
            left: 10,
            right: 10
          })
        ForEach(this.scoreList, (item: number) => {
          Image($r("app.media.ic_public_highlightsed"))
            .width(15)
            .height(15)
            .colorBlend((item <= this.score) ? Color.Yellow : Color.Gray)
            .onClick(() => {
              this.score = item;
            })
        })
        Text(" (" + this.score + ") ")
      }
      .backgroundColor(Color.White)
      .width("100%")
      .height("5%")
      .borderRadius("50%")

      if (this.isWriting) {
        Column({space:5}){
          Row({space:5}){
            Text("收起输入框")
              .fontSize(12)
              .fontColor(Color.Gray)
              .decoration({
                type:TextDecorationType.Underline
              })
              .onClick(()=>{
                this.isWriting=false;
              })
            Image($r("app.media.ic_public_arrow_down_0"))
              .height("80%")
          }
          .height("4%")
          .justifyContent(FlexAlign.Center)
          TextArea({ text: this.content, placeholder: '在此处填写您的评价' })
            .height('95%')
            .width('100%')
            .placeholderFont({ size: 12 })
            .fontSize(12)
            .fontColor(Color.Gray)
            .maxLines(15)
            .onChange((value: string) => {
              this.content = value;
            })
        }
        .height('45%')
      } else {
        if (this.comments.length == 0) {
          Column() {
            Text('您尚未评价,添加评价让更多人了解这款商品')
          }
          .width("100%")
          .height("45%")
        } else {
          Scroll() {
            Column({space:5}) {
              ForEach(this.comments, (item: CommentModel) => {
                Column({space:5}) {
                  Row() {
                    Text(item.type == CommentType.REPLY ? '商家回复:' : '您的评价')
                      .fontSize(12)
                    Text(item.date.toLocaleString())
                      .fontSize(12)
                  }
                  .justifyContent(FlexAlign.SpaceBetween)
                  .height("10%")
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
                    .height("80%")
                    .width("100%")
                }
                .padding(5)
                .borderRadius(5)
                .width("100%")
                .height("70%")
                .backgroundColor('#fff6f6f6')
              })
            }
            .backgroundColor(Color.White)
            .borderRadius(5)
            .padding(20)
          }
          .width("100%")
          .height("45%")
        }
      }
      Button(this.isWriting ? '发表' : '填写评论')
        .fontColor(Color.White)
        .fontSize(15)
        .width("80%")
        .height("5%")
        .backgroundColor(Color.Red)
        .onClick(async () => {
          if (this.isWriting) {
            switch (this.type) {
              case CommentType.ORIGINAL:
                await GlobalVariable.getInstance().createOriginalComment(this.order.id, this.content, this.score);
                break;
              case CommentType.FOLLOW:
                await GlobalVariable.getInstance()
                  .createFollowComment(this.order.id, this.content, this.comments[this.content.length-1].id);
                break;
              case CommentType.REPLY:
                await GlobalVariable.getInstance()
                  .createReplyComment(this.order.id, this.content, this.comments[this.content.length-1].id);
                break;
            }
          }
          this.isWriting = !this.isWriting
          this.comments = await GlobalVariable.getInstance().getAllCommentsByOrderId(this.order.id);
        })
    }
    .padding(10)
    .width("100%")
    .height("100%")
    .backgroundColor(CommonCss.BG_COLOR)
  }
}