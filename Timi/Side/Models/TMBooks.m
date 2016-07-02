//
//  TMBooks.m
//  Timi
//
//  Created by chairman on 16/6/27.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "TMBooks.h"

@implementation TMBooks

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

+ (NSArray *)ignoredProperties
{
    return @[kBookImage];
}
+(NSString *)primaryKey {
    return kBooksID;
}
/** getter */
- (UIImage *)bookImage {
    return [UIImage imageNamed:self.bookImageFileName];
}
#pragma mark - update Methods
- (void)updateBookName:(NSString *)bookName {
    if ([self.bookName isEqualToString:bookName]) return;
    RLMRealm *realm = RLMRealm.defaultRealm;
    TMBooks *book = [TMBooks objectsWhere:@"booksID = %@",self.booksID].firstObject;
    [realm transactionWithBlock:^{
        book.bookName = bookName;
    }];
}
/** 修改账本图片对应的下标 */
- (void)updateImageIndex:(NSNumber<RLMInt> *)imageIndex {
    if (self.imageIndex.intValue == imageIndex.intValue) return;
    RLMRealm *realm = RLMRealm.defaultRealm;
    TMBooks *book = [TMBooks objectsWhere:@"booksID = %@",self.booksID].firstObject;
    [realm transactionWithBlock:^{
        book.imageIndex = imageIndex;
    }];
}
/** 修改账本图片文件名称 */
- (void)updateBookImageFileName:(NSString *)bookImageFileName {
    if ([self.bookImageFileName isEqualToString:bookImageFileName]) return;
    RLMRealm *realm = RLMRealm.defaultRealm;
    TMBooks *book = [TMBooks objectsWhere:@"booksID = %@",self.booksID].firstObject;
    [realm transactionWithBlock:^{
        book.bookImageFileName = bookImageFileName;
    }];
}


@end
