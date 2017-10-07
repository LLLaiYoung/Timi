//
//  Const.h
//  Timi
//
//  Created by chairman on 16/5/19.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#ifndef Const_h
#define Const_h

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

/** 弱引用 */
#define WEAKSELF __weak typeof(self) weakSelf = self;

/** 屏幕的SIZE */
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size

#define SCREEN_WIDTH_Phone ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)

#define SCREEN_HEIGHT_Phone ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)

#define SCREEN_WIDTH    MIN(SCREEN_WIDTH_Phone,SCREEN_HEIGHT_Phone)
#define SCREEN_HEIGHT   MAX(SCREEN_WIDTH_Phone,SCREEN_HEIGHT_Phone)

#define kStatusBarHeight  [[UIApplication sharedApplication] statusBarFrame].size.height
/** 时光轴线条颜色 */
#define LineColor [UIColor colorWithWhite:0.800 alpha:1.000]
/** 时光轴背景颜色 */
#define LinebgColor [UIColor colorWithWhite:0.986 alpha:1.000]
/** 时光轴按钮 */
#define kTimeLineBtnWidth 30.0
/** 时光轴动画时间 */
#define kAnimationDuration .2f

/** 时光轴空白区域宽度 */
#define kBlankWidth ((SCREEN_SIZE.width - kTimeLineBtnWidth)/2/2 + (SCREEN_SIZE.width - kTimeLineBtnWidth)/2/2/3)

/** navigationBar的高 */
#define kNavigationBarMaxY CGRectGetMaxY(self.navigationController.navigationBar.frame)
/** 时光轴HeaderView的height */
#define kHeaderViewHeight 220

/** 接收到的y 235为HeaderView的height*/
#define kRectY self.receiveRect.origin.y + kHeaderViewHeight + 2
/** maxY navigationBar  + maxY statusBar*/
#define kMaxNBY CGRectGetMaxY(self.navigationController.navigationBar.frame)+CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame)
/** 一个item的宽 */
#define kCollectionCellWidth SCREEN_SIZE.width/6

#define kSelectColor [UIColor colorWithRed:0.907 green:0.454 blue:0.000 alpha:1.000]
/** height +10 是因为image和label都对顶部有5个像素的偏移量 */
#define kCollectionFrame CGRectMake(0, kMaxNBY + kCreateBillHeaderViewFrame.size.height, SCREEN_SIZE.width,(kCollectionCellWidth + 10) * 4)


#define kPageControllerFrame CGRectMake(0, kMaxNBY + kCollectionFrame.size.height + kCreateBillHeaderViewFrame.size.height, SCREEN_SIZE.width, 30)
/** 记账界面的headerViewFrame */
#define kCreateBillHeaderViewFrame CGRectMake(0, kMaxNBY, SCREEN_SIZE.width, 60)
/** 颜色提取点 根据原图的size提取  default 30 8*/
#define kColorExtractionPoint CGPointMake(30, 8)
/** 头部类别图片的center  48.5->图片的宽 10->左边距 60->headerView的高*/
#define kHeaderCategoryImageCenter CGPointMake(30, (kCreateBillHeaderViewFrame.size.height - 48.5)/2 + kMaxNBY);

#define  adjustsTableViewInsets(tableView)\
do {\
if (@available(iOS 11.0, *)) {\
tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;\
tableView.contentInset = UIEdgeInsetsZero;\
tableView.scrollIndicatorInsets = tableView.contentInset;\
}\
} while (0);

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define iPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define iPhoneX (iPhone && SCREEN_MAX_LENGTH == 812.0)

#endif /* Const_h */
