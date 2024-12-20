import { promptAction } from '@kit.ArkUI'
import { GlobalVariable } from '../global/GlobalVariable'
import { numberToProductType } from '../model/ProductModel'


@Component
struct Publish {
  @State typeText: string = "优惠券码"
  @State typeIndex: number = 0
  @State images: string[] = []
  @State location: string = ''
  @State name: string = ''
  @State description: string = ''
  @State stock: number = 1
  @State price: number = 0.00
  controller: TextAreaController = new TextAreaController()
  @State inputValue: string = ''


  aboutToAppear(): void {
    this.reset();
  }

  reset() {
    this.images = []
    this.location = ''
    this.name = ''
    this.description = ''
    this.stock = 1
    this.price = 0.00
    this.inputValue = ''
  }

  @Builder
  CustomKeyboardBuilder() {
    Column() {
      Divider()
        .height(2)
        .color(Color.Gray)
      Row() {
        Button('取消')
          .backgroundColor(Color.Red)
          .width('50%')
          .height('100%')
          .type(ButtonType.Normal)
          .fontColor(Color.White)
          .onClick(() => {
            this.inputValue = '0.00'
            this.controller.stopEditing()
          })
        Blank()
        Button('确认')
          .backgroundColor(Color.Yellow)
          .width('50%')
          .height('100%')
          .type(ButtonType.Normal)
          .fontColor(Color.Black)
          .onClick(() => {
            this.controller.stopEditing()
            this.price = Number(this.inputValue)
          })
      }
      .width('100%')
      .height('8%')

      Grid() {
        ForEach([1, 2, 3, 4, 5, 6, 7, 8, 9, '.', 0, '删除'], (item: number | string) => {
          GridItem() {
            if (item != '删除') {
              Button(item + "")
                .buttonStyle(ButtonStyleMode.TEXTUAL)
                .width(110)
                .fontColor(Color.Black)
                .onClick(() => {
                  this.inputValue += item
                })
                .type(ButtonType.Normal)
            } else {
              Button(item + "")
                .buttonStyle(ButtonStyleMode.TEXTUAL)
                .width(110)
                .fontColor(Color.Red)
                .onClick(() => {
                  this.inputValue = this.inputValue.substring(0, this.inputValue.length - 1)
                })
                .type(ButtonType.Normal)
            }
          }
        })
      }
      .maxCount(3)
      .padding(5)
    }.backgroundColor('#f1f3f5')
  }

  build() {
    Column({ space: 10 }) {
      Row() {
        Text('发布商品')
          .fontSize(18)
        Blank()
        Button('发布')
          .backgroundColor(Color.Red)
          .fontSize(15)
          .fontColor(Color.White)
          .width('20%')
          .height('50%')
          .margin({
            left: 10
          })
          .onClick(async () => {
            if(this.name.length==0)
            {
              promptAction.showDialog({ message: '商品名称不能为空', buttons: [{ text: '确认', color: '#000000' }] })
              return
            }
            if (this.images.length == 0) {
              promptAction.showDialog({ message: '商品图片至少一张', buttons: [{ text: '确认', color: '#000000' }] })
              return
            }
            if(this.location.length==0)
            {
              promptAction.showDialog({ message: '商品发货地址不能为空', buttons: [{ text: '确认', color: '#000000' }] })
              return
            }
            if (!GlobalVariable.getInstance().getLoginState()) {
              promptAction.showDialog({ message: '请先登录', buttons: [{ text: '确认', color: '#000000' }] })
              return
            }
            let info = await GlobalVariable.getInstance()
              .publishProduct(this.name, this.price, this.description, this.location, this.images,
                numberToProductType(this.typeIndex + 1), this.stock)
            if (info.result) {
              promptAction.showDialog({ message: '商品发布成功', buttons: [{ text: '确认', color: '#000000' }] })
              console.log(`数目: ${this.stock}, 价格: ${this.price}, 名称: ${this.name}, 描述: ${this.description}, 地址: ${this.location}`);
              this.reset();
            } else {
              promptAction.showDialog({ message: info.message, buttons: [{ text: '确认', color: '#000000' }] });
            }
          })
      }
      .width('100%')
      .height('10%')

      Row() {
        Blank()
        Image($r('app.media.ic_public_add_norm_filled'))
          .width('20%')
          .colorFilter('#f1f3f5')
        Text('添加图片')
          .fontSize(10)
        Blank()
      }
      .onClick(() => {
        if (this.images.length < 8) {
          this.images.push('app.media.classify0' + Math.floor(Math.random() * (19 - 1) + 1))
        } else {
          this.getUIContext().showAlertDialog({
            message: '最多上传8张图片',
            confirm: {
              value: '确认',
              action: () => {
              }
            }
          })
        }
      })
      .backgroundColor('#f1f3f5')
      .width('20%')
      .height('3%')
      .border({
        width: 1,
        color: Color.Gray
      })
      .borderRadius('50%')

      Column() {
        Grid() {
          ForEach(this.images, (item: string, index: number) => {
            GridItem() {
              Column() {
                Image($r(item))
                Image($r('app.media.ic_public_close'))
                  .width('15%')
                  .position({
                    top: 2,
                    left: 2
                  })
                  .onClick(() => {
                    this.images.splice(index, 1);
                  })
              }
              .backgroundColor('#ffe5e5e5')
              .border({
                width: 1,
                color: '#ffe5e5e5'
              })
              .borderRadius('10%')
            }
          })
        }
        .columnsTemplate('1fr 1fr 1fr 1fr')
        .rowsTemplate('1fr 1fr')
        .columnsGap(5)
        .rowsGap(5)
        .height('100%')
        .width('100%')
      }
      .height('25%')
      .width('100%')
      .backgroundColor('#f1f3f5')
      .borderRadius(10)
      .border({
        width: 2,
        color: '#ffcbcbcb'
      })

      Row() {
        Text('商品类别:')
          .fontSize(12)
        Select([
          { value: '优惠券码' },
          { value: '家具生活' },
          { value: '美容彩妆' },
          { value: '母婴用品' },
          { value: '数码用品' },
          { value: '服饰鞋帽' },
          { value: '运动户外' },
          { value: '模玩动漫' },
          { value: '宠物花卉' },
          { value: '家用电器' },
          { value: '包表首饰' },
          { value: '图书影像' },
          { value: '办公文件' },
          { value: '手工艺品' },
          { value: '古玩收藏' }])
          .margin({ left: 10 })
          .selected(this.typeIndex)
          .value(this.typeText)
          .font({ size: 12, weight: 300 })
          .fontColor('#182431')
          .selectedOptionFont({ size: 12, weight: 300 })
          .optionFont({ size: 12, weight: 300 })
          .arrowPosition(ArrowPosition.END)
          .menuAlign(MenuAlignType.START, { dx: 0, dy: 0 })
          .optionWidth(100)
          .optionHeight(300)
          .height('80%')
          .onSelect((index: number, text?: string | undefined) => {
            console.info('Select:' + index)
            this.typeIndex = index;
            if (text) {
              this.typeText = text;
            }
          })
        Blank()
        TextInput({
          text: this.name,
          placeholder: '商品名称'
        })
          .maxLength(15)
          .width('50%')
          .height('100%')
          .fontSize(12)
          .placeholderFont({ size: 12 })
          .onChange((value: string) => {
            this.name = value
          })
      }
      .width('100%')
      .height('5%')

      Row() {
        Text('发货地址:')
          .height('100%')
          .fontSize(12)
          .textAlign(TextAlign.Center)
          .margin({ right: 15 })
        TextInput()
          .width('80%')
          .height('100%')
          .fontSize(12)
          .fontColor(Color.Gray)
          .onChange((value: string) => {
            this.location = value
          })
      }
      .height('5%')
      .width('100%')

      Row() {
        Text('数目：')
          .fontSize(12)
        Image($r('app.media.ic_public_arrow_left'))
          .height('80%')
          .onClick(() => {
            if (this.stock > 1) {
              this.stock--
            } else {
              try {
                promptAction.showDialog({ message: '最小数目应为1', buttons: [{text: '确认', color: '#000000'}]})
              } catch (error) {
                console.error(`showDialog args error code is ${error.code}, message is ${error.message}`);
              }
            }
            ;
          })
        TextInput({ text: this.stock.toString() })
          .height('100%')
          .width('20%')
          .placeholderFont({ size: 12 })
          .fontColor(Color.Gray)
          .fontSize(12)
          .textAlign(TextAlign.Center)
          .inputFilter('[0-9]', (e) => {
            console.log(JSON.stringify(e))
          })
          .onChange((value: string) => {
            this.stock = Number(value)
          })
          .maxLength(2)
        Image($r('app.media.ic_public_arrow_right'))
          .height('80%')
          .onClick(() => {
            if (this.stock < 99) {
              this.stock++
            } else {
              try {
                promptAction.showDialog({
                  message: '最大数目应为99',
                  buttons: [
                    {
                      text: '确认',
                      color: '#000000',
                    }
                  ],
                })
              } catch (error) {
                console.error(`showDialog args error code is ${error.code}, message is ${error.message}`);
              }
            }
            ;
          })
        Blank()
        Text('单价:')
          .height('100%')
          .fontSize(12)
        TextInput({ controller: this.controller, text: this.inputValue, placeholder: '0.00' })
          .customKeyboard(this.CustomKeyboardBuilder())
          .margin(10)
          .height('100%')
          .width('20%')
          .placeholderFont({ size: 12 })
          .fontColor(Color.Gray)
          .fontSize(12)
          .textAlign(TextAlign.Center)
          .onChange((value: string) => {
            this.price = Number(value)
          })
        Text('元')
          .height('100%')
          .fontSize(12)
      }
      .height('5%')
      .width('100%')

      Text('商品简介：').fontSize(15)
      TextArea({ text: this.description, placeholder: '在此处输入商品的描述，型号等信息' })
        .height('30%')
        .width('100%')
        .placeholderFont({ size: 12 })
        .fontSize(12)
        .fontColor(Color.Gray)
        .maxLines(15)
        .onChange((value: string) => {
          this.description = value;
        })
    }
    .padding(10)
    .backgroundColor('#f1f3f5')
    .width('100%')
    .height('100%')
  }
}

export default Publish