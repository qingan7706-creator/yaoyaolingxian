import router from '@ohos.router'
@Entry
//账号安全
@Component
struct Account_security_page {
  build() {
    Column() {
      // 头部导航栏
      Stack() {
        Row({space:100}){
          Image($r('app.media.back'))
            .width(30)
            .height(20)
            .margin({left:20})
            .onClick(()=>{
              router.back()
            })
          Text('账号安全')
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
        SettingItem({ title: 'pages/Login_password_page', name:'登陆密码' })
        SettingItem({ title: 'pages/Phone_number_page' ,name:'我的手机号'})

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
  @Prop name : string = ''

  build() {
    Column() {
      Row() {
        Text(this.name)
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
      router.pushUrl({url:`${this.title}`})
    })
  }
}