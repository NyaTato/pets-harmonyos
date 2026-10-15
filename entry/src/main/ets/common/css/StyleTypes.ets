// 样式类型定义

// BorderStyle枚举 - 与ArkUI的BorderStyle保持一致
export const enum BorderStyle {
  Solid = 0,
  Dotted = 1,
  Dashed = 2
}



export interface ShadowOptions {
  radius: number;
  color: string;
  offsetX: number;
  offsetY: number;
}

export interface PaddingOptions {
  left?: number | string;
  right?: number | string;
  top?: number | string;
  bottom?: number | string;
}

export interface BorderOptions {
  width: number;
  color: string;
  radius?: number;
  style?: number; // 使用number类型以兼容ArkUI的BorderStyle
}

export interface SimpleBorderOptions {
  width: number;
  color: string | number;
}



export interface MarginOptions {
  bottom?: number;
  top?: number;
  left?: number;
  right?: number;
}

export interface InputErrorStyle {
  border: BorderOptions;
}

export interface CardStyleDark {
  backgroundColor: string | number;
  shadow: ShadowOptions;
}

export interface ListItemDarkStyle {
  backgroundColor: string | number;
}

export interface TextStyle {
  fontSize: number;
  fontWeight?: number | string;
  fontColor: string | number;
}

export interface ContainerPaddingStyle {
  padding: PaddingOptions;
}

export interface SectionMarginStyle {
  margin: MarginOptions;
}

export interface LoadingContainerStyle {
  width: string | number;
  height: number | string;
  justifyContent?: string | FlexAlign;
  alignItems?: string | FlexAlign;
  padding?: PaddingOptions | number;
}

export interface EmptyStateStyle {
  width: string | number;
  height: number;
  justifyContent: string;
  alignItems: string;
}

export interface ErrorContainerStyle {
  width: string | number;
  padding: PaddingOptions | number;
  backgroundColor: string | number;
  borderRadius: number;
  justifyContent?: string | FlexAlign;
  alignItems?: string | FlexAlign;
}

export interface CardStyle {
  width: string | number;
  backgroundColor: string | number;
  borderRadius: number;
  padding: PaddingOptions;
  shadow?: ShadowOptions;
  border?: BorderOptions;
  margin?: MarginOptions;
}

export interface ButtonStyle {
  width: string | number;
  height: number;
  fontSize: number;
  fontWeight: number | string;
  fontColor: string | number;
  backgroundColor: string | number;
  borderRadius: number;
  stateEffect?: boolean;
  border?: BorderOptions;
  padding?: PaddingOptions;
  shadow?: ShadowOptions;
}

export interface TextSimpleStyle {
  fontSize: number;
  fontWeight?: number;
  fontColor: string;
}

export interface InputStyle {
  width: string | number;
  height: number;
  fontSize: number;
  backgroundColor: string | number;
  borderRadius: number;
  padding: PaddingOptions;
  border: BorderOptions;
  shadow?: ShadowOptions;
}

export interface TagStyle {
  backgroundColor: string;
  borderRadius: number;
  padding: PaddingOptions;
  fontSize?: number;
  fontWeight?: number;
  fontColor?: string;
}

export interface GradientBackgroundStyle {
  backgroundImage: string;
}

export interface ContainerStyle {
  width?: string | number;
  height?: string | number;
  backgroundColor?: string | number;
  padding?: number | PaddingOptions;
  flexGrow?: number;
}

export interface CardContainerStyle {
  backgroundColor: string;
  borderRadius: number;
  shadow: ShadowOptions;
  padding: PaddingOptions;
}

// 添加ComponentStyles.ets中使用的其他接口定义
export interface AvatarStyle {
  width: number;
  height: number;
  borderRadius: number;
}

export interface BadgeStyle {
  width: number;
  height: number;
  backgroundColor: string | number;
  borderRadius: number;
  fontColor: string | number;
  fontSize: number;
}

export interface ProgressStyle {
  width: string | number;
  height: number;
  backgroundColor: string | number;
  borderRadius: number;
  valueColor: string | number;
}

export interface SwitchStyle {
  width: number;
  height: number;
  selectedColor: string | number;
  trackColor: string | number;
}

export interface SliderStyle {
  width: string | number;
  height: number;
  selectedColor: string | number;
  trackColor: string | number;
  blockColor: string | number;
}

export interface TabStyle {
  width: string | number;
  height: number;
  selectedColor: string | number;
  unselectedColor: string | number;
  fontSize: number;
  fontWeight: number | string;
}

export interface ListItemStyle {
  width: string | number;
  height: number;
  backgroundColor: string | number;
  borderRadius: number;
  padding: PaddingOptions;
  margin?: MarginOptions;
}

export interface GridItemStyle {
  width: string | number;
  height: number;
  backgroundColor: string | number;
  borderRadius: number;
  padding: PaddingOptions;
}

export interface ModalStyle {
  width: string | number;
  backgroundColor: string | number;
  borderRadius: number;
  padding: PaddingOptions;
}

export interface ToastStyle {
  width: string | number;
  backgroundColor: string | number;
  borderRadius: number;
  padding: PaddingOptions;
  fontColor: string | number;
  fontSize: number;
}

export interface LoadingStyle {
  size: number;
  color: string | number;
}

export interface DividerStyle {
  width: string | number;
  height: number;
  color: string | number;
  strokeWidth?: number;
}

export interface IconStyle {
  width: number;
  height: number;
  color: string | number;
}

export interface ImageStyle {
  width: string | number;
  height: number;
  borderRadius: number;
}

export interface TextAreaStyle {
  width: string | number;
  height: number;
  fontSize: number;
  backgroundColor: string | number;
  borderRadius: number;
  padding: PaddingOptions;
  border: BorderOptions;
}

export interface CheckboxStyle {
  width: number;
  height: number;
  selectedColor: string | number;
  unselectedColor: string | number;
}

export interface RadioStyle {
  width: number;
  height: number;
  selectedColor: string | number;
  unselectedColor: string | number;
}

export interface TitleStyle {
  fontSize: number;
  fontWeight: number | string;
  fontColor: string | number;
}

export interface PickerStyle {
  width: string | number;
  height: number;
  fontSize: number;
  backgroundColor: string | number;
  borderRadius: number;
  padding: PaddingOptions;
}

export interface DatePickerStyle {
  width: string | number;
  height: number;
  fontSize: number;
  backgroundColor: string | number;
  borderRadius: number;
  padding: PaddingOptions;
}

export interface TimePickerStyle {
  width: string | number;
  height: number;
  fontSize: number;
  backgroundColor: string | number;
  borderRadius: number;
  padding: PaddingOptions;
}

export interface RatingStyle {
  width: string | number;
  height: number;
  selectedColor: string | number;
  unselectedColor: string | number;
}

export interface SearchStyle {
  width: string | number;
  height: number;
  fontSize: number;
  backgroundColor: string | number;
  borderRadius: number;
  padding: PaddingOptions;
  border: BorderOptions;
}
