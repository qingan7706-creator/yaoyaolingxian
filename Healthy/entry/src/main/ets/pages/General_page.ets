import router from '@ohos.router'
@Entry
//设置通用
@Component
struct General_Page {
  build() {
    Column() {
      // 头部导航栏
      Stack() {
        Row({space:115}){
          Image($r('app.media.back'))
            .width(30)
            .height(20)
            .margin({left:20})
            .onClick(()=>{
              router.back()
            })
          Text('通用')
        }
        .width('100%')
        .height(70)
        .backdropBlur(50)
        .zIndex(999)
      }
      .backgroundColor(0xffffff)
      .shadow({ radius: 2, offsetY: 1, color: '#eee' })

      // 设置选项列表
      Column() {
        SettingItem({ title: '深色模式' })
        SettingItem({ title: '字体大小' })
        SettingItem({ title: '聊天背景' })
        SettingItem({ title: '多语言' })
        SettingItem({ title: '照片、视频' })
        SettingItem({ title: '存储空间' })
        SettingItem({ title: '辅助功能' })

        Blank().height(15)
      }
      .margin({ top: 15, left: 15, right: 15 })
      .backgroundColor(0xffffff)
      .borderRadius(12)
      .shadow({ radius: 3, color: '#f0f0f0' })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(0xf5f5f5)
  }
}

// 自定义组件
@Component
struct SettingItem {
  // 使用@Prop
  @Prop title: string = ''
  @Prop textColor: string = '#333333'
  @Prop showDivider: boolean = true

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontSize(18)
          .fontColor(this.textColor)
      }
      .width('100%')
      .height(56)
      .padding({ left: 15, right: 15 })

      if (this.showDivider) {
        Divider()
          .strokeWidth(0.5)
          .color('#eeeeee')
          .margin({ left: 15 })
      }
    }
    .width('100%')
    .onClick(() => {
      AlertDialog.show({
        message: `跳转到${this.title}界面`
      })
    })
  }
}