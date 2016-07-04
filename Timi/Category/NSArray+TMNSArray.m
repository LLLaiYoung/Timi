//
//  NSArray+TMNSArray.m
//  Timi
//
//  Created by chairman on 16/6/28.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "NSArray+TMNSArray.h"

@implementation NSArray (TMNSArray)
#pragma mark - sort

/** 返回一个完成排序数组  */
+ (NSArray *)sortArray:(NSArray *)array ascending:(BOOL)ascending {
    //比较操作
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch
    | NSNumericSearch
    | NSWidthInsensitiveSearch
    | NSForcedOrderingSearch;
    //语言
    //https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSLocale_Class/
    NSLocale *currentLocale = [NSLocale currentLocale];
    
    NSArray *finderSortArray = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSRange string1Range = NSMakeRange(0, [obj2 length]);
        //ascending ? 升序:降序
        return ascending?[obj1 compare:obj2 options:comparisonOptions range:string1Range locale:currentLocale]:[obj2 compare:obj1 options:comparisonOptions range:string1Range locale:currentLocale];
    }];
    return finderSortArray;
}

+ (NSArray *)objectSortArray:(NSArray *)array ascending:(BOOL)ascending {
    NSSortDescriptor *dateStrDesc = [NSSortDescriptor sortDescriptorWithKey:@"dateStr" ascending:ascending];
    NSArray *deses = [NSArray arrayWithObjects:dateStrDesc, nil];
    NSArray *array2 = [array sortedArrayUsingDescriptors:deses];
    return array2;
}
#pragma mark - imageFileNames
+ (NSArray *)bookImageFiles {
    //@"book_cover_0",
    return @[
             @"book_cover_0",
             @"book_cover_1",
             @"book_cover_2",
             @"book_cover_3",
             @"book_cover_4",
             @"book_cover_5"
             ];
}
+ (NSArray *)headerBgImageFiles {
    return @[
             @"background1",
             @"background2",
             @"background3",
             @"background4",
             @"background5",
             @"background6",
             @"background7",
             @"background8",
             @"background9",
             @"background10",
             @"background11",
             @"background12",
             @"background13",
             ];
}

@end
