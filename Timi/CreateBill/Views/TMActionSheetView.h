//
//  TMActionSheetView.h
//  Timi
//
//  Created by chairman on 16/6/2.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMActionSheetView : UIView
@property (nonatomic, copy) void (^cancelBtnBlock)();
@property (nonatomic, copy) void (^camerBtnBlock)();
@property (nonatomic, copy) void (^albumBtnBlock)();
@end
