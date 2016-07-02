//
//  TMPieCategoryDetailViewController.h
//  Timi
//
//  Created by chairman on 16/6/22.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "LYBaseViewController.h"
@class TMCalculate;
@interface TMPiewCategoryDetailViewController : LYBaseViewController
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, assign) PaymentType type;
@end
