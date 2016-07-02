//
//  TMAddBookView.h
//  Timi
//
//  Created by chairman on 16/6/28.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMAddBookView : UIView
@property (nonatomic, copy) void(^clickCancelBtn)();
@property (nonatomic, copy) void(^clickSureBtn)(NSString *bookName,NSString *bookImageFileName,NSInteger imageIndex);
/** update的时候设置 */
@property (nonatomic, copy) NSString *text;
/** update时候设置 */
@property (nonatomic, assign) NSInteger index;
- (void)becomeFirstResponder;
- (void)resignFirstResponder;
- (void)reloadData;
@end
