// 写的依托构式……
//修改昵称
import router from '@ohos.router'
@Entry
@Component
struct Show_page {
  @State Options: string[] = ['仅自己可见', '部分人可见','所有人可见'];
  @State select: string = '';
  @State graph: ResourceStr[] = [$r('app.media.plus')];
  build() {
    Column(){
      Stack() {
        Row({space:95}){
          Image($r('app.media.back'))
            .width(30)
            .height(20)
            .margin({left:20})
            .onClick(()=>{
              router.back()
            })
          Text('修改昵称')
        }
        .width('100%')
        .height(70)
        .backdropBlur(50)

        // 右侧完成按钮
        Button('完成')
          .height(30)
          .margin({ left: 240 })
          .backgroundColor('#4CAF50')
          .fontColor('#FFFFFF')
          .fontSize(16)
          .borderRadius(15)
          .onClick(() => {
            router.back()
          })
      }
      .width('100%')
      .height(50)
      .backgroundColor(0xffffff)
      Row(){
        TextInput({placeholder:'记录美好生活'})
          .position({y:20})
          .height(150)
        Image($r('app.media.plus'))
          .position({x:20,y:180})
          .width(100)
          .height(100)
          .onClick(()=>{
            AlertDialog.show({message:'最多上传三张图片'})
          })
      }
      .height(300)
      .width('100%')
      .backgroundColor(Color.White)
      .margin({left:10,right:10,top:10,bottom:10})
      .borderRadius(10)
      Row(){
        List() {
          ForEach(this.Options, (option: string) => {
            ListItem() {
              Column() {
                Button(option)
                  .width('100%')
                  .height(56)
                  .backgroundColor(this.select === option ? '#E6F4FF' : '#FFFFFF')
                  .fontColor('#000000')
                  .borderRadius(2)
                  .padding({ left: 16 })
                  .onClick(() => {
                    this.select = option;
                  })

                // 分界线
                if (option !== this.Options[this.Options.length - 1]) {
                  Divider()
                    .strokeWidth(1)
                    .color('#EEEEEE')
                    .margin({ left: 16 })
                }
              }
              .width('100%')
            }
          }, (option: string) => option)
        }
        .margin({ top: 16 })
        .width('95%')

      }
    }
    .height('100%')
    .width('100%')
    .backdropBlur(20)
    .backgroundImage($r('app.media.a'))
    .backgroundImagePosition(Alignment.Center)
    .backgroundImageSize(ImageSize.Cover)  }
}