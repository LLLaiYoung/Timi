//
//  TMPieCategoryDetailViewController.m
//  Timi
//
//  Created by chairman on 16/6/22.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "TMPiewCategoryDetailViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "TMPiewCategoryDetailCell.h"
#import "TMBill.h"
#import "TMCategory.h"
#import "NSArray+TMNSArray.h"
#import "NSString+TMNSString.h"
#import "UIImage+TMUIImage.h"
static NSString *cellID = @"cell";

#define kAttributedStringColor [UIColor colorWithWhite:0.395 alpha:1.000]

@interface TMPiewCategoryDetailViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UIView *headerContainerView;
@property (nonatomic, strong) UIView *grayView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIImageView *categoryImageView;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *categoryNameLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RLMResults *results;
/**
 *  直接add到self.view即可,不需要在scrollViewDidScroll改变height
 */
@property (nonatomic, strong) UIView *footerLineView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *bills;
@end

@implementation TMPiewCategoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationBar];
    [self layoutSuview];
    [self setupUIData];
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {//iOS 11 透明navigationBar
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        //去掉导航栏底部的黑线
        self.navigationController.navigationBar.shadowImage = [UIImage new];
    } else {
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0.0];
    }
    
    //* push的有问题 */
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:nil];
    }
}

- (void)setupNavigationBar {
    UIButton *dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIImage *image = [[UIImage imageNamed:@"back_light"] imageByResizeToSize:dismissBtn.frame.size];
    [dismissBtn setImage:image forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:dismissBtn];
}

- (void)layoutSuview {
    self.headerContainerView = [UIView new];
    [self.view addSubview:self.headerContainerView];
    WEAKSELF
    CGFloat multiplied = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0") ? 0.23 : 0.25;
    [self.headerContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf.view);
        make.height.equalTo(weakSelf.view).multipliedBy(multiplied);
    }];
    self.grayView = [UIView new];
    self.grayView.backgroundColor = [UIColor colorWithWhite:0.880 alpha:1.000];
    [self.headerContainerView addSubview:self.grayView];
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf.headerContainerView);
        make.height.equalTo(weakSelf.headerContainerView).multipliedBy(0.7);
    }];
    
    self.countLabel = [UILabel new];
    [self.grayView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grayView).offset(18);
        make.bottom.equalTo(weakSelf.grayView).offset(-5);
    }];
    
    self.categoryImageView = [UIImageView new];
    [self.grayView addSubview:self.categoryImageView];
    [self.categoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.grayView);
        make.centerY.equalTo(weakSelf.grayView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    self.moneyLabel  = [UILabel new];
    self.moneyLabel.font = [UIFont systemFontOfSize:20];
    self.moneyLabel.textColor = [UIColor colorWithWhite:0.190 alpha:1.000];
    [self.grayView addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.grayView).offset(-5);
        make.bottom.equalTo(weakSelf.countLabel);
    }];
    
    self.categoryNameLabel = [UILabel new];
    self.categoryNameLabel.font = [UIFont systemFontOfSize:15.0];
    [self.headerContainerView addSubview:self.categoryNameLabel];
    [self.categoryNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.headerContainerView);
        make.bottom.equalTo(weakSelf.headerContainerView).offset(-5);
    }];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = 55;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[TMPiewCategoryDetailCell class] forCellReuseIdentifier:cellID];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerContainerView.mas_bottom);
        make.left.right.bottom.equalTo(weakSelf.view);
    }];
    

    self.tableView.tableFooterView = [UIView new];
    
    self.footerLineView = [UIView new];
    self.footerLineView.backgroundColor = LineColor;
    [self.view addSubview:self.footerLineView];
    [self.footerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerContainerView.mas_bottom);
        make.width.equalTo(@1);
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
    }];
    
}
/** 设置界面数据 */
- (void)setupUIData {
    self.results = [[TMDataBaseManager defaultManager] queryBillWithBookID:[NSString readUserDefaultOfSelectedBookID] andBeginSwithContains:self.dateString andCategoryTitle:self.categoryName];
    
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%li",self.results.count] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0],NSForegroundColorAttributeName:kAttributedStringColor}];
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@" 笔" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0],NSForegroundColorAttributeName:kAttributedStringColor}];
    [string1 appendAttributedString:string2];
    self.countLabel.attributedText = string1;
    if (self.results.count==0) {
        self.moneyLabel.text = @"0.00";
        self.categoryNameLabel.text = self.categoryName;
        if (self.type==income) {
            self.categoryImageView.image = [UIImage imageNamed:@"type_big_0"];
        } else {
            self.categoryImageView.image = [UIImage imageNamed:@"type_big_1"];
        }
        return;
    }
    TMBill *bill = self.results.firstObject;
    self.categoryImageView.image = bill.category.categoryImage;
    self.categoryNameLabel.text = bill.category.categoryTitle;
    float money = [TMCalculate queryAllMoneyWithCategotyTitleOfBookID:[NSString readUserDefaultOfSelectedBookID] andCategoryTitle:self.categoryName andDateStr:self.dateString];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",money];
    
    [self resetBill];
}
/** 重新设置数据 */
- (void)resetBill {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (TMBill *bill in self.results) {
        [array addObject:bill];
    }
    NSArray *receives = [NSArray objectSortArray:array ascending:NO];
    self.bills = [NSMutableArray array];
    NSString *previous;
    for (NSInteger i=0; i<receives.count; i++) {
        TMBill *bill = receives[i];
        if (i==0) {//第一个数据永远是不相同的
            [self.bills addObject:bill];
            previous = bill.dateStr;
            continue;
        } else {
            TMBill *theBill = [TMBill new];
            if ([previous isEqualToString:bill.dateStr]) {//完全相同,时间日期
                theBill = bill;
                theBill.same = YES;
                [self.bills addObject:theBill];
            } else if ([[previous substringToIndex:7] isEqualToString:[bill.dateStr substringToIndex:7]]) {//部分相同,年月份相同,具体时间不同
                theBill = bill;
                theBill.partSame = YES;
                [self.bills addObject:theBill];
            } else {//不同
                [self.bills addObject:bill];
            }
            previous = bill.dateStr;
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bills.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TMPiewCategoryDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TMBill *bill = self.bills[indexPath.row];
    cell.bill = bill;
    return cell;
}
#pragma mark - UITableViewDelegate


#pragma mark - action
- (void)dismiss {
    [self.navigationController popViewControllerAnimated:YES];
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
