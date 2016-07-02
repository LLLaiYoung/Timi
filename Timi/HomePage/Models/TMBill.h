//
//  TMBill.h
//  Timi
//
//  Created by chairman on 16/5/16.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import <Realm/Realm.h>
@class TMCategory;
@class TMBooks;

static NSString *const kBillPrimaryKey  = @"billID";
static NSString *const kBillDate        = @"dateStr";
static NSString *const kBillReMarks     = @"reMarks";
static NSString *const kBillIncome      = @"iSIncome";
static NSString *const kBillMoney       = @"money";
static NSString *const kBillRemarkPhoto = @"remarkPhoto";
static NSString *const KBillCount       = @"count";
static NSString *const kBillSame        = @"same";
static NSString *const kBillPartSame    = @"partSame";
static NSString *const kBillEmpty       = @"empty";


@interface TMBill : RLMObject
/** 账单主键 */
@property NSString *billID;
/** 时间 */
@property NSString *dateStr;
/** 备注 */
@property NSString *reMarks;
/** 备注照片 */
@property NSData *remarkPhoto;
/** 收入?YES:NO */
@property NSNumber<RLMBool> *isIncome;
/** 金额 */
@property NSNumber<RLMDouble> *money;
/** 外健 */
@property TMCategory *category;
/** 外健 */
@property TMBooks *books;
/** 完全相同,年月日 ->不保存数据库 ,cell重用导致数据年月日label显示混乱 */
@property (nonatomic, assign,getter=isSame) BOOL same;
/** 部分相同,年月 ->不保存数据库 ,cell重用导致数据年月日label显示混乱 */
@property (nonatomic, assign,getter=isPartSame) BOOL partSame;
/** 判断数据是否为空－>不保存数据库, 当数据为空的时候 显示｀新账本｀  */
@property (nonatomic, assign,getter=isEmpty) BOOL empty;
/** 笔数 ->不保存数据库 */
@property (nonatomic, assign) NSInteger count;
/** 修改时间 */
- (void)updateDateStr:(NSString *)dateStr;
/** 修改备注 */
- (void)updateRemarks:(NSString *)remakrs;
/** 修改相册 */
- (void)updateRemarkPhoto:(NSData *)photoData;
/** 修改类型 */
- (void)updateIncome:(NSNumber<RLMBool> *)isIncome;
/** 修改金额 */
- (void)updateMoney:(NSNumber<RLMDouble> *)money;
/** 修改外健 */
- (void)updateCategory:(TMCategory *)category;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<TMBill>
RLM_ARRAY_TYPE(TMBill)
