//
//  TMCalculate.h
//  Timi
//
//  Created by chairman on 16/5/17.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TMCategory;
@interface TMCalculate : NSObject

typedef enum : NSUInteger {
    expend,
    income,
    allPayment//expend && income
} PaymentType;


/**
 *  查询所有账单的总支出or总收入
 *
 *  @param type expend ｜ income
 *
 *  @return 金额
 */
+ (float)queryAllIncomeOrExpendOfPaymentType:(PaymentType)type;
/**
 *  根据账本ID 查找对应类型(收支)的总金额
 *
 *  @param bookID 账本ID
 *  @param type   expend ｜ income
 *
 *  @return 金额
 */
+ (float)queryAllIncomeOrExpendOfBookID:(NSString *)bookID andPaymentType:(PaymentType)type;
/**
 *  查询所有账单的总差额
 *
 *  @return 差额
 */
+ (float)queryAmountOfPriceDifference;
/**
 *  根据账本ID 查询总差额
 *
 *  @param bookID 账本ID
 *
 *  @return 差额
 */
+ (float)queryAmountOfPriceDifferenceWithBookID:(NSString *)bookID;
/**
 *  根据账本ID和时间查找某日总支出金额
 *
 *  @param bookID  账本ID
 *  @param dateStr 时间 eg.@"2016-05-18"
 *
 *  @return 金额
 */
+ (float)queryDayAllExpendWithBookID:(NSString *)bookID andDateString:(NSString *)dateStr;

/**
 *  根据账本ID,日期查询,类型(收支)查询月总收入or总支出
 *
 *  @param bookID  账本ID
 *  @param dateStr 时间 eg.@"2016-05-18"
 *  @param type    expend ｜ income
 *
 *  @return 金额
 */
+ (float)queryMonthAllIncomeOrExpendOfBookID:(NSString *)bookID andDateString:(NSString *)dateStr withPaymentType:(PaymentType)type;

/**
 *  根据账本ID,类别标题,时间 查询某个时间点类别总金额
 *
 *  @param bookID        账本ID
 *  @param categoryTitle 类别标题
 *  @param dateString    时间 eg.@"2016-05-18"/@"ALL"
 *
 *  @return 金额
 */
+ (float)queryAllMoneyWithCategotyTitleOfBookID:(NSString *)bookID andCategoryTitle:(NSString *)categoryTitle andDateStr:(NSString *)dateString;

/** 账本ID 查询某个时间段 某类别所占百分比 */
/**
 *  根据账本ID,时间,类别标题 查询某个月份 某类别所占百分比
 *
 *  @param bookID        账本ID
 *  @param dateString    时间 eg./@"2016-05-18"/@"ALL"
 *  @param categoryTitle 类别标题
 *  @param type          income | expend | allPayment
 *
 *  @return 百分比
 */
+ (float)calculateCategoryPercentWithBookID:(NSString *)bookID andDateString:(NSString *)dateString andCategoryTitle:(NSString *)categoryTitle andPaymentType:(PaymentType)type;


@end
