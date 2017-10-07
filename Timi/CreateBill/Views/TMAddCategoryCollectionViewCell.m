//
//  TMAddCategoryCollectionViewCell.m
//  Timi
//
//  Created by chairman on 16/6/22.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "TMAddCategoryCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "Const.h"

@implementation TMAddCategoryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [UIImageView new];
        [self.contentView addSubview:self.imageView];
        WEAKSELF
//        [self.imageView makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(weakSelf.contentView);
//        }];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.contentView);
        }];
    }
    return self;
}

@end
