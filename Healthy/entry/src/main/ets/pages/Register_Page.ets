import router from '@ohos.router'
import http from '@ohos.net.http' // 正确导入鸿蒙官方 http 模块
interface RegisterResponse {
  status: 'success' | 'fail';
  message: string;
}
@Entry
@Component
struct Register_Page {
  @State value1: string = ''
  @State value2: string = ''
  @State value3: string = ''

  async registerUser(): Promise<void> {
    const httpRequest = http.createHttp();

    try {
      const response = await httpRequest.request(
        'http://192.168.111.171:8000/api/register/',
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json'
          },
          extraData: JSON.stringify({
            username: this.value1,
            password: this.value2
          }),
          readTimeout: 6000,
          connectTimeout: 6000,
          expectDataType: http.HttpDataType.STRING
        }
      );
      console.info('响应结果：', response.result);

      // 这里断言 response.result 是字符串类型
      const resStr: string = response.result as string;
      const resJson: RegisterResponse = JSON.parse(resStr) as RegisterResponse;


      if (resJson.status === 'success') {
        AlertDialog.show({ message: resJson.message || '注册成功！' });
        router.replaceUrl({ url: 'pages/Login_Page' });
      } else {
        AlertDialog.show({ message: '注册失败：' + (resJson.message || '未知错误') });
      }
    } catch (err) {
      console.error('请求失败：', JSON.stringify(err));
      AlertDialog.show({ message: '注册失败：' + (err as Error).message });
    } finally {
      httpRequest.destroy();
    }
  }



  build() {
    Stack() {
      Image($r('app.media.a'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      Column({ space: 20 }) {
        Text('新用户注册')
          .fontColor('#4CAF50')
          .fontSize(30)
          .fontWeight(500)
          .width('100%')
          .padding({ left: 16, bottom: 80, top: 20 })

        TextInput({ placeholder: '设置用户名(英文和数字)' })
          .onChange((value: string) => this.value1 = value)

        TextInput({ placeholder: '设置密码（大于六位数字）' })
          .type(InputType.Password)
          .onChange((value: string) => this.value2 = value)

        TextInput({ placeholder: '再次输入密码' })
          .type(InputType.Password)
          .onChange((value: string) => this.value3 = value)

        Button('注  册')
          .width('100%')
          .backgroundColor('#4CAF50')
          .fontColor('#FFF')
          .borderRadius(25)
          .onClick(() => {
            if (this.value1.length < 8 || this.value1.length > 12) {
              AlertDialog.show({ message: '用户名长度应在8到12位' })
            } else if (this.value2.length < 6) {
              AlertDialog.show({ message: '密码长度应大于6位' })
            } else if (this.value2 !== this.value3) {
              AlertDialog.show({ message: '两次输入的密码不一致' })
            } else {
              this.registerUser()
            }
          })

        Text('返回登录')
          .padding({ top: 270 })
          .fontColor('#999')
          .fontSize(16)
          .onClick(() => router.replaceUrl({ url: 'pages/Login_Page' }))
      }
      .padding(20)
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}