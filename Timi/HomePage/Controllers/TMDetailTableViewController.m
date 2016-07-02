//
//  TMDetailTableViewController.m
//  Timi
//
//  Created by chairman on 16/6/16.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "TMDetailTableViewController.h"
#import "TMDataBaseManager.h"
#import "TMDetailViewCell.h"
#import <UIViewController+MMDrawerController.h>
#import "NSArray+TMNSArray.h"
#import "NSString+TMNSString.h"
/** 编辑按钮文本颜色 */
#define kEditBtnTitleColor [UIColor colorWithWhite:0.575 alpha:1.000]

@interface TMDetailTableViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *allBills;
@end
static NSString * const cellID = @"detailViewCell";
@implementation TMDetailTableViewController

- (NSArray *)allBills
{
    if (!_allBills) {
        NSMutableArray *mutableArray = [NSMutableArray new];
        RLMResults *results = [[TMDataBaseManager defaultManager] queryAllBillsWithBookID:[NSString readUserDefaultOfSelectedBookID]];
        for (TMBill *bill in results) {
            [mutableArray addObject:bill];
        }
        _allBills = [NSArray objectSortArray:mutableArray ascending:NO];
    }
    return _allBills;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self layoutSubviews];
    [self.tableView setContentOffset:CGPointMake(0, _currentIndex * SCREEN_SIZE.height) animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0.0];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}

- (void)setupNavigationBar {
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [backBtn setImage:[UIImage imageNamed:@"back_light"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)layoutSubviews {
    self.tableView = [UITableView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.pagingEnabled = YES;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = SCREEN_SIZE.height;
    [self.tableView registerClass:[TMDetailViewCell class] forCellReuseIdentifier:cellID];
    [self.view addSubview:self.tableView];
    WEAKSELF
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    UIButton *shareBtn = [UIButton new];
    [shareBtn addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"button_edge"] forState:UIControlStateNormal];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:kEditBtnTitleColor forState:UIControlStateNormal];
    [self.view addSubview:shareBtn];
    [shareBtn makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(60, 60));
        make.right.bottom.equalTo(weakSelf.view).offset(-10);
    }];
    
    UIButton *editBtn = [UIButton new];
    [editBtn addTarget:self action:@selector(clickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setBackgroundImage:[UIImage imageNamed:@"button_edge"] forState:UIControlStateNormal];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitleColor:kEditBtnTitleColor forState:UIControlStateNormal];
    [self.view addSubview:editBtn];
    [editBtn makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(shareBtn);
        make.right.equalTo(shareBtn.left).offset(-30);
        make.bottom.equalTo(shareBtn);
    }];
}
#pragma mark - action
- (void)dismiss {
    [self.navigationController  popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickShareBtn:(UIButton *)sender {
    NSLog(@"click shareBtn");
    TMBill *bill = self.allBills[_currentIndex];
    NSLog(@"line = %i,bill = %@",__LINE__,bill);
}
- (void)clickEditBtn:(UIButton *)sender {
    NSLog(@"click editBtn");
    TMBill *bill = self.allBills[_currentIndex];
    NSLog(@"%i,%@",__LINE__,bill);
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allBills.count;
}
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TMDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailBill = self.allBills[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    _currentIndex = indexPath.row;
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
