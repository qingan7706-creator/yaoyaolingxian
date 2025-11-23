// 改好了删注释
import router from '@ohos.router'
//家庭成员
interface data {
  image_d: ResourceStr | string,
  text_d: string
}

interface ParamObj {
  icon_p: string,
  name_p:string
}


@Entry
@Component
struct Family_inf_Page {
  //回到顶部按钮对象
  myScroll : Scroller = new Scroller()
  //滚动监听对象
  @State
  yOffset:number = 0

  //接受上一级页面传递过来的参数
  @State icon: string = ''
  @State name: string = ''
  onPageShow(): void {
    const params = router.getParams() as ParamObj
    this.icon = params.icon_p
    this.name = params.name_p
  }

  //自定义朋友圈列表
  @Builder
  navItem(icon_d:ResourceStr | string, name_d:string){
    Row({space:20}){
      Image(icon_d)
        .width(90)
        .height(90)
        .borderRadius(5)
        .margin({bottom:10})
      Text(name_d)
        .width('60%')
    }
    .width('90%')
  }

  //自定义数据数组

  @State data1:data[] = [
  //家庭成员1
    {image_d: $r('app.media.pyq1'),text_d:'今日步数达标 ✅ 走着走着，健康就来了。'}]
  //家庭成员2
  @State data2:data[] = [
    {image_d: $r('app.media.pyq2'),text_d:'早睡早起第一天，挑战开始～'},]
  //家庭成员3
  @State data3:data[] = [
    {image_d: $r('app.media.pyq3'),text_d:'吃得干净，睡得踏实，状态满分💯'},]

  //家庭成员4
  @State data4:data[] = [
    {image_d: $r('app.media.pyq4'),text_d:'运动30分钟，出汗真爽！坚持就是胜利!'},]
  //家庭成员5
  @State data5:data[] = [
    {image_d: $r('app.media.pyq5'),text_d:'喝水打卡💧身体的自我修复，从补水开始。'},]
  //家庭成员6-xjj
  @State data6:data[] = [
    {image_d:$r('app.media.pyq7'),text_d:'跳一支舞，追逐自由的气息。'},
    {image_d:$r('app.media.pyq8'),text_d:'和朋友训练一下♂。'},
    {image_d:$r('app.media.pyq9'),text_d:'这位兄弟邀请我去他家地下室，去不去？♂'}]
  //家庭成员7
  @State data7:data[] = [
    {image_d: $r('app.media.pyq3'),text_d:'拒绝外卖第7天！健康饮食真的不难。'},]
  //家庭成员8
  @State data8:data[] = [
    {image_d: $r('app.media.pyq2'),text_d:'一觉到天亮，这种自然醒的感觉太棒了😴'},]
  //家庭成员9
  @State data9:data[] = [
    {image_d: $r('app.media.pyq1'),text_d:'健康不是一阵子，是一辈子的事。慢慢来，我们都能做到～'},]
  //家庭成员10
  @State data10:data[] = [
    {image_d: $r('app.media.pyq2'),text_d:'坚持记录饮食后才发现，嘴巴是健康的第一道关口。'},]
  @State data11:data[] = [
    {image_d: $r('app.media.pyq3'),text_d:'午饭只吃七分饱，下午工作效率更高了👍'},]

  build(){
    Stack({alignContent:Alignment.TopStart}) {
      //标题导航栏
      Row({space:100}){
        Image($r('app.media.back'))
          .width(30)
          .height(20)
          .margin({left:20})
          .onClick(()=>{
            router.back()
          })
        Text('家庭成员')
      }
      .width('100%')
      .height(70)
      .backdropBlur(50)
      .zIndex(999)

      //置顶图标
      if(this.yOffset>400){
        Image($r('app.media.rocket'))
          .width(40)
          .borderRadius(20)
          .padding(5)
          .offset({x:300,y:600})
          .onClick(()=>{
            this.myScroll.scrollEdge(Edge.Top)
          })
          .zIndex(8888)
      }

      //主显示页面
      Scroll(this.myScroll){

        Column(){
          Image($r('app.media.bg2'))
            .width('100%')
            .height(200)
            .margin({bottom:40})
          Column({space:5}) {
            Image(this.icon)
              .width(80)
              .height(80)
              .borderRadius(10)
            Text(this.name)
          }
          .position({x:270,y:150})
          if (this.name == '手握日月摘星辰') {
            ForEach(this.data1,(item:data,index)=>{
              this.navItem(item.image_d,item.text_d)
            })
          } else if (this.name == 'zzz') {
            ForEach(this.data2,(item:data,index)=>{
              this.navItem(item.image_d,item.text_d)
            })
          } else if (this.name == '蓝收') {
            ForEach(this.data3,(item:data,index)=>{
              this.navItem(item.image_d,item.text_d)
            })
          } else if (this.name == 'Xx-LE') {
            ForEach(this.data4,(item:data,index)=>{
              this.navItem(item.image_d,item.text_d)
            })
          } else if (this.name == '佐助') {
            ForEach(this.data5,(item:data,index)=>{
              this.navItem(item.image_d,item.text_d)
            })
          } else if (this.name == '香蕉君') {
            ForEach(this.data6,(item:data,index)=>{
              this.navItem(item.image_d,item.text_d)
            })
          } else if (this.name == '落芷') {
            ForEach(this.data7,(item:data,index)=>{
              this.navItem(item.image_d,item.text_d)
            })
          } else if (this.name == 'K.') {
            ForEach(this.data8,(item:data,index)=>{
              this.navItem(item.image_d,item.text_d)
            })
          } else if (this.name == '跳跳鬼') {
            ForEach(this.data9,(item:data,index)=>{
              this.navItem(item.image_d,item.text_d)
            })
          } else if (this.name == 'γ') {
            ForEach(this.data10,(item:data,index)=>{
              this.navItem(item.image_d,item.text_d)
            })
          } else {
            ForEach(this.data11,(item:data,index)=>{
              this.navItem(item.image_d,item.text_d)
            })
          }

        }
        .width('100%')
        .margin({top:60})

      }
      .onScroll(()=>{
        this.yOffset = this.myScroll.currentOffset().yOffset
      })

    }
    .backgroundImage($r('app.media.a'))
    .backgroundImagePosition(Alignment.Center)
    .backgroundImageSize(ImageSize.Cover)
    .height('100%')
  }

}