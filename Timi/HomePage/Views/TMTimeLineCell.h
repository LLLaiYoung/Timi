//
//  TMTimeLineCell.h
//  Timi
//
//  Created by chairman on 16/5/18.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TMBill;
@class TMCategoryButton;
@protocol TMTimeLineCellDelegate <NSObject>
@required
/** 点击时光轴类别按钮 */
- (void)didClickCategoryBtnWithIndexPath:(NSIndexPath *)indexPath;
@optional

@end

@interface TMTimeLineCell : UITableViewCell
@property (nonatomic, strong) TMBill *timeLineBill;
@property (nonatomic, weak) id<TMTimeLineCellDelegate> cellDeletega;
/** 纪录cell的indexPath,用于获取对应的cell的rect */
@property (nonatomic, strong) NSIndexPath *indexPath;
/** 最后一个setion的lastBill */
@property (nonatomic, assign, getter=isLastBill) BOOL lastBill;
/** 是否点击了删除 */
@property (nonatomic, assign, getter=isClickDelete) BOOL clickedDelete;

@property (nonatomic, strong) TMCategoryButton *categoryImageBtn;
/** 隐藏cell的label */
- (void)cellLabelWithHidden:(BOOL)hidden;


@end
