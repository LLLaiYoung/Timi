//
//  NSArray+TMNSArray.h
//  Timi
//
//  Created by chairman on 16/6/28.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TMBill;
@interface NSArray (TMNSArray)
#pragma mark - sort

/** 排序 */
+ (NSArray *)sortArray:(NSArray *)array ascending:(BOOL)ascending;
/** 根据对象的dateStr进行排序 */
+ (NSArray *)objectSortArray:(NSArray <TMBill *> *)array ascending:(BOOL)ascending;

#pragma mark - imageFileNames

/** 账本图片名称 */
+ (NSArray *)bookImageFiles;
/** 时光轴头部界面背景图 */
+ (NSArray *)headerBgImageFiles;
@end
