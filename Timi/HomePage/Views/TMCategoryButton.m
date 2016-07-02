//
//  TMCategoryButton.m
//  Timi
//
//  Created by chairman on 16/6/26.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "TMCategoryButton.h"
#import "Const.h"
@implementation TMCategoryButton
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat x = (contentRect.size.width - kTimeLineBtnWidth)/2;
    CGFloat y = (contentRect.size.height - kTimeLineBtnWidth)/2;
    return CGRectMake(x, y, kTimeLineBtnWidth, kTimeLineBtnWidth);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
