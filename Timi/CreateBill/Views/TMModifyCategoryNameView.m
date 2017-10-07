//
//  TMModifyCategoryNameView.m
//  Timi
//
//  Created by chairman on 16/6/19.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "TMModifyCategoryNameView.h"
#import <Masonry/Masonry.h>
#import "Const.h"
#import "TMCategory.h"
#define kContainerViewWidth 50

@interface TMModifyCategoryNameView()
@property (nonatomic, strong) UIView *categoryContainerView;
@property (nonatomic, strong) UIImageView *categoryImageView;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@end

@implementation TMModifyCategoryNameView
- (UIView *)categoryContainerView
{
    if (!_categoryContainerView) {
        _categoryContainerView = [UIView new];
        _categoryContainerView.backgroundColor = [UIColor whiteColor];
        _categoryContainerView.layer.cornerRadius = kContainerViewWidth/2;
    }
    return _categoryContainerView;
}

- (UIImageView *)categoryImageView
{
    if (!_categoryImageView) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _categoryImageView = imageView;
    }
    return _categoryImageView;
}
- (UILabel *)categoryLabel
{
    if (!_categoryLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = LineColor;
        _categoryLabel = label;
    }
    return _categoryLabel;
}
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [UITextField new];
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.textColor = LineColor;
    }
    return _textField;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = LineColor;
    }
    return _lineView;
}
- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _cancelBtn = button;
    }
    return _cancelBtn;
}
- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickSureBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _sureBtn = button;
    }
    return _sureBtn;
}





- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        [self addSubview:self.categoryContainerView];
        [self.categoryContainerView addSubview:self.categoryImageView];
        [self addSubview:self.categoryLabel];
        [self addSubview:self.textField];
        [self addSubview:self.lineView];
        [self addSubview:self.cancelBtn];
        [self addSubview:self.sureBtn];
        WEAKSELF
        [self.categoryContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.mas_top);
            make.centerX.equalTo(weakSelf);
            make.size.mas_equalTo(CGSizeMake(kContainerViewWidth, kContainerViewWidth));
        }];
        
        self.categoryImageView.image = [UIImage imageNamed:@"type_big_2"];
        [self.categoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(2, 2, 2, 2));
        }];
        self.categoryLabel.text = @"服饰";
        [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.top.equalTo(weakSelf).offset(30.5);
        }];
        self.textField.placeholder = @"服饰";
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 20));
            make.center.equalTo(weakSelf);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 1));
            make.top.equalTo(weakSelf.textField.mas_bottom).offset(1);
            make.centerX.equalTo(weakSelf.textField);
        }];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(20);
            make.bottom.equalTo(weakSelf).offset(-5);
        }];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf).offset(-20);
            make.bottom.equalTo(weakSelf.cancelBtn);
        }];
        
    }
    return self;
}

#pragma mark - action
- (void)clickCancelBtn:(UIButton *)sender {
    NSLog(@"clickCancelBtn");
    [self.textField resignFirstResponder];
    [self.superview.superview sendSubviewToBack:self.superview];
    self.superview.backgroundColor = [UIColor clearColor];
}

- (void)clickSureBtn:(UIButton *)sender {
    NSLog(@"clickSureBtn");
    if (self.clickSureBtn) {
        self.clickSureBtn();
    }
    [self clickCancelBtn:sender];
}

#pragma mark - setter
- (void)setCategory:(TMCategory *)category {
    _category = category;
    self.categoryImageView.image = category.categoryImage;
    self.textField.placeholder = category.categoryTitle;
    self.categoryLabel.text = category.categoryTitle;
    
}
#pragma mark - getter
- (NSString *)categoryName
{
    return _textField.text;
}


- (void)becomeFirstResponder {
    [self.textField becomeFirstResponder];
}

@end
