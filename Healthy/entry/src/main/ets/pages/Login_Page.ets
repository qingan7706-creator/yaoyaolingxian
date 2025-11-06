import router from '@ohos.router'
import http from '@ohos.net.http'
import GlobalStore from './GlobalStore'
import promptAction from '@ohos.promptAction';



interface LoginResponse {
  status: 'success' | 'fail';
  message: string;
  sessionid:string;
}




@Entry
@Component
struct Login_Page {
  @State account: string = ''
  @State password: string = ''
  @State judge: boolean = false
  private httpRequest: http.HttpRequest = http.createHttp() // 将 httpRequest 作为组件成员变量

  // 提取 sessionId 的函数
  extractSessionId(aaa: string): string | null {

    return '';
  }

  build() {
    Column({ space: 20 }) {
      // ... 其他 UI 元素
      Image($r('app.media.HL_logo'))
        .width(150)
        .borderRadius(10)

      Text('享受健康生活')
        .fontSize(24)

      TextInput({
        placeholder: '用户名',
        text: this.account
      })
        .onChange((value: string) => {
          this.account = value
        })

      // 密码输入框
      TextInput({
        placeholder: '密码',
        text: this.password
      })
        .type(InputType.Password)
        .onChange((value: string) => {
          this.password = value
        })
      if (this.account !== '' && this.password !== '' && this.judge) {
        Button('登 录')
          .width('100%')
          .backgroundColor('#ff0b990b')
          .fontColor('#FFF')
          .onClick(async () => {
            try {
              const response: http.HttpResponse = await this.httpRequest.request(
                'http://192.168.111.171:8000/api/login/',
                {
                  method: http.RequestMethod.POST,
                  header: {
                    'Content-Type': 'application/json',
                  },
                  extraData: JSON.stringify({
                    username: this.account,
                    password: this.password,
                  }),
                  expectDataType: http.HttpDataType.STRING,

                }
              );

              if (response.responseCode === 200 && typeof response.result === 'string') {
                const result: LoginResponse = JSON.parse(response.result);

                if (result.status === 'success') {
                  console.info('✅ 登录成功');

                  // 提取并存储 sessionId

                  if (true) {
                    const sessionId: string | null = result.sessionid;
                    if (sessionId) {
                      console.log(sessionId)
                      GlobalStore.sessionId = sessionId;
                    }
                  }

                  router.replaceUrl({ url: 'pages/Main_Page' });
                } else {
                  AlertDialog.show({ message: result.message || '账号或密码错误' });
                  this.account = '';
                  this.password = '';
                }
              } else {
                AlertDialog.show({ message: '账号或密码错误' });
              }
            } catch (error) {
              console.error('Login error:', error);
              AlertDialog.show({
                message: '网络异常：' + (error instanceof Error ? error.message : JSON.stringify(error))
              });
            }

            // 不要销毁 httpRequest，否则 Cookie 会被清除
          });
      } else {
        Button('登 录')
          .width('100%')
          .backgroundColor('#999')
          .fontColor('#FFF')
      }

      Row() {
        Checkbox()
          .width(10)
          .margin({ top: 7 })
          .onClick(() => this.judge = !this.judge)

        Text() {
          Span('我已阅读并同意')
          Span('《CQR隐私政策》').fontColor('#3274f6')
          Span('《CQR用户服务协议》').fontColor('#3274f6')
          Span('未注册的手机号将自动创建账号')
        }
        .fontSize(12)
        .fontColor('#666')
        .lineHeight(20)
      }
      .alignItems(VerticalAlign.Top)
      .margin({ top: 20, bottom: 150 })

      Row({ space: 70 }) {
        Text('前往注册')
          .fontColor('#ffffffff')
          .fontWeight(700)
          .height(30)
          .width(65)
          .borderRadius(50)
          .onClick(() => router.replaceUrl({ url: 'pages/Register_Page' }))

        Text('忘记密码')
          .fontColor('#ffffffff')
          .fontWeight(700)
          .onClick(() => router.replaceUrl({ url: 'pages/Forget_Page_1' }))
      }
    }
    .backdropBlur(20)
    .backgroundImage($r('app.media.a'))
    .backgroundImagePosition(Alignment.Center)
    .backgroundImageSize(ImageSize.Cover)
    .padding(20)
    .width('100%')
    .height('100%')
  }
}
