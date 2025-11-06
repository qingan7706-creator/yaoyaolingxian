import router from '@ohos.router'
import http from '@ohos.net.http'
import GlobalStore from './GlobalStore' // 根据你的实际路径修改

// 定义响应类型
interface LogoutResponse {
  status: 'success' | 'fail';
  message: string;
}

@Entry
@Component
struct Setting_Page {
  build() {
    Column() {
      Stack() {
        Row({ space: 120 }) {
          Image($r('app.media.back'))
            .width(30)
            .height(20)
            .margin({ left: 20 })
            .onClick(() => {
              router.back()
            })
          Text('设置')
        }
        .width('100%')
        .height(70)
        .backdropBlur(50)
        .zIndex(999)
      }
      .backgroundColor(0xffffff)
      .shadow({ radius: 2, offsetY: 1, color: '#eee' })

      Column() {
        SettingItem({ title: '个人资料' })
          .onClick(() => {
            router.pushUrl({ url: 'pages/Personal_Data_Page' })
          })
        SettingItem({ title: '账号安全' })
          .onClick(() => {
            router.pushUrl({ url: 'pages/Account_security_page' })
          })
        SettingItem({ title: '消息通知' })
          .onClick(() => {
            router.pushUrl({ url: 'pages/Message_notification_page' })
          })
        SettingItem({ title: '通用' })
          .onClick(() => {
            router.pushUrl({ url: 'pages/General_page' })
          })
        SettingItem({ title: '朋友权限' })
          .onClick(() => {
            router.pushUrl({ url: 'pages/Friend_permission_page' })
          })

        Blank().height(15)

        SettingItem({
          title: '退出登录',
          textColor: '#e64340',
          showDivider: false
        })
          .onClick(() => {
            this.handleLogout()
          })
      }
      .margin({ top: 15, left: 15, right: 15 })
      .backgroundColor(0xffffff)
      .borderRadius(12)
      .shadow({ radius: 3, color: '#f0f5f0' })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(0xf5f5f5)
  }

  // 退出登录处理方法
  private async handleLogout() {
    const httpRequest: http.HttpRequest = http.createHttp();

    try {
      const sessionId: string = GlobalStore.sessionId;

      const response = await httpRequest.request(
        'http://192.168.111.171:8000/api/logout/',
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Cookie': `sessionid=${sessionId}` // 将 sessionid 传入后端
          },
          extraData: JSON.stringify({}),
          expectDataType: http.HttpDataType.STRING
        }
      );

      if (response.responseCode === 200 && typeof response.result === 'string') {
        const result: LogoutResponse = JSON.parse(response.result);

        if (result.status === 'success') {
          // 清除前端的 sessionId
          console.log(sessionId)
          GlobalStore.sessionId = '';
          console.info('退出成功，sessionId 已清除');
          router.replaceUrl({ url: 'pages/Login_Page' });
        } else {
          AlertDialog.show({
            message: result.message || '退出登录失败，请重试'
          });
        }
      } else {
        AlertDialog.show({
          message: '服务器错误，请稍后再试'
        });
      }
    } catch (error) {
      AlertDialog.show({
        message: '网络异常，请检查连接'
      });
      console.error('Logout error:', JSON.stringify(error));
    } finally {
      httpRequest.destroy();
    }
  }
}

  @Component
struct SettingItem {
  @Prop title: string
  @Prop textColor: string = '#000000'
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
  }
}