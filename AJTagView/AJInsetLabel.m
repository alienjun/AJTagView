//  AJInsetLabel.m
//  AJTagView
//
//  Created by AlienJunX on 16/5/12.
//  Copyright (c) 2016 AlienJunX
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "AJInsetLabel.h"

@implementation AJInsetLabel

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize adjustedSize = [super sizeThatFits:size];
    adjustedSize.width += self.contentInsets.left + self.contentInsets.right;
    adjustedSize.height += self.contentInsets.top + self.contentInsets.bottom;
    
    return adjustedSize;
}

- (void)drawTextInRect:(CGRect)rect {
    CGRect insetRect = CGRectMake(self.contentInsets.left,
                                  self.contentInsets.top,
                                  rect.size.width - self.contentInsets.left - self.contentInsets.right,
                                  rect.size.height - self.contentInsets.top - self.contentInsets.bottom);
    [super drawTextInRect:insetRect];
}
@end
