//
//  TMCategotyCollectionViewCell.m
//  Timi
//
//  Created by chairman on 16/5/26.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "TMCategotyCollectionViewCell.h"
#import <Masonry.h>
#import "Const.h"
#import "TMCategory.h"

@interface TMCategotyCollectionViewCell()

@property (nonatomic, strong) UILabel *categotyName;
@end
@implementation TMCategotyCollectionViewCell
- (UIImageView *)categoryImageView
{
    if (!_categoryImageView) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _categoryImageView = imageView;
    }
    return _categoryImageView;
}
- (UILabel *)categotyName
{
    if (!_categotyName) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentCenter;
        
        _categotyName = label;
    }
    return _categotyName;
}
#pragma mark - system Methods

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        WEAKSELF
        [self.contentView addSubview:self.categoryImageView];
        [self.categoryImageView makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(kCollectionCellWidth-20, kCollectionCellWidth-20));
            make.centerX.equalTo(weakSelf);
            make.top.equalTo(weakSelf).offset(5);
        }];
        [self.contentView addSubview:self.categotyName];
        [self.categotyName makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf.categoryImageView);
            make.height.mas_equalTo(20);
            make.top.equalTo(weakSelf.categoryImageView.bottom).offset(5);
            make.centerX.equalTo(weakSelf);
        }];
    }
    return self;
}
#pragma mark - setter

- (void)setCategoty:(TMCategory *)categoty {
    self.categoryImageView.image = categoty.categoryImage;
    self.categotyName.text = categoty.categoryTitle;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.categoty = nil;
    self.categotyName.text = nil;
    self.categoryImageView.image = nil;
}
@end
