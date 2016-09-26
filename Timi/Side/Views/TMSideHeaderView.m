//
//  TMSideHeaderView.m
//  Timi
//
//  Created by chairman on 16/6/25.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "TMSideHeaderView.h"
#import <Masonry.h>
#import "TMButton.h"
#import "Const.h"
#import "TMSideButton.h"
//#import "TMDataBaseManager.h"
//#import "TMCalculatorView.h"
#import "TMCalculate.h"

#define kFont [UIFont systemFontOfSize:13.0f]

@interface TMSideHeaderView()
/** 头像 */
@property (nonatomic, strong) TMButton *avatarBtn;
/** 昵称 */
@property (nonatomic, strong) UILabel *nikeNameLabel;
/** 同步 */
@property (nonatomic, strong) TMSideButton *synBtn;
/** 设置 */
@property (nonatomic, strong) TMSideButton *settingBtn;
/** 线条 */
@property (nonatomic, strong) UIView *lineView;
/** 总收入 */
@property (nonatomic, strong) UILabel *allIncomeLabel;
/** 总支出 */
@property (nonatomic, strong) UILabel *allExpendLabel;
/** 总结余 */
@property (nonatomic, strong) UILabel *allBalanceLabel;
@end
@implementation TMSideHeaderView
#pragma mark - lazy loading
- (TMButton *)avatarBtn
{
    if (!_avatarBtn) {
        _avatarBtn = [TMButton new];
        _avatarBtn.layer.cornerRadius = 40/2;
        _avatarBtn.layer.masksToBounds = YES;
        [_avatarBtn setImage:[UIImage imageNamed:@"IMG_0852"] forState:UIControlStateNormal];
        [_avatarBtn addTarget:self action:@selector(clickAvatarBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarBtn;
}
- (UILabel *)nikeNameLabel
{
    if (!_nikeNameLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = LineColor;
        label.font = [UIFont systemFontOfSize:14.0f];
        
        _nikeNameLabel = label;
    }
    return _nikeNameLabel;
}
- (TMSideButton *)settingBtn
{
    if (!_settingBtn) {
        TMSideButton *button = [[TMSideButton alloc]init];
        [button setTitle:@"设置" forState:UIControlStateNormal];
        button.titleLabel.font = kFont;
        [button setImage:[UIImage imageNamed:@"menu_setting"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickSettingBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _settingBtn = button;
    }
    return _settingBtn;
}
- (TMSideButton *)synBtn
{
    if (!_synBtn) {
        TMSideButton *button = [[TMSideButton alloc]init];
        [button setTitle:@"同步" forState:UIControlStateNormal];
        button.titleLabel.font = kFont;
        [button setImage:[UIImage imageNamed:@"synchronize_default"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickSynBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _synBtn = button;
    }
    return _synBtn;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = LineColor;
    }
    return _lineView;
}

- (UILabel *)allIncomeLabel
{
    if (!_allIncomeLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = LineColor;
        label.font = kFont;
        label.numberOfLines = 2;
        
        _allIncomeLabel = label;
    }
    return _allIncomeLabel;
}
- (UILabel *)allExpendLabel
{
    if (!_allExpendLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = LineColor;
        label.font = kFont;
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentCenter;
        
        _allExpendLabel = label;
    }
    return _allExpendLabel;
}
- (UILabel *)allBalanceLabel
{
    if (!_allBalanceLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = LineColor;
        label.font = kFont;
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentRight;
        _allBalanceLabel = label;
    }
    return _allBalanceLabel;
}



#pragma mark - system Methods

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        WEAKSELF
        [self addSubview:self.avatarBtn];
        [self.avatarBtn makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(40, 40));
            make.top.equalTo(weakSelf).offset(kStatusBarHeight + 10);
            make.left.equalTo(weakSelf).offset(20);
        }];
        [self addSubview:self.nikeNameLabel];
        self.nikeNameLabel.text = @"LaiYoung_";
        [self.nikeNameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.width.lessThanOrEqualTo(100);
            make.centerY.equalTo(weakSelf.avatarBtn);
            make.left.equalTo(weakSelf.avatarBtn.right).offset(10);
        }];
        [self addSubview:self.settingBtn];
        [self.settingBtn makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(30, 40));
            make.centerY.equalTo(weakSelf.avatarBtn);
            make.right.equalTo(weakSelf).offset(-20);
        }];
        
        [self addSubview:self.synBtn];
        [self.synBtn makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(weakSelf.settingBtn);
            make.centerY.equalTo(weakSelf.avatarBtn);
            make.right.equalTo(weakSelf.settingBtn.left).offset(-10);
        }];
        [self addSubview:self.lineView];
        [self.lineView makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(SCREEN_SIZE.width);
            make.height.equalTo(0.5);
            make.top.equalTo(weakSelf.avatarBtn.bottom).offset(15);
        }];
        [self addSubview:self.allIncomeLabel];
       
        CGFloat width = SCREEN_SIZE.width - 50;
        [self.allIncomeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.width.lessThanOrEqualTo(width/3.5);
            make.left.equalTo(weakSelf.avatarBtn);
            make.top.equalTo(weakSelf.lineView.bottom).offset(15);
        }];
        [self addSubview:self.allExpendLabel];
        
        [self.allExpendLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.top.equalTo(weakSelf.allIncomeLabel);
            make.width.lessThanOrEqualTo(weakSelf.allIncomeLabel);
        }];
        [self addSubview:self.allBalanceLabel];
        [self.allBalanceLabel makeConstraints:^(MASConstraintMaker *make) {
            make.width.lessThanOrEqualTo(weakSelf.allIncomeLabel);
            make.right.equalTo(weakSelf.settingBtn);
            make.top.equalTo(weakSelf.allIncomeLabel);
        }];
    }
    return self;
}
#pragma mark - action
- (void)clickAvatarBtn:(UIButton *)sender {
    NSLog(@"click AvatarBtn");
}
- (void)clickSettingBtn:(TMSideButton *)sender {
    NSLog(@"click SettingBtn");
}
- (void)clickSynBtn:(TMSideButton *)sender {
    NSLog(@"click SynBtn");
}
- (void)reloadData {
    self.allExpendLabel.text = [NSString stringWithFormat:@"总支出\n%.2f",[TMCalculate queryAllIncomeOrExpendOfPaymentType:expend]];
    self.allBalanceLabel.text = [NSString stringWithFormat:@"总结余\n%.2f",[TMCalculate queryAmountOfPriceDifference]];
     self.allIncomeLabel.text = [NSString stringWithFormat:@"总收入\n%.2f",[TMCalculate queryAllIncomeOrExpendOfPaymentType:income]];

}
@end
