
介绍
==============
可以给任何View添加类似nice 应用中的那种标签。<br/>
![Aaron Swartz](https://github.com/alienjun/AJTagView/blob/master/Screenshots/screenshot1.gif)


特性
==============
- 开启长按和点击手势后，默认实现点击切换方向，长按删除。
- 可以任意移动位置。

用法
==============
###添加标签
	 #import "UIView+Tag.h"
	 //指定标签原点相对于需要显示的视图的百分比，需要显示的文字即可
    AJTagView *tagView = [self.imageView aj_showTagWithPercent:CGPointMake(0.2, 0.3) text:@"人群中寻找"];
    
    // 可以拖动tag
    tagView.enableMove = YES; 
    // 启用点击
    tagView.enableTapGesture = YES;
    // 启用长按
    tagView.enableLongGesture = YES;
    
    // 设置标签朝向
    tagView.direction = AJTagDirectionLeft; 
    // 背景色
    tagView.backgroundColor = color;
    // 标签原点颜色
    tagView.pointColor = color;
    // 标签原点阴影颜色
    tagView.pointShadowColor = color;
    // 标签字体
    tagView.font = [UIFont systemFontOfSize:18];
    // 单独设置text
    tagView.text = @"test";
    
	// 给tag添加自定义点击事件
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTagViewStyle:)];
    tagView.tapGestureRecognizer = tap;
    
    // 获取图片上tag的点
    [self.imageView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[AJTagView class]]) {
            CGPoint point = [((AJTagView *)obj) getTagPointPercent];
            NSLog(@"%@",NSStringFromCGPoint(point));
        }
    }];

###批量添加tag
	// 批量添加tag
    NSArray *percentArray = @[
    [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)],
    [NSValue valueWithCGPoint:CGPointMake(0.2, 0.8)],
    [NSValue valueWithCGPoint:CGPointMake(0.8, 0.7)]
    ];
    NSArray *textArray = @[@"测试",@"测试默默",@"人群中寻找"];
    [self.imageView aj_showTagsWithPercentArray:percentArray textArray:textArray];


安装
==============
### 手动安装

1. 下载 AJTagView 文件夹内的所有内容。
2. 将 AJTagView 内的源文件添加(拖放)到你的工程。
3. 导入 `UIView+Tag.h`。



系统要求
==============
该项目最低支持 `iOS 7.0` 和 `Xcode 7.0`。


许可证
==============
AJTagView 使用 MIT 许可证，详情见 LICENSE 文件。


感谢
==============
[https://github.com/lovels/LBTagView](https://github.com/lovels/LBTagView)

