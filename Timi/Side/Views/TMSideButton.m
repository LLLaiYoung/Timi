//
//  TMSideButton.m
//  Timi
//
//  Created by chairman on 16/6/25.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "TMSideButton.h"
#import "Const.h"
@implementation TMSideButton

#define kImageWidth 52/2
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat x = (contentRect.size.width - kImageWidth)/2;
    return CGRectMake(x, 0, kImageWidth, kImageWidth);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleWidth = contentRect.size.width;
    CGFloat titleHeight = contentRect.size.height-kImageWidth;
    return CGRectMake(0, kImageWidth + 3, titleWidth, titleHeight);
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.textColor =LineColor;
        [self setTitleColor:LineColor forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
