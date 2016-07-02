//
//  TMCalculate.m
//  Timi
//
//  Created by chairman on 16/5/17.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "TMCalculate.h"
#import <Realm/Realm.h>
#import "TMBill.h"
#import "TMDataBaseManager.h"
#import "TMBooks.h"
@implementation TMCalculate

+ (float)queryAllIncomeOrExpendOfPaymentType:(PaymentType)type {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isIncome = %i",type];
    RLMResults *results = [TMBill objectsWithPredicate:predicate];
    NSNumber *moneyNumber = [results sumOfProperty:@"money"];
    return moneyNumber.floatValue;
}

+ (float)queryAllIncomeOrExpendOfBookID:(NSString *)bookID andPaymentType:(PaymentType)type {
    if (bookID.length <= 0) return 0;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"books.booksID = %@ and isIncome = %i",bookID,type];
    RLMResults *results = [TMBill objectsWithPredicate:predicate];
    NSNumber *moneyNumber = [results sumOfProperty:@"money"];
    return moneyNumber.floatValue;

}

+ (float)queryAmountOfPriceDifference {
    RLMResults *incomeResults = [TMBill objectsWhere:@"isIncome = 1"];
    RLMResults *expendResults = [TMBill objectsWhere:@"isIncome = 0"];
    NSNumber *incomeMoney = [incomeResults sumOfProperty:@"money"];
    NSNumber *expendMoney = [expendResults sumOfProperty:@"money"];
    return incomeMoney.floatValue - expendMoney.floatValue;
}

+ (float)queryAmountOfPriceDifferenceWithBookID:(NSString *)bookID {
    if (bookID.length <= 0) return 0;
    RLMResults *incomeResults = [TMBill objectsWhere:@"books.booksID = %@ and isIncome = 1",bookID];
    RLMResults *expendResults = [TMBill objectsWhere:@"books.booksID = %@ and isIncome = 0",bookID];
    NSNumber *incomeMoney = [incomeResults sumOfProperty:@"money"];
    NSNumber *expendMoney = [expendResults sumOfProperty:@"money"];
    return incomeMoney.floatValue - expendMoney.floatValue;
}


+ (float)queryMonthAllIncomeOrExpendOfBookID:(NSString *)bookID andDateString:(NSString *)dateStr withPaymentType:(PaymentType)type {
    if (dateStr.length<=0 || bookID.length <= 0) return 0;
    NSString *str = [dateStr substringToIndex:7];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"books.booksID = %@ and dateStr contains %@ and isIncome = %li",bookID,str,type];
    RLMResults *results = [TMBill objectsWithPredicate:predicate];
    return  [results sumOfProperty:@"money"].floatValue;
}

+ (float)queryDayAllExpendWithBookID:(NSString *)bookID andDateString:(NSString *)dateStr {
    if (dateStr.length<=0 || bookID.length <= 0) return 0;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"books.booksID = %@ and dateStr = %@ and isIncome = 0",bookID,dateStr];
    RLMResults *results = [TMBill objectsWithPredicate:predicate];
    NSNumber *moneyNumber = [results sumOfProperty:@"money"];
    return moneyNumber.floatValue;

}
+ (float)queryAllMoneyWithCategotyTitleOfBookID:(NSString *)bookID andCategoryTitle:(NSString *)categoryTitle andDateStr:(NSString *)dateString {
    if (categoryTitle.length<=0 || dateString.length<=0 || bookID.length<= 0) return 0;
    if ([dateString isEqualToString:@"ALL"]) {
        RLMResults *results = [TMBill objectsWhere:@"books.booksID = %@ and category.categoryTitle = %@",bookID,categoryTitle];
        return [results sumOfProperty:@"money"].floatValue;
    }
    RLMResults *results = [TMBill objectsWhere:@"books.booksID = %@ and category.categoryTitle = %@ and dateStr BEGINSWITH %@",bookID,categoryTitle,[dateString substringToIndex:7]];
    return [results sumOfProperty:@"money"].floatValue;
}

+ (float)calculateCategoryPercentWithBookID:(NSString *)bookID
                              andDateString:(NSString *)dateString
                           andCategoryTitle:(NSString *)categoryTitle
                             andPaymentType:(PaymentType)type {
    if (categoryTitle.length <= 0 || dateString.length <= 0 || bookID.length <= 0) return 0;
    
    float categoryMoney = [[[TMDataBaseManager defaultManager] queryBillWithBookID:bookID andBeginSwithContains:dateString andCategoryTitle:categoryTitle] sumOfProperty:@"money"].floatValue;
    RLMResults *results = [[TMDataBaseManager defaultManager] queryBillWithBookID:bookID andBeginSwithContains:dateString andPaymentType:type];
    float allMoney = [results sumOfProperty:@"money"].floatValue;
    return categoryMoney / allMoney * 100;//百分比
}

@end
