import router from '@ohos.router'
@Entry
//选择性别
@Component
struct GenderSetting {
  @State genderOptions: string[] = ['男', '女'];
  @State selectGender: string = '';
  build() {
    Column() {
      // 头部导航栏 - 保持与Setting_Page一致的风格
      Stack() {
        Row({space:100}){
          Image($r('app.media.back'))
            .width(30)
            .height(20)
            .margin({left:20})
            .onClick(()=>{
              router.back()
            })
          Text('选择性别')
        }
        .width('100%')
        .height(70)
        .backdropBlur(50)
        .zIndex(999)

        Button('完成')
          .backgroundColor('#4CAF50')
          .zIndex(999)
          .height(30)
          .margin({ left: 240 })
          .onClick(() => {
            if (this.selectGender) {
              router.back()
            }
            else {
              AlertDialog.show({ message: '请选择性别' });
            }
          });
      }
      .width('100%')
      .height(70)
      .backgroundColor(0xffffff)
      .shadow({ radius: 2, offsetY: 1, color: '#eee' })

      // 性别选项列表 - 保持与SettingItem一致的风格
      List() {
        ForEach(this.genderOptions, (option: string) => {
          ListItem() {
            Column() {
              Button(option)
                .width('100%')
                .height(56)
                .backgroundColor(this.selectGender === option ? '#E6F4FF' : '#FFFFFF')
                .fontColor('#000000')
                .borderRadius(2)
                .padding({ left: 16 })
                .onClick(() => {
                  this.selectGender = option;
                })

              // 分界线
              if (option !== this.genderOptions[this.genderOptions.length - 1]) {
                Divider()
                  .strokeWidth(1)
                  .color('#EEEEEE')
                  .margin({ left: 16 })
              }
            }
            .width('100%')
          }
        }, (option: string) => option)
      }
      .margin({ top: 16 })
      .width('95%')

    }
    .width('100%')
    .height('100%')
    .backgroundColor(0xf5f5f5)
  }
}