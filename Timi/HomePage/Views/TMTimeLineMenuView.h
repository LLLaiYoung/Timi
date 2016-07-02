//
//  TMTimeLineMenuView.h
//  Timi
//
//  Created by chairman on 16/5/20.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TMTimeLineCell;
@protocol TMTimeLineMenuViewDelegate <NSObject>
@required
/** 隐藏cell的label */
- (void)hiddenCellLabelWithBool:(BOOL)hidden;
- (void)clickDeleteBtn;
- (void)clickUpdateBtn;
@optional

@end
@interface TMTimeLineMenuView : UIView
@property (nonatomic, weak) id<TMTimeLineMenuViewDelegate> timeLineMenuDelegate;
@property (nonatomic, strong) UIImage *currentImage;
- (void)showTimeLineMenuViewWithRect:(CGRect)receiveRect;
- (void)dismiss;
@end
