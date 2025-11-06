import router from '@ohos.router';
//首页
import { promptAction } from '@kit.ArkUI';
// import { notificationManager } from '@kit.NotificationKit';
import http from '@ohos.net.http'


// 如果你保存了 sessionid，例如在登录成功后
import GlobalStore from './GlobalStore' // 请替换为实际路径
interface OtherUserProgress {
  username: string;
  total_progress: number;
}

interface HealthInfoResponse {
  sessionid: string;
  data: number[]; // [sleep, stand, calorie, steps]
  others: OtherUserProgress[];
}

type HealthDataType = 'sleep' | 'stand' | 'calorie' | 'steps';
interface HealthDataPayload {
  type: HealthDataType;
  value: number;
}
// 广场——折线图
@Component
struct LineChartCard {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private data: number[] = [10, 80, 20, 40, 35, 60, 45]

  build() {
    Column() {
      Canvas(this.context)
        .width('100%')
        .height(200)
        .onReady(() => {
          this.drawLineChart()
        })
    }
    .width('90%')
    .padding(16)
    .backgroundColor('#ffefefef')
    .borderRadius(10)
    .shadow({ radius: 10, color: '#0000001A', offsetX: 10, offsetY: 10 })
  }

  drawLineChart() {
    const ctx = this.context
    const width = ctx.width
    const height = ctx.height
    const padding = 20
    const pointCount = this.data.length
    const maxValue = Math.max(...this.data)
    const minValue = Math.min(...this.data)
    const yScale = (height - 2 * padding) / (maxValue - minValue)
    const xStep = (width - 2 * padding) / (pointCount - 1)

    // 清除画布
    ctx.clearRect(0, 0, width, height)
    // 绘制折线
    ctx.strokeStyle = '#4CAF50' // 绿色
    ctx.lineWidth = 4
    ctx.beginPath()
    this.data.forEach((value, index) => {
      const x = padding + xStep * index
      const y = height - padding - (value - minValue) * yScale
      if (index === 0) {
        ctx.moveTo(x, y)
      } else {
        ctx.lineTo(x, y)
      }
    })
    ctx.stroke()

    // 绘制数据点
    ctx.fillStyle = '#ff9800' // 橙色
    this.data.forEach((value, index) => {
      const x = padding + xStep * index
      const y = height - padding - (value - minValue) * yScale
      ctx.beginPath()
      ctx.arc(x, y, 4, 0, 2 * Math.PI)
      ctx.fill()
    })
  }
}
// 声明接口，避免 ArkTS 报错
interface CheckFamilyResponse {
  has_family: boolean;
}
// 新增接口定义


function checkFamilyAndNavigate(): void {
  const httpRequest: http.HttpRequest = http.createHttp()
  console.log(GlobalStore.sessionId)
  httpRequest.request(
    'http://192.168.111.171:8000/api/check/',
    {
      method: http.RequestMethod.POST,
      header: {
        'Cookie': `sessionid=${GlobalStore.sessionId}`,
        'Content-Type': 'application/json'
      }
    }
  ).then((response: http.HttpResponse) => {
    if (response.responseCode === 200) {
      const result: CheckFamilyResponse = JSON.parse(response.result.toString())
      if (result.has_family === true) {
        router.pushUrl({ url: 'pages/Family_member_Page' })
      } else {
        router.pushUrl({ url: 'pages/test' })
      }
    } else {
      console.error(`请求失败，状态码：${response.responseCode}`)
    }
  }).catch((err: Error) => {
    console.error('网络请求异常:', err)
  })
}
@Entry
@Component
struct Index {
  aboutToAppear() {
    this.loadHealthInfo()
  }
  private themeColor = '#4CAF50';
  private inactiveColor = '#666666';
  private cardBgColor = '#bfefefef';
  private blurRadius = 85;
  private FONTColor = '#cc000000';
  private FONTSize = 25;
  private tabsController: TabsController = new TabsController()
  @State error: string = ''
  @State isDialogVisible: boolean = false;
  @State currentInputValue: string = '';
  @State currentDataType: HealthDataType = 'sleep' // 记录当前编辑的数据类型
  @State inputPlaceholder: string = '输入你的运动数据';
  @State progressValues: number[] = [0, 0, 0, 0,0]
  // 新增接口定义

  // 复选框
  @State @Watch('onHealthDataChanged') healthData: HealthInfoResponse = {
    sessionid: '',
    data: [0, 0, 0, 0, 0],
    others: []
  };

  onHealthDataChanged(): void {
    console.log('健康数据已更新:', this.healthData.data);
    // 在此处可以添加其他需要在健康数据更新时执行的逻辑
  }

  onPageShow() {
    // 每次页面显示时刷新数据
    this.loadHealthInfo();
  }
  @State isLoading: boolean = false
  @State isChecked: boolean = false;
   // 睡眠、站立、卡路里、步数
  // 底部Tab
  @State selectedIndex: number = 0;
  @Builder
  tabBuilder(itemIndex: number, title: string, img: ResourceStr) { // ,selImg: ResourceStr
    Column() {
      Image($r(`${img}`))// itemIndex == this.selectedIndex ? 高亮图 : img
        .width(25)
        .fillColor(itemIndex == this.selectedIndex ? this.themeColor : this.FONTColor)
        .padding({ top: 5, bottom:5 })
      Text(title)
        .fontColor(itemIndex == this.selectedIndex ? this.themeColor : this.FONTColor)
        .fontSize(14)
    }
    .width('100%')
    .height(60)
    .backgroundColor('#95ffffff')
    .backdropBlur(this.blurRadius)
  }
  // 信息卡片组件
  @Builder
  infoCard(label: string, dataType: HealthDataType, index: number) {
    Column() {
      Text(label)
        .fontSize(this.FONTSize)
        .fontColor(this.FONTColor)
        .margin({top: 20})
        .onClick(() => {
          this.currentDataType = dataType; // 直接使用枚举值
          this.isDialogVisible = true;
          this.currentInputValue = '';
        })

      Progress({
        value: this.progressValues[index], // 直接绑定到响应式数组
        type: ProgressType.Eclipse,
        total: 100
      })
        .size({width: 50, height: 50})
        .margin({top: 20, bottom: 20})
        .color(this.themeColor)

      Text(`已完成 ${this.progressValues[index]}%`)
    }
    .width(150)
    .height(200)
    .backgroundColor(this.cardBgColor)
    .borderRadius(12)
    .backdropBlur(this.blurRadius)
    .shadow({ radius: 10, color: '#0000001A', offsetX: 10, offsetY: 10 })
    .margin({ top: 10,left: 5, right: 5, bottom: 10 })
  }
  // 在组件内部添加方法


  async loadHealthInfo() {

    this.isLoading = true
    const httpRequest = http.createHttp()
    const url = 'http://192.168.111.171:8000/api/healthhistory/'
    try {
      const response = await httpRequest.request(
        url,
        {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/json',
            'Cookie': `sessionid=${GlobalStore.sessionId}`
          },
          expectDataType: http.HttpDataType.STRING
        }
      )

      if (response.responseCode === 200 && typeof response.result === 'string') {
        let result: HealthInfoResponse

        try {
          result = JSON.parse(response.result)
          console.log('后端返回原始数据 response.result: ', response.result)

        } catch (e) {
          promptAction.showToast({ message: '数据解析失败', duration: 2000 })
          return
        }
        // 保存健康数据
        this.healthData = {
          sessionid: result.sessionid,
          data: [...result.data],
          others: [...result.others]
        };
        this.progressValues = [...result.data]

        // 更新 sessionid（如需要）
        if (result.sessionid) {
          GlobalStore.sessionId = result.sessionid
        }
      } else {
        promptAction.showToast({ message: `HTTP错误：${response.responseCode}`, duration: 2000 })
      }

    } catch (err) {
      promptAction.showToast({ message: `网络异常：${(err as Error).message}`, duration: 2000 })
    } finally {
      httpRequest.destroy()
      this.isLoading = false
    }
  }
  private async submitHealthData() {
    // 1. 数据验证
    if (!this.currentInputValue || isNaN(Number(this.currentInputValue))) {
      promptAction.showToast({ message: '请输入有效数字', duration: 2000 });
      return;
    }

    // 2. 构造标准化数据
    const payload: HealthDataPayload = {
      type: this.currentDataType,
      value: Number(this.currentInputValue),
       // 自动添加时间戳
    };

    // 3. 发送请求
    try {
      const httpRequest = http.createHttp();
      const response = await httpRequest.request(
        'http://192.168.111.171:8000/api/healthdata/',
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Cookie': `sessionid=${GlobalStore.sessionId}`
          },
          extraData: JSON.stringify(payload)
        }
      );

      // 4. 处理响应
      if (response.responseCode === 200) {
        promptAction.showToast({ message: '数据提交成功', duration: 2000 });
        this.currentInputValue = '';
        await this.loadHealthInfo();
      } else {
        promptAction.showToast({ message: '提交失败', duration: 2000 });
      }
    } catch (error) {
      promptAction.showToast({ message: '网络错误', duration: 2000 });
    }
  }

  // 发帖按钮
  @Builder
  postButton() {

    Image($r('app.media.plus'))
      .fillColor(Color.White)
      .padding(16)
      .width(60)
      .height(60)
      .borderRadius(32)
      .backgroundColor(this.themeColor)
      .backdropBlur(25)
      .onClick(() => {
        router.pushUrl({ url: `pages/Show_Page` })
      })
  }
  @Builder
  dataInputDialog() {
    if (this.isDialogVisible) {
      Column() {
        TextInput({ placeholder: this.inputPlaceholder })
          .width('80%')
          .height(50)
          .onChange((value: string) => {
            this.currentInputValue = value;
          })

        Button('完成', { type: ButtonType.Normal })
          .width('50%')
          .margin(10)
          .backgroundColor(this.themeColor)
          .onClick(() => {
            this.submitHealthData();
            this.isDialogVisible = false;
          })
      }
      .width('90%')
      .padding(20)
      .backgroundColor(Color.White)
      .borderRadius(15)
      .position({ x: '5%', y: '30%' })
      .zIndex(999)
    }
  }
  @Builder
  build() {
    Column() {
      Stack({ alignContent: Alignment.Bottom }) {
        Stack({ alignContent: Alignment.Top }) {
          Row() {
            Text('健康')
              .fontSize(32)
              .fontWeight(700)
              .fontColor(this.FONTColor)

            Image($r('app.media.setting'))
              .width(32)
              .borderRadius(100)
              .onClick(() => {
                router.pushUrl({ url: `pages/Personal_Data_Page` })
              })
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ left: 16, right: 16 })
          .width('100%')
          .height(70)
          .backdropBlur(this.blurRadius)
          .zIndex(999)

          Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
            TabContent() {
              Scroll() {
                Column() {
                  Image($r('app.media.HL_logo'))
                    .width(100)
                    .margin({ top: 10, bottom: 20 })
                    .borderRadius(10)


                  Column() {
                    Row() {
                      Text('健康建议')
                    }
                    .justifyContent(FlexAlign.Center)
                    .width('85%')
                    .height(50)
                    .borderRadius(10)
                    .backgroundColor(this.cardBgColor)
                    .margin({ left: 10, right: 10, bottom: 10 })
                    .onClick(() => {
                      router.pushUrl({ url: 'pages/Dietary_Advice_Page' })
                    })

                    Row() {
                      Text('运动建议')
                    }
                    .justifyContent(FlexAlign.Center)
                    .width('85%')
                    .height(50)
                    .borderRadius(10)
                    .backgroundColor(this.cardBgColor)
                    .margin({ left: 10, right: 10, bottom: 20 })
                    .onClick(() => {
                      router.pushUrl({ url: 'pages/Exercise_Page' })
                    })
                  }

                  Column() {
                    Row() {
                      this.infoCard('睡眠', 'sleep', 0)
                      this.infoCard('站立时长', 'stand', 1)
                    }.justifyContent(FlexAlign.Center)

                    Row() {
                      this.infoCard('卡路里', 'calorie', 2)
                      this.infoCard('步数', 'steps', 3)
                    }.justifyContent(FlexAlign.Center)
                  }.width('100%')
                  this.dataInputDialog()
                }.padding({ top: 60, bottom: 60 })
              }
            }.tabBar(this.tabBuilder(0, '首页', 'app.media.mainpg'))

            // 广场
            TabContent() {
              Stack() {
                Scroll() {
                  Column() {
                    LineChartCard()
                    Text("运动总时长变化图")
                      .fontSize(14)
                      .fontColor(this.inactiveColor)
                      .padding({ top: 5, bottom: 10 })
                      .borderRadius(10)
                    Column() {
                      ForEach([1,2,3,4,5,6,7,8,9], (value: number, idx: number) => {
                        Column() {
                          Row() {
                            Image('app.media.HL_logo')
                              .width(32)
                              .height(32)
                              .borderRadius(16)
                            Text(`朋友 ${idx+1}`)
                              .fontSize(16)
                              .fontColor(this.themeColor)
                              .margin({ left: 8 })
                          }
                          .alignItems(VerticalAlign.Center)
                          .margin({ bottom: 8 })

                          Text('这是用户动态内容预览喵……')
                            .fontSize(14)
                            .fontColor(this.inactiveColor)
                        }
                        .backgroundColor(this.cardBgColor)
                        .borderRadius(12)
                        .backdropBlur(this.blurRadius)
                        .padding(16)
                        .margin({ bottom: 16 })
                        .width('100%')
                      })
                    }
                    .width('90%')
                  }
                  .alignItems(HorizontalAlign.Center)
                  .width('100%')
                  .padding({ top: 80, bottom: 100 })
                }

                // 发布按钮定位
                Column() {
                  this.postButton()
                }
                .position({ bottom: 20, right: 20 })
                .zIndex(200)
              }

            }
            .tabBar(this.tabBuilder(1, '广场',
              'app.media.pyq'))

            // 目标
            TabContent() {
              Scroll() {
                Column() {
                  // 我的目标进度标题
                  Text('我的目标进度')
                    .fontSize(this.FONTSize)
                    .fontColor(this.FONTColor)
                    .margin({ bottom: 32 })

                  // 我的目标进度 - 环形进度条
                  Progress({
                    value: this.progressValues[4], // 假设你有这个方法或变量返回总进度
                    total: 100,
                    type: ProgressType.Ring
                  })
                    .style({ strokeWidth: 20 })
                    .color(this.themeColor)
                    .size({ width: 150, height: 150 })
                    .margin({ bottom: 32 })
                    .onClick(() => {
                      router.pushUrl({ url: 'pages/Goal_Page' })
                    })

                  // 家庭成员进度展示
                  Column() {
                    ForEach(this.healthData.others, (item: OtherUserProgress, idx: number) => {
                      Column() {
                        Row() {
                          Image('app.media.HL_logo')
                            .width(32)
                            .height(32)
                            .borderRadius(16)
                          Text(`${item.username}`)
                            .fontSize(16)
                            .fontColor(this.themeColor)
                            .margin({ left: 8 })
                        }
                        .alignItems(VerticalAlign.Center)
                        .margin({ bottom: 8 })

                        Text(`该家庭成员目标总进度 ${item.total_progress}%`)
                          .fontSize(14)
                          .fontColor(this.inactiveColor)

                        Progress({ value: item.total_progress, total: 100, type: ProgressType.Linear })
                          .style({ strokeWidth: 5 })
                          .color(this.themeColor)
                          .size({ width: '80%' })
                          .margin({ top: 10 })
                      }
                      .backgroundColor(this.cardBgColor)
                      .borderRadius(12)
                      .backdropBlur(this.blurRadius)
                      .padding(16)
                      .margin({ bottom: 16 })
                      .width('100%')
                    })
                  }
                }
                .width('90%')
                .padding({ top: 80, bottom: 80 })
              }
            }
            .tabBar(this.tabBuilder(2, '目标', 'app.media.goal'))


            // 我的
            TabContent() {
              Stack() {
                Scroll() {
                  Column() {
                    // 用户头像
                    Image($r('app.media.HL_logo'))
                      .width(100)
                      .borderRadius(10)
                      .onClick(() => {
                        this.tabsController.changeIndex(0); // 跳至“首页”Tab
                      })
                      .margin({ bottom: 100 })

                    Row() {
                      Button('我的动态')
                        .layoutWeight(16)
                        .backgroundColor(this.themeColor)
                    }
                    .width('100%')
                    .height(40)
                    .borderRadius(20)
                    .margin({ bottom: 20 })
                    .padding({
                      left: 16,
                      right: 16,
                    })
                    .onClick(() => {
                      promptAction.showToast({
                        message: "当前暂无动态",
                        duration: 3500,
                        bottom: 100,
                        backgroundBlurStyle: BlurStyle.Thin
                      })                    })

                    Row() {
                      Button('家庭成员')
                        .layoutWeight(16)
                        .backgroundColor(this.themeColor)
                    }
                    .width('100%')
                    .height(40)
                    .borderRadius(20)
                    .margin({ bottom: 20 })
                    .padding({
                      left: 16,
                      right: 16
                    })
                    .onClick(() => {
                      console.log("按钮被点击");
                      checkFamilyAndNavigate()
                    })

                    Row() {
                      Button('设置与帮助')
                        .layoutWeight(16)
                        .backgroundColor(this.themeColor)
                    }
                    .width('100%')
                    .height(40)
                    .borderRadius(20)
                    .margin({ bottom: 20 })
                    .padding({
                      left: 16,
                      right: 16
                    })
                    .onClick(() => {
                      router.pushUrl({ url: 'pages/Setting_page' })
                    })

                    // 复选框(没啥用)
                    Row() {
                      Checkbox()
                        .select(this.isChecked)
                        .onChange((value: boolean) => {
                          if (!this.isChecked && value) {
                            promptAction.showToast({
                              message: "识时务者为俊杰",
                              duration: 3500,
                              bottom: 100,
                              backgroundBlurStyle: BlurStyle.Thin
                            })
                          }
                          this.isChecked = value
                        })
                        .width(10)
                        .margin({ top: 7 })
                      Text() {
                        Span('我已阅读并同意')
                        Span('《软件隐私政策》')
                          .fontColor(this.themeColor)
                        Span('《用户服务协议》')
                          .fontColor(this.themeColor)
                      }
                      .fontSize(12)
                      .fontColor('#666')
                      .lineHeight(20)
                    }
                    .alignItems(VerticalAlign.Top)
                    .margin({ top: 20 })
                  }
                }
              }
            }
            .tabBar(this.tabBuilder(3, '我的',
              'app.media.mine'))
          }
          // 监听Tab切换后事件
          .onChange((index: number) => {
            this.selectedIndex = index
          })
        }
        .width('100%')
        .height('100%')
        .backgroundImage($r('app.media.a'))
        .backgroundImagePosition(Alignment.Center)
        .backgroundImageSize(ImageSize.Cover)
      }
    }
  }
}