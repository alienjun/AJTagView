//
//  UIView+Tag.m
//  AJTagView
//
//  Created by AlienJunX on 16/5/12.
//  Copyright (c) 2016 AlienJunX
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "UIView+Tag.h"
#import "AJTagView.h"

@implementation UIView (Tag)

- (AJTagView *)aj_showTagWithPercent:(CGPoint)percent text:(NSString *)text {
    AJTagView *tagView = [[AJTagView alloc] init];
    [tagView showWithInView:self pointPercent:percent text:text];
    return tagView;
}

- (NSArray *)aj_showTagsWithPercentArray:(NSArray *)percentArray textArray:(NSArray *)textArray {
    NSMutableArray *tagArray = [NSMutableArray array];
    if (!percentArray || !textArray) {
        return tagArray;
    }
    
    for (NSInteger i = 0; i < percentArray.count; i++) {
        NSValue *value = percentArray[i];
        CGPoint point = [value CGPointValue];
        if (i == textArray.count) {
            break;
        }
        
        NSString *text = textArray[i];
        AJTagView *tagView = [self aj_showTagWithPercent:point text:text];
        [tagArray addObject:tagView];
    }
    return tagArray;
}

@end
