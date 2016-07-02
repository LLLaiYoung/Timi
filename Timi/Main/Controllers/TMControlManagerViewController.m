//
//  TMControlManagerViewController.m
//  Timi
//
//  Created by chairman on 16/5/27.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "TMControlManagerViewController.h"
#import "Const.h"
#import "HomePageViewController.h"
#import "TMPiewViewController.h"
#import "TYPagerController.h"
@interface TMControlManagerViewController ()
<
TYPagerControllerDataSource,
TYPagerControllerDelegate
>
@property (nonatomic, strong) TYPagerController *pagerController;
@end

@implementation TMControlManagerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    TYPagerController *pagerController = [[TYPagerController alloc] init];
    pagerController.dataSource = self;
    pagerController.delegate = self;
    pagerController.view.frame = self.view.bounds;
    [self addChildViewController:pagerController];
    [self.view addSubview:pagerController.view];
    _pagerController = pagerController;
    /** 默认第一个为UIBarStyleBlack */
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _pagerController.view.frame = self.view.bounds;
}
#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController{
    return 2;
}

// viewController at index in pagerController
#warning 如果Return Navi 则 push 的控制器能左右滑动
- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index {
    if (index==0) {
        return [HomePageViewController new];
    } else {
        return [TMPiewViewController new];
    }
}
#pragma mark - TYPagerControllerDelegate

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)formIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    NSLog(@"transitionFromIndex = %li toIndex = %li",formIndex,toIndex);
    if (toIndex==0) {
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    } else {
        [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
