//
//  LYBaseViewController.h
//  HiSchool
//
//  Created by chairman on 16/4/6.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "Const.h"
#import "TMDataBaseManager.h"
#import "TMBooks.h"
@class TMBill;
@interface LYBaseViewController : UIViewController
///显示网络请求状态 顶部网络请求小菊花
-(void)showNetworkIndicator;
///隐藏网络请求状态
-(void)hideNetworkIndicator;
/////显示进度
//-(void)showProgress;
/////隐藏进度
//-(void)hideProgress;
///提示
-(void)alert:(NSString*)msg;
///错误提示
-(BOOL)alertError:(NSError*)error;
///错误过滤器
-(BOOL)filterError:(NSError*)error;
///在主线程
-(void)runInMainQueue:(void (^)())queue;
///在子线程
-(void)runInGlobalQueue:(void (^)())queue;
///延迟执行
-(void)runAfterSecs:(float)secs block:(void (^)())block;
////显示提示文字
//-(void)showHUDText:(NSString*)text;
/** SVHUD maskType:Gradi style:Dark */
- (void)showSVProgressHUD:(NSString *)text;


@end
