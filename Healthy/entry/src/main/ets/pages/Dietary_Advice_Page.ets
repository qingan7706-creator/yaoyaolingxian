import router from '@ohos.router';

import http from '@ohos.net.http'

//健康建议
@Entry
@Component
struct Dietary_Advice_Page {


  @State background_text: string[] = []

  aboutToAppear() {
    this.loadDataFromNetwork()
  }

  // 网络请求方法
  private async loadDataFromNetwork() {
    try {
      const httpRequest: http.HttpRequest = http.createHttp()
      httpRequest.request(
        'http://192.168.111.171:8000/api/check/',
        {
          method:http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/json'
          }
        }
      ).then((response: http.HttpResponse)=>{
        if (response.responseCode === 200){
          this.background_text = JSON.parse(response.result.toString()).content.split('$')
        } else {
          console.error(`请求失败，状态码：${response.responseCode}`)
        }
      })
    }catch (error) {
      console.error('数据加载失败:', error);
    }
  }

 //滚动对象
  myScroll : Scroller = new Scroller()
  //滚动监听对象
  @State
  yOffset:number = 0

  // background_text : string[] = ['    定期体检，关注身体指标变化。每年进行一次全面体检，重点关注血压、血糖、血脂等指标，及时发现潜在健康问题，做到早预防、早治疗。',
  //   '    每天吃够 5 种蔬果，补充维生素。可以在早餐时搭配一份浆果，午餐加一份绿叶蔬菜，晚餐吃根茎类蔬菜，再以新鲜水果作为加餐，维持身体营养均衡。',
  // '    控制糖分摄入，少喝含糖饮料。用无糖茶、黑咖啡或柠檬水代替奶茶、可乐，警惕隐藏在果汁、酸奶中的添加糖，降低肥胖和患糖尿病风险。',
  // '    保证每天 7-8 小时高质量睡眠。睡前 1 小时避免使用电子设备，营造安静、黑暗的睡眠环境，规律作息时间，让身体得到充分休息与修复。',
  // '    减少久坐，每小时起身活动 5 分钟。设置手机定时提醒，可做简单拉伸、深蹲或走动，缓解肌肉疲劳，促进血液循环，预防腰颈椎疾病。',
  // '    细嚼慢咽，每餐吃到七八分饱。每口食物咀嚼 20 次左右，用餐时间不少于 20 分钟，给大脑留出接收饱腹感信号的时间，避免过量饮食。',
  // '    戒烟限酒，远离二手烟环境。尝试逐步减少吸烟量，选择低度数酒类并控制饮用量，多去无烟场所，降低呼吸系统和心血管疾病发生几率。',
  // '    每天喝够 1.5-2 升水，少量多次。随身携带水杯，晨起空腹喝一杯温水唤醒肠胃，工作间隙、运动前后定时补水，维持身体正常代谢。',
  // '    保持心态平和，学会释放压力。每天安排 15 分钟冥想、深呼吸，或通过听音乐、写日记、与朋友倾诉等方式缓解焦虑，保持心理健康。']


  build() {

    Stack({alignContent:Alignment.Top}){
      if(this.yOffset<30){
        Row({space:130}){
          Row({space:100}){
            Image($r('app.media.back'))
              .width(30)
              .height(20)
              .margin({left:20})
              .onClick(()=>{
                router.back()
              })
            Text('健康建议')
          }
          .width('100%')
          .height(70)
          .backdropBlur(50)
        }
        .zIndex(999)
      }

      Scroll(this.myScroll){

        Column(){
          // 轮播图
          Swiper(){
            Image($r('app.media.food1'))
              .borderRadius(16)
            Image($r('app.media.food2'))
              .borderRadius(16)
            Image($r('app.media.food3'))
              .borderRadius(16)
            Image($r('app.media.food4'))
              .borderRadius(16)
            Image($r('app.media.food5'))
              .borderRadius(16)
            Image($r('app.media.food6'))
              .borderRadius(16)
          }
          .width('100%')
          .height('30%')
          .padding(5)
          .autoPlay(true)
          .interval(3000)
          .indicator(Indicator.dot()
            .selectedColor(Color.White)
          )
          .margin({top:60})

          // 提示文本
          Text('健康建议')
            .fontSize(30)
            .fontColor(Color.Green)
            .margin({top:20})
            .border({width:{bottom:5},color:Color.Green})
          //健康LOGO
          Image($r('app.media.hl'))
            .width(40)
            .height(40)
            .position({x:270,y:270})

          //健康建议栏
          ForEach(this.background_text,(text:string, index)=>{

            Stack(){
              Image($r('app.media.bg'))
                .padding({left:5,right:5,top:5,bottom:5})
              Text(text)
                .padding(100)
            }

          })
        }
      }
      .onScroll(()=>{
        this.yOffset = this.myScroll.currentOffset().yOffset
      })
    }
    .backgroundImage($r('app.media.a'))
    .backgroundImagePosition(Alignment.Center)
    .backgroundImageSize(ImageSize.Cover)
  }

}