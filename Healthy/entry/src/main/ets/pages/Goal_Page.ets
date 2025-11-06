import { promptAction, router } from '@kit.ArkUI';
import http from '@ohos.net.http'
import GlobalStore from './GlobalStore'
type HealthDataType = 'steps' | 'sleep' | 'calorie' | 'stand';

interface HealthDataPayload {
  type: HealthDataType;
  value: number;
  timestamp: string;
}
@Entry
@Component
struct Index {
  private async submitGoal(type: string, value: string) {
    // 网络请求逻辑
    const parsedValue = this.parseValue(type as HealthDataType, value);
    if (parsedValue === null) {
      promptAction.showToast({ message: '解析失败，请选择正确格式', duration: 2000 });
      return;
    }
    await this.submitHealthData(type as HealthDataType, parsedValue);
  }
  // 统一提交接口
  private async submitHealthData(type: HealthDataType, value: number) {
    const payload: HealthDataPayload = {
      type,
      value,
      timestamp: new Date().toISOString(),
    };

    try {
      const httpRequest = http.createHttp();
      const response = await httpRequest.request(
        'http://192.168.111.171:8000/api/healthgoal/',
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Cookie': `sessionid=${GlobalStore.sessionId}`
          },
          extraData: JSON.stringify(payload)
        }
      );

      // ✅ 正确属性是 response.responseCode
      if (response.responseCode === 200) {
        promptAction.showToast({ message: `提交成功: ${type} ${value}`, duration: 2000 });
      } else {
        promptAction.showToast({ message: '提交失败', duration: 2000 });
      }
    } catch (error) {
      promptAction.showToast({ message: '网络错误', duration: 2000 });
    }
  }

  // 显示选择框并提交
  private showTextPickerDialog(type: HealthDataType, options: string[]) {
    let dialog: TextPickerDialogOptions = {
      range: options as string[], // ✅ 明确 string[]
      defaultPickerItemHeight: 50,

      canLoop: false,
      shadow: {
        radius: 10,
        offsetX: 20,
        offsetY: 20,
        color: "#66333333",
      },
      onAccept: (result: TextPickerResult) => {
        let selectedValue: string = Array.isArray(result.value) ? result.value[0] : result.value;
        this.submitGoal(type, selectedValue);
      }
    };
    TextPickerDialog.show(dialog);
  }

  // 解析文本为数字（根据类型不同）
  private parseValue(type: HealthDataType, text: string): number | null {
    switch (type) {
      case 'steps': {
        // 形如 "5000步", "30000+步"
        const match = text.match(/^(\d+)(\+)?步$/);
        return match ? Number(match[1]) : null;
      }
      case 'sleep': {
        // 形如 "5小时", "12+小时"
        const match = text.match(/^(\d+)(\+)?小时$/);
        return match ? Number(match[1]) : null;
      }
      case 'calorie': {
        // 形如 "200千卡", "1000+千卡"
        const match = text.match(/^(\d+)(\+)?千卡$/);
        return match ? Number(match[1]) : null;
      }
      case 'stand': {
        // 形如 "30分钟", "270+分钟"
        const match = text.match(/^(\d+)(\+)?分钟$/);
        return match ? Number(match[1]) : null;
      }
      default:
        return null;
    }
  }

  build() {
    Column() {
      Stack() {
        Row({ space: 95 }) {
          Image($r('app.media.back'))
            .width(30)
            .height(20)
            .margin({ left: 20 })
            .onClick(() => {
              router.back();
            });
          Text('目标设定');
        }
        .width('100%')
        .height(70)
        .backdropBlur(50);
      }
      .padding({ bottom: 100 });

      Column({ space: 20 }) {
        Button("步数目标")
          .onClick(() => {
            this.showTextPickerDialog('steps', ['5000步', '6000步', '7000步', '8000步', '9000步', '10000步', '15000步', '20000步', '25000步', '30000+步']);
          })
          .backgroundColor('#4CAF50')
          .width('80%');
        Button("睡眠目标")
          .onClick(() => {
            this.showTextPickerDialog('sleep', ['5小时', '6小时', '7小时', '8小时', '9小时', '10小时', '11小时', '12+小时']);
          })
          .backgroundColor('#4CAF50')
          .width('80%');
        Button("卡路里目标")
          .onClick(() => {
            this.showTextPickerDialog('calorie', ['200千卡', '300千卡', '400千卡', '500千卡', '600千卡', '700千卡', '800千卡', '900千卡', '1000+千卡']);
          })
          .backgroundColor('#4CAF50')
          .width('80%');
        Button("站立时长")
          .onClick(() => {
            this.showTextPickerDialog('stand', ['30分钟', '60分钟', '90分钟', '120分钟', '150分钟', '180分钟', '210分钟', '240分钟', '270+分钟']);
          })
          .backgroundColor('#4CAF50')
          .width('80%');
      }
      .width('100%');
    }
    .backgroundColor(0xffffff);
  }
}
