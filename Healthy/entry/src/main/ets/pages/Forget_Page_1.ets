import router from '@ohos.router'
import http from '@ohos.net.http'

interface ResetResponse {
  status: 'success' | 'fail'
  message: string
}

@Entry
@Component
struct Forget_Page_1 {
  @State account: string = ''
  @State newPassword: string = ''
  @State confirmPassword: string = ''

  async submitNewPassword() {
    // 前端验证
    if (!this.account) {
      AlertDialog.show({ message: '账号不能为空' })
      return
    }

    if (this.newPassword.length < 6) {
      AlertDialog.show({ message: '新密码长度不能少于6位' })
      return
    }

    if (this.newPassword !== this.confirmPassword) {
      AlertDialog.show({ message: '两次密码输入不一致' })
      return
    }

    const httpRequest = http.createHttp()

    try {
      const response = await httpRequest.request(
        'http://192.168.111.171:8000/api/change/',  // 请替换成你的后端接口地址
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json'
          },
          extraData: JSON.stringify({
            username: this.account,
            password: this.newPassword // 注意字段名与后端保持一致
          }),
          expectDataType: http.HttpDataType.STRING
        }
      )

      if (response.responseCode === 200 && typeof response.result === 'string') {
        const result = JSON.parse(response.result) as ResetResponse

        AlertDialog.show({ message: result.message })

        if (result.status === 'success') {
          // 密码修改成功，跳转登录页
          router.replaceUrl({ url: 'pages/Login_Page' })
        } else {
          // 修改失败，清空密码输入
          this.newPassword = ''
          this.confirmPassword = ''
        }
      } else {
        AlertDialog.show({ message: '服务器错误，请稍后再试' })
      }
    } catch (err) {
      AlertDialog.show({ message: '网络异常，请检查网络连接' })
      console.error('Reset password error:', JSON.stringify(err))
    } finally {
      httpRequest.destroy()
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Row({ space: 100 }) {
        Image($r('app.media.back'))
          .width(30)
          .height(20)
          .margin({ left: 20 })
          .onClick(() => {
            router.replaceUrl({ url: `pages/Login_Page` })
          })
        Text('修改密码')
      }
      .width('100%')
      .height(70)
      .backdropBlur(50)
      .zIndex(999)

      Column({ space: 20 }) {
        Image($r('app.media.forget1'))
          .width(200)
          .height(200)
          .margin({ top: 70 })

        Column({ space: 10 }) {
          TextInput({
            placeholder: '请输入账号',
            text: this.account
          })
            .onChange((val: string) => this.account = val)
            .borderRadius(20)

          TextInput({
            placeholder: '请输入新密码',
            text: this.newPassword
          })
            .type(InputType.Password)
            .onChange((val: string) => this.newPassword = val)
            .borderRadius(20)

          TextInput({
            placeholder: '请确认新密码',
            text: this.confirmPassword
          })
            .type(InputType.Password)
            .onChange((val: string) => this.confirmPassword = val)
            .borderRadius(20)

          Button('提交修改')
            .onClick(() => this.submitNewPassword())
            .backgroundColor('#4CAF50')
        }
      }
      .width('100%')
      .height('100%')
    }
    .backgroundImage($r('app.media.a'))
    .backgroundImagePosition(Alignment.Center)
    .backgroundImageSize(ImageSize.Cover)
  }
}
