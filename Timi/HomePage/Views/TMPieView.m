//
//  TMPieView.m
//  Timi
//
//  Created by chairman on 16/5/21.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "TMPieView.h"
#import <Masonry.h>
#import "Const.h"
#import "TMButton.h"
/** 动画时间 */
const NSTimeInterval animationTime = 1.0f;

@interface TMPieView()
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAShapeLayer *containerLayer;
@property (nonatomic, assign, getter=isCompleteAnimation) BOOL completeAnimation;
@end
@implementation TMPieView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _lineWidth = 8;
        _spacing = 6;
        self.animationStrokeColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self drawPieWithAnimation];
}

/** 动画->饼图 */
- (void)drawPieWithAnimation {
    self.containerLayer = nil;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.bounds.size.height/2];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.fillColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:layer];
    self.containerLayer = layer;
    
    NSUInteger count = self.sections.count;
    float total = 0.0,starAngle = M_PI/2,endAngle;
    for (NSInteger i=0; i<count; i++) {
        total += [self.sections[i] floatValue];
    }
    CGPoint center = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.origin.y + self.bounds.size.height/2);
    for (NSInteger j=0; j<count; j++) {
        /** 计算比例 */
        CGFloat scale = [self.sections[j] floatValue]/total;
        UIColor *color = self.sectionColors[j];
        endAngle = starAngle + scale * 2 * M_PI;
        //* 弧形layer */
        //* center是这个UIView的中心点,而不是它在父容器的center */
        UIBezierPath *fanshapedPath = [UIBezierPath bezierPathWithArcCenter:center radius:(self.bounds.size.height - self.spacing)/2 startAngle:starAngle endAngle:endAngle clockwise:YES];

        CAShapeLayer *fanshapedLayer = [CAShapeLayer layer];
        fanshapedLayer.lineWidth = self.lineWidth;
        fanshapedLayer.path = fanshapedPath.CGPath;
        fanshapedLayer.fillColor = [UIColor clearColor].CGColor;
        fanshapedLayer.strokeColor = color.CGColor;
        /** 重新设置起始位置 */
        starAngle = endAngle;
        [layer addSublayer:fanshapedLayer];
    }
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    baseAnimation.fromValue = @1.0;
    baseAnimation.toValue = @0.0;
//    baseAnimation.delegate = self;
    baseAnimation.duration = animationTime;
    /** 逆时针的角度是负的*/
    UIBezierPath *coverPath = [UIBezierPath bezierPathWithArcCenter:center radius:(self.bounds.size.height - self.spacing)/2 startAngle:M_PI_2 endAngle: -2*M_PI+M_PI_2 clockwise:NO];
    CAShapeLayer *coverLayer = [CAShapeLayer layer];
    coverLayer.path = coverPath.CGPath;
    coverLayer.lineWidth = self.lineWidth;
    coverLayer.fillColor = [UIColor clearColor].CGColor;
    coverLayer.strokeColor = self.animationStrokeColor.CGColor;
    /** 保持动画执行的状态 */
    baseAnimation.removedOnCompletion = NO;//执行完成后动画对象不要移除
    baseAnimation.fillMode = kCAFillModeForwards;//保持当前状态
    [layer addSublayer:coverLayer];
    [coverLayer addAnimation:baseAnimation forKey:@"coverLayer"];
    self.shapeLayer = coverLayer;
}
- (void)reloadDataCompletion:(void (^)())completion {
    [self drawPieWithAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completion();
    });
}

- (NSInteger)getLayerIndexWithPoint:(CGPoint)point {
    for (NSInteger i=0; i<[self.containerLayer sublayers].count; i++) {
        CAShapeLayer *layer = (CAShapeLayer *)[self.containerLayer sublayers][i];
        CGPathRef path = [layer path];
        if (CGPathContainsPoint(path, NULL, point, 0)) {
            return i;
        }
    }
    return -1;
}

- (CGPoint)getLayerCenterPointWithPoint:(CGPoint)point {
    NSLog(@"sublayers.count = %li",[self.containerLayer sublayers].count);
    __block CGPoint centerPoint;
    CGAffineTransform transform = CGAffineTransformIdentity;
    NSMutableArray *allLayers = [[self.containerLayer sublayers] mutableCopy];
    [allLayers removeLastObject];//删除动画layer
    [allLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CAShapeLayer *layer = (CAShapeLayer *)obj;
        CGPathRef path = [layer path];
        if (CGPathContainsPoint(path, &transform, point, 0)) {
            
        }
    }];
    return centerPoint;
}

#pragma mark - CAAnimationDelegate

//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    if (flag) {
//        NSLog(@"%i 动画完成",__LINE__);
//        [self.shapeLayer removeFromSuperlayer];
//    }
//}
- (void)dismissAnimationByTimeInterval:(NSTimeInterval)time {
    NSLog(@"hello i am here with dismissAnimation ");
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    baseAnimation.duration = time;
    if (self.isCompleteAnimation) {
        self.completeAnimation = NO;
        baseAnimation.fromValue = @1.0;
        baseAnimation.toValue = @0.0;
    } else {
        self.completeAnimation = YES;
        baseAnimation.fromValue = @0.0;
        baseAnimation.toValue = @1.0;
    }
    /** 保持动画执行的状态 */
    baseAnimation.removedOnCompletion = NO;//执行完成后动画对象不要移除
    baseAnimation.fillMode = kCAFillModeForwards;//保持当前状态
    [self.shapeLayer addAnimation:baseAnimation forKey:nil];
}
- (void)dealloc {
    /** 移除动画 */
//    [self.shapeLayer removeAnimationForKey:@"coverLayer"];
    [self.shapeLayer removeAllAnimations];
}
@end
