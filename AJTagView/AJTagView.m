//
//  AJTagView.m
//  AJTagView
//
//  Created by AlienJunX on 16/5/12.
//  Copyright (c) 2016 AlienJunX
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "AJTagView.h"
#import "AJInsetLabel.h"

static CGFloat cornerRadius = 3; // 文字背景圆角
static CGFloat arrowWidth = 8; // 箭头宽度
static NSInteger pointSpace = 8; // 箭头与标记圆点的间隔

@interface AJTagView()<UIAlertViewDelegate>
{
    CGPoint _lastPoint;
    CGPoint _originPoint; // 标记点
    CGFloat _contentMaxWidth; // 文字可显示的最大宽度
    CGSize _textSize; // 文字尺寸
}
@property (nonatomic) CGSize pointSize;// 标记点大小
@property (weak, nonatomic) AJInsetLabel *contentLabel;
@property (weak, nonatomic) UIView *pointView;// 标记点所在的view
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer; // 点击手势
@property (nonatomic, strong) UILongPressGestureRecognizer *longGestureRecognizer; // 长按手势，默认长按删除
@end


@implementation AJTagView

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    // 初始化数据
    _backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _textColor = [UIColor whiteColor];
    _direction = AJTagDirectionLeft;
    _font = [UIFont systemFontOfSize:12];
    _pointSize = CGSizeMake(6, 6);
    _pointColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    _pointShadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _enableMove = NO;
    _enableTapGesture = NO;
    _enableLongGesture = NO;
    
    // 默认手势
    [self defaultGesture];
    
    // 添加标记点
    [self createCircleView];
    
    // 添加内容区域
    [self createContentLabel];
}

#pragma mark - Public
- (void)showWithInView:(UIView *)view point:(CGPoint)point text:(NSString *)text {
    // 最大宽度
    // point.x小于midx则箭头朝左，大于则朝右
    CGFloat midx = CGRectGetMidX(view.bounds);
    if (point.x < midx) {
        _direction = AJTagDirectionLeft;
        _contentMaxWidth = CGRectGetWidth(view.bounds) - point.x;
    } else {
        _direction = AJTagDirectionRight;
        _contentMaxWidth = point.x;
    }
    
    // 原点，标记点
    _originPoint = point;
    
    // 为了让内容垂直居中于标记点
    _textSize = [self.class labelSize:text font:_contentLabel.font width:_contentMaxWidth];
    _textSize.height += 10;
    CGFloat selfY = point.y - _textSize.height * 0.5;
    
    CGFloat selfX = point.x;
    if (_direction == AJTagDirectionRight) {
        CGFloat labelWidth = _textSize.width + arrowWidth;
        selfX = point.x - labelWidth - pointSpace - _pointSize.width/2.0;
        selfX = selfX < 0 ? 0:selfX;
    }

    self.frame = CGRectMake(selfX, selfY, 0, 0);
    self.text = text;
    [view addSubview:self];
}

- (void)showWithInView:(UIView *)view pointPercent:(CGPoint)percent text:(NSString *)text {
    CGFloat x = CGRectGetWidth(view.bounds) * percent.x;
    CGFloat y = CGRectGetHeight(view.bounds) * percent.y;
    CGPoint point = CGPointMake(x, y);
    [self showWithInView:view point:point text:text];
}

- (CGPoint)getTagPoint {
    if (self.direction == AJTagDirectionLeft) {
        return CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + CGRectGetHeight(self.frame)/2.0);
    } else {
        return CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame) + CGRectGetHeight(self.frame)/2.0);
    }
}

- (CGPoint)getTagPointPercent {
    CGPoint tagPoint = [self getTagPoint];
    CGFloat superViewWith = CGRectGetWidth(self.superview.frame);
    CGFloat superViewHeight = CGRectGetHeight(self.superview.frame);
    return CGPointMake(floor((tagPoint.x / superViewWith)*100)/100, floor((tagPoint.y / superViewHeight)*100)/100);
}

#pragma mark - init UI
// 创建标记圆点
- (void)createCircleView {
    CGSize circleSize = _pointSize;
    
    // animation layer
    CALayer *circleLayer =[CALayer new];
    circleLayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7].CGColor;
    circleLayer.position = CGPointMake(circleSize.width/2, circleSize.height/2);
    circleLayer.bounds = CGRectMake(0, 0, circleSize.width, circleSize.height);
    circleLayer.cornerRadius = circleSize.width/2;
    
    // circleView
    UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, circleSize.width, circleSize.height)];
    pointView.backgroundColor = [UIColor clearColor];
    [self addSubview:pointView];
    pointView.center = CGPointMake(10, CGRectGetHeight(self.frame)/2.0);
    [pointView.layer addSublayer:circleLayer];
    self.pointView = pointView;
    
    // point layer
    CALayer *circlePointLayer = [CALayer new];
    circlePointLayer.backgroundColor = self.pointColor.CGColor;
    circlePointLayer.position = CGPointMake(circleSize.width/2, circleSize.height/2);
    circlePointLayer.bounds = CGRectMake(0, 0, circleSize.width, circleSize.height);
    circlePointLayer.cornerRadius = circleSize.width/2;
    [pointView.layer addSublayer:circlePointLayer];
    
    [self circlePointAnimation:circleLayer];
}

// 创建显示内容的label
- (void)createContentLabel {
    AJInsetLabel *label = [[AJInsetLabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    label.numberOfLines = 0;
    label.font = self.font;
    label.textColor = self.textColor;
    label.backgroundColor = self.backgroundColor;
    label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:label];
    self.contentLabel = label;
}

// 默认手势
- (void)defaultGesture {
    // 长按
    _longGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    _longGestureRecognizer.minimumPressDuration = 1.0;
    [self addGestureRecognizer:_longGestureRecognizer];
    
    // 点击
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:_tapGestureRecognizer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.direction == AJTagDirectionRight) {
        self.pointView.center = CGPointMake(CGRectGetWidth(self.contentLabel.frame) + pointSpace,  self.frame.size.height/2.0);
    } else {
        self.pointView.center = CGPointMake(0, CGRectGetHeight(self.frame)/2.0);
    }
}

// 绘制和位置调整
- (void)drawPostion:(UILabel *)label {
    label.layer.mask = nil;
    UIBezierPath *path = [UIBezierPath  new];
    UIBezierPath *pathArrow = [UIBezierPath new];
    switch (self.direction) {
        case AJTagDirectionRight:
        {
            //绘制背景
            // 1.矩形
            path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, CGRectGetWidth(label.frame) - arrowWidth, CGRectGetHeight(label.frame)) cornerRadius:cornerRadius];
            // 2.尖头
            [pathArrow moveToPoint:CGPointMake(CGRectGetWidth(label.frame) - arrowWidth - 0.5, CGRectGetHeight(label.frame)/2+5)];
            [pathArrow addLineToPoint:CGPointMake(CGRectGetWidth(label.frame), CGRectGetHeight(label.frame)/2.0)];
            [pathArrow addLineToPoint:CGPointMake(CGRectGetWidth(label.frame) - arrowWidth - 0.5, CGRectGetHeight(label.frame)/2-5)];
            
            // 3.调整控件位置
            self.contentLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentLabel.frame), CGRectGetHeight(self.contentLabel.frame));
            self.pointView.center = CGPointMake(CGRectGetWidth(self.contentLabel.frame) + pointSpace,  self.frame.size.height/2.0);
            self.contentLabel.contentInsets = UIEdgeInsetsMake(0, 2, 0, arrowWidth);

            break;
        }
        case AJTagDirectionLeft:
        default:
        {
            // 绘制背景
            // 1.矩形
            path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(arrowWidth, 0, CGRectGetWidth(label.frame) - arrowWidth, CGRectGetHeight(label.frame)) cornerRadius:cornerRadius];
            // 2.尖头
            [pathArrow moveToPoint:CGPointMake(0, CGRectGetHeight(label.frame)/2.0)];
            [pathArrow addLineToPoint:CGPointMake(arrowWidth + 0.5, CGRectGetHeight(label.frame)/2+5)];
            [pathArrow addLineToPoint:CGPointMake(arrowWidth + 0.5, CGRectGetHeight(label.frame)/2-5)];
            
            // 3.调整控件位置
            self.pointView.center = CGPointMake(0, self.frame.size.height/2.0);
            self.contentLabel.frame = CGRectMake(pointSpace, 0, CGRectGetWidth(self.contentLabel.frame), CGRectGetHeight(self.contentLabel.frame));
            self.contentLabel.contentInsets = UIEdgeInsetsMake(0, arrowWidth + 2, 0, 0);
            break;
        }
    }

    CAShapeLayer *arrowLayer = [CAShapeLayer layer];
    arrowLayer.path = pathArrow.CGPath;
    CAShapeLayer *mask = [CAShapeLayer layer];
    [mask addSublayer:arrowLayer];
    mask.path = path.CGPath ;
    label.layer.mask = mask;
    
    // 重绘文字
    [self.contentLabel setNeedsDisplay];
    
    // 调整frame
    CGRect rect = _contentLabel.frame;
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            rect.size.width + pointSpace,
                            rect.size.height);
}

// 圆点动画
- (void)circlePointAnimation:(CALayer *)layer {
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.repeatCount = HUGE_VALF;
    [animationGroup setDuration:1];
    [animationGroup setRemovedOnCompletion:NO];
    [animationGroup setFillMode:kCAFillModeForwards];
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animationGroup.timingFunction = timingFunction;
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = [NSNumber numberWithFloat:0.5];
    fadeAnimation.toValue = [NSNumber numberWithFloat:0];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1];
    scaleAnimation.toValue = [NSNumber numberWithFloat:5];
    animationGroup.animations = [NSArray arrayWithObjects:fadeAnimation, scaleAnimation, nil];
    [layer addAnimation:animationGroup forKey:@"fadeAnimation"];
}

+ (CGSize)labelSize:(NSString *)contentStr font:(UIFont *)font width:(CGFloat)width {
    CGSize size = [contentStr boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    return size;
}

#pragma mark - setter
- (void)setText:(NSString *)text {
    if (text == nil) {
        text = @"";
    }
    _text = text;
    _contentLabel.text = _text;
    
    // 计算实际高度
    _textSize = [self.class labelSize:_text font:_contentLabel.font width:_contentMaxWidth];
    
    // 调整_contentLabel frame
    CGRect rect = _contentLabel.frame;
    rect.size = _textSize;
    rect.size.height += 10;
    rect.size.width += arrowWidth + 5;//尖头宽度=insets 为10，这里宽度偏移5
    
    // 宽度限制
    if (rect.size.width > _contentMaxWidth) {
        rect.size.width = _contentMaxWidth;
    }
    
    _contentLabel.frame = rect;
    
    // 重新绘制
    [self drawPostion:_contentLabel];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    _contentLabel.textColor = textColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    _contentLabel.backgroundColor = backgroundColor;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    _contentLabel.font = font;
    [self setText:_contentLabel.text];
}

- (void)setDirection:(AJTagDirection)direction {
    _direction = direction;
    [self drawPostion:_contentLabel];
}

- (void)setTapGestureRecognizer:(UITapGestureRecognizer *)tapGesture {
    if ([tapGesture isKindOfClass:[UITapGestureRecognizer class]]) {
        [self removeGestureRecognizer:_tapGestureRecognizer];
        _tapGestureRecognizer = tapGesture;
        [self addGestureRecognizer:tapGesture];
    }
}

- (void)setLongGestureRecognizer:(UILongPressGestureRecognizer *)longGesture {
    if ([longGesture isKindOfClass:[UILongPressGestureRecognizer class]]) {
        [self removeGestureRecognizer:_longGestureRecognizer];
        _longGestureRecognizer = longGesture;
        [self addGestureRecognizer:longGesture];
    }
}

#pragma mark Touch event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!_enableMove || touches.count > 1) {
        return;
    }
    UITouch *touch = [touches anyObject];
    UIView *superView = self.superview;
    _lastPoint = [touch locationInView:superView];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!_enableMove || touches.count > 1) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.superview];
    
    // center x最大、小值
    CGFloat centerMaxX = CGRectGetWidth(self.superview.frame) - CGRectGetWidth(self.bounds)/2.0;
    CGFloat centerMinX = CGRectGetWidth(self.bounds)/2.0;
    // center y最大、小值
    CGFloat centerMaxY = CGRectGetHeight(self.superview.frame) - CGRectGetHeight(self.bounds)/2.0;
    CGFloat centerMinY = CGRectGetHeight(self.bounds)/2.0;
    
    // 防止拖出父视图范围
    CGFloat centerX = self.center.x + point.x - _lastPoint.x;
    CGFloat centerY = self.center.y + point.y - _lastPoint.y;
    if (centerX > centerMaxX) {
        centerX = centerMaxX;
    } else if (centerX < centerMinX) {
        centerX = centerMinX;
    }
    
    if (centerY > centerMaxY) {
        centerY = centerMaxY;
    } else if (centerY < centerMinY) {
        centerY = centerMinY;
    }

    self.center = CGPointMake(centerX, centerY);
    _lastPoint = point;

    // 标记点坐标
    if (self.direction == AJTagDirectionLeft) {
        _originPoint = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + CGRectGetHeight(self.frame)/2.0);
    } else {
        _originPoint = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame) + CGRectGetHeight(self.frame)/2.0);
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan && _enableLongGesture) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除标签？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    if (_enableTapGesture) {
        // 默认支持切换朝向
        self.direction = self.direction == AJTagDirectionLeft ? AJTagDirectionRight : AJTagDirectionLeft;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self removeFromSuperview];
    }
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
