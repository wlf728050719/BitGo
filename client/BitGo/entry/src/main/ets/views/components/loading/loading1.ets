@Component
struct loading1{
  @State num:number = 0
  @State numZ:number = 100
  @State num2:number = 90
  @State num2Z:number = 90
  @State num3:number = 180
  @State num3Z:number = 90
  @State num4:number = 270
  @State num4Z:number = 270
  @Prop w:number = 0
  build() {
    Stack(){
      Row(){
        Text('加载中\nloading')
      }
      Row(){}
      .width(this.w)
      .height(this.w)
      .border({width:{bottom:8},color:'rgb(255,141,249)',style:BorderStyle.Solid})
      .borderRadius(90)
      .rotate({
        x:50,
        y:0,
        z:this.numZ,
        angle:this.num,
        centerX:this.w/2,
        centerY:this.w/2
      })
      Row(){}
      .width(this.w)
      .height(this.w)
      .border({width:{bottom:8},color:'rgb(255,65,106)',style:BorderStyle.Solid})
      .borderRadius(90)
      .rotate({
        x:20,
        y:50,
        z:this.num2Z,
        angle:this.num2,
        centerX:this.w/2,
        centerY:this.w/2
      })
      Row(){}
      .width(this.w)
      .height(this.w)
      .border({width:{bottom:8},color:'rgb(0,255,255)',style:BorderStyle.Solid})
      .borderRadius(90)
      .rotate({
        x:40,
        y:150,
        z:this.num3Z,
        angle:this.num3,
        centerX:this.w/2,
        centerY:this.w/2
      })
      Row(){}
      .width(this.w)
      .height(this.w)
      .border({width:{bottom:8},color:'rgb(252,183,55)',style:BorderStyle.Solid})
      .borderRadius(90)
      .rotate({
        x:20,
        y:50,
        z:this.num4Z,
        angle:this.num4,
        centerX:this.w/2,
        centerY:this.w/2
      })
    }
    .onAppear(()=>{
      this.getUIContext().animateTo({
        duration:2000,
        iterations:-1,
        curve:Curve.Linear
      },()=>{
        this.num = 360
        this.numZ = 470
        this.num2 = 450
        this.num2Z = 470
        this.num3 = 480
        this.num3Z = 450
        this.num4 = 610
        this.num4Z = 630
      })
    })
  }
}
export default loading1