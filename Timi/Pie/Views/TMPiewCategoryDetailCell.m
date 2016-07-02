//
//  TMPiewCategoryDetailCell.m
//  Timi
//
//  Created by chairman on 16/6/23.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "TMPiewCategoryDetailCell.h"
#import "Const.h"
#import <Masonry.h>
#import "TMBill.h"
#import "TMCategory.h"
#import "NSString+TMNSString.h"

#define kSmallFont  [UIFont systemFontOfSize:10.0f]

#define kPointViewWidth 5

@interface TMPiewCategoryDetailCell()
/** 竖 */
@property (nonatomic, strong) UIView *lineView;
/** 点 */
@property (nonatomic, strong) UIView *pointView;
/** 横 */
@property (nonatomic, strong) UIView *smallLineView;
/** 类别名称和金额 */
@property (nonatomic, strong) UILabel *categoryName_moneyLabel;
/** 日 */
@property (nonatomic, strong) UILabel *dayLabel;
/** 年月 */
@property (nonatomic, strong) UILabel *year_monthLabel;
/** 数字 */
@property (nonatomic, strong) UILabel *numberLabel;
/** 备注 */
@property (nonatomic, strong) UILabel *remarkLabel;

@end

@implementation TMPiewCategoryDetailCell

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = LineColor;
    }
    return _lineView;
}
- (UIView *)pointView
{
    if (!_pointView) {
        _pointView = [UIView new];
        _pointView.backgroundColor = LineColor;
        _pointView.layer.cornerRadius = kPointViewWidth/2;
    }
    return _pointView;
}
- (UIView *)smallLineView
{
    if (!_smallLineView) {
        _smallLineView = [UIView new];
        _smallLineView.backgroundColor = LineColor;
    }
    return _smallLineView;
}
- (UILabel *)categoryName_moneyLabel
{
    if (!_categoryName_moneyLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:22.0f];
        
        
        _categoryName_moneyLabel = label;
    }
    return _categoryName_moneyLabel;
}
- (UILabel *)dayLabel
{
    if (!_dayLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = LineColor;
        label.font = kSmallFont;
        label.text = @"日";
        
        _dayLabel = label;
    }
    return _dayLabel;
}
- (UILabel *)year_monthLabel
{
    if (!_year_monthLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = LineColor;
        label.font = kSmallFont;
        
        _year_monthLabel = label;
    }
    return _year_monthLabel;
}
- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:22.0f];
        
        _numberLabel = label;
    }
    return _numberLabel;
}

- (UILabel *)remarkLabel
{
    if (!_remarkLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = LineColor;
        label.font = kSmallFont;
        
        _remarkLabel = label;
    }
    return _remarkLabel;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        WEAKSELF
        [self.contentView addSubview:self.lineView];
        
        [self.contentView addSubview:self.pointView];
        [self.pointView makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf.contentView);
            make.size.equalTo(CGSizeMake(kPointViewWidth, kPointViewWidth));
        }];
        
        [self.contentView addSubview:self.smallLineView];
        [self.smallLineView makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(5, 1));
            make.top.equalTo(weakSelf.contentView).offset(5);
            make.right.equalTo(weakSelf.lineView.left);
        }];
        
        [self.contentView addSubview:self.categoryName_moneyLabel];
        [self.categoryName_moneyLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.lineView.left).offset(10.5);
            make.height.equalTo(30);
            make.right.lessThanOrEqualTo(weakSelf.contentView);
            make.centerY.equalTo(weakSelf.contentView);
        }];
        
        [self.contentView addSubview:self.dayLabel];
        [self.dayLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView.centerY);
            make.right.equalTo(weakSelf.lineView.left).offset(-20);
        }];
        
        [self.contentView addSubview:self.year_monthLabel];
        [self.year_monthLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView);
            make.right.equalTo(weakSelf.smallLineView.left).offset(-5);
            make.height.equalTo(12);
        }];
        
        [self.contentView addSubview:self.numberLabel];
        [self.numberLabel makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(weakSelf.categoryName_moneyLabel);
            make.top.equalTo(weakSelf.year_monthLabel.bottom);
            make.right.equalTo(weakSelf.dayLabel.left).offset(-5);
        }];
        
        [self.contentView addSubview:self.remarkLabel];
        [self.remarkLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.categoryName_moneyLabel.bottom);
            make.left.equalTo(weakSelf.categoryName_moneyLabel);
            make.right.lessThanOrEqualTo(weakSelf.contentView);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    WEAKSELF
    [self.lineView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView);
        make.size.equalTo(CGSizeMake(1, weakSelf.contentView.bounds.size.height));
    }];
}

- (void)setBill:(TMBill *)bill {
    _bill = bill;
    self.year_monthLabel.text = [NSString tm_conversionYearMonthWithDateStr:_bill.dateStr];
    NSString *numer = [bill.dateStr substringFromIndex:8];
    self.numberLabel.text = [NSString stringWithFormat:@"%li",numer.integerValue];
    NSMutableAttributedString *categoryString = [[NSMutableAttributedString alloc] initWithString:bill.category.categoryTitle attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor colorWithWhite:0.203 alpha:1.000]}];
    NSMutableAttributedString *moneyString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",bill.money.floatValue] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor colorWithWhite:0.742 alpha:1.000]}];
    [categoryString appendAttributedString:moneyString];
    self.categoryName_moneyLabel.attributedText = categoryString;
    self.remarkLabel.text = bill.reMarks;
    if (bill.isSame) {
        [self hiddenThreeUIView:YES];
    }
    if (bill.isPartSame) {
        [self hiddenYearLabel:YES];
    }
    
    //* --------------------------❌----------------------------- */
//    if ([previousDateStr isEqualToString:_bill.dateStr]) {//完全一样
//        [self hiddenThreeUIView:YES];
//        previousDateStr = _bill.dateStr;
//        return;
//    } else if ([[previousDateStr substringToIndex:7] isEqualToString:[_bill.dateStr substringToIndex:7]]) {
//        [self hiddenYearLabel:YES];
//        previousDateStr = _bill.dateStr;
//        return;
//    } else {
//        [self hiddenYearLabel:NO];
//        [self hiddenYearLabel:NO];
//    }
//    previousDateStr = _bill.dateStr;
}
- (void)hiddenThreeUIView:(BOOL)hidden {
    self.year_monthLabel.hidden = hidden;
    self.dayLabel.hidden = hidden;
    self.numberLabel.hidden = hidden;
    self.smallLineView.hidden = hidden;
}
- (void)hiddenYearLabel:(BOOL)hidden {
    self.year_monthLabel.hidden = hidden;
    self.smallLineView.hidden = hidden;
}
- (void)prepareForReuse {
    [super prepareForReuse];
    self.categoryName_moneyLabel.text = nil;
    self.year_monthLabel.text = nil;
    self.remarkLabel.text = nil;
    self.numberLabel.text = nil;
}

@end
