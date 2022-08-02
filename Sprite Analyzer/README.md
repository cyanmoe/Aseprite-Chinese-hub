# Sprite Analyzer

**Sprite Analyzer** 是一个扩展，它可以创建带有精灵分解的实时预览，允许您跟踪精灵的值、轮廓、轮廓和块状形状。

## 如何使用扩展程序

为了分析精灵，您需要：
 1. 安装扩展并重新启动 Aseprite 
 2. 打开任何精灵/图像 
 3. 选择要创建预览的区域 - 最好使用矩形选框工具 
 4. 转到*窗口*菜单，然后单击底部附近的*Sprite Analyzer*选项

## 如何添加颜色

![Preview of a manual color selection](/Sprite%20Analyzer/readme-images/sprite-analyzer-preview.gif "Preview of a manual color selection")

Sprite Analyzer 可以显示额外的预览 - **轮廓预览**和 **平面颜色** 预览 - 这两个关于颜色的额外信息都需要输入。

有两个部分用于输入轮廓颜色和颜色以展平：

![Sprite Analysis Dialog](/Sprite%20Analyzer/readme-images/sprite-analysis-dialog.png "Sprite Analysis Dialog")

**Outline Colors** 有一个颜色集合，在预览中将显示为黑色。

**Flatten Colors** 可以有多个颜色集合/渐变，它们都将被绘制为集合中的第一种颜色。

为了配置集合： 
- 添加颜色 
- 通过左键单击颜色集合，这将添加当前前景颜色或在调色板中选择的颜色 
- 删除颜色 
- 通过右键单击集合中的颜色 
- 重新排序颜色
- 通过移动集合中的颜色，将颜色移出集合将其移除，轮廓颜色的顺序无关紧要

## 如何自动分析精灵

![Preview of an automatic color analysis](/Sprite%20Analyzer/readme-images/sprite-analyzer-auto-preview.gif "Preview of an automatic color analysis")

您可以通过从对话框顶部选择 *New Auto* 选项来自动分析精灵。这将引导您完成一个简短的过程，首先，您可以选择精灵中使用的轮廓颜色（或缺少轮廓颜色），然后使用的所有颜色将分组到颜色渐变中，您可以使用两个滑块调整分组：

- Tolerance - 它控制色调变化的大小对于仍然被视为同一渐变的一部分的颜色是可以接受的
- Ignorance - 它控制给定颜色的多少像素需要相邻才能被视为同一渐变的一部分

![Palette Extraction Dialog](/Sprite%20Analyzer/readme-images/palette-extraction-dialog.png "Palette Extraction Dialog")

## 如何管理预设

任何由轮廓颜色、要展平的颜色和预览选项组成的配置都可以作为预设保存和加载。对话框的顶部提供了用于管理预设的选项。
