//
//  TMCategory.m
//  Timi
//
//  Created by chairman on 16/5/16.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "TMCategory.h"

@implementation TMCategory

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

+ (NSArray *)ignoredProperties
{
    return @[kCTImage,kCTPercent];
}

+ (NSString *)primaryKey {
    return kCTID;
}
- (UIImage *)categoryImage {
    return [UIImage imageNamed:self.categoryImageFileNmae];
}
//* --------------------------read plist----------------------------- */

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+ (instancetype)categoryWithDic:(NSDictionary *)dic {
    return  [[self alloc]initWithDic:dic];
}
+ (NSArray *)categoryList {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"category" ofType:@"plist"];
    NSArray *dicArray = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (NSDictionary *dic in dicArray) {
        TMCategory *category = [TMCategory categoryWithDic:dic];
        [tempArray addObject:category];
    }
    return tempArray;
}
#pragma mark - 修改

- (void)modifyCategoryTitle:(NSString *)categoryTitle {
    if ([self.categoryTitle isEqualToString:categoryTitle])return;
    RLMRealm *realm = RLMRealm.defaultRealm;
    TMCategory *category = [[TMCategory objectsWhere:@"categoryID == %@",self.categoryID] firstObject];
    [realm transactionWithBlock:^{
        category.categoryTitle = categoryTitle;
    }];
}
@end
