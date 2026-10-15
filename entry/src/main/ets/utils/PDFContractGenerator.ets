/**
 * PDF合同生成工具
 * 前端模拟生成领养合同PDF文本
 */

import { CommonStyles } from '../common/css/CommonStyles';

// 合同数据接口
export interface ContractData {
  // 宠物信息
  petName: string;
  petType: string;
  petBreed: string;
  petAge: number;
  petGender: string;

  // 领养人信息
  adopterName: string;
  adopterIdCard: string;
  adopterPhone: string;
  adopterAddress: string;

  // 领养信息
  adoptionDate: string;
  adoptionFee: number;
  trialPeriod: number; // 试用期（天）

  // 条款
  terms: ContractTerm[];
}

// 合同条款
export interface ContractTerm {
  id: number;
  title: string;
  content: string;
  required: boolean;
}

// 合同生成器类
export class PDFContractGenerator {
  // 生成合同HTML内容
  static generateContractHTML(data: ContractData): string {
    const termsHTML = data.terms.map(term => `
      <div class="term ${term.required ? 'required' : ''}">
        <h4>${term.id}. ${term.title}</h4>
        <p>${term.content}</p>
      </div>
    `).join('');

    return `
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8">
        <title>宠物领养合同</title>
        <style>
          body {
            font-family: 'SimSun', '宋体', serif;
            line-height: 1.6;
            color: #333;
            padding: 20px;
            max-width: 800px;
            margin: 0 auto;
          }

          .header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #4CAF50;
            padding-bottom: 20px;
          }

          .header h1 {
            color: #4CAF50;
            margin-bottom: 10px;
          }

          .contract-no {
            text-align: right;
            margin-bottom: 20px;
            color: #666;
          }

          .section {
            margin-bottom: 25px;
          }

          .section h2 {
            color: #4CAF50;
            border-left: 4px solid #4CAF50;
            padding-left: 10px;
            margin-bottom: 15px;
          }

          .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 20px;
          }

          .info-item {
            margin-bottom: 10px;
          }

          .info-label {
            font-weight: bold;
            color: #555;
            margin-bottom: 5px;
          }

          .info-value {
            padding: 8px;
            background: #f5f5f5;
            border-radius: 4px;
            border: 1px solid #ddd;
          }

          .term {
            margin-bottom: 15px;
            padding: 15px;
            background: #f9f9f9;
            border-left: 3px solid #4CAF50;
          }

          .term.required {
            border-left-color: #f44336;
            background: #fff5f5;
          }

          .term h4 {
            margin-top: 0;
            color: #333;
          }

          .signature {
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #ddd;
          }

          .signature-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-top: 20px;
          }

          .signature-box {
            text-align: center;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
          }

          .signature-line {
            margin-top: 60px;
            border-top: 1px solid #333;
            width: 200px;
            display: inline-block;
          }

          .footer {
            margin-top: 50px;
            text-align: center;
            color: #666;
            font-size: 12px;
          }

          .stamp {
            position: absolute;
            right: 50px;
            bottom: 100px;
            color: #f44336;
            font-size: 14px;
            font-weight: bold;
            border: 2px solid #f44336;
            padding: 5px 10px;
            transform: rotate(15deg);
          }
        </style>
      </head>
      <body>
        <div class="header">
          <h1>宠物领养合同</h1>
          <p>领养协议编号: AD${Date.now().toString().slice(-8)}</p>
        </div>

        <div class="contract-no">
          合同编号: CT${new Date().getFullYear()}${(new Date().getMonth() + 1).toString().padStart(2, '0')}${Math.floor(Math.random() * 10000).toString().padStart(4, '0')}
        </div>

        <div class="section">
          <h2>一、宠物信息/h2>
          <div class="info-grid">
            <div class="info-item">
              <div class="info-label">宠物名称</div>
              <div class="info-value">${data.petName}</div>
            </div>
            <div class="info-item">
              <div class="info-label">宠物种类</div>
              <div class="info-value">${data.petType}</div>
            </div>
            <div class="info-item">
              <div class="info-label">品种</div>
              <div class="info-value">${data.petBreed}</div>
            </div>
            <div class="info-item">
              <div class="info-label">年龄</div>
              <div class="info-value">${data.petAge}岁/div>
            </div>
            <div class="info-item">
              <div class="info-label">性别</div>
              <div class="info-value">${data.petGender}</div>
            </div>
          </div>
        </div>

        <div class="section">
          <h2>二、领养人信息</h2>
          <div class="info-grid">
            <div class="info-item">
              <div class="info-label">领养人姓名/div>
              <div class="info-value">${data.adopterName}</div>
            </div>
            <div class="info-item">
              <div class="info-label">身份证号</div>
              <div class="info-value">${data.adopterIdCard}</div>
            </div>
            <div class="info-item">
              <div class="info-label">联系电话</div>
              <div class="info-value">${data.adopterPhone}</div>
            </div>
            <div class="info-item">
              <div class="info-label">联系地址</div>
              <div class="info-value">${data.adopterAddress}</div>
            </div>
          </div>
        </div>

        <div class="section">
          <h2>三、领养信息/h2>
          <div class="info-grid">
            <div class="info-item">
              <div class="info-label">领养日期</div>
              <div class="info-value">${data.adoptionDate}</div>
            </div>
            <div class="info-item">
              <div class="info-label">领养费用</div>
              <div class="info-value">¥${data.adoptionFee.toFixed(2)}</div>
            </div>
            <div class="info-item">
              <div class="info-label">试用期/div>
              <div class="info-value">${data.trialPeriod}岁/div>
            </div>
          </div>
        </div>

        <div class="section">
          <h2>四、合同条款/h2>
          ${termsHTML}
        </div>

        <div class="section signature">
          <h2>五、双方签字/h2>
          <p>本人已仔细阅读并同意以上所有条款，自愿承担领养宠物的责任和义务岁/p>

          <div class="signature-grid">
            <div class="signature-box">
              <p><strong>领养人签岁/strong></p>
              <div class="signature-line"></div>
              <p>签字日期: ${new Date().toLocaleDateString()}</p>
            </div>

            <div class="signature-box">
              <p><strong>送养机构签字</strong></p>
              <div class="signature-line"></div>
              <p>签字日期: ${new Date().toLocaleDateString()}</p>
            </div>
          </div>
        </div>

        <div class="stamp">
          电子合同?br>
          鸿蒙宠物领养平台
        </div>

        <div class="footer">
          <p>本合同一式两份，双方各执一份，具有同等法律效力岁/p>
          <p>生成时间: ${new Date().toLocaleString()}</p>
          <p>© 2024 鸿蒙宠物领养平台 版权所有?/p>
        </div>
      </body>
      </html>
    `;
  }

  // 生成合同文本（简化版岁
  static generateContractText(data: ContractData): string {
    return `
宠物领养合同
=============

合同编号: CT${new Date().getFullYear()}${(new Date().getMonth() + 1).toString().padStart(2, '0')}${Math.floor(Math.random() * 10000).toString().padStart(4, '0')}
生成时间: ${new Date().toLocaleString()}

一、宠物信息
-----------
宠物名称: ${data.petName}
宠物种类: ${data.petType}
品种: ${data.petBreed}
年龄: ${data.petAge}岁
性别: ${data.petGender}

二、领养人信息
-------------
领养人姓名 ${data.adopterName}
身份证号: ${data.adopterIdCard}
联系电话: ${data.adopterPhone}
联系地址: ${data.adopterAddress}

三、领养信息
-----------
领养日期: ${data.adoptionDate}
领养费用: ¥${data.adoptionFee.toFixed(2)}
试用期 ${data.trialPeriod}岁

四、合同条款
-----------
${data.terms.map(term => `${term.id}. ${term.title}\n   ${term.content}`).join('\n\n')}

五、双方签字
-----------
本人已仔细阅读并同意以上所有条款，自愿承担领养宠物的责任和义务岁

领养人签岁 ___________________
签字日期: ${new Date().toLocaleDateString()}

送养机构签字: ___________________
签字日期: ${new Date().toLocaleDateString()}

备注: 本合同一式两份，双方各执一份，具有同等法律效力岁

© 2024 鸿蒙宠物领养平台 版权所有?
    `;
  }

  // 获取默认合同条款
  static getDefaultTerms(): ContractTerm[] {
    return [
      {
        id: 1,
        title: "领养责任",
        content: "领养人承诺为宠物提供安全、舒适的生活环境，保证宠物的健康和安全。",
        required: true
      },
      {
        id: 2,
        title: "医疗保健",
        content: "领养人承诺定期为宠物进行健康检查、疫苗接种和驱虫，及时治疗疾病。",
        required: true
      },
      {
        id: 3,
        title: "饮食照料",
        content: "领养人承诺为宠物提供充足、营养均衡的食物和清洁的饮用水。",
        required: true
      },
      {
        id: 4,
        title: "居住环境",
        content: "领养人承诺为宠物提供干净、宽敞的居住空间，定期清洁宠物居住环境。",
        required: true
      },
      {
        id: 5,
        title: "不得遗弃",
        content: "领养人承诺不遗弃、不虐待宠物，如无法继续饲养需联系送养机构安排转养。",
        required: true
      },
      {
        id: 6,
        title: "定期回访",
        content: "领养人同意送养机构在领养后半年内进行定期回访，了解宠物生活状况。",
        required: true
      },
      {
        id: 7,
        title: "试用期条款",
        content: "领养后有15天试用期，如发现不适应可协商退还宠物，领养费用全额退还。",
        required: true
      },
      {
        id: 8,
        title: "违约责任",
        content: "如违反本合同条款，送养机构有权收回宠物，并追究领养人的法律责任。",
        required: true
      }
    ];
  }

  // 生成示例合同数据
  static getExampleContractData(): ContractData {
    return {
      petName: "小白",
      petType: "狗狗",
      petBreed: "柯基",
      petAge: 2,
      petGender: "公",
      adopterName: "测试用户",
      adopterIdCard: "110101199001011234",
      adopterPhone: "00000000000",
      adopterAddress: "北京市朝阳区建国门外大街1号",
      adoptionDate: new Date().toLocaleDateString(),
      adoptionFee: 0,
      trialPeriod: 15,
      terms: PDFContractGenerator.getDefaultTerms()
    };
  }
}
