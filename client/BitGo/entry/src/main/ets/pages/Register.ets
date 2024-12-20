import { promptAction, router } from '@kit.ArkUI';
import { GlobalVariable } from '../global/GlobalVariable';
import Info from '../model/Info';
import { isValidEmail, isValidPassword, isValidPhoneNumber, isValidUsername } from '../util/CommonUtil';

@Entry
@Component
struct Register {
  @State message: string = '注册帐号以使用云空间、应用市场及更多服务';
  @State addressLabel: string = '中国 +86';
  @State username:string='';
  @State account: string = '';
  @State password: string = '';
  @State secondPassword:string='';
  @State email:string ='';
  @State code:string ='';
  @State usernameOk:number=0;
  @State accountOk:number=0;
  @State passwordOk:number=0;
  @State secondPasswordOk:number=0;
  @State emailOk:number=0;
  @State codeOk:number=0;
  title: string = '华为帐号'

  build() {
    Column() {
      Image($r('app.media.ic_header_logo'))
        .width(50)
        .margin({ top: 30 })
      Text(this.title)
        .fontSize(25)
        .fontWeight(900)
        .margin({ top: 20, bottom: 5 })
      Text(this.message)
        .fontSize(14)
        .fontColor('#666')
        .margin({ bottom: 50 })

      Column() {
        Row() {
          Text('国家/地区')
            .fontColor('#666')
          Row() {
            Text(this.addressLabel)
              .fontColor('#666')
            Image($r('app.media.ic_public_arrow_right'))
              .width(20)
              .fillColor('#666')
          }
          .onClick(() => {
            router.pushUrl({
              url: 'pages/CountryRegion',
            })
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ left: 10, right: 10 })

        Row(){
          if(this.accountOk==-1)
            Text("请输入正确格式账号/手机号")
              .fontColor(Color.Red)
              .fontSize(10)
          else if(this.accountOk==1)
            Text("账号/手机号符合要求")
              .fontColor(Color.Green)
              .fontSize(10)
        }
        .padding(4)
        .width("100%")
        .height(20)
        TextInput({
          placeholder: '账号/手机号'
        })
          .border({
            width:this.accountOk==-1?1:0,
            color:Color.Red
          })
          .maxLength(20)
          .type(InputType.Number)
          .onChange((value:string) => {
            this.account=value;
            if(this.account.length>0)
              this.accountOk=isValidPhoneNumber(value)?1:-1;
            else
              this.accountOk=0;
          })

        Row(){
          if(this.usernameOk==-1)
            Text("用户名只能包含数字和字母，最小长度为5，最大长度为15")
              .fontColor(Color.Red)
              .fontSize(12)
          else if(this.usernameOk==1)
            Text("用户名符合要求")
              .fontColor(Color.Green)
              .fontSize(12)
        }
        .padding(4)
        .width("100%")
        .height(20)
        TextInput({
          placeholder: '用户名'
        })
          .maxLength(20)
          .onChange((value:string) => {
            this.username=value;
            if(this.username.length>0)
              this.usernameOk=isValidUsername(this.username)?1:-1;
            else
              this.usernameOk=0;
          })
        Row(){
          if(this.emailOk==-1)
            Text("请输入正确格式邮箱")
              .fontColor(Color.Red)
              .fontSize(12)
          else if(this.emailOk==1)
            Text("邮箱格式正确")
            .fontColor(Color.Green)
            .fontSize(12)
        }
        .padding(4)
        .width("100%")
        .height(20)
        TextInput({
          placeholder: '邮箱'
        })
          .maxLength(20)
          .onChange((value:string) => {
            this.email=value;
            if(this.email.length>0)
              this.emailOk=isValidEmail(this.email)?1:-1;
            else
              this.emailOk=0;
          })

        Row(){
          if(this.codeOk==-1)
            Text("验证码错误")
              .fontColor(Color.Red)
              .fontSize(12)
        }
        .padding(4)
        .width("100%")
        .height(20)
        Row()
        {
          TextInput({
            placeholder: '验证码'
          })
            .maxLength(20)
            .type(InputType.Number)
            .onChange((value:string) => {
              this.code=value;
            })
            .width("60%");
          Button('获取验证码')
            .onClick(async ()=>{
              let info:Info =await GlobalVariable.getInstance().emailCheck(this.email);
              promptAction.showDialog({ message: info.message, buttons: [{ text: '确认', color: '#000000', }], })}).width("30%");
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width("100%")
        Row(){
          if(this.passwordOk==-1)
            Text("密码最少长度为8,且需要包括数字以及大小写字母")
              .fontColor(Color.Red)
              .fontSize(12)
          else if(this.passwordOk==1)
            Text("密码符合要求")
              .fontColor(Color.Green)
              .fontSize(12)
        }
        .padding(4)
        .width("100%")
        .height(20)
        TextInput({
          placeholder: '密码'
        })
          .maxLength(20)
          .onChange((value:string) => {
          this.password=value;
          if(this.password.length>0)
            this.passwordOk=isValidPassword(this.password)?1:-1;
          else
            this.passwordOk=0;
        })

        Row(){
          if(this.secondPasswordOk==-1)
            Text("密码不一致，请重新输入")
              .fontColor(Color.Red)
              .fontSize(12)
          else if(this.secondPasswordOk==1)
            Text("两次密码一致")
              .fontColor(Color.Green)
              .fontSize(12)
        }
        .padding(4)
        .width("100%")
        .height(20)
        TextInput({
          placeholder: '请再次输入密码'
        })
          .maxLength(20)
          .onChange((value:string) => {
            this.secondPassword=value;
            if(this.secondPassword.length>0)
              this.secondPasswordOk=(this.secondPassword==this.password)?1:-1;
            else
              this.secondPasswordOk=0;
          })

        Button('注册')
          .width('100%')
          .onClick(async () => {
            let info:Info = await GlobalVariable.getInstance().register(this.account,this.username,this.password,this.email,this.code);
            promptAction.showDialog({message:info.message, buttons: [{ text: '确认', color: '#000000'}]}).then(data=>{
              if(info.result)
              {
                router.pushUrl({
                  url:'pages/Login'
                })
              }
            })
          })
          .margin({
            top:15,
            bottom: 15
          })
        Text('返回登录')
          .fontColor('#007dff')
          .onClick(() => {
            router.pushUrl({
              url:'pages/Login'
            })
          })
      }
    }
    .padding(20)
    .width("100%")
    .height("100%")
  }
}