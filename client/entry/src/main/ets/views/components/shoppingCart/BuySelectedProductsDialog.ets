import { GlobalVariable } from '../../../global/GlobalVariable'
import { ProductInShoppingCart } from '../../../model/ProductInShoppingCart'

@Component
struct BuySelectedProductsDialog {
  @Prop selectedProducts: ProductInShoppingCart[]
  @State recipientName: string = ''
  @State phone: string = ''
  @State getLocation: string = ''
  closeBuyProductDialog=()=>{}
  removeProductsFromShoppingCart=(productsInShoppingCart:ProductInShoppingCart[])=>{}
  build() {
    Column() {
      Row() {
        Text('填写订单')
        Blank()
        Image($r('app.media.ic_public_arrow_right'))
          .width('5%')
          .onClick(()=>{this.closeBuyProductDialog();})
      }
      .width('100%')
      .height('10%')
      .backgroundColor('#ffeaeaea')

      Scroll() {
        Column() {
          ForEach(this.selectedProducts, (item: ProductInShoppingCart) => {
            Row() {
              Text(item.productModel.name)
                .fontSize(12)
                .fontColor(Color.Gray)
              Blank()
              Text(item.productModel.price.toString()+'X' + item.num)
                .fontSize(12)
                .fontColor(Color.Gray)
            }.width('100%')
            .height('20%')
          })
        }.width('100%')
        .height('100%')
      }
      .height('40%')
      .width('')

      Column({ space: 10 }) {
        Row() {
          Text('收货人:')
            .fontSize(12)
          Blank()
          TextInput({ placeholder: '填写收货人姓名', text: this.recipientName })
            .placeholderFont({ size: 12 })
            .placeholderColor(Color.Gray)
            .onChange((value: string) => {
              this.recipientName = value;
            })
            .width('80%')
        }
        .width('100%')

        Row() {
          Text('手机号:')
            .fontSize(12)
          Blank()
          TextInput({ placeholder: '填写收货人手机号', text: this.phone })
            .placeholderFont({ size: 12 })
            .placeholderColor(Color.Gray)
            .onChange((value: string) => {
              this.phone = value
            })
            .width('80%')
        }
        .width('100%')

        Row() {
          Text('地址:')
            .fontSize(12)
          Blank()
          TextInput({ placeholder: '选择收货地址', text: this.getLocation })
            .placeholderFont({ size: 12 })
            .placeholderColor(Color.Gray)
            .onChange((value: string) => {
              this.getLocation = value
            })
            .width('80%')
        }
        .width('100%')

        Button('立即支付')
          .backgroundColor(Color.Red)
          .fontColor(Color.White)
          .fontSize(12)
          .width('80%')
          .height('15%')
          .onClick(() => {
            if (this.getLocation.length < 1) {
              this.getUIContext().showAlertDialog({
                message: '地址不能为空',
                confirm: {
                  value: 'button',
                  action: () => {
                  }
                }
              })
            } else {
              for(let item of this.selectedProducts)
              {
                GlobalVariable.getInstance().createOrder(item.productModel,item.num,this.recipientName,this.phone,this.getLocation)
              }
              this.removeProductsFromShoppingCart(this.selectedProducts)
              this.closeBuyProductDialog();
            }
          })
      }
      .padding(10)
      .width('100%')
      .height('50%')
    }
    .width('100%')
    .height('70%')
    .backgroundColor(Color.White)
  }
}

export default BuySelectedProductsDialog