//
//  TMAddCategory.h
//  Timi
//
//  Created by chairman on 16/6/22.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import <Realm/Realm.h>
#import <UIKit/UIKit.h>
@interface TMAddCategory : RLMObject

@property NSString *categoryID;
@property NSString *categoryImageFileName;
@property NSNumber<RLMBool> *isIncome;
@property (nonatomic,readonly) UIImage *image;
+ (NSArray *)addCategorysList;

@end




// This protocol enables typed collections. i.e.:
// RLMArray<TMAddCategory>
RLM_ARRAY_TYPE(TMAddCategory)
