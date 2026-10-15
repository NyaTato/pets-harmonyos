// 搜索栏组件
import { CommonStyles } from '../common/css/CommonStyles';

@Component
export struct SearchBar {
  @Link searchKeyword: string;
  @Prop placeholder: string = '搜索...';
  // 使用普通属性而不是@Prop，因为@Prop不支持函数类型
  private onSearch?: (keyword: string) => void;
  private onClear?: () => void;

  build() {
    Row({ space: CommonStyles.SM }) {
      // 搜索图标
      Text('🔍')
        .fontSize(18)
        .margin({ left: CommonStyles.MD })

      // 搜索输入框
      TextInput({ placeholder: this.placeholder, text: this.searchKeyword })
        .placeholderColor(CommonStyles.TEXT_TERTIARY)
        .placeholderFont({ size: CommonStyles.FONT_SIZE_MD })
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .layoutWeight(1)
        .onChange((value: string) => {
          this.searchKeyword = value;
        })
        .onSubmit(() => {
          if (this.onSearch) {
            this.onSearch(this.searchKeyword);
          }
        })

      // 清除按钮
      if (this.searchKeyword) {
        Text('✕')
          .fontSize(14)
          .fontColor(CommonStyles.TEXT_TERTIARY)
          .margin({ right: CommonStyles.MD })
          .onClick(() => {
            this.searchKeyword = '';
            if (this.onClear) {
              this.onClear();
            }
          })
      }
    }
    .width('100%')
    .height(44)
    .backgroundColor(CommonStyles.GRAY_100)
    .borderRadius(CommonStyles.RADIUS_FULL)
  }
}