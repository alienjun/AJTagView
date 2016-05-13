//
//  DemoViewController.m
//  AJTagViewExample
//
//  Created by AlienJunX on 16/5/13.
//  Copyright © 2016年 com.alienjun. All rights reserved.
//

#import "DemoViewController.h"
#import "UIView+Tag.h"

@interface DemoViewController()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) BOOL isFirst;
@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirst = YES;
    
    // 如果没有使用Autolayout，可以直接在这里设置
    /*[self.imageView aj_showTagWithPercent:CGPointMake(0.5, 0.5) text:@"测试"];
    [self.imageView aj_showTagWithPercent:CGPointMake(0.2, 0.8) text:@"测试沙宣美发"];
    [self.imageView aj_showTagWithPercent:CGPointMake(0.8, 0.7) text:@"波波网iOS"];
     */
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_isFirst) {
#warning imageView使用Autolayout
        [self.imageView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        
        // 使用Autolayout 需要在viewDidAppear下设置tag，此时控件的frame才是正确的
        AJTagView *tagView = [self.imageView aj_showTagWithPercent:CGPointMake(0.5, 0.3) text:@"人群中哈市的角度讲爱哦欧松杀死后搜到好哦啊到爱撒谎是多厚碍手碍脚都是啊手动还加饭啥都好生动安山东华啥都好生动后安徽的寻找"];
        tagView.canMove = YES; // 可以拖动tag
//        tagView.direction = AJTagDirectionLeft; // 设置标签朝向
        
        // 给tag添加点击事件
        self.imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTagViewStyle:)];
        tagView.tapGestureRecognizer = tap;
        
        
        // 批量添加tag
        NSArray *percentArray = @[[NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)],[NSValue valueWithCGPoint:CGPointMake(0.2, 0.8)],[NSValue valueWithCGPoint:CGPointMake(0.8, 0.7)]];
        NSArray *textArray = @[@"测试",@"测试默默",@"人群中寻找"];
        [self.imageView aj_showTagsWithPercentArray:percentArray textArray:textArray];
    }

    _isFirst = NO;
}

- (IBAction)hideAllAction:(id)sender {
    [self.imageView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
}

- (IBAction)showAllAction:(id)sender {
    [self.imageView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = NO;
    }];
}

- (void)changeTagViewStyle:(UITapGestureRecognizer *)tap {
    AJTagView *tag = (AJTagView *)tap.view;
    UIColor *color = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:0.7];
    tag.backgroundColor = color;
    tag.pointColor = color;
    tag.pointShadowColor = color;
    tag.font = [UIFont systemFontOfSize:14];
    // 切换方向
    tag.direction = tag.direction == AJTagDirectionLeft ? AJTagDirectionRight : AJTagDirectionLeft;
}

@end
