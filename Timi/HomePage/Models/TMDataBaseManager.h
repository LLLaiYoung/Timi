//
//  TMDataBaseManager.h
//  Timi
//
//  Created by chairman on 16/5/16.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import "TMCalculate.h"
@class TMBill;
@class TMCategory;
@class TMAddCategory;
@class TMBooks;

#warning 如果一个模型存在主键,直接在transactionWithBlock对数据进行更新

@interface TMDataBaseManager : NSObject
/** 单例 */
+ (instancetype)defaultManager;

#pragma mark - TMBill

/**
 *  根据账本ID 查询对应账本的总账单数
 *
 *  @param bookID 账本ID
 *
 *  @return 对应账本的总账单数
 */
- (NSInteger)numberOfAllBillCountWithBookID:(NSString *)bookID;

/**
 *  新增一笔账
 *
 *  @param bill 账单
 */
- (void)insertWithBill:(TMBill *)bill;

/**
 *  删除一笔账
 *
 *  @param bill 账单
 */
- (void)deleteWithBill:(TMBill *)bill;

/**
 *  根据账本ID查询账本下的所有账单
 *
 *  @param bookID 账本ID
 *
 *  @return RLMResults(TMBill)
 */
- (RLMResults *)queryAllBillsWithBookID:(NSString *)bookID;

/**
 *  根据账本ID,查询账本的支出or收入,所有账单的数据
 *
 *  @param bookID 账本ID
 *  @param type   income | expend
 *
 *  @return RLMResults(TMBill)
 */
- (RLMResults *)queryAllBillsWithBookID:(NSString *)bookID paymentType:(PaymentType)type;

/**
 *  根据账本ID,查询账本某个类别的某年/某月所有数据
 *
 *  @param bookID        账本ID
 *  @param dateStr       时间 eg.@"2016-05-18"/@"ALL"
 *  @param categotyTitle 类别标题
 *
 *  @return RLMResults(TMBill)
 */
- (RLMResults *)queryBillWithBookID:(NSString *)bookID andBeginSwithContains:(NSString *)dateStr andCategoryTitle:(NSString *)categotyTitle;

/**
 *  根据账本ID,查询账本某年/某月支出 or 收入 or 总 数据
 *
 *  @param bookID  账本ID
 *  @param dateStr 时间 eg.@"2016-05-18"/@"ALL"
 *  @param type    income | expend | allPayment
 *
 *  @return RLMResults(TMBill)
 */
- (RLMResults *)queryBillWithBookID:(NSString *)bookID andBeginSwithContains:(NSString *)dateStr andPaymentType:(PaymentType)type;

/**
 *  根据账本ID,将时间重复的数据进行组合
 *
 *  @param bookID 账本ID
 *
 *  @return key:dateStr Values:RLMResults(TMBill)
 */
- (NSDictionary *)queryNonRepeatWithBookID:(NSString *)bookID;

/**
 *  查询某个类别的图标文件名
 *
 *  @param categoryTitle 类别标题
 *
 *  @return (因为)categoryImage是只读,(所以)将文件名保存到categoryImageFileNmae
 */
- (NSString *)queryCategoryImageWithCategotyTitle:(NSString *)categoryTitle;

/**
 *  根据账本ID,获取饼图数据
 *
 *  @param bookID     账本ID
 *  @param dateString 时间 eg.@"2016-05-18"/@"ALL"
 *  @param type       income | expend | allPayment
 *
 *  @return key:categoryTitle ,values:bill(count,percent,categoryImageFileName,money)
 */
- (NSDictionary *)getPieDataWithBookID:(NSString *)bookID andDateSting:(NSString *)dateString andPaymentType:(PaymentType)type;

#pragma mark - TMCategory

/** 类别总条数 */
- (NSInteger)numberOfAllCategoryCount;

/** 查询所有类别 */
- (RLMResults *)queryAllCategorys;

/**
 *  根据账本ID,查询账本某个时间点类别的总数
 *
 *  @param bookID        账本ID
 *  @param categoryTitle 账本标题
 *  @param dateStr       时间 eg.@"2016-05-18"/@"ALL"
 *
 *  @return 某时间点账本类别总数
 */
- (NSInteger)countWithCategoryTitleOfBookID:(NSString *)bookID andCategoryTitle:(NSString *)categoryTitle andDateStr:(NSString *)dateStr;

/**
 *  查询类别数量
 *
 *  @param type expend ｜ income
 *
 *  @return 对应类别总数
 */
- (NSInteger)numberOfCategoryCountWithPaymentType:(PaymentType)type;

/**
 *  查询类型结果
 *
 *  @param type expend ｜ income
 *
 *  @return RLMResults(TMCategory)
 */
- (RLMResults *)queryCategorysWithPaymentType:(PaymentType)type;

/**
 *  新增一个类别
 *
 *  @param category 类别
 */
- (void)insertCategory:(TMCategory *)category;

#pragma mark - TMAddCategory

/**
 *  根据类别类型查询对应新增类别总数
 *
 *  @param type expend ｜ income ｜ allPayment
 *
 *  @return 对应类别类型总数
 */
- (NSInteger)numberOfAddCategoryCountWithPaymentType:(PaymentType)type;

/**
 *  根据类别类型查询对应新增类别
 *
 *  @param type expend ｜ income
 *
 *  @return RLMResults(TMAddCategory)
 */
- (RLMResults *)queryAddCategorysWithPaymentType:(PaymentType)type;

/**
 *  删除新增类别
 *
 *  @param addCategory 新增类别
 */
- (void)deleteWithAddCategory:(TMAddCategory *)addCategory;

#pragma mark - TMBooks

/** 查询账本总数 */
- (NSInteger)numberOfAllBooksCount;

/**
 *  根据账本ID查找账本在数据中的位置
 *
 *  @param bookID 账本ID
 *
 *  @return index
 */
- (NSInteger)bookIndexWithBookID:(NSString *)bookID;

/**
 *  删除账本,并且删除账本下的所有数据
 *
 *  @param bookID 账本ID
 */
- (void)deleteBookWithBookID:(NSString *)bookID;

/**
 *  新增账本
 *
 *  @param book 账本
 */
- (void)insertBooks:(TMBooks *)book;

/** 所有账本 */
- (RLMResults *)queryAllBooks;

/**
 *  根据账本ID查询对应的账本
 *
 *  @param bookID 账本ID
 *
 *  @return TMBooks
 */
- (TMBooks *)queryBooksWithBookID:(NSString *)bookID;

@end


