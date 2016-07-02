//
//  TMAddCategory.m
//  Timi
//
//  Created by chairman on 16/6/22.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "TMAddCategory.h"

@implementation TMAddCategory

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

+ (NSArray *)ignoredProperties
{
    return @[@"image"];
}
+ (NSString *)primaryKey {
    return @"categoryID";
}
- (UIImage *)image {
    return [UIImage imageNamed:self.categoryImageFileName];
}

//* --------------------------read Plist----------------------------- */

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+ (instancetype)addCateogryWithDic:(NSDictionary *)dic {
    return  [[self alloc]initWithDic:dic];
}
+ (NSArray *)addCategorysList {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"addCategory" ofType:@"plist"];
    NSArray *dicArray = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (NSDictionary *dic in dicArray) {
        TMAddCategory *category = [TMAddCategory addCateogryWithDic:dic];
        [tempArray addObject:category];
    }
    return tempArray;
}
@end
