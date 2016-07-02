//
//  TMDetailViewCell.m
//  Timi
//
//  Created by chairman on 16/6/16.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//


//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import "TMDetailViewCell.h"
#import <Masonry.h>
#import "Const.h"
#import <YYText.h>
#import "TMBill.h"
#import "TMCategory.h"
#define kDetailViewTimePointWidth 10
#define kDetailViewCategoryImageViewWidth 20
#define kDetailViewContainerViewHeight 75
@interface TMDetailViewCell()
/** 灰线 */
@property (nonatomic, strong) UIView *lineView;
/** 时间点 */
@property (nonatomic, strong) UIView *timePointView;
/** 容器,存放类别图片和类别label */
@property (nonatomic, strong) UIView *containerCategoryImageAndLabelView;
/** 类别图片 */
@property (nonatomic, strong) UIImageView *categoryImageView;
/** 时间 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 类别名&金额 */
@property (nonatomic, strong) UILabel *categoryLabelAndMoneyLabel;
/** logo */
@property (nonatomic, strong) UIImageView *logoImageView;
/** 备注 */
@property (nonatomic, strong) YYLabel *remarkLabel;
/** 照片 */
@property (nonatomic, strong) UIImageView *pictureImageView;
/** 备注容器 */
@property (nonatomic, strong) UIView *containerRemarkLabelView;
@end

@implementation TMDetailViewCell
#pragma mark - lazy loading
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = LineColor;
    }
    return _lineView;
}
- (UIView *)timePointView
{
    if (!_timePointView) {
        _timePointView = [UIView new];
        _timePointView.backgroundColor = [UIColor redColor];
        _timePointView.layer.cornerRadius = kDetailViewTimePointWidth/2;
        //        _timePointView.layer.masksToBounds = YES;
    }
    return _timePointView;
}
- (UIView *)containerCategoryImageAndLabelView
{
    if (!_containerCategoryImageAndLabelView) {
        _containerCategoryImageAndLabelView = [UIView new];
        _timePointView.backgroundColor = [UIColor whiteColor];
    }
    return _containerCategoryImageAndLabelView;
}
- (UIImageView *)categoryImageView
{
    if (!_categoryImageView) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = kDetailViewCategoryImageViewWidth/2;
        //        imageView.layer.masksToBounds = YES;
        
        _categoryImageView = imageView;
    }
    return _categoryImageView;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = LineColor;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentRight;
        _timeLabel = label;
    }
    return _timeLabel;
}

- (UILabel *)categoryLabelAndMoneyLabel
{
    if (!_categoryLabelAndMoneyLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        _categoryLabelAndMoneyLabel = label;
    }
    return _categoryLabelAndMoneyLabel;
}
- (UIImageView *)logoImageView
{
    if (!_logoImageView) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"launch_title"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _logoImageView = imageView;
    }
    return _logoImageView;
}
- (YYLabel *)remarkLabel
{
    if (!_remarkLabel) {
        _remarkLabel = [YYLabel new];
        _remarkLabel.backgroundColor = [UIColor whiteColor];
        _remarkLabel.textColor = [UIColor colorWithWhite:0.232 alpha:1.000];
        _remarkLabel.numberOfLines = 3;
    }
    return _remarkLabel;
}
- (UIImageView *)pictureImageView
{
    if (!_pictureImageView) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.layer.borderWidth = 1.0;
        imageView.layer.borderColor = [UIColor colorWithWhite:0.689 alpha:1.000].CGColor;
        
        _pictureImageView = imageView;
    }
    return _pictureImageView;
}
- (UIView *)containerRemarkLabelView
{
    if (!_containerRemarkLabelView) {
        _containerRemarkLabelView = [UIView new];
    }
    return _containerRemarkLabelView;
}

#pragma mark - system Methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
   self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.timePointView];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.containerCategoryImageAndLabelView];
        [self.containerCategoryImageAndLabelView addSubview:self.categoryImageView];
        [self.containerCategoryImageAndLabelView addSubview:self.categoryLabelAndMoneyLabel];
        [self.contentView addSubview:self.logoImageView];
        [self.contentView addSubview:self.pictureImageView];
        [self.contentView addSubview:self.containerRemarkLabelView];
        self.containerRemarkLabelView.backgroundColor = [UIColor whiteColor];
        
        WEAKSELF
        [self.lineView makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(1.5, SCREEN_SIZE.height));
            make.centerX.equalTo(weakSelf.contentView);
            make.top.equalTo(weakSelf.contentView);
        }];
        
        self.containerCategoryImageAndLabelView.backgroundColor = [UIColor whiteColor];
        [self.containerCategoryImageAndLabelView makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(SCREEN_SIZE.width, kDetailViewContainerViewHeight));
            make.center.equalTo(weakSelf.contentView).priorityLow();
        }];
        
        self.categoryImageView.image = [UIImage imageNamed:@"type_big_1006"];
        [self.categoryImageView makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(40, 40));
            make.centerX.equalTo(weakSelf.containerCategoryImageAndLabelView);
            make.top.equalTo(weakSelf.containerCategoryImageAndLabelView).offset(5).priorityLow();
        }];
        self.categoryLabelAndMoneyLabel.text = @"用餐 4558.00";
        [self.categoryLabelAndMoneyLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.containerCategoryImageAndLabelView).priorityLow();
            make.bottom.equalTo(weakSelf.containerCategoryImageAndLabelView).offset(-5);
        }];
        
        self.timePointView.backgroundColor = LineColor;
        [self.timePointView makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(kDetailViewTimePointWidth, kDetailViewTimePointWidth));
            make.centerX.equalTo(weakSelf.contentView);
            make.centerY.equalTo(weakSelf.containerCategoryImageAndLabelView.top).offset(-15).priorityLow();
        }];
        
        
        self.timeLabel.text = @"31日";
        [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.timePointView).priorityLow();
            make.right.equalTo(weakSelf.timePointView.left).offset(-10);
        }];
        
        [self.logoImageView makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(88, 16));
            make.left.equalTo(weakSelf.contentView).offset(10);
            make.bottom.equalTo(weakSelf.contentView).offset(-10);
        }];

    }
    return self;
}
#pragma mark - updateConstraints

/** 修改时间点和类别图片&备注容器view的布局->顶部 */
- (void)updateTimePointAndContainerViewConstraints {
    WEAKSELF
    [self.timePointView remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(kDetailViewTimePointWidth, kDetailViewTimePointWidth));
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.contentView).offset(50);
    }];
    [self.containerCategoryImageAndLabelView remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(SCREEN_SIZE.width, kDetailViewContainerViewHeight));
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.timePointView.bottom).offset(15);
    }];
}
/** 修改备注照片的布局 */
- (void)updatePictureImageViewConstraintsWithHave:(BOOL)have {
    WEAKSELF
    /** 替换remarkLabel位置 */
    if (have) {
        [self.pictureImageView remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@250);
            make.bottom.equalTo(weakSelf.contentView).offset(-150);
            make.centerX.equalTo(weakSelf.contentView);
            make.top.equalTo(weakSelf.containerCategoryImageAndLabelView.bottom);
        }];
    } else {
        [self.pictureImageView remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
    }
}
/** 修改备注的布局 bottom ? 底部:中部 */
- (void)updateRemarkLabelConstraintsWithBottom:(BOOL)bottom {
    WEAKSELF
    if (bottom) {//底部
        [self.remarkLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.pictureImageView.bottom);
            make.size.equalTo(CGSizeMake(SCREEN_SIZE.width - 50, 65));
            make.centerX.equalTo(weakSelf.contentView);
        }];
        [self.containerRemarkLabelView remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
    } else {//中部
        [self.containerRemarkLabelView remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREEN_SIZE.width);
            make.top.equalTo(weakSelf.containerCategoryImageAndLabelView.bottom);
            make.bottom.equalTo(weakSelf).offset(-100);
        }];
        
        [self.remarkLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREEN_SIZE.width);
            make.height.equalTo(@250);
            make.center.equalTo(weakSelf.containerRemarkLabelView);
        }];
    }
}
/** 时间点原点 */
- (void)originTimePointAndContainerViewContraints {
    WEAKSELF
    [self.containerCategoryImageAndLabelView remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(SCREEN_SIZE.width, kDetailViewContainerViewHeight));
        make.center.equalTo(weakSelf.contentView);
    }];
    [self.timePointView remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(kDetailViewTimePointWidth, kDetailViewTimePointWidth));
        make.centerX.equalTo(weakSelf.contentView);
        make.centerY.equalTo(weakSelf.containerCategoryImageAndLabelView.top).offset(-15).priorityLow();
    }];
}
#pragma mark - setter

- (void)setDetailBill:(TMBill *)detailBill {
    _detailBill = detailBill;
    //* 当没有备注的时候应当移除,当有备注的时候则会被add */
    [self.remarkLabel removeFromSuperview];
    
    NSRange range = NSMakeRange(8, 2);
    self.timeLabel.text = [NSString stringWithFormat:@"%@日",[detailBill.dateStr substringWithRange:range]];
    self.categoryImageView.image = detailBill.category.categoryImage;
    self.categoryLabelAndMoneyLabel.text = [NSString stringWithFormat:@"%@ %.2f",detailBill.category.categoryTitle,detailBill.money.floatValue];
    
    if (_detailBill.remarkPhoto && _detailBill.reMarks.length>0) {
        [self.contentView addSubview:self.remarkLabel];
        self.remarkLabel.numberOfLines = 2;
        self.remarkLabel.textAlignment = NSTextAlignmentCenter;
        [self updateTimePointAndContainerViewConstraints];
        [self updatePictureImageViewConstraintsWithHave:YES];
        [self updateRemarkLabelConstraintsWithBottom:YES];
        self.pictureImageView.image = [UIImage imageWithData:detailBill.remarkPhoto];
        self.remarkLabel.text = detailBill.reMarks;
        return;
    }else if(_detailBill.remarkPhoto){
        self.pictureImageView.image = [UIImage imageWithData:detailBill.remarkPhoto];
        [self updateTimePointAndContainerViewConstraints];
        [self updatePictureImageViewConstraintsWithHave:YES];
        return;
    }else if (_detailBill.reMarks.length>0){
        [self.containerRemarkLabelView addSubview:self.remarkLabel];
        self.remarkLabel.textAlignment = NSTextAlignmentCenter;//无效
        //* 设置竖直排版 */
        self.remarkLabel.verticalForm = YES;
        self.remarkLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        [self updateTimePointAndContainerViewConstraints];
        [self updatePictureImageViewConstraintsWithHave:NO];
        [self updateRemarkLabelConstraintsWithBottom:NO];
        self.remarkLabel.text = detailBill.reMarks;
        return;
    }else{
        [self originTimePointAndContainerViewContraints];
        [self updatePictureImageViewConstraintsWithHave:NO];
        [self.containerRemarkLabelView remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
    }
}
-(void)prepareForReuse {
    [super prepareForReuse];
    self.detailBill = nil;
}

@end
