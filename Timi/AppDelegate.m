//
//  AppDelegate.m
//  Timi
//
//  Created by chairman on 16/5/6.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "AppDelegate.h"
#import "HomePageViewController.h"
#import "TMControlManagerViewController.h"
#import <MMDrawerController.h>
#import "TMSideViewController.h"
#import "Const.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self didChangeStatusFrameNotification];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    TMControlManagerViewController *controlManageVC = [[TMControlManagerViewController alloc] init];
    UINavigationController *controlManagerVCNV = [[UINavigationController alloc] initWithRootViewController:controlManageVC];
    
    TMSideViewController *sideVC = [[TMSideViewController alloc] init];

    MMDrawerController *drawerController = [[MMDrawerController alloc] initWithCenterViewController:controlManagerVCNV leftDrawerViewController:sideVC];
    /** 设置打开/关闭抽屉的手势 */
    drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    drawerController.closeDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    drawerController.showsShadow = NO;
    /** 设置左边抽屉显示的多少 */
    drawerController.maximumLeftDrawerWidth = SCREEN_SIZE.width - 50;
    self.window.rootViewController = drawerController;
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)didChangeStatusFrameNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarFrame:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}
- (void)didChangeStatusBarFrame:(NSNotification *)noti {
    NSLog(@"%@",noti.userInfo[@"UIApplicationStatusBarFrameUserInfoKey"]);
    if ([UIApplication sharedApplication].statusBarFrame.size.height==40) {
        
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
