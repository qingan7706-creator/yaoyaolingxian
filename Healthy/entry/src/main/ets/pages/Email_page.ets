import router from '@ohos.router'
//邮箱绑定
@Entry
@Component
struct Email_Page {
  @State currentEmail: string = '123@lzu.edu.cn'
  @State newEmail: string = ''
  @State isEditPageVisible: boolean = true // 管理页面显示状态

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
          Text('绑定邮箱')
        }
        .width('100%')
        .height(70)
        .backdropBlur(50)

        // 右侧完成按钮
        Button('完成')
          .height(30)
          .margin({ left: 240 })
          .backgroundColor(this.newEmail.trim() ? '#4CAF50' : '#CCCCCC')
          .fontColor('#FFFFFF')
          .fontSize(16)
          .borderRadius(15)
          .enabled(this.newEmail.trim() !== '')
          .onClick(() => this.updateEmail())
          .onClick(() => {
            router.back()
          })
      }
      .backgroundColor(0xffffff)
      .shadow({ radius: 2, offsetY: 1, color: '#eee' })

      // 卡片容器
      Column() {
        // 输入区域
        TextInput({
          placeholder: '绑定邮箱'
        })
          .width('100%')
          .height(56) //
          .backgroundColor(0xFFFFFF)
          .fontSize(18) // 字体大小
          .padding({ left: 16 }) // 内边距
          .onChange((value: string) => {
            this.newEmail = value
          })

        // 分界线
        if (this.isEditPageVisible) {
          Divider()
            .strokeWidth(0.5)
            .color('#eeeeee')
            .margin({ left: 16 })
        }
      }
      .margin({ top: 15, left: 15, right: 15 }) // 卡片边距
      .backgroundColor(0xffffff)
      .borderRadius(12)
      .shadow({ radius: 3, color: '#f0f0f0' }) // 阴影效果


    }
    .width('100%')
    .height('100%')
    .backgroundColor(0xf5f5f5)
  }

  // 自定义更新名字
  updateEmail() {
    if (!this.newEmail.trim()) {
      AlertDialog.show({
        message: '邮箱不能为空',
        autoCancel: true
      })
      return
    }
    this.currentEmail = this.newEmail // 更新当前密码
    console.info(`更新密码为: ${this.newEmail}`)
  }
}