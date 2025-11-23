import router from '@ohos.router'
import http from '@ohos.net.http'
import GlobalStore from './GlobalStore' // 请替换为实际路径

function post_phonenumber(text:string): number {
  const httpRequest: http.HttpRequest = http.createHttp()
  console.log(GlobalStore.sessionId)
  httpRequest.request(
    'http://192.168.111.171:8000/api/check/',
    {
      method: http.RequestMethod.POST,
      header: {
        'Cookie': `sessionid=${GlobalStore.sessionId}`,
        'Content-Type': 'application/json'
      },
      extraData: text
    }
  ).catch((err: Error) => {
    console.error('网络请求异常:', err)
    return 404
  })
  return 200
}
@Entry
//设置手机号
@Component
struct Phone_number_Page {
  @State currentNumber: string = '123456'
  @State newNumber: string = ''
  @State isEditPageVisible: boolean = true // 管理页面显示状态

  build() {
    Column() {
      // 头部导航栏
      Stack() {
        Row({space:91}){
          Image($r('app.media.back'))
            .width(30)
            .height(20)
            .margin({left:20})
            .onClick(()=>{
              router.back()
            })
          Text('设置手机号')
        }
        .width('100%')
        .height(70)
        .backdropBlur(50)
        // 右侧完成按钮
        Button('完成')
          .height(30)
          .margin({ left: 240 })
          .backgroundColor(this.newNumber.trim() ? '#4CAF50' : '#CCCCCC')
          .fontColor('#FFFFFF')
          .fontSize(16)
          .borderRadius(15)
          .enabled(this.newNumber.trim() !== '')
          .onClick(() => {
            if (post_phonenumber(this.newNumber.trim()) == 200){
              console.info(`更新手机号为: ${this.newNumber}`)
            } else{
              console.info(`更新失败`)
            }
            router.back()
          })
      }
      .backgroundColor(0xffffff)
      .shadow({ radius: 2, offsetY: 1, color: '#eee' })

      // 卡片容器
      Column() {
        // 输入区域
        TextInput({
          placeholder: '修改手机号'
        })
          .width('100%')
          .height(56) //
          .backgroundColor(0xFFFFFF)
          .fontSize(18) // 字体大小
          .padding({ left: 16 }) // 内边距
          .onChange((value: string) => {
            this.newNumber = value
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


}