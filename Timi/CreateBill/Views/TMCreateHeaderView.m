//
//  TMCreateHeaderView.m
//  Timi
//
//  Created by chairman on 16/5/25.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS


#import "TMCreateHeaderView.h"
#import <Masonry/Masonry.h>
#import "TMButton.h"
#import "Const.h"
@interface TMCreateHeaderView()

@property (nonatomic, strong) UIImageView *categoryImageView;
@property (nonatomic, strong) TMButton *categoryNameBtn;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) CAShapeLayer *bgColorlayer;
@property (nonatomic, strong) UIColor *previousSelectColor;
@end
@implementation TMCreateHeaderView
#pragma mark - lazy loading
- (UIImageView *)categoryImageView
{
    if (!_categoryImageView) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:@"type_big_2"];
        _categoryImageView = imageView;
    }
    return _categoryImageView;
}
- (TMButton *)categoryNameBtn
{
    if (!_categoryNameBtn) {
        _categoryNameBtn = [TMButton new];
        [_categoryNameBtn addTarget:self action:@selector(clickCategoryNameBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_categoryNameBtn setTintColor:[UIColor whiteColor]];
        _categoryNameBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_categoryNameBtn setTitle:@"用餐" forState:UIControlStateNormal];
        [_categoryNameBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    return _categoryNameBtn;
}
- (UILabel *)moneyLabel
{
    if (!_moneyLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:20.0f];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentRight;
        label.text = @"¥ 0.00";
        
        _moneyLabel = label;
    }
    return _moneyLabel;
}
#pragma mark - system Methods

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        WEAKSELF
        [self addSubview:self.categoryImageView];
        [self.categoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(48.5, 48.5));
            make.centerY.equalTo(weakSelf);
            make.left.equalTo(weakSelf).offset(10);
        }];
        
        [self addSubview:self.categoryNameBtn];
        //    [self.categoryNameBtn setTitle:@"工资" forState:UIControlStateNormal];
        [self.categoryNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.equalTo(CGSizeMake(60, 30));
            make.left.mas_equalTo(weakSelf.categoryImageView.mas_right).offset(10);
            make.centerY.equalTo(weakSelf);
        }];
        
        [self addSubview:self.moneyLabel];
        //    self.moneyLabel.text = @"¥ 9999999999.00";
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.equalTo(CGSizeMake(weakSelf.bounds.size.width/2, 30));
            make.centerY.equalTo(weakSelf);
            make.right.equalTo(@(-10));
        }];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.bounds.origin];
    [path addLineToPoint:CGPointMake(self.bounds.origin.x, self.bounds.size.height)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    //* 设置路径 */
    layer.path = path.CGPath;
    //* 设置填充色 */
    layer.fillColor = [UIColor clearColor].CGColor;
    //* 设置边框色 */
    layer.strokeColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:layer];
    self.bgColorlayer = layer;
}
#pragma mark - action 
- (void)clickCategoryNameBtn:(TMButton *)sender {
    NSLog(@"click CatrgoryNameBtn");
    if (self.clickCategoryName) {
        self.clickCategoryName();
    }
}
- (void)categoryImageWithFileName:(NSString *)imageFieleName andCategoryName:(NSString *)categoryName {
    self.categoryImageView.image = [UIImage imageNamed:imageFieleName];
    [self.categoryNameBtn setTitle:categoryName forState:UIControlStateNormal];
}
- (void)updateMoney:(NSString *)money {
    if (self.moneyLabel.text.length>13) {
        if ([money isEqualToString:@"0.00"]) {
            self.moneyLabel.text = [NSString stringWithFormat:@"¥ %@",money];
        }
        return;
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"¥ %@",money];
}

- (void)animationWithBgColor:(UIColor *)color {
    //* 如果选择的类别图片的颜色和上次选择的一样  直接return */
    if ([color isEqual: self.previousSelectColor]) return;
    //* 修改背景颜色为上一次选择的颜色,不然就会是最开始默认的颜色,动画会很丑 */
    self.backgroundColor = self.previousSelectColor;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    animation.fromValue = @0.0;
    animation.toValue = @(self.bounds.size.width * 2);
    animation.duration = 0.3f;
    //* 设置填充色 */
    self.bgColorlayer.fillColor = color.CGColor;
    //* 设置边框色 */
    self.bgColorlayer.strokeColor = color.CGColor;
    
    self.previousSelectColor = color;
    //* 保持动画 */
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [self.bgColorlayer addAnimation:animation forKey:@"bgColorAnimation"];

    //* 将子控件放在最上面,不然layer会覆盖 */
    [self bringSubviewToFront:self.categoryImageView];
    [self bringSubviewToFront:self.moneyLabel];
    [self bringSubviewToFront:self.categoryNameBtn];
    
    NSLog(@"animationSub = %@",[self.bgColorlayer animationKeys]);
}

- (void)shakingAnimation {
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"right"];
//    NSNumber *number1 = @(-20);
//    NSNumber *number2 = @(-10);
//    animation.duration = 5.0f;
//    animation.values = @[number2,number1,number2];
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    [self.moneyLabel.layer addAnimation:animation forKey:@"shakingAnimation"];
    WEAKSELF
    [UIView animateWithDuration:5.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        NSLog(@"line = %i",__LINE__);
        [weakSelf.moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-20));
        }];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:5.0 animations:^{
            NSLog(@"line = %i",__LINE__);
            [weakSelf.moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@(-10));
            }];
        }];
    }];
    [UIView animateWithDuration:5.0 delay:10.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        NSLog(@"line = %i",__LINE__);
        [weakSelf.moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-20));
        }];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:5.0 animations:^{
            NSLog(@"line = %i",__LINE__);
            [weakSelf.moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@(-10));
            }];
        }];
    }];
}
- (void)dealloc {
    [self.bgColorlayer removeAllAnimations];
    [self.moneyLabel.layer removeAllAnimations];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
