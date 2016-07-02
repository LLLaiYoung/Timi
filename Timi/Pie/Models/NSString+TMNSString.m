//
//  NSString+TMNSString.m
//  Timi
//
//  Created by chairman on 16/6/23.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "NSString+TMNSString.h"

@implementation NSString (TMNSString)
+ (NSString *)tm_conversionYearMonthWithDateStr:(NSString *)dateStr {
    NSMutableString *mutableStr = [dateStr mutableCopy];
    NSRange yearRange = NSMakeRange(4, 1);
    [mutableStr replaceCharactersInRange:yearRange withString:@"年"];
    NSRange monthRange = NSMakeRange(7, 3);
    [mutableStr replaceCharactersInRange:monthRange withString:@"月"];
    return mutableStr;
}
/** 读取选择的账本ID */
+ (NSString *)readUserDefaultOfSelectedBookID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return  [userDefaults objectForKey:@"selectBookID"];
}
/** 返回当前时间格式字符串 */
+ (NSString *)currentDateStr {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}
@end
