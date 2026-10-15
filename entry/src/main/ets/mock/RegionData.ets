// 地区数据
export interface Region {
  code: string;
  name: string;
  children?: Region[];
}

// 省份数据
const provinces: Region[] = [
  { code: '110000', name: '北京市' },
  { code: '120000', name: '天津市' },
  { code: '130000', name: '河北省' },
  { code: '140000', name: '山西省' },
  { code: '150000', name: '内蒙古自治区' },
  { code: '210000', name: '辽宁省' },
  { code: '220000', name: '吉林省' },
  { code: '230000', name: '黑龙江省' },
  { code: '310000', name: '上海市' },
  { code: '320000', name: '江苏省' },
  { code: '330000', name: '浙江省' },
  { code: '340000', name: '安徽省' },
  { code: '350000', name: '福建省' },
  { code: '360000', name: '江西省' },
  { code: '370000', name: '山东省' },
  { code: '410000', name: '河南省' },
  { code: '420000', name: '湖北省' },
  { code: '430000', name: '湖南省' },
  { code: '440000', name: '广东省' },
  { code: '450000', name: '广西壮族自治区' },
  { code: '460000', name: '海南省' },
  { code: '500000', name: '重庆市' },
  { code: '510000', name: '四川省' },
  { code: '520000', name: '贵州省' },
  { code: '530000', name: '云南省' },
  { code: '540000', name: '西藏自治区' },
  { code: '610000', name: '陕西省' },
  { code: '620000', name: '甘肃省' },
  { code: '630000', name: '青海省' },
  { code: '640000', name: '宁夏回族自治区' },
  { code: '650000', name: '新疆维吾尔自治区' },
  { code: '710000', name: '台湾省' },
  { code: '810000', name: '香港特别行政区' },
  { code: '820000', name: '澳门特别行政区' }
];

// 城市数据（以北京市为例）
const beijingCities: Region[] = [
  { code: '110100', name: '北京市' }
];

// 区县数据（以北京市为例）
const beijingDistricts: Region[] = [
  { code: '110101', name: '东城区' },
  { code: '110102', name: '西城区' },
  { code: '110105', name: '朝阳区' },
  { code: '110106', name: '丰台区' },
  { code: '110107', name: '石景山区' },
  { code: '110108', name: '海淀区' },
  { code: '110109', name: '门头沟区' },
  { code: '110111', name: '房山区' },
  { code: '110112', name: '通州区' },
  { code: '110113', name: '顺义区' },
  { code: '110114', name: '昌平区' },
  { code: '110115', name: '大兴区' },
  { code: '110116', name: '怀柔区' },
  { code: '110117', name: '平谷区' },
  { code: '110118', name: '密云区' },
  { code: '110119', name: '延庆区' }
];

// 获取省份列表
export function getProvinces(): string[] {
  return provinces.map(province => province.name);
}

// 根据省份获取城市列表
export function getCitiesByProvince(provinceName: string): string[] {
  if (provinceName === '北京市') {
    return beijingCities.map(city => city.name);
  }
  // 其他省份的数据暂时返回空数组
  return [];
}

// 根据城市获取区县列表
export function getDistrictsByCity(cityName: string): string[] {
  if (cityName === '北京市') {
    return beijingDistricts.map(district => district.name);
  }
  // 其他城市的数据暂时返回空数组
  return [];
}

// 获取完整的地区数据
export function getRegions(): Region[] {
  return provinces;
}