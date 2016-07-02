//
//  TMSideCell.h
//  Timi
//
//  Created by chairman on 16/6/26.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TMBooks;
@protocol TMSideCellDelegate <NSObject>
@required
@optional
- (void)TMSideCellWithIndexPath:(NSIndexPath *)indexPath withLongPress:(UILongPressGestureRecognizer *)longPress;

@end
@interface TMSideCell : UICollectionViewCell
@property (nonatomic, weak) id<TMSideCellDelegate> sideCellDelegate;
@property (nonatomic, strong) TMBooks *book;
@property (nonatomic, strong) NSIndexPath *indexPath;
/** 选择的图 */
@property (nonatomic, strong) UIImageView *selectedItemImageView;
/** 编辑时候选择的 */
@property (nonatomic, strong) UIImageView *editSelectedItemImageView;
@end
