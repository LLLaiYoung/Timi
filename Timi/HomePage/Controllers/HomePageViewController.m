//
//  HomePageViewController.m
//  Timi
//
//  Created by chairman on 16/5/6.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "HomePageViewController.h"
#import "TMDataBaseManager.h"
#import "TMBill.h"
#import "TMCategory.h"
#import "TMTimeLineCell.h"
#import "TMTimeLineMenuView.h"
#import "TMHeaderView.h"
#import "TMButton.h"
#import "TMCalculate.h"
#import <MMDrawerBarButtonItem.h>
#import <UIViewController+MMDrawerController.h>
#import "TMCreateBillViewController.h"
#import "CCColorCube.h"
#import "TMDetailTableViewController.h"
#import "LYPushTransition.h"
#import "LYPopTransition.h"
#import "TMCategoryButton.h"
#import "NSString+TMNSString.h"
#import "NSArray+TMNSArray.h"
//* 导航栏字体大小 */
#define kTitleTextFont 14.0f
//* 导航栏btnSize */
#define kTitleBtnSize CGSizeMake( 60, 25)
/** Notification */
NSString *const homeReloadNotifiation = @"homeReloadData";

static NSString *const timeLineCell = @"timeLineCell";

@interface HomePageViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
TMTimeLineCellDelegate,
TMTimeLineMenuViewDelegate,
TMHeaderViewDelegate,
TMCreateBillViewControllerDelegate,
UIViewControllerTransitioningDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TMTimeLineMenuView *timeLineMenuView;
/** 记录点击的cell,用于隐藏cell的label */
@property (nonatomic, strong) TMTimeLineCell *timeLineCell;
@property (nonatomic, strong) TMHeaderView *headerView;
/** 是否打开时光轴菜单 */
@property (nonatomic, assign, getter=isOpenMenu) BOOL openMenu;
/** 时光轴下拉线条 */
@property (nonatomic, strong) UIView *dropdownLineView;
/** 导航栏title按钮 */
@property (nonatomic, strong) UIButton *titleBtn;
/** 标题按钮 */
@property (nonatomic, assign, getter=isOpenTitleBtn) BOOL openTitleBtn;
/** 选择的账单 */
@property (nonatomic, strong) TMBill *selectedBill;

@property (nonatomic, strong) RLMResults *results;
@property (nonatomic, strong) NSMutableArray *bills;
/** 新账本 无数据时候 */
@property (nonatomic, strong) UILabel *newsBooksLabel;
/** 数据库更新通知 需要强引用 */
@property (nonatomic, strong) RLMNotificationToken *token;

@property (nonatomic, strong) TMBooks *book;

@end

@implementation HomePageViewController


#pragma mark - lazy loading

- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kHeaderViewHeight, SCREEN_SIZE.width, SCREEN_SIZE.height - kHeaderViewHeight)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = LinebgColor;
        tableView.rowHeight = 64.0;
        _tableView = tableView;
    }
    return _tableView;
}
#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _book = [[TMDataBaseManager defaultManager] queryBooksWithBookID:[NSString readUserDefaultOfSelectedBookID]];
    
    [self layoutSubviews];
    
    [self.headerView calculateMoney];
    WEAKSELF
    _token = [[TMBill allObjects] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        [weakSelf.headerView calculateMoney];
        [weakSelf loadingPieView];
        [weakSelf getDataAndResetBill];
    }];
    [[TMDataBaseManager defaultManager] numberOfAllBooksCount];// ignory

    
    UIScreenEdgePanGestureRecognizer *screenEdgeGR = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(clickMenuBtn:)];
    screenEdgeGR.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:screenEdgeGR];
    
    [self registerNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置打开抽屉模式
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];

}
#pragma mark - Notification
- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedBook) name:homeReloadNotifiation object:nil];
}
- (void)changedBook {
    [self getDataAndResetBill];
    [self loadingPieView];
    [self.headerView calculateMoney];
    _book = [[TMDataBaseManager defaultManager] queryBooksWithBookID:[NSString readUserDefaultOfSelectedBookID]];
    [_titleBtn setTitle:_book.bookName forState:UIControlStateNormal];
    CGFloat width = [self titleBtnSizeWithTitle:_book.bookName].width;
    [_titleBtn updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(width);

    }];
}

#pragma mark - about UI

/**
 *  获取数据并重新设置数据
 *  先拿到所有数据,添加到数组
 *  进行排序,将排好序的数组进行数据的重新设置
 */

- (void)getDataAndResetBill {
    
    self.bills = [NSMutableArray array];
    self.results = [[TMDataBaseManager defaultManager] queryAllBillsWithBookID:[NSString readUserDefaultOfSelectedBookID]];
    if (self.results.count==0) {//当数据为空时候
        [self.tableView bringSubviewToFront:self.newsBooksLabel];
        TMBill *bill = [TMBill new];
        bill.dateStr = [NSString currentDateStr];
        bill.empty = YES;
        [self.bills addObject:bill];
        [self.tableView reloadData];
        return;
    }
    [self.tableView sendSubviewToBack:self.newsBooksLabel];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (TMBill *bill in self.results) {
        [array addObject:bill];
    }
    NSArray *receives = [NSArray objectSortArray:array ascending:NO];
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
            } else {//不同
                [self.bills addObject:bill];
            }
            previous = bill.dateStr;
        }
    }
    [self.tableView reloadData];
}
/** 根据账本名称获取size*/
- (CGSize)titleBtnSizeWithTitle:(NSString *)title {
    CGFloat width = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kTitleTextFont]}].width + 20;
    return CGSizeMake(width, 25);
}
- (void)layoutSubviews {

    self.timeLineMenuView = [[TMTimeLineMenuView alloc] initWithFrame:self.view.frame];
    self.timeLineMenuView.timeLineMenuDelegate = self;
    [self.view addSubview:self.timeLineMenuView];
    
    self.dropdownLineView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_SIZE.width-1)/2,0 , 1, 0)];
    self.dropdownLineView.backgroundColor = LineColor;
    [self.tableView addSubview:self.dropdownLineView];
    //* 放到tableView的最底层 */
    [self.tableView sendSubviewToBack:self.dropdownLineView];
    
    
    self.headerView = [[TMHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, kHeaderViewHeight)];

    self.headerView.backgroundColor = LinebgColor;
    self.headerView.headerViewDelegate = self;
    [self.view addSubview:self.headerView];
    TMButton *menuBtn = [TMButton new];
    [menuBtn setImage:[UIImage imageNamed:@"btn_menu"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(clickMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:menuBtn];
    [menuBtn makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(40, 40));
        make.left.equalTo(10);
        make.top.equalTo(25);
    }];
    
    _titleBtn = [UIButton new];
    [_titleBtn setBackgroundColor:[UIColor colorWithWhite:0.278 alpha:0.500]];
    _titleBtn.layer.cornerRadius = kTitleBtnSize.height/2;
    _titleBtn.alpha = 0.7;
    /** 设置边框宽度 */
    _titleBtn.layer.borderWidth = 1.5;
    //* 设置Btn的边框颜色 */
    _titleBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _titleBtn.titleLabel.font = [UIFont systemFontOfSize:kTitleTextFont];
    [_titleBtn setTitle:_book.bookName forState:UIControlStateNormal];
    [_titleBtn setTintColor:[UIColor whiteColor]];
    [_titleBtn addTarget:self action:@selector(clickTitltBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:_titleBtn];
    WEAKSELF
    [_titleBtn makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo([weakSelf titleBtnSizeWithTitle:weakSelf.book.bookName]);
        make.centerX.equalTo(weakSelf.headerView);
        make.centerY.equalTo(menuBtn);
    }];

    
    TMButton *cameraBtn = [TMButton new];
    [cameraBtn setImage:[UIImage imageNamed:@"btn_camera"] forState:UIControlStateNormal];
    [cameraBtn addTarget:self action:@selector(clickCameraBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:cameraBtn];
    [cameraBtn makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(menuBtn);
        make.centerY.equalTo(menuBtn);
        make.right.equalTo(-10);
    }];
    
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[TMTimeLineCell class] forCellReuseIdentifier:timeLineCell];
    
    //* 隐藏滚动条 */
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.newsBooksLabel = [UILabel new];
    self.newsBooksLabel.text = @"新账本";
    self.newsBooksLabel.textColor = LineColor;
    self.newsBooksLabel.font = [UIFont systemFontOfSize:20.0f];
    [self.tableView addSubview:self.newsBooksLabel];

    [self.newsBooksLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.tableView).offset(30);
    }];
    [self.tableView sendSubviewToBack:self.newsBooksLabel];
}
/** 加载饼图 */
- (void)loadingPieView {
    
    NSDictionary *dataDic = [[TMDataBaseManager defaultManager] getPieDataWithBookID:[NSString readUserDefaultOfSelectedBookID] andDateSting:@"ALL" andPaymentType:allPayment];
    NSArray *allValues = dataDic.allValues;
    NSMutableArray *sections = [NSMutableArray array];
    NSMutableArray *sectionColors = [NSMutableArray array];
    WEAKSELF
    [self runInGlobalQueue:^{
        [allValues enumerateObjectsUsingBlock:^(TMBill *bill, NSUInteger idx, BOOL * _Nonnull stop) {
            [sections addObject:bill.money];
            CCColorCube *imageColor = [[CCColorCube alloc] init];
            NSArray *colors = [imageColor extractColorsFromImage:bill.category.categoryImage flags:CCAvoidBlack count:1];
            [sectionColors addObject:colors.firstObject];
        }];
        if (sections.count==0) {
            [sections addObject:@100];
            [sectionColors addObject:LineColor];
        }
        [weakSelf runInMainQueue:^{
            [weakSelf.headerView loadPieViewWihtSection:sections withColors:sectionColors];
        }];
    }];

    
}
#pragma mark - Item Action
- (void)clickMenuBtn:(UIButton *)sender {
//    NSLog(@"click MenuBtn");
    //* 不加判断则会 开->关->开 无限循环 */
    if (self.mm_drawerController.openSide == MMDrawerSideNone) {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        return;
    }
    
}
- (void)clickCameraBtn:(UIButton *)sender {
    NSLog(@"click CameraBtn");
}
- (void)clickTitltBtn:(UIButton *)sender {
//    NSLog(@"click TitleBtn");
    WEAKSELF
    //* 改变titleBtn的颜色 */
    [UIView animateWithDuration:0.3f delay:0.2f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [weakSelf.titleBtn setBackgroundColor:[UIColor colorWithRed:1.000 green:0.812 blue:0.124 alpha:1.000]];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [weakSelf.titleBtn setBackgroundColor:[UIColor colorWithWhite:0.278 alpha:0.500]];
        } completion:^(BOOL finished) {
            
        }];
    }];
    NSString *titleStr = nil;
    if (!self.isOpenTitleBtn) {
        self.openTitleBtn = YES;
        titleStr = [NSString stringWithFormat:@"余额 %.2f",[TMCalculate queryAmountOfPriceDifferenceWithBookID:[NSString readUserDefaultOfSelectedBookID]]];
        CGFloat width = [self titleBtnSizeWithTitle:titleStr].width;
        [weakSelf.titleBtn updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(width);
        }];
    } else {
        self.openTitleBtn = NO;
        [weakSelf.titleBtn updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo([weakSelf titleBtnSizeWithTitle:weakSelf.book.bookName]);
        }];
        titleStr = _book.bookName;
    }
    [weakSelf.titleBtn setTitle:titleStr forState:UIControlStateNormal];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bills.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TMTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:timeLineCell forIndexPath:indexPath];
    cell.backgroundColor = LinebgColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    cell.cellDeletega = self;
    if (indexPath.row==self.bills.count-1) {
        cell.lastBill = YES;
    }
    TMBill *bill = self.bills[indexPath.row];

    cell.timeLineBill = bill ;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF
    TMBill *bill = self.bills[indexPath.row];
    if (bill.isEmpty) {
        return;
    }
    TMDetailTableViewController *detailVC = [[TMDetailTableViewController alloc] init];
    detailVC.currentIndex = indexPath.row;

    [weakSelf.navigationController pushViewController:detailVC animated:YES];

}


#pragma mark - TMTimeLineCellDelegate
- (void)didClickCategoryBtnWithIndexPath:(NSIndexPath *)indexPath {
    self.selectedBill = self.bills[indexPath.row];
    if (self.selectedBill.isEmpty) {
        return;
    }
    self.openMenu = YES;
    self.timeLineCell = [self.tableView cellForRowAtIndexPath:indexPath];
    /** 获取cell在tableView中的位置 */
    CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
    //* 转换成在self.view中的位置 */
    CGRect rectInSuperview = [self.tableView convertRect:rect toView:[self.tableView superview]];
    self.timeLineMenuView.currentImage = self.timeLineCell.categoryImageBtn.currentImage;
    [self.timeLineMenuView showTimeLineMenuViewWithRect:rectInSuperview ];
}
#pragma mark - TMTimeLineMenuViewDelegate
- (void)hiddenCellLabelWithBool:(BOOL)hidden {
    [self.timeLineCell cellLabelWithHidden:hidden];
}
- (void)clickDeleteBtn {
    WEAKSELF
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您是否确定要删除所选账目?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.timeLineMenuView dismiss];
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"selected = %@",weakSelf.selectedBill);
        [[TMDataBaseManager defaultManager] deleteWithBill:weakSelf.selectedBill];
        weakSelf.timeLineCell.clickedDelete = YES;
        [weakSelf.timeLineMenuView dismiss];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)clickUpdateBtn {
    TMCreateBillViewController *createBillVC = [TMCreateBillViewController new];
    createBillVC.update = YES;
    createBillVC.bill = self.selectedBill;
    createBillVC.tmCreateBillDelegate = self;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:createBillVC];
    navi.transitioningDelegate = self;
    WEAKSELF
    [self presentViewController:navi animated:YES completion:^{
        [weakSelf.timeLineMenuView dismiss];
    }];
}
#pragma mark - TMHeaderViewDelegate
- (void)didClickPieInCreateBtn {

    TMCreateBillViewController *createBillVC = [[TMCreateBillViewController alloc] init];
    createBillVC.tmCreateBillDelegate = self;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:createBillVC];
    navi.transitioningDelegate = self;
    [self presentViewController:navi animated:YES completion:nil];
}
#pragma mark - TMCreateBillViewControllerDelegate
- (void)clickDismissBtnWithTMCreateBillViewController:(TMCreateBillViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UIViewControllerTransitioningDelegate
/** prensent */
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [LYPushTransition new];
}
/** dismiss */
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [LYPopTransition new];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /** 当下拉的时候才有动画  y>0下拉,y<0上划*/
    CGFloat  y = [scrollView.panGestureRecognizer translationInView:self.tableView].y;
//    NSLog(@"%s--%d---y = %f",__func__,__LINE__,y);
    if (y>0) {
        /**
         *  疑问:为什么是`y`是`-y`不是`0`,因为`dropdownLineView`是添加到`tableView`的,所以当`tabelView`拉下的时候`dropdownLineView`也会跟着向下移动。
         *  当`y`是`-y`的时候`dropdownLineView`会向上移动`y`个单位,才会达到我们理想的效果
         */
        self.dropdownLineView.frame = CGRectMake((SCREEN_SIZE.width-1)/2, -y, 1, y);
        [self.tableView bringSubviewToFront:self.dropdownLineView];
        
        [self.headerView animationWithCreateBtnDuration:1.0f angle:y];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.isOpenMenu) {
        self.openMenu = NO;
        [self.timeLineMenuView dismiss];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    //    NSLog(@"contentOffsetY = %f",contentOffsetY);
    if (contentOffsetY < -60) {//下拉push
        [self didClickPieInCreateBtn];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"good by HomePageViewController");
    [_token stop];
    [[NSNotificationCenter defaultCenter ] removeObserver:self];
}

@end




