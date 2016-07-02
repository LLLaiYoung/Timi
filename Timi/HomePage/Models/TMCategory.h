//
//  TMCategory.h
//  Timi
//
//  Created by chairman on 16/5/16.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import <Realm/Realm.h>
#import <UIKit/UIKit.h>
static NSString *const kCTID            = @"categoryID";
static NSString *const kCTTitle         = @"categoryTitle";
static NSString *const kCTImage         = @"categoryImage";
static NSString *const kCTImageFileName = @"categoryImageFileNmae";
static NSString *const kCTPercent       = @"percent";
static NSString *const kCTIncome        = @"isIncome";

@interface TMCategory : RLMObject

/** 类别ID 主键 */
@property NSString *categoryID;
/** 类别图片名称 */
@property NSString *categoryImageFileNmae;
/** 类别标题 */
@property NSString *categoryTitle;
/** 所占百分比 不保存数据库 */
//@property NSNumber<RLMFloat> *percent;
@property (nonatomic, assign) float percent;
/** 收入or支出类别 */
@property NSNumber<RLMBool> *isIncome;
/** 类别图片 */
@property (nonatomic,readonly) UIImage *categoryImage;
/** 类别plist表 */
+ (NSArray *)categoryList;
/** 修改类别标题 */
- (void)modifyCategoryTitle:(NSString *)categoryTitle;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<TMCategory>
RLM_ARRAY_TYPE(TMCategory)
