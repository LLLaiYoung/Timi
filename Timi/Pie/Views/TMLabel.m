//
//  TMLabel.m
//  Timi
//
//  Created by chairman on 16/6/7.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "TMLabel.h"

@implementation TMLabel

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    size.width += 5;
    return size;
}
@end
