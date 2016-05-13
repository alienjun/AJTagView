//
//  DemoCell.m
//  AJTagViewExample
//
//  Created by AlienJunX on 16/5/13.
//  Copyright © 2016年 com.alienjun. All rights reserved.
//

#import "ViewCell.h"
#import "UIView+Tag.h"

@interface ViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@end

@implementation ViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    [_coverImageView layoutIfNeeded];
    
    // clear
    [_coverImageView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    float randomX = (arc4random()%10)/12.0;
    float randomY = (arc4random()%10)/12.0;

    [_coverImageView aj_showTagWithPercent:CGPointMake(randomX, randomY) text:@"测试内容，美女哈哈"];
    //tagView.direction = AJTagDirectionLeft; // 指定方向
}
@end
