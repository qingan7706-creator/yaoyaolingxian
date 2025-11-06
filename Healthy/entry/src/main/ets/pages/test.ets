import router from '@ohos.router';
import http from '@ohos.net.http';
import promptAction from '@ohos.promptAction';
import GlobalStore from './GlobalStore';

interface FamilyResponse {
  status: 'success' | 'fail';
  message: string;
  family_code?: string;
}
interface FamilyResponse1 {
  status: 'success' | 'fail';
  message: string;
  family_id?: string;
}
interface CreateFamilyResponse {
  status: 'success' | 'fail';
  family_id?: string;
  message?: string;
}

@Entry
@Component
struct FamilyOperationPage {
  @State joinFamilyCode: string = '';

  build() {
    Column() {
      // 顶部导航栏
      Stack() {
        Row({ space: 91 }) {
          Image($r('app.media.back'))
            .width(30)
            .height(20)
            .margin({ left: 20 })
            .onClick(() => {
              router.back()
            })
          Text('家庭操作')
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
        }
        .width('100%')
        .height(70)
        .backdropBlur(50)
      }
      .backgroundColor(0xffffff)
      .shadow({ radius: 2, offsetY: 1, color: '#eee' })

      // 内容区域
      Column() {
        // 加入家庭输入框
        Column() {
          TextInput({ placeholder: '输入家庭码加入家庭' })
            .width('100%')
            .height(56)
            .backgroundColor(0xFFFFFF)
            .fontSize(18)
            .padding({ left: 16 })
            .onChange((value: string) => {
              this.joinFamilyCode = value
            })

          Divider()
            .strokeWidth(0.5)
            .color('#eeeeee')
            .margin({ left: 16 })
        }
        .margin({ top: 20, left: 15, right: 15 })
        .backgroundColor(0xffffff)
        .borderRadius(12)
        .shadow({ radius: 3, color: '#f0f0f0' })

        // 加入家庭按钮
        Column() {
          Row() {
            Button('加入家庭')
              .layoutWeight(1)
              .backgroundColor('#4CAF50')
              .fontColor('#FFFFFF')
              .fontSize(16)
              .height(40)
              .borderRadius(20)
          }
          .width('100%')
          .height(56)
          .padding({ left: 16, right: 16 })
          .onClick(() => {
            this.handleJoinFamily()
          })
        }
        .margin({ top: 20, left: 15, right: 15 })
        .backgroundColor(0xffffff)
        .borderRadius(12)
        .shadow({ radius: 3, color: '#f0f0f0' })

        // 创建家庭按钮
        Column() {
          Row() {
            Button('创建家庭')
              .layoutWeight(1)
              .backgroundColor('#4CAF50')
              .fontColor('#FFFFFF')
              .fontSize(16)
              .height(40)
              .borderRadius(20)
          }
          .width('100%')
          .height(56)
          .padding({ left: 16, right: 16 })
          .onClick(() => {
            this.handleCreateFamily()
          })
        }
        .margin({ top: 20, left: 15, right: 15, bottom: 30 })
        .backgroundColor(0xffffff)
        .borderRadius(12)
        .shadow({ radius: 3, color: '#f0f0f0' })
      }
      .width('100%')
      .margin({ top: 10 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(0xf5f5f5)
  }

  // 保持逻辑函数不变
  private async handleJoinFamily() {
    if (this.joinFamilyCode.length !== 4) {
      this.showDialog('家庭码格式错误，应为4位');
      return;
    }

    const httpRequest = http.createHttp();

    try {
      const sessionId: string = GlobalStore.sessionId;

      const response = await httpRequest.request(
        'http://192.168.111.171:8000/api/join/', // ✅ 修改为后端对应的路径
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Cookie': `sessionid=${sessionId}`
          },
          extraData: JSON.stringify({ family_code: this.joinFamilyCode }), // ✅ 提交家庭码
          expectDataType: http.HttpDataType.STRING
        }
      );

      if (response.responseCode === 200 && typeof response.result === 'string') {
        const result: FamilyResponse1 = JSON.parse(response.result);

        if (result.status === 'success') {
          this.showDialog(`加入家庭成功：${result.message}`);
          setTimeout(() => {
            router.replaceUrl({ url: 'pages/Main_Page' });
          }, 10000);
          // ✅ 可选：将 family_id 存入 GlobalStore
          // GlobalStore.familyId = result.family_id || '';
        } else {
          this.showDialog(result.message || '加入家庭失败');
        }
      } else {
        this.showDialog('查无此家庭码');
      }
    } catch (error) {
      this.showDialog('网络异常，请检查连接');
      console.error('join_family error:', JSON.stringify(error));
    } finally {
      httpRequest.destroy();
    }
  }



private async handleCreateFamily() {
  const httpRequest = http.createHttp();
  try {
    const sessionId: string = GlobalStore.sessionId;

    const response = await httpRequest.request(
      'http://192.168.111.171:8000/api/new/',
      {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json',
          'Cookie': `sessionid=${sessionId}`
        },
        extraData: JSON.stringify({}),  // 后端不依赖请求体，但需要有效 JSON 格式
        expectDataType: http.HttpDataType.STRING
      }
    );

    if (response.responseCode === 200 && typeof response.result === 'string') {
      const result: CreateFamilyResponse = JSON.parse(response.result);

      if (result.status === 'success' && result.family_id) {
        this.showDialog(`创建家庭成功，请妥善保存你的家庭码：${result.family_id}`);
        setTimeout(() => {
          router.replaceUrl({ url: 'pages/Main_Page' });
        }, 10000);
        // 可选：保存家庭码
        // GlobalStore.familyId = result.family_id;
      } else {
        this.showDialog(result.message || '创建家庭失败');
      }
    } else {
      this.showDialog('服务器错误，请稍后再试');
    }
  } catch (error) {
    this.showDialog('网络异常，请检查连接');
    console.error('handleCreateFamily error:', JSON.stringify(error));
  } finally {
    httpRequest.destroy();
  }
}


private showDialog(message: string) {
    promptAction.showDialog({
      title: '提示',
      message: message,
      buttons: [
        {
          text: '确定',
          color: '#4CAF50'
        }
      ]
    });
  }
}
