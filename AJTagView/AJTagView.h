//
//  AJTagView.h
//  AJTagView
//
//  Created by AlienJunX on 16/5/12.
//  Copyright (c) 2016 AlienJunX
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,AJTagDirection) {
    AJTagDirectionLeft,
    AJTagDirectionRight
};

@interface AJTagView : UIView

@property (nonatomic) BOOL enableMove; // 是否能移动 默认NO
@property (nonatomic) BOOL enableLongGesture; // 是否能长按 默认NO
@property (nonatomic) BOOL enableTapGesture; // 是否能点击 默认NO
@property (nonatomic, copy) NSString *text; // 内容
@property (nonatomic, strong) UIColor *textColor; // 文字颜色 默认[UIColor whiteColor]
@property (nonatomic, assign) AJTagDirection direction; // 标签箭头朝向 默认BoTagDirectionLeft
@property (nonatomic, strong) UIFont *font; // 字体
@property (nonatomic, strong) UIColor *backgroundColor; // 背景色
@property (nonatomic, strong) UIColor *pointColor; // 标记点颜色
@property (nonatomic, strong) UIColor *pointShadowColor; // 标记点阴影颜色

/**
 *  显示某个tag，3个参数必须
 *
 *  @param view  显示在哪个view上
 *  @param point 显示在哪个点上
 *  @param text 标签内容
 */
- (void)showWithInView:(UIView *)view point:(CGPoint)point text:(NSString *)text;

/**
 *  按照tag关键点在父视图的百分比显示tag，3个参数必须
 *
 *  @param view    显示在哪个view上
 *  @param percent 关键点百分比
 *  @param text    标签内容
 */
- (void)showWithInView:(UIView *)view pointPercent:(CGPoint)percent text:(NSString *)text;

/**
 *  设置点击手势
 *
 *  @param tapGesture
 */
- (void)setTapGestureRecognizer:(UITapGestureRecognizer *)tapGesture;

/**
 *  设置长按手势
 *
 *  @param longGesture
 */
- (void)setLongGestureRecognizer:(UILongPressGestureRecognizer *)longGesture;

/**
 *  获取标记点
 *
 *  @return point
 */
- (CGPoint)getTagPoint;

/**
 *  获取标记点相对于所在视图坐标的百分比
 *
 *  @return 百分比
 */
- (CGPoint)getTagPointPercent;

@end
