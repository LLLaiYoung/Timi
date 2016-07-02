//
//  TMCreateBillViewController.h
//  Timi
//
//  Created by chairman on 16/5/25.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "LYBaseViewController.h"
@class TMBill;
@class TMCreateBillViewController;
@protocol TMCreateBillViewControllerDelegate <NSObject>
@required
- (void)clickDismissBtnWithTMCreateBillViewController:(TMCreateBillViewController *)viewController;
@optional

@end
@interface TMCreateBillViewController : LYBaseViewController
@property (nonatomic, weak) id<TMCreateBillViewControllerDelegate> tmCreateBillDelegate;
@property (nonatomic, strong) TMBill *bill;
@property (nonatomic, assign, getter=isUpdade) BOOL update;
@end
