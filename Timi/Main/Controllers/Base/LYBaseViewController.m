//
//  LYBaseViewController.m
//  HiSchool
//
//  Created by chairman on 16/4/6.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "LYBaseViewController.h"
//#import <MBProgressHUD.h>
#import <SVProgressHUD.h>
@interface LYBaseViewController ()

@end

@implementation LYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /** 解决容器是navigation controller时，默认的布局将从navigation bar的顶部开始。解决所有的UI元素都往上漂移了44pt。 */
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //* 解决tableView origin.y=64 导致的初始化整体下移64个单位*/
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

///显示网络请求状态 顶部网络请求小菊花
-(void)showNetworkIndicator {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
///隐藏网络请求状态
-(void)hideNetworkIndicator {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
/////显示进度
//-(void)showProgress {
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//}
/////隐藏进度
//-(void)hideProgress {
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//}
///提示
-(void)alert:(NSString*)msg {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
///错误提示
-(BOOL)alertError:(NSError*)error {
    if (error) {
        [self alert:[NSString stringWithFormat:@"%@",error]];
        return YES;
    }
    return NO;
}
///错误过滤器
-(BOOL)filterError:(NSError*)error {
    return [self alertError:error]==NO;//如果alertError返回NO filterError返回YES
}
///在主线程
-(void)runInMainQueue:(void (^)())queue {
    dispatch_async(dispatch_get_main_queue(), queue);
}
///在子线程
-(void)runInGlobalQueue:(void (^)())queue {
    dispatch_async(dispatch_get_global_queue(0, 0), queue);
}
///延迟执行
-(void)runAfterSecs:(float)secs block:(void (^)())block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), block);
}
////显示提示文字
//-(void)showHUDText:(NSString*)text {
//    MBProgressHUD* hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText=text;
//    hud.margin=10.f;
//    hud.removeFromSuperViewOnHide=YES;
//    hud.mode=MBProgressHUDModeText;
//    [hud hide:YES afterDelay:2];
//}

#pragma mark - SVProgressHUD 
- (void)showSVProgressHUD:(NSString *)text {
    [SVProgressHUD setMinimumDismissTimeInterval:0.5];
    [SVProgressHUD showImage:nil status:text];
//    [SVProgressHUD setMinimumSize:CGSizeMake(100, 60)];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:18]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
}

@end
