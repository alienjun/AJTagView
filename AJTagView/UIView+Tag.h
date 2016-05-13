//
//  UIView+Tag.h
//  AJTagView
//
//  Created by AlienJunX on 16/5/12.
//  Copyright (c) 2016 AlienJunX
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>
#import "AJTagView.h"

@interface UIView (Tag)

/**
 *  显示单个tag
 *
 *  @param percent 百分比
 *  @param text    标签内容
 *
 *  @return 添加到当前view 的tag
 */
- (AJTagView *)aj_showTagWithPercent:(CGPoint)percent text:(NSString *)text;

/**
 *  批量显示tag
 *
 *  @param percentArray 百分比数组 [CGPoint,CGPoint,CGPoint]
 *  @param textArray    显示的标签内容
 *
 *  @return 添加到当前view 的所有tags
 */
- (NSArray *)aj_showTagsWithPercentArray:(NSArray *)percentArray textArray:(NSArray *)textArray;

@end
