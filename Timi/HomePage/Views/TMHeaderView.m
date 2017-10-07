//
//  TMHeaderView.m
//  Timi
//
//  Created by chairman on 16/5/21.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "TMHeaderView.h"
#import <Masonry/Masonry.h>
#import "Const.h"
#import "TMCalculate.h"
#import "TMPieView.h"
#import "NSString+TMNSString.h"
#import "NSArray+TMNSArray.h"
#define kBtnWidth 40
#define kCircleWidth 100
@interface TMHeaderView()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) TMPieView *pieView;
@property (nonatomic, strong) UILabel *incomeLabel;
@property (nonatomic, strong) UILabel *incomeMoneyLabel;
@property (nonatomic, strong) UILabel *expendLabel;
@property (nonatomic, strong) UILabel *expendMoneyLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *createBtn;

@end

@implementation TMHeaderView
#pragma mark - lazy loading

- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"background8"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        _bgImageView = imageView;
    }
    return _bgImageView;
}

- (TMPieView *)pieView
{
    if (!_pieView) {
        _pieView = [TMPieView new];
        _pieView.backgroundColor = [UIColor clearColor];
        _pieView.layer.cornerRadius = kCircleWidth/2;
        _pieView.lineWidth = 2;
//        _pieView.layer.masksToBounds = YES;
    }
    return _pieView;
}

- (UIButton *)createBtn
{
    if (!_createBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button addTarget:self action:@selector(clickCreateBtn:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"circle_btn"] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.layer.cornerRadius =(kCircleWidth-30-30)/2;
        button.layer.masksToBounds = YES;
        _createBtn = button;
    }
    return _createBtn;
}

- (UILabel *)incomeLabel
{
    if (!_incomeLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = LineColor;
        label.font = [UIFont systemFontOfSize:15.0f];
        label.text = @"收入";
        _incomeLabel = label;
    }
    return _incomeLabel;
}
- (UILabel *)incomeMoneyLabel
{
    if (!_incomeMoneyLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = LineColor;
        label.font = [UIFont systemFontOfSize:18.0f];
        _incomeMoneyLabel = label;
    }
    return _incomeMoneyLabel;
}
- (UILabel *)expendLabel
{
    if (!_expendLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = LineColor;
        label.font = [UIFont systemFontOfSize:15.0f];
        label.text = @"支出";
        _expendLabel = label;
    }
    return _expendLabel;
}
- (UILabel *)expendMoneyLabel
{
    if (!_expendMoneyLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = LineColor;
        label.font = [UIFont systemFontOfSize:18.0f];
        label.textAlignment = NSTextAlignmentRight;
        _expendMoneyLabel = label;
    }
    return _expendMoneyLabel;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = LineColor;
    }
    return _lineView;
}


#pragma mark - action
- (void)clickCreateBtn:(UIButton *)sender {
    NSLog(@"click CreateBtn");
    if (self.headerViewDelegate && [self.headerViewDelegate respondsToSelector:@selector(didClickPieInCreateBtn)]) {
        [self.headerViewDelegate didClickPieInCreateBtn];
    }
}
#pragma mark - system Methods

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        WEAKSELF
        [self addSubview:self.bgImageView];
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(155);
            make.width.mas_equalTo(SCREEN_SIZE.width);
            make.left.top.and.right.equalTo(weakSelf);
        }];
        
        [self.bgImageView addSubview:self.pieView];
        [self.pieView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kCircleWidth, kCircleWidth));
            make.centerX.equalTo(weakSelf.bgImageView);
            make.centerY.equalTo(weakSelf.bgImageView.mas_bottom);
        }];
        [self.bgImageView addSubview:self.createBtn];
        [self.createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.pieView).insets(UIEdgeInsetsMake(30, 30, 30, 30));
        }];
        
        [self addSubview:self.incomeLabel];
        [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.bgImageView.mas_bottom).offset(10);
            make.left.equalTo(weakSelf).offset(20);
        }];
        
        [self addSubview:self.incomeMoneyLabel];
        [self.incomeMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.incomeLabel).offset(20);
            make.left.equalTo(weakSelf.incomeLabel);
        }];
        
        [self addSubview:self.expendLabel];
        [self.expendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.incomeLabel);
            make.right.equalTo(weakSelf).offset(-20);
        }];
        
        [self addSubview:self.expendMoneyLabel];
        [self.expendMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.expendLabel).offset(20);
            make.right.equalTo(weakSelf.expendLabel);
        }];
        
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(1, 20));
            make.centerX.equalTo(weakSelf);
            make.top.equalTo(weakSelf.pieView.mas_bottom);
        }];
    }
    return self;
}
#pragma mark -

- (void)calculateMoney {
    self.incomeMoneyLabel.text = [NSString stringWithFormat:@"%.2f",[TMCalculate queryAllIncomeOrExpendOfBookID:[NSString readUserDefaultOfSelectedBookID] andPaymentType:income]];
    self.expendMoneyLabel.text = [NSString stringWithFormat:@"%.2f",[TMCalculate queryAllIncomeOrExpendOfBookID:[NSString readUserDefaultOfSelectedBookID] andPaymentType:expend]];
    NSString *imageFileName = [NSArray headerBgImageFiles][arc4random()%[NSArray headerBgImageFiles].count];
    self.bgImageView.image = [UIImage imageNamed:imageFileName];
}
- (void)loadPieViewWihtSection:(NSArray *)sections withColors:(NSArray *)colors {
    self.pieView.sections = sections;
    self.pieView.sectionColors = colors;
    /** 调用setNeedsDisplay 会调用drawRect */
    [self.pieView setNeedsDisplay];
}
- (void)animationWithCreateBtnDuration:(NSTimeInterval)time angle:(CGFloat)angle{
    WEAKSELF
    [UIView animateWithDuration:time delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.createBtn.transform = CGAffineTransformRotate(weakSelf.createBtn.transform, angle/500);
    } completion:^(BOOL finished) {
        [UIView  animateWithDuration:time/2 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakSelf.createBtn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }];
}


@end
