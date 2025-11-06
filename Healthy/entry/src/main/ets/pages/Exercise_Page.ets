import router from '@ohos.router'
@Entry
@Component
struct Exercise_Page {

  //滚动对象
  myScroll : Scroller = new Scroller()
  //滚动监听对象
  @State
  yOffset:number = 0

  background_text : string[] = ['每天步行 30 分钟以上：选择通勤或饭后时段，加快步频至微微喘气，可提升代谢、增强心肺，轻松融入日常。',
  '每周 3 次有氧训练：如慢跑、跳绳或游泳 30 分钟，心率维持在 120-150 次 / 分，有效燃烧脂肪、改善体能。',
  '力量训练每周 2-3 次：深蹲、俯卧撑、哑铃等动作结合，每组 8-12 次，练后拉伸，塑造肌肉线条并提升基础代谢。',
  '尝试瑜伽 / 普拉提练习：每周 2 次，通过呼吸配合体式，缓解压力、改善体态，增强核心控制力与身体柔韧性。',
  '骑行替代短途通勤：选择共享单车或自行车，单程 15-20 分钟，感受微风的同时锻炼下肢，低碳又健康。',
  '饭后散步 + 简单拉伸：用餐后慢走 10-15 分钟，搭配扩胸、转腰等拉伸动作，促进消化并放松紧绷肌群。',
  '周末进行户外有氧运动：爬山、徒步或骑行郊外，呼吸新鲜空气，既能锻炼全身，又能缓解一周工作压力。',
  '居家跟练健身视频：选择 HIIT、帕梅拉等短时高效课程，每天 20 分钟，利用碎片化时间提升体能与协调性。',
  '组队参与球类运动：约朋友打羽毛球、篮球或乒乓球，每周 1-2 次，在互动中提升反应力，让运动更具趣味性。',
  '晨起 / 睡前拉伸放松：各花 5-8 分钟做全身动态拉伸（如猫牛式、腿部后侧拉伸），唤醒身体或缓解一天疲劳。']

  build() {

    Stack({alignContent:Alignment.Top}) {
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
            Text('运动建议')
          }
          .width('100%')
          .height(70)
          .backdropBlur(50)
        }
        .zIndex(999)
      }

      Scroll(this.myScroll){

        Column() {
          // 轮播图
          Swiper(){
            Image($r("app.media.exercise1"))
              .borderRadius(16)
            Image($r('app.media.exercise2'))
              .borderRadius(16)
            Image($r("app.media.exercise3"))
              .borderRadius(16)
            Image($r("app.media.exercise4"))
              .borderRadius(16)
            Image($r("app.media.exercise5"))
              .borderRadius(16)
            Image($r("app.media.exercise6"))
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
          Text('运动建议')
            .fontSize(30)
            .fontColor(Color.Green)
            .margin({top:20})
            .border({width:{bottom:5},color:Color.Green})
          //健康LOGO
          Image($r('app.media.hl'))
            .width(40)
            .height(40)
            .position({x:270,y:270})


          //主体建议
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