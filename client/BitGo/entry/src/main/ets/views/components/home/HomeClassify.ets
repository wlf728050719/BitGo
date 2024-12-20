import { router } from '@kit.ArkUI'

interface ClassifyListType {
  text: string
  handle: () => void
}

@Component
struct HomeClassify {
  private scroller: Scroller = new Scroller()
  @State classifyList: ClassifyListType[] = [
    {
      text: '全部商品', handle: () => {
    }
    },
    {
      text: '优惠券码', handle: () => {
    }
    },
    {
      text: '家居生活', handle: () => {
    }
    },
    {
      text: '美容彩妆', handle: () => {
    }
    },
    {
      text: '母婴用品', handle: () => {
    }
    },
    {
      text: '数码产品', handle: () => {
    }
    },
    {
      text: '服饰鞋帽', handle: () => {
    }
    },
    {
      text: '运动户外', handle: () => {
    }
    },
    {
      text: '模玩动漫', handle: () => {
    }
    },
    {
      text: '宠物花卉', handle: () => {
    }
    },
    {
      text: '家用电器', handle: () => {
    }
    },
    {
      text: '包表首饰', handle: () => {
    }
    },
    {
      text: '图书音像', handle: () => {
    }
    },
    {
      text: '办公文具', handle: () => {
    }
    },
    {
      text: '手工艺品', handle: () => {
    }
    },
    {
      text: '古玩收藏', handle: () => {
    }
    }
  ]

  build() {
    Column() {
      Scroll(this.scroller) {
        Grid() {
          ForEach(this.classifyList, (item: ClassifyListType, index: number) => {
            GridItem() {
              Column() {
                Image($r(`app.media.classify0${index + 1}`))
                  .width(50)
                Text(item.text)
                  .fontSize(12)
                  .fontColor('#fd262626')
              }
              .width('100%')
              .height('100%')
            }
            .onClick(() => {
              router.pushUrl({
                url: 'pages/Index',
                params: {
                  currentIndex: 1,
                  currentCategory: index
                }
              })
            })
          })
        }
        .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr')
        .rowsTemplate('1fr 1fr')
        .height(150)
        .width('200%')
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)

      ScrollBar({ scroller: this.scroller, direction: ScrollBarDirection.Horizontal, state: BarState.On }) {
        Text()
          .width(15)
          .height(5)
          .borderRadius(10)
          .backgroundColor('#000')
      }
      .width(30)
      .borderRadius(5)
      .backgroundColor('#ededed')
    }
    .margin({
      left: 12,
      right: 12,
      top: 10
    })
    .padding({
      bottom: 5
    })
  }
}

export default HomeClassify