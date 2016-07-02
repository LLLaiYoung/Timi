//
//  TMPiewCategoryDetailCell.h
//  Timi
//
//  Created by chairman on 16/6/23.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TMBill;
@interface TMPiewCategoryDetailCell : UITableViewCell
@property (nonatomic, strong) TMBill *bill;
- (void)hiddenThreeUIView:(BOOL)hidden;
- (void)hiddenYearLabel:(BOOL)hidden;
@end
