//
//  TMCalculatorView.h
//  Timi
//
//  Created by chairman on 16/5/26.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMCalculatorView : UIView
/** 传递输入的值 */
@property (nonatomic, copy) void (^passValuesBlock)(NSString *string);
/** 点击时间选择器按钮 */
@property (nonatomic, copy) void (^didClickDateBtnBlock)();
/** 保存 */
@property (nonatomic, copy) void (^didClickSaveBtnBlock)();
/** 点击备注 */
@property (nonatomic, copy) void (^didClickRemarkBtnBlock)();
/** 设置时间 */
- (void)setTimeWtihTimeString:(NSString *)timeString;
@end
