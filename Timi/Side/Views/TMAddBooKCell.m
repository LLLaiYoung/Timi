//
//  TMAddBooKCell.m
//  Timi
//
//  Created by chairman on 16/6/28.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "TMAddBooKCell.h"
#import <Masonry.h>
#import "Const.h"
@interface TMAddBooKCell()

@end
@implementation TMAddBooKCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [UIImageView new];
        self.imageView.image = [UIImage imageNamed:@"book_cover_0"];
        [self.contentView addSubview:self.imageView];
        WEAKSELF
        [self.imageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.contentView);
        }];
        self.selectedImageView = [UIImageView new];
        self.selectedImageView.image = [UIImage imageNamed:@"menu_selected_icon"];
        [self.contentView addSubview:self.selectedImageView];
        [self.selectedImageView makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(10, 20));
            make.top.equalTo(weakSelf.contentView);
            make.left.equalTo(weakSelf.contentView).offset(5);
        }];
    }
    return self;
}
@end
