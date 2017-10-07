//
//  UIImage+TMUIImage.m
//  Timi
//
//  Created by LaiYoung_ on 2017/10/7.
//  Copyright © 2017年 LaiYoung. All rights reserved.
//

#import "UIImage+TMUIImage.h"

@implementation UIImage (TMUIImage)

- (UIImage *)imageByResizeToSize:(CGSize)size {
    if (size.width <= 0 || size.height <= 0) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
