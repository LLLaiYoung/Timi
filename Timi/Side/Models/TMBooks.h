//
//  TMBooks.h
//  Timi
//
//  Created by chairman on 16/6/27.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import <Realm/Realm.h>
#import <UIKit/UIKit.h>

static NSString *const kBooksID           = @"booksID";
static NSString *const kBooksName         = @"bookName";
static NSString *const kBookImageFileName = @"bookImageFileName";
static NSString *const kBookImage         = @"bookImage";
static NSString *const kBookimageIndex    = @"imageIndex";

@interface TMBooks : RLMObject
/** 主键 */
@property NSString *booksID;
/** 账本名称 */
@property NSString *bookName;
/** 图片名的下标 */
@property NSNumber<RLMInt> *imageIndex;
/** 账本背景图片名 */
@property NSString *bookImageFileName;
/** 账本背景 －>不保存数据库*/
@property (nonatomic, strong,readonly) UIImage *bookImage;
/** 修改账本名称 */
- (void)updateBookName:(NSString *)bookName;
/** 修改账本图片对应的下标 */
- (void)updateImageIndex:(NSNumber<RLMInt> *)imageIndex;
/** 修改账本图片文件名称 */
- (void)updateBookImageFileName:(NSString *)bookImageFileName;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<TMBooks>
RLM_ARRAY_TYPE(TMBooks)
