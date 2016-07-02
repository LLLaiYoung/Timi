//
//  TMPieView.h
//  Timi
//
//  Created by chairman on 16/5/21.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMPieView : UIView
/** 分组数据 */
@property (nonatomic, strong) NSArray *sections;
/** 分组数据对应颜色 */
@property (nonatomic, strong) NSArray *sectionColors;
/** 距离外layer间距 */
@property (nonatomic, assign) CGFloat spacing;      //Default == 6
/** 饼图线条宽*/
@property (nonatomic, assign) CGFloat lineWidth;    //Default == 8
/** 线边颜色 */
@property (nonatomic, strong) UIColor *animationStrokeColor; //Default whiteColor
/** 刷新数据 */
- (void)reloadDataCompletion:(void (^)())completion;
/** 获取layer的位置 */
- (NSInteger)getLayerIndexWithPoint:(CGPoint)point;
/** 消失动画 */
- (void)dismissAnimationByTimeInterval:(NSTimeInterval)time;
@end
