import UseModel from '../model/UserModel'
import { isValidEmail, isValidPassword, isValidUsername } from '../util/CommonUtil';
import { promptAction, router } from '@kit.ArkUI';
import { GlobalVariable } from '../global/GlobalVariable';
import Info from '../model/Info';

@Entry
@Component
struct ChangeUserInfo {
  @State user: UseModel = UseModel.getDefaultUserModel();
  @State usernameOK: boolean = true;
  @State emailOK: boolean = true;
  @State newPasswordOk:boolean = true;
  @State secondPasswordOk:boolean = true;
  @State newUsername: string = this.user.username;
  @State newEmail: string = this.user.email;
  @State newPassword:string = '';
  @State secondPassword:string ='';
  @State oldEmailCheckCode: string = '';
  @State newEmailCheckCode: string = '';
  @State changeEmail: boolean = false;
  @State changeUsername: boolean = false;
  @State changePassword:boolean = false;

  aboutToAppear(): void {
    this.user = GlobalVariable.getInstance().getUser();
  }

  build() {
    Column({ space: 10 }) {
      Row()
      {
        Image($r('app.media.ic_public_arrow_left'))
          .onClick(()=>{
            router.back()
          })
          .height("80%")
        Text('修改用户信息')
      }
      .height("5%")
      .width("100%")
      Row() {
        if (this.changeUsername) {
          Text(this.usernameOK ? '用户名更改' : '用户名只能包含数字和字母，最小长度为5，最大长度为15')
            .fontColor(this.usernameOK ? Color.Green : Color.Red)
            .fontSize(8)
        }
      }
      .width("100%")
      .height("3%")

      Row() {
        Text('用户名:')
        TextInput({ placeholder: this.user.username })
          .onChange((value: string) => {
            if (value.length == 0) {
              this.newUsername = this.user.username;
            } else {
              this.newUsername = value;
            }
            this.changeUsername = this.newUsername != this.user.username;
            this.usernameOK = isValidUsername(this.newUsername);
          })
          .width("80%")
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width("100%")

      Row() {
        if (this.changeEmail) {
          Text(this.emailOK ? '邮箱更改' : '请输入正确格式邮箱')
            .fontColor(this.emailOK ? Color.Green : Color.Red)
            .fontSize(8)
        }
      }
      .width("100%")
      .height("3%")

      Row() {
        Text('邮箱:')
        TextInput({ placeholder: this.user.email })
          .onChange((value: string) => {
            if(value.length==0){
              this.newEmail = this.user.email;
            }else {
              this.newEmail = value;
            }
            this.changeEmail = this.newEmail != this.user.email;
            this.emailOK = isValidEmail(this.newEmail);
          })
          .width("80%")
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width("100%")

      if (this.changeEmail) {
        Row()
        {
          Column({space:10}){
            Row({space:10}) {
              Text('旧邮箱验证码')
              TextInput()
                .onChange((value: string) => {
                  this.oldEmailCheckCode = value;
                })
                .width("40%")
            }
            .width("100%")
            Row({space:10}) {
              Text('新邮箱验证码')
              TextInput().onChange((value: string) => {
                this.newEmailCheckCode = value;
              })
                .width("40%")
            }
            .width("100%")
          }
          .width("60%")
          .height("100%")
          Button('发送验证码')
            .onClick(async ()=>{
              if(this.emailOK)
              {
                let info1:Info = await GlobalVariable.getInstance().emailCheck(this.newEmail);
                if(!info1.result)
                {
                  promptAction.showDialog({ message: info1.message, buttons: [{ text: '确认', color: '#000000' }] });
                  return
                }
                let info2:Info = await GlobalVariable.getInstance().emailCheck(this.user.email);
                if(!info2.result)
                {
                  promptAction.showDialog({ message: info2.message, buttons: [{ text: '确认', color: '#000000' }] });
                  return
                }
                promptAction.showDialog({ message: '邮件已经发送，请及时查看', buttons: [{ text: '确认', color: '#000000' }] });
              }
              else
                promptAction.showDialog({ message: '邮箱格式错误', buttons: [{ text: '确认', color: '#000000' }] });
            })
            .width("30%")
            .backgroundColor(Color.Red)
            .fontColor(Color.White)
        }
        .width("100%")
        .height("15%")
      }

      Row() {
        if (this.changePassword) {
          Text(this.newPasswordOk ? '密码更改' : '密码最少长度为8,且需要包括数字以及大小写字母')
            .fontColor(this.newPasswordOk ? Color.Green : Color.Red)
            .fontSize(8)
        }
      }
      .width("100%")
      .height("3%")
      Row() {
        Text('修改密码:')
        TextInput({ placeholder: 'xxxxxxxx' })
          .type(InputType.Password)
          .onChange((value: string) => {
            this.newPassword=value;
            this.changePassword = this.newPassword.length>0;
            this.secondPasswordOk = this.newPassword==this.secondPassword;
            if(this.changePassword)
              this.newPasswordOk = isValidPassword(this.newPassword);
            else
              this.newPasswordOk = true
          })
          .width("80%")
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width("100%")
      if(this.changePassword)
      {
        Row() {
          if(this.secondPassword.length>0)
            Text(this.secondPasswordOk ? '密码一致' : '两次密码不一致')
              .fontColor(this.secondPasswordOk ? Color.Green : Color.Red)
              .fontSize(8)
        }
        .width("100%")
        .height("3%")
        Row() {
          Text('确认密码:')
          TextInput()
            .type(InputType.Password)
            .onChange((value: string) => {
              this.secondPassword=value;
              this.secondPasswordOk = (this.newPassword==this.secondPassword);
            })
            .width("80%")
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width("100%")
      }
      Button('提交')
        .onClick(async () => {
          if (this.usernameOK && this.emailOK &&this.newPasswordOk&&this.secondPasswordOk) {
            if(!this.changeEmail&&!this.changeUsername&&!this.changePassword)
            {
              promptAction.showDialog({ message: '当前未修改任何信息', buttons: [{ text: '确认', color: '#000000' }] })
              return
            }
            if(this.changeUsername)
            {
              let info1: Info = await GlobalVariable.getInstance().changeUserName(this.newUsername);
              if (!info1.result) {
                promptAction.showDialog({ message: info1.message, buttons: [{ text: '确认', color: '#000000' }] })
                return
              }
            }
            if(this.changeEmail)
            {
              let info2: Info = await GlobalVariable.getInstance()
                .changeEmail(this.user.email, this.newEmail, this.oldEmailCheckCode, this.newEmailCheckCode);
              if (!info2.result) {
                promptAction.showDialog({ message: info2.message, buttons: [{ text: '确认', color: '#000000' }] })
                return
              }
            }
            if(this.changePassword)
            {
              let info3: Info = await GlobalVariable.getInstance()
                .changePassword(this.newPassword)
              if (!info3.result) {
                promptAction.showDialog({ message: info3.message, buttons: [{ text: '确认', color: '#000000' }] })
                return
              }
            }
            await GlobalVariable.getInstance().logout();
            promptAction.showDialog({
              message: '信息修改成功,请重新登录',
              buttons: [{ text: '确认', color: '#000000' }]
            })
            router.pushUrl({
              url: "pages/Login"
            })
          } else {
            promptAction.showDialog({ message: '请正确填写表单', buttons: [{ text: '确认', color: '#000000' }] })
          }
        })
        .width("80%")
        .backgroundColor(Color.Red)
        .fontColor(Color.White)
    }
    .width("100%")
    .height("100%")
    .padding(10)
  }
}