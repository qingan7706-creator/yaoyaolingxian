import router from '@ohos.router'
import http from '@ohos.net.http'
import promptAction from '@ohos.promptAction'
import GlobalStore from './GlobalStore'

// 家庭成员列表接口类型
interface data {
  image: ResourceStr,
  name: string
}

// 后端接口返回结构
interface FamilyResponse {
  status: string;
  usernames?: string[];
  message?: string;
}

@Entry
@Component
struct Family_member_Page {

  myScroll: Scroller = new Scroller()

  @State yOffset: number = 0

  // 默认头像资源
  localImages: ResourceStr[] = [
    $r('app.media.usericon1'),
    $r('app.media.usericon2'),
    $r('app.media.usericon3'),
    $r('app.media.usericon4'),
    $r('app.media.usericon5'),
    $r('app.media.usericon6'),
    $r('app.media.usericon7'),
    $r('app.media.usericon8'),
    $r('app.media.usericon9'),
    $r('app.media.usericon10'),
  ]

  @State datas: data[] = []
  @State isLoading: boolean = true

  // 页面显示时加载数据
  aboutToAppear() {
    this.loadFamilyMembers()
  }

  async loadFamilyMembers() {
    this.isLoading = true
    const httpRequest = http.createHttp()
    const url = 'http://192.168.111.171:8000/api/find/' // 替换为你自己的接口地址

    try {
      const response = await httpRequest.request(
        url,
        {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/json',
            'Cookie': `sessionid=${GlobalStore.sessionId}` // 如果需要登录凭证
          },
          expectDataType: http.HttpDataType.STRING
        }
      )

      if (response.responseCode === 200 && typeof response.result === 'string') {
        const result: FamilyResponse = JSON.parse(response.result)

        if (result.status === 'success' && result.usernames) {
          // 将用户名映射为 data[]，头像按索引循环分配
          this.datas = result.usernames.map((username: string, index: number): data => {
            return {
              name: username,
              image: this.localImages[index % this.localImages.length]
            }
          })
        } else {
          promptAction.showToast({ message: result.message ?? '数据获取失败', duration: 2000 })
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

  @Builder
  navItem(icon: ResourceStr, name: string) {
    Row({ space: 20 }) {
      Image(icon)
        .width(90)
        .height(90)
        .borderRadius(90)
      Text(name)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/Family_inf_Page',
            params: {
              icon_p: icon,
              name_p: name
            }
          })
        })
    }
    .margin({ left: 20, bottom: 20 })
    .width('100%')
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      // 顶部导航栏
      Row({ space: 100 }) {
        Image($r('app.media.back'))
          .width(30)
          .height(20)
          .margin({ left: 20 })
          .onClick(() => router.back())
        Text('家庭成员').fontSize(20).fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .height(70)
      .backdropBlur(50)
      .zIndex(999)

      // 返回顶部按钮
      if (this.yOffset > 400) {
        Image($r('app.media.rocket'))
          .width(40)
          .borderRadius(20)
          .padding(5)
          .offset({ x: 300, y: 600 })
          .onClick(() => this.myScroll.scrollEdge(Edge.Top))
          .zIndex(888)
      }

      // 主体区域
      Scroll(this.myScroll) {
        Column() {
          if (this.isLoading) {
            LoadingProgress().color(Color.Blue).margin(20)
            Text('加载中...').margin({ bottom: 20 })
          } else if (this.datas.length === 0) {
            Text('暂无家庭成员').fontSize(18).margin(20)
          } else {
            ForEach(this.datas, (item: data, index: number) => {
              this.navItem(item.image, item.name)
            })
          }
        }
        .width('100%')
        .margin({ top: 70 })
      }
      .onScroll(() => {
        this.yOffset = this.myScroll.currentOffset().yOffset
      })
    }
    .backgroundImage($r('app.media.a'))
    .backgroundImageSize(ImageSize.Cover) // 或 ImageSize.Cover
    .width('100%')
    .height('100%')

  }
}
