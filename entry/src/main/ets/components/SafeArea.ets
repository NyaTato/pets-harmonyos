// SafeArea component wrapper for ArkTS safe area handling
// Note: Actual safe area inset is handled by '45mm' padding on each page

@Component
export struct SafeArea {
  @Prop edges: string[] = ['top', 'bottom'];

  @BuilderParam content: () => void;

  build() {
    Column() {
      this.content()
    }
    .width('100%')
    .height('100%')
  }
}
