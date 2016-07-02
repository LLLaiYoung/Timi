//
//  TMSideCell.m
//  Timi
//
//  Created by chairman on 16/6/26.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import "TMSideCell.h"
#import <Masonry.h>
#import "Const.h"
#import "TMBooks.h"
#import "NSString+TMNSString.h"
#import "TMDataBaseManager.h"
@interface TMSideCell()
/** 背景图 */
@property (nonatomic, strong) UIImageView *bgImageView;
/** 账本名称 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 笔数 */
@property (nonatomic, strong) UILabel *countLabel;


@end
@implementation TMSideCell
- (UIImageView *)selectedItemImageView
{
    if (!_selectedItemImageView) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"menu_selected_icon"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _selectedItemImageView = imageView;
    }
    return _selectedItemImageView;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 2;
        _nameLabel = label;
    }
    return _nameLabel;
}
- (UILabel *)countLabel
{
    if (!_countLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:10.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 2;
        _countLabel = label;
    }
    return _countLabel;
}
- (UIImageView *)editSelectedItemImageView
{
    if (!_editSelectedItemImageView) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"book_check"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _editSelectedItemImageView = imageView;
    }
    return _editSelectedItemImageView;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        WEAKSELF
        self.bgImageView = [UIImageView new];
        self.bgImageView.image = [UIImage imageNamed:@"book_cover_0"];
        [self.contentView addSubview:self.bgImageView];
        [self.bgImageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.contentView);
        }];
        [self.contentView addSubview:self.selectedItemImageView];
        [self.selectedItemImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.bgImageView);
            make.left.equalTo(weakSelf.bgImageView).offset(5);
        }];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.bgImageView).offset(40);
            make.centerX.equalTo(weakSelf.bgImageView);
        }];
        [self.contentView addSubview:self.countLabel];
        [self.countLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.bgImageView).offset(-10);
            make.right.equalTo(weakSelf.bgImageView).equalTo(-5);
        }];
        [self.contentView addSubview:self.editSelectedItemImageView];
        [self.editSelectedItemImageView makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(25, 25));
            make.center.equalTo(weakSelf.contentView).centerOffset(CGPointMake(0, 10));
        }];
        self.editSelectedItemImageView.hidden = YES;
        
        //* 长按手势 */
        UILongPressGestureRecognizer *longGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGR:)];
        longGR.minimumPressDuration = 1.0;
        longGR.numberOfTouchesRequired = 1;
        longGR.allowableMovement = 10;
        [self addGestureRecognizer:longGR];
    }
    return self;
}

#pragma mark - action
/** 持续响应事件－>手指移动 */
- (void)longGR:(UILongPressGestureRecognizer *)longPress {
    NSLog(@"longGR");
    if (self.sideCellDelegate && [self.sideCellDelegate respondsToSelector:@selector(TMSideCellWithIndexPath:withLongPress:)]) {
        [self.sideCellDelegate TMSideCellWithIndexPath:self.indexPath withLongPress:longPress];
    }
}


#pragma mark - setter

- (void)setBook:(TMBooks *)book {
    _book = book;
    self.bgImageView.image = book.bookImage;
    self.nameLabel.text = book.bookName;
    NSUInteger count = [[TMDataBaseManager defaultManager] numberOfAllBillCountWithBookID:book.booksID];
    self.countLabel.text =  [NSString stringWithFormat:@"%lu笔",count];
}


@end
