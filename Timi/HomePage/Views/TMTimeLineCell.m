//
//  TMTimeLineCell.m
//  Timi
//
//  Created by chairman on 16/5/18.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "TMTimeLineCell.h"
#import "Const.h"
#import <Masonry.h>
#import "TMBill.h"
#import "TMCategory.h"
#import "TMCalculate.h"
#import "TMCategoryButton.h"
#import "TMBooks.h"
/** 金额label的宽度 */
//* 30 = categoryImageBtnWidth | 50 = CategoryNameLabelWidth | 5 = moneyLabel距离categoryLabel */
#define kMoneyLabelWidth (SCREEN_SIZE.width - kTimeLineBtnWidth) / 2 - 30 - 10
/** 类别按钮的大小 */
#define kCategoryNameLabelSize CGSizeMake(30, 25)
/** 剩余宽度 30->类别按钮 5->偏移量*/
#define kRemainingWidth kBlankWidth + 30 + 5 + 5

#define kRemarkFont 10.0f

#define kMoneyFont 14.0f

#define kPhotoWidth 35

/** 时光轴SectionHeaderView 小点的Width */
#define kTimePointViewWidth 6

#define kTextFont 12.0f


@interface TMTimeLineCell()
/** 点 */
@property (nonatomic, strong) UIView *timePointView;
/** 时间 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 金额 */
@property (nonatomic, strong) UILabel *moneyLabel;
/** 线条 */
@property (nonatomic, strong) UIView *lineView;
/** 左边类别名称 */
@property (nonatomic, strong) UILabel *leftCategoryNameLabel;
/** 左边金额 */
@property (nonatomic, strong) UILabel *leftMoneyLabel;
/** 左边备注 */
@property (nonatomic, strong) UILabel *leftRemarkLabel;
/** 左边备注照片 相反 */
@property (nonatomic, strong) UIButton *leftRemarkPhotoBtn;
/** 右边类别名称 */
@property (nonatomic, strong) UILabel *rightCategoryNameLabel;
/** 右边金额 */
@property (nonatomic, strong) UILabel *rightMoneyLabel;
/** 右边容器 放类别和金额 */
//@property (nonatomic, strong) UIView *rightContaierView;
/** 右边备注 */
@property (nonatomic, strong) UILabel *rightRemarkLabel;
/** 右边备注照片 */
@property (nonatomic, strong) UIButton *rightRemarkPhotoBtn;

@end

@implementation TMTimeLineCell
#pragma mark - lazy loading
- (UIView *)timePointView
{
    if (!_timePointView) {
        _timePointView = [UIView new];
        _timePointView.backgroundColor = LineColor;
        _timePointView.layer.cornerRadius = kTimePointViewWidth/2;
        //        _timePointView.layer.masksToBounds = YES;
    }
    return _timePointView;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = LineColor;
        label.font = [UIFont systemFontOfSize:kTextFont];
        label.textAlignment = NSTextAlignmentRight;
        
        _timeLabel = label;
    }
    return _timeLabel;
}
- (UILabel *)moneyLabel
{
    if (!_moneyLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = LineColor;
        label.font = [UIFont systemFontOfSize:kTextFont];
        _moneyLabel = label;
    }
    return _moneyLabel;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = LineColor;
    }
    return _lineView;
}

- (TMCategoryButton *)categoryImageBtn
{
    if (!_categoryImageBtn) {
        TMCategoryButton *button = [[TMCategoryButton alloc]init];
        [button addTarget:self action:@selector(clickCategoryBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _categoryImageBtn = button;
    }
    return _categoryImageBtn;
}

- (UILabel *)leftCategoryNameLabel
{
    if (!_leftCategoryNameLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:kMoneyFont];
        label.textAlignment = NSTextAlignmentRight;
        [self setContentPriorityWithLabel:label];
        _leftCategoryNameLabel = label;
    }
    return _leftCategoryNameLabel;
}

- (UILabel *)leftMoneyLabel
{
    if (!_leftMoneyLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = LineColor;
        label.font = [UIFont systemFontOfSize:kMoneyFont];
        label.textAlignment = NSTextAlignmentRight;
        [self setContentPriorityWithLabel:label];
        _leftMoneyLabel = label;
    }
    return _leftMoneyLabel;
}
- (UILabel *)leftRemarkLabel
{
    if (!_leftRemarkLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = LineColor;
        label.font = [UIFont systemFontOfSize:kRemarkFont];
        label.textAlignment = NSTextAlignmentRight;
        [self setContentPriorityWithLabel:label];
        _leftRemarkLabel = label;
    }
    return _leftRemarkLabel;
}
- (UIButton *)leftRemarkPhotoBtn
{
    if (!_leftRemarkPhotoBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button addTarget:self action:@selector(clickLeftRemarkPhotoBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _leftRemarkPhotoBtn = button;
    }
    return _leftRemarkPhotoBtn;
}

- (UILabel *)rightCategoryNameLabel
{
    if (!_rightCategoryNameLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:kMoneyFont];
        label.textAlignment = NSTextAlignmentLeft;
        [self setContentPriorityWithLabel:label];
        _rightCategoryNameLabel = label;
    }
    return _rightCategoryNameLabel;
}

- (UILabel *)rightMoneyLabel
{
    if (!_rightMoneyLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = LineColor;
        label.font = [UIFont systemFontOfSize:kMoneyFont];
        label.textAlignment = NSTextAlignmentLeft;
        [self setContentPriorityWithLabel:label];
        _rightMoneyLabel = label;
    }
    return _rightMoneyLabel;
}
- (UILabel *)rightRemarkLabel
{
    if (!_rightRemarkLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = LineColor;
        label.font = [UIFont systemFontOfSize:kRemarkFont];
        [self setContentPriorityWithLabel:label];
        _rightRemarkLabel = label;
    }
    return _rightRemarkLabel;
}
- (UIButton *)rightRemarkPhotoBtn
{
    if (!_rightRemarkPhotoBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button addTarget:self action:@selector(clickRightRemarkPhotoBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _rightRemarkPhotoBtn = button;
    }
    return _rightRemarkPhotoBtn;
}


#pragma mark -
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
#warning 这里的cell的height是44,需要在layoutSubviews里面获取
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //* label可以不用设置size,label会根据内容调用系统(intrinsicContentSize)计算的值 */
        /*
         make.trailing.equalTo(weakSelf.leftCategoryNameLabel)
         默认与leftCategoryNameLabel的trailing对齐
         */
        WEAKSELF
        //* --------------------------华丽的分割线----------------------------- */
        [self.contentView addSubview:self.timePointView];
        [self.timePointView makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(kTimePointViewWidth, kTimePointViewWidth));
            make.centerX.equalTo(weakSelf.contentView);
            make.top.equalTo(9);
        }];
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.timePointView);
            make.right.equalTo(weakSelf.timePointView.left).offset(-3);
        }];
        [self.contentView addSubview:self.moneyLabel];
        [self.moneyLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.timePointView);
            make.left.equalTo(weakSelf.timePointView.right).offset(3);
        }];
        //* --------------------------华丽的分割线----------------------------- */
        
        [self.contentView addSubview:self.lineView];
        self.lineView.frame = CGRectMake((SCREEN_SIZE.width - 1)/2, 0, 1, self.contentView.bounds.size.height);
        
        [self.contentView addSubview:self.categoryImageBtn];
        [self.categoryImageBtn makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(kTimeLineBtnWidth + 10, kTimeLineBtnWidth + 10));
            make.centerX.equalTo(weakSelf.contentView);
            make.bottom.equalTo(weakSelf.contentView);
        }];
        
        [self.contentView addSubview:self.leftCategoryNameLabel];
        [self.leftCategoryNameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(weakSelf.categoryImageBtn.leading).mas_offset(-5);
            make.centerY.equalTo(weakSelf.categoryImageBtn);
        }];
        
        
        [self.contentView addSubview:self.leftMoneyLabel];
        [self.leftMoneyLabel makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(weakSelf.leftCategoryNameLabel.leading).offset(-3);
            make.top.equalTo(weakSelf.leftCategoryNameLabel);
        }];
        
        [self.contentView addSubview:self.leftRemarkLabel];
        [self.leftRemarkLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.leftCategoryNameLabel.bottom);
            make.right.equalTo(weakSelf.leftCategoryNameLabel);
            make.left.equalTo(weakSelf);
            
        }];
        
        [self.contentView addSubview:self.leftRemarkPhotoBtn];
        [self.leftRemarkPhotoBtn makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(kPhotoWidth, kPhotoWidth));
            make.right.equalTo(weakSelf.categoryImageBtn.left).offset(-5);
            make.centerY.equalTo(weakSelf.categoryImageBtn);
        }];
        
        [self.contentView addSubview:self.rightCategoryNameLabel];
        [self.rightCategoryNameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.categoryImageBtn.trailing).offset(5);
            make.centerY.equalTo(weakSelf.categoryImageBtn);
        }];
        
        [self.contentView addSubview:self.rightMoneyLabel];
        [self.rightMoneyLabel makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.rightCategoryNameLabel.trailing).offset(5);
            make.top.equalTo(weakSelf.rightCategoryNameLabel);
        }];
        
        [self.contentView addSubview:self.rightRemarkLabel];
        [self.rightRemarkLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.rightCategoryNameLabel.bottom);
            make.left.equalTo(weakSelf.rightCategoryNameLabel);
            make.right.equalTo(weakSelf);
        }];
        
        [self.contentView addSubview:self.rightRemarkPhotoBtn];
        [self.rightRemarkPhotoBtn makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(weakSelf.leftRemarkPhotoBtn);
            make.left.equalTo(weakSelf.categoryImageBtn.right).offset(5);
            make.centerY.equalTo(weakSelf.categoryImageBtn);
        }];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    if (!self.isLastBill) {
        self.lineView.frame = CGRectMake((SCREEN_SIZE.width - 1)/2, 0, 1, self.contentView.bounds.size.height);
    } else {
        self.lineView.frame = CGRectMake((SCREEN_SIZE.width - 1)/2, 0, 1, self.contentView.bounds.size.height-5);
    }
    if (_timeLineBill.isEmpty) {
        self.lineView.frame = CGRectMake((SCREEN_SIZE.width - 1)/2, 0, 1, 9);
    }
}
//* 设置label的内容优先级 */
- (void)setContentPriorityWithLabel:(UILabel *)label {
    //* 设置不被压缩 */
    [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    //* 设置不被拉宽 */
    [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}
#pragma mark - action 
- (void)clickCategoryBtn:(UIButton *)sender {
    if ([self.cellDeletega respondsToSelector:@selector(didClickCategoryBtnWithIndexPath:)]) {
        [self.cellDeletega didClickCategoryBtnWithIndexPath:self.indexPath];
    }
}
- (void)clickLeftRemarkPhotoBtn:(UIButton *)sender {
    NSLog(@"click LeftRemarkPhotoBtn");
}
- (void)clickRightRemarkPhotoBtn:(UIButton *)sender {
    NSLog(@"click RightRemarkPhotoBtn");
}
- (void)cellLabelWithHidden:(BOOL)hidden {
    WEAKSELF
    [UIView animateWithDuration:kAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{

        weakSelf.leftCategoryNameLabel.hidden = hidden;
        weakSelf.leftMoneyLabel.hidden = hidden;
        weakSelf.rightCategoryNameLabel.hidden = hidden;
        weakSelf.rightMoneyLabel.hidden = hidden;
        weakSelf.leftRemarkLabel.hidden = hidden;
        weakSelf.rightRemarkLabel.hidden = hidden;
        if (weakSelf.clickedDelete) {//点击了删除之后不许对remarkPhtotBtn的hidden进行设置
            weakSelf.clickedDelete = NO;
            _timeLineBill = nil;//当这个对象被删除之后,不置为nil则会报错。
            return ;
        } else {
            NSLog(@"timeBill = %@",_timeLineBill);
            if (_timeLineBill.remarkPhoto) {
                if (_timeLineBill.isIncome.boolValue) {
                    if (weakSelf.rightRemarkPhotoBtn.isHidden) {
                        weakSelf.rightRemarkPhotoBtn.hidden = NO;
                    } else {
                        weakSelf.rightRemarkPhotoBtn.hidden = YES;
                    }
                } else {
                    if (weakSelf.leftRemarkPhotoBtn.isHidden) {
                        weakSelf.leftRemarkPhotoBtn.hidden = NO;
                    } else {
                        weakSelf.leftRemarkPhotoBtn.hidden = YES;
                    }
                }
            }
        }
        
    } completion:^(BOOL finished) {
        
    }];
}
- (void)hiddenTwoRemarkPhoto:(BOOL)hidden {
    self.leftRemarkPhotoBtn.hidden = hidden;
    self.rightRemarkPhotoBtn.hidden = hidden;
}

- (void)setTimeLineBill:(TMBill *)timeLineBill {
    if (!timeLineBill) {
        return;
    }
    _timeLineBill = timeLineBill;
    self.timeLabel.text = _timeLineBill.dateStr;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",[TMCalculate queryDayAllExpendWithBookID:_timeLineBill.books.booksID andDateString:_timeLineBill.dateStr]];
    
    [self hiddenTwoRemarkPhoto:YES];
    [self.leftRemarkPhotoBtn setImage:nil forState:UIControlStateNormal];
    [self.rightRemarkPhotoBtn setImage:nil forState:UIControlStateNormal];
    
    if (_timeLineBill.category.categoryImage) {
        [self.categoryImageBtn setImage:_timeLineBill.category.categoryImage forState:UIControlStateNormal] ;
    }
    UIImage *image = [UIImage imageWithData:_timeLineBill.remarkPhoto];
    
    if (_timeLineBill.isEmpty) {
        [self.categoryImageBtn setImage:nil forState:UIControlStateNormal];
        [self hiddenTwoRemarkPhoto:YES];
        return;
    }
    if (_timeLineBill.isIncome.boolValue) {//收入
        self.leftMoneyLabel.text = [NSString stringWithFormat:@"%.2f",_timeLineBill.money.floatValue];
        self.leftCategoryNameLabel.text = _timeLineBill.category.categoryTitle;
        self.leftRemarkLabel.text = _timeLineBill.reMarks;
        if (_timeLineBill.remarkPhoto) {
            self.rightRemarkPhotoBtn.hidden = NO;
            [self.rightRemarkPhotoBtn setImage:image forState:UIControlStateNormal];
        }
    } else {
        self.rightCategoryNameLabel.text = _timeLineBill.category.categoryTitle;
        self.rightMoneyLabel.text = [NSString stringWithFormat:@"%.2f",_timeLineBill.money.floatValue];
        self.rightRemarkLabel.text = _timeLineBill.reMarks;
        if (_timeLineBill.remarkPhoto) {
            self.leftRemarkPhotoBtn.hidden = NO;
            [self.leftRemarkPhotoBtn setImage:image forState:UIControlStateNormal];
        }
    }

    _timeLineBill.isSame ? [self hiddenUIControl:YES] : [self hiddenUIControl:NO];

}
- (void)hiddenUIControl:(BOOL)hidden {
    self.timeLabel.hidden = hidden;
    self.timePointView.hidden = hidden;
    self.moneyLabel.hidden = hidden;
}
//* 准备重用,防止滚动出现数据错乱 */
- (void)prepareForReuse {
    [super prepareForReuse];
    self.timeLineBill = nil;
    self.categoryImageBtn.imageView.image = nil;
    self.leftCategoryNameLabel.text = nil;
    self.leftMoneyLabel.text = nil;
    self.leftRemarkLabel.text = nil;
    self.rightCategoryNameLabel.text = nil;
    self.rightMoneyLabel.text = nil;
    self.rightRemarkLabel.text = nil;
    self.lastBill = NO;
}
- (void)dealloc {
    self.timeLineBill = nil;
}
@end
