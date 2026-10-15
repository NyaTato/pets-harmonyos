// 筛选栏组件
import { CommonStyles } from '../common/css/CommonStyles';

@Component
export struct FilterBar {
  @Link selectedFilter: string;
  @Prop filters: Array<FilterItem> = [];
  // 使用普通属性而不是@Prop，因为@Prop不支持函数类型
  private onFilterChange?: (filter: string) => void;

  build() {
    Scroll() {
      Row({ space: CommonStyles.SPACE_MD }) {
        ForEach(this.filters, (filter: FilterItem) => {
          Button(filter.label)
            .padding({
              left: CommonStyles.SPACE_LG,
              right: CommonStyles.SPACE_LG,
              top: CommonStyles.SPACE_SM,
              bottom: CommonStyles.SPACE_SM
            })
            .backgroundColor(
              this.selectedFilter === filter.value
                ? CommonStyles.PRIMARY_COLOR
                : CommonStyles.WHITE
            )
            .fontColor(
              this.selectedFilter === filter.value
                ? CommonStyles.WHITE
                : CommonStyles.TEXT_PRIMARY
            )
            .fontSize(CommonStyles.FONT_SIZE_MD)
            .border({
              width: 1,
              color: this.selectedFilter === filter.value
                ? CommonStyles.PRIMARY_COLOR
                : CommonStyles.GRAY_300
            })
            .borderRadius(CommonStyles.RADIUS_FULL)
            .onClick(() => {
              this.selectedFilter = filter.value;
              if (this.onFilterChange) {
                this.onFilterChange(filter.value);
              }
            })
        })
      }
      .padding({ left: CommonStyles.SPACE_LG, right: CommonStyles.SPACE_LG })
    }
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
  }
}

// 筛选项接口
export interface FilterItem {
  label: string;
  value: string;
}
