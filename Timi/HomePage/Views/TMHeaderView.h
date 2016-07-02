//
//  TMHeaderView.h
//  Timi
//
//  Created by chairman on 16/5/21.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TMHeaderViewDelegate <NSObject>
@required
@optional
//* 点击了饼图内的创建按钮 */
- (void)didClickPieInCreateBtn;

@end

@interface TMHeaderView : UIView
@property (nonatomic, weak) id<TMHeaderViewDelegate> headerViewDelegate;
- (void)calculateMoney;
/**
 *  加载饼图
 *
 *  @param sections 数据组(一共多少)
 *  @param colors   数据组对应的颜色
 */
- (void)loadPieViewWihtSection:(NSArray *)sections withColors:(NSArray *)colors;
/** 创建按钮的动画 */
- (void)animationWithCreateBtnDuration:(NSTimeInterval)time angle:(CGFloat)angle;
@end
