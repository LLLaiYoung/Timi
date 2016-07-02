//
//  TMDataBaseManager.m
//  Timi
//
//  Created by chairman on 16/5/16.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "TMDataBaseManager.h"
#import "TMBill.h"
#import "TMCategory.h"
#import "Const.h"
#import "TMAddCategory.h"
#import "TMBooks.h"

@interface TMDataBaseManager()
/** 读取类别plist表 */
@property (nonatomic, strong) NSArray *readCategorys;
/** 读取新增类别plist表 */
@property (nonatomic, strong) NSArray *readAddCategorys;
@end
@implementation TMDataBaseManager
#pragma mark - read Plist

- (NSArray *)readCategorys
{
    if (!_readCategorys) {
        _readCategorys = [TMCategory categoryList];
        
    }
    return _readCategorys;
}
- (NSArray *)readAddCategorys
{
    if (!_readAddCategorys) {
        _readAddCategorys = [TMAddCategory addCategorysList];
    }
    return _readAddCategorys;
}


#pragma mark - singleton

/** 单例 */
+ (instancetype)defaultManager {
    static TMDataBaseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TMDataBaseManager alloc] init];
        [manager readCategoryFromPlistSaveToDB];
        [manager readAddCategoryFromPlistSaveToDB];
        [manager setupDefaultBooks];
    });
    return manager;
}
#pragma mark - Private Methods
// * 生成64位随机字符串作为主键 */
-(NSString *)ret64bitString {
    char data[64];
    for (int x=0; x <64; data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:64 encoding:NSUTF8StringEncoding];
}

#pragma mark - TMBill
- (NSInteger)numberOfAllBillCountWithBookID:(NSString *)bookID {
    if (bookID.length<=0) return 0;
    return [TMBill objectsWhere:@"books.booksID = %@",bookID].count;
}

- (void)insertWithBill:(TMBill *)bill {
    if (bill.money.doubleValue<0.0 || bill.money.doubleValue==0.0) return;
    RLMRealm *realm = RLMRealm.defaultRealm;
    
    WEAKSELF
    [realm transactionWithBlock:^{
        bill.billID = [weakSelf ret64bitString];
        [TMBill createInDefaultRealmWithValue:bill];
    }];
}

- (void)deleteWithBill:(TMBill *)bill {
    if (bill.billID.length<=0) return;
    RLMRealm *realm = RLMRealm.defaultRealm;
    [realm transactionWithBlock:^{
        [realm deleteObject:bill];
    }];
}

- (RLMResults *)queryAllBillsWithBookID:(NSString *)bookID {
    if (bookID.length<=0)return nil;
    return [TMBill objectsWhere:@"books.booksID = %@",bookID];
}

- (RLMResults *)queryAllBillsWithBookID:(NSString *)bookID paymentType:(PaymentType)type {
    if (bookID.length <= 0) return nil;
    return [TMBill objectsWhere:@"books.booksID = %@ and isIncome = %li",bookID,type];
}

- (RLMResults *)queryBillWithBookID:(NSString *)bookID andBeginSwithContains:(NSString *)dateStr andCategoryTitle:(NSString *)categotyTitle {
    if (dateStr.length<=0 || categotyTitle.length<=0 || bookID.length <= 0) return nil;
    RLMResults *results = nil;
    if ([dateStr isEqualToString:@"ALL"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"books.booksID = %@ and category.categoryTitle = %@",bookID,categotyTitle];
        results = [TMBill objectsWithPredicate:predicate];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"books.booksID = %@ and dateStr BEGINSWITH %@ and category.categoryTitle = %@",bookID,[dateStr substringToIndex:7],categotyTitle];
        results = [TMBill objectsWithPredicate:predicate];
    }
    return results;
}

- (RLMResults *)queryBillWithBookID:(NSString *)bookID andBeginSwithContains:(NSString *)dateStr andPaymentType:(PaymentType)type {
    if (dateStr.length <=0 || bookID.length <=0 ) return nil;
    NSPredicate *predicate = nil;
    if (type==allPayment) {
        return [self queryAllBillsWithBookID:bookID];
    } else {
        if ([dateStr isEqualToString:@"ALL"]) {
            predicate= [NSPredicate predicateWithFormat:@"books.booksID = %@ and isIncome = %li",bookID,type];
        } else {
            predicate= [NSPredicate predicateWithFormat:@"books.booksID = %@ and dateStr BEGINSWITH %@ and isIncome = %li",bookID,[dateStr substringToIndex:7],type];
        }
    }
    RLMResults *results = [TMBill objectsWithPredicate:predicate];
    
    return results;
}

- (NSDictionary *)queryNonRepeatWithBookID:(NSString *)bookID {
    if (bookID.length <= 0) return @{};
    /**
     *  筛选重复数据
     *  1.把要筛选的数据提取出来放进一个数组array1
     *  2.初始化一个新数组array2,用于存放筛选出的数据,使用数组的containsObject方法判断数据是否重复,不重复就放进array2数组 ,用｀NSMutableSet｀也可以。｀NSMutableSet｀会直接过滤掉重复的数据
     *  3.初始化一个字典resultsDic,用于存放最终数据。for in 筛选之后的数组array2 使用 NSPredicate进行筛选
     使用筛选之后第一个对象的dateStr作为key,符合条件的对象为values。
     */
    RLMResults *results = [self queryAllBillsWithBookID:bookID];
    NSMutableArray *dates1 = [NSMutableArray array];
    //1.把要筛选的数据提取出来放进一个数组dates1
    for (TMBill *bill in results) {
        [dates1 addObject:bill.dateStr];
    }
    //2.初始化一个新数组dates2,用于存放筛选出的数据,使用数组的containsObject方法判断数据是否重复,不重复就放进array2数组
    NSMutableArray *dates2 = [NSMutableArray array];
    for (NSInteger i=0; i<dates1.count; i++) {
        if (![dates2 containsObject:dates1[i]]) {
            [dates2 addObject:dates1[i]];
        }
    }
    //3.初始化一个字典resultsDic,用于存放最终数据。for in 筛选之后的数组array2 使用 NSPredicate进行筛选,使用筛选之后第一个对象的dateStr作为key,符合条件的对象为values。
    NSMutableDictionary *resultsDic = [NSMutableDictionary dictionary];
    for (NSString *dateStr in dates2) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateStr == %@",dateStr];
        RLMResults *cellResults = [results objectsWithPredicate:predicate];
        [resultsDic setObject:cellResults forKey:[(TMBill *)cellResults[0] dateStr]];
    }
    
    return resultsDic;
}

- (NSString *)queryCategoryImageWithCategotyTitle:(NSString *)categoryTitle {
    if (categoryTitle.length==0) return nil;
    RLMResults *results = [TMCategory objectsWhere:@"categoryTitle = %@",categoryTitle];
    TMCategory *category = results[0];
    return category.categoryImageFileNmae;
}

- (NSDictionary *)getPieDataWithBookID:(NSString *)bookID andDateSting:(NSString *)dateString andPaymentType:(PaymentType)type {
    if (dateString.length<=0 || bookID.length <= 0) return @{};
    
    NSMutableSet *mutableSet = [NSMutableSet set];
    if ([dateString isEqualToString:@"ALL"]) {
        if (type==allPayment) {
            RLMResults *results = [self queryAllBillsWithBookID:bookID];
            //* 过滤重复数据 */
            for (TMBill *bill in results) {
                [mutableSet addObject:bill.category.categoryTitle];
            }
        } else {
            RLMResults *results = [self queryAllBillsWithBookID:bookID paymentType:type];
            //* 过滤重复数据 */
            for (TMBill *bill in results) {
                [mutableSet addObject:bill.category.categoryTitle];
            }
        }
    } else {
        RLMResults *results = [self queryBillWithBookID:bookID andBeginSwithContains:[dateString substringToIndex:7] andPaymentType:type];
        for (TMBill *bill in results) {
            [mutableSet addObject:bill.category.categoryTitle];
        }
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *categotyTitle in mutableSet) {
        TMBill *bill = [TMBill new];
        NSUInteger count = [self countWithCategoryTitleOfBookID:bookID andCategoryTitle:categotyTitle andDateStr:dateString];
        float money = [TMCalculate queryAllMoneyWithCategotyTitleOfBookID:bookID andCategoryTitle:categotyTitle andDateStr:dateString];
        
        NSString *imageFileName = [self queryCategoryImageWithCategotyTitle:categotyTitle];
        float percent = [TMCalculate calculateCategoryPercentWithBookID:bookID andDateString:dateString andCategoryTitle:categotyTitle andPaymentType:type];
        bill.count = count;
        bill.money = @(money);
        bill.category.percent = percent;
        bill.category.categoryTitle = categotyTitle;
        bill.category.categoryImageFileNmae = imageFileName;
        [dic setValue:bill forKey:categotyTitle];
    }
    return dic;
}


#pragma mark - TMCategory

- (NSInteger)numberOfAllCategoryCount {
    return [[TMCategory allObjects] count];
}

- (void)deleteWithCategory:(TMCategory *)category {
    if (category.categoryTitle.length==0) return;
    RLMRealm *realm = RLMRealm.defaultRealm;
    [realm transactionWithBlock:^{
        [realm deleteObject:category];
    }];
}

- (RLMResults *)queryAllCategorys {
   return [TMCategory allObjects];
}

- (NSInteger)countWithCategoryTitleOfBookID:(NSString *)bookID andCategoryTitle:(NSString *)categoryTitle andDateStr:(NSString *)dateStr {
    if (categoryTitle.length<=0 || dateStr.length<=0 || bookID.length <= 0) return 0;
    if ([dateStr isEqualToString:@"ALL"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"books.booksID = %@ and category.categoryTitle = %@",bookID,categoryTitle];
        return [TMBill objectsWithPredicate:predicate].count;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"books.booksID = %@ and category.categoryTitle = %@ and dateStr BEGINSWITH %@ ",bookID,categoryTitle,[dateStr substringToIndex:7]];
    return [TMBill objectsWithPredicate:predicate].count;
}

- (NSInteger)numberOfCategoryCountWithPaymentType:(PaymentType)type {
    return [TMCategory objectsWhere:@"isIncome = %i",type].count;
}

- (RLMResults *)queryCategorysWithPaymentType:(PaymentType)type {
    return [TMCategory objectsWhere:@"isIncome = %i",type];
}

- (void)insertCategory:(TMCategory *)category {
    if (category.categoryTitle.length <= 0) return;
    RLMRealm *realm = RLMRealm.defaultRealm;
    WEAKSELF
    [realm transactionWithBlock:^{
        category.categoryID = [weakSelf ret64bitString];
        [TMCategory createInDefaultRealmWithValue:category];
    }];
}
/** 当数据库类别为0时,从plist读取数据,保存到数据库 */
- (void)readCategoryFromPlistSaveToDB {
    if ([self numberOfAllCategoryCount]!=0)return;
    for (TMCategory *category in self.readCategorys) {
        [self insertCategory:category];
    }
}

#pragma mark - TMAddCategory

- (NSInteger)numberOfAddCategoryCountWithPaymentType:(PaymentType)type {
    if (type==allPayment) return [TMAddCategory allObjects].count;
    return [TMAddCategory objectsWhere:@"isIncome = %i",type].count;
}

- (RLMResults *)queryAddCategorysWithPaymentType:(PaymentType)type {
    return [TMAddCategory objectsWhere:@"isIncome = %i",type];
}

- (void)insertAddCategory:(TMAddCategory *)addCategory {
    RLMRealm *realm = RLMRealm.defaultRealm;
    WEAKSELF
    [realm transactionWithBlock:^{
        addCategory.categoryID = [weakSelf ret64bitString];
        [TMAddCategory createInDefaultRealmWithValue:addCategory];
    }];
}
/** 当数据库为0时,从plist表读取数据,保存到数据库 */
- (void)readAddCategoryFromPlistSaveToDB {
    if ([self numberOfAddCategoryCountWithPaymentType:allPayment]!=0) return;
    for (TMAddCategory *addCategory in self.readAddCategorys) {
        [self insertAddCategory:addCategory];
    }
}
- (void)deleteWithAddCategory:(TMAddCategory *)addCategory {
    RLMRealm *realm =RLMRealm.defaultRealm;
    [realm transactionWithBlock:^{
        [realm deleteObject:addCategory];
    }];
}

#pragma mark - TMBooks

- (NSInteger)numberOfAllBooksCount {
    return [TMBooks allObjects].count;
}
- (void)insertBooks:(TMBooks *)book {
    RLMRealm *realm = RLMRealm.defaultRealm;
    WEAKSELF
    [realm transactionWithBlock:^{
        book.booksID = [weakSelf ret64bitString];
        [TMBooks createInDefaultRealmWithValue:book];
    }];
}
- (RLMResults *)queryAllBooks {
    return [TMBooks allObjects];
}
- (void)setupDefaultBooks {
    if ([self numberOfAllBooksCount]!=0) return;
    TMBooks *book = [TMBooks new];
    book.bookName = @"日常账本";
    book.bookImageFileName = @"book_cover_0";
    book.imageIndex = @0;
    [self insertBooks:book];
    [self setupUserDefaults];
}
//* 应该保存对象,需要归档,解挡,Realm支持不好 */
/** 第一次设置默认选择的账本 */
- (void)setupUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    TMBooks *book = [TMBooks allObjects].firstObject;
    [defaults setObject:book.booksID forKey:@"selectBookID"];
   [defaults synchronize];
}
- (TMBooks *)queryBooksWithBookID:(NSString *)bookID {
    if (bookID.length<=0) return nil;
    return [TMBooks objectsWhere:@"booksID = %@",bookID].firstObject;
}
- (NSInteger)bookIndexWithBookID:(NSString *)bookID {
    if (bookID.length<=0) return -1;
    for (NSInteger i=0; i<[TMBooks allObjects].count; i++) {
        TMBooks *theBook = [TMBooks allObjects][i];
        if ([theBook.booksID isEqualToString:bookID]) {
            return i;
        }
    }
    return -1;
}
- (void)deleteBookWithBookID:(NSString *)bookID {
    if (bookID.length <= 0) return;
    RLMResults *results = [self queryAllBillsWithBookID:bookID];
    TMBooks * book = [self queryBooksWithBookID:bookID];
    RLMRealm *realm = RLMRealm.defaultRealm;
    [realm transactionWithBlock:^{
        [realm deleteObjects:results];
        [realm deleteObject:book];
    }];
}

@end


