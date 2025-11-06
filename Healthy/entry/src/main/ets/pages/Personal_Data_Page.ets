import router from '@ohos.router'
@Entry
//个人资料
@Component
struct Personal_data_page {
  build() {
    Column() {
      // 头部导航栏（保持不变）
      Stack() {
        Row({space:100}){
          Image($r('app.media.back'))
            .width(30)
            .height(20)
            .margin({left:20})
            .onClick(()=>{
              router.back()
            })
          Text('个人资料')
        }
        .width('100%')
        .height(70)
        .backdropBlur(50)
        .zIndex(999)
      }
      .backgroundColor(0xffffff)
      .shadow({ radius: 2, offsetY: 1, color: '#eee' })

      // 个人资料选项列表
      Column() {
        // 头像行
        SettingItem({
          title: '头像',
          imageSource: $r( 'app.media.HL_logo')
        })

        SettingItem({ title: '昵称', page:'pages/Name_page' })
        SettingItem({ title: '性别',page:'pages/Gender_page' })
        SettingItem({ title: '手机号',page:'pages/Phone_number_page' })
        SettingItem({ title: '个性签名',page:'pages/Sign_page' })

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

// 自定义设置项组件（修改后）
@Component
struct SettingItem {
  // 使用@Prop
  @Prop title: string = ''
  @Prop textColor: string = '#333333'
  @Prop showDivider: boolean = true
  @Prop imageSource?: ResourceStr = undefined // 新增：头像图片资源
  @Prop page : string = ''

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontSize(18)
          .fontColor(this.textColor)
          .margin({ left: 15 })
          .width('40%') // 调整文本宽度占比

        // 显示头像
        if (this.imageSource) {
          Image(this.imageSource)
            .width(40)
            .height(40)
            .objectFit(ImageFit.Contain)
            .borderRadius(20) // 圆形头像
            .margin({ right: 30 })
        }
      }
      .width('100%')
      .height(56)
      .justifyContent(FlexAlign.SpaceBetween) // 两端对齐

      if (this.showDivider) {
        Divider()
          .strokeWidth(0.5)
          .color('#eeeeee')
          .margin({ left: 15 })
      }
    }
    .width('100%')
    .onClick(() => {
      router.pushUrl({url:`${this.page}`})
    })
  }
}