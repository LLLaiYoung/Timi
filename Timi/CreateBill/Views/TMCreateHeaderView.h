//
//  TMCreateHeaderView.h
//  Timi
//
//  Created by chairman on 16/5/25.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMCreateHeaderView : UIView
@property (nonatomic, copy) void(^clickCategoryName)();
/**
 *  修改headerView的类别图片和类别名
 *  @param imageFieleName 类别图片文件名
 *  @param categoryName   类别名称
 */
- (void)categoryImageWithFileName:(NSString *)imageFieleName andCategoryName:(NSString *)categoryName;
- (void)updateMoney:(NSString *)money;
/** 背景颜色动画 */
- (void)animationWithBgColor:(UIColor *)color;
/** 金额摇晃 */
- (void)shakingAnimation;
@end
