//
//  TMRemarkViewController.h
//  Timi
//
//  Created by chairman on 16/6/2.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "LYBaseViewController.h"
@class TMBill;
@interface TMRemarkViewController : LYBaseViewController
@property (nonatomic, strong) TMBill *bill;
@property (nonatomic, copy) void (^passbackBlock)(NSString *remarks,NSData *photoData);
@end
