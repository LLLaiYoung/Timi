//
//  TMCreateBillViewController.m
//  Timi
//
//  Created by chairman on 16/5/25.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//


#import "TMCreateBillViewController.h"
#import "TMCreateHeaderView.h"
#import "TMCategoryCollectionViewFlowLayout.h"
#import "TMCategotyCollectionViewCell.h"
#import "TMCategory.h"
#import <Masonry.h>
#import "TMButton.h"
#import "TMDataBaseManager.h"
#import "CCColorCube.h"
#import "TMCalculatorView.h"
#import "TMBill.h"
#import "TMCategory.h"
#import "SZCalendarPicker.h"
#import "TMRemarkViewController.h"
#import "TMModifyCategoryNameView.h"
#import "TMAddCategoryViewController.h"
#import "NSString+TMNSString.h"
static NSString *const collectionIdentifier = @"categoryCell";
@interface TMCreateBillViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic, strong) TMCreateHeaderView *headerView;
/** 支出collectionView1 */
@property (nonatomic, strong) UICollectionView *expenCategoryCollectionView;
/** 支出collectionView2 */
@property (nonatomic, strong) UICollectionView *expenCategoryCollectionView2;
@property (nonatomic, strong) UICollectionView *incomeCategoryCollectionView;
/** add expendCategoryCollectionView 1&2  */
@property (nonatomic, strong) UIScrollView *expendCategoryScrollView;
@property (nonatomic, strong) UIPageControl *pageController;
/** NavigationTitleContainer add incomeBtn,expendBtn */
@property (nonatomic, strong) UIView *titleView;
/**
 *  隔板:解决self.view的子控制器只有两层view,把incomeCategoryCollectionView放到最后面滑动scroller能看到incomeCategoryCollectionView
 */
@property (nonatomic, strong) UIView *clapboard;
/** NavigationTitleView 收入按钮*/
@property (nonatomic, strong) TMButton *incomeBtn;
/** NavigationTitleView 支出按钮*/
@property (nonatomic, strong) TMButton *expendBtn;
/** 最后几个支出类别 */
@property (nonatomic, strong) NSArray *lastfewExpendCategorys;
/** 选择的类别图片,用于动画 */
@property (nonatomic, strong) UIImageView *selectCategoryImageView;
/** 计算器 */
@property (nonatomic, strong) TMCalculatorView *calculatorView;
/** 修改类别名称视图 */
@property (nonatomic, strong) TMModifyCategoryNameView *categoryNameView;
/** 类别编辑容器 */
@property (nonatomic, strong) UIView *categoryEditContainerView;
/** 更新的时间 */
@property (nonatomic, strong) NSString *updateTimeStr;
/** 备注 */
@property (nonatomic, strong) NSString *remarks;
/** 备注照片 */
@property (nonatomic, strong) NSData *photoData;
/** 选择的类别 */
@property (nonatomic, strong) TMCategory *selectedCategory;
/** 收入? */
@property (nonatomic, assign, getter=isIcome) BOOL income;
/** 金额 */
@property (nonatomic, assign) double money;
@end

@implementation TMCreateBillViewController
#pragma mark - lazy loading

- (TMCalculatorView *)calculatorView
{
    if (!_calculatorView) {
        _calculatorView = [[[NSBundle mainBundle] loadNibNamed:@"TMCalculatorView" owner:nil options:nil] lastObject];
        _calculatorView.frame =CGRectMake(0, CGRectGetMaxY(_pageController.frame), SCREEN_SIZE.width, SCREEN_SIZE.height - CGRectGetMaxY(_pageController.frame));
    }
    return _calculatorView;
}

- (TMButton *)expendBtn
{
    if (!_expendBtn) {
        TMButton *button = [[TMButton alloc]init];
        [button setTitle:@"支出" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:kSelectColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(clickExpendBtn:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        
        _expendBtn = button;
    }
    return _expendBtn;
}

- (TMButton *)incomeBtn
{
    if (!_incomeBtn) {
        TMButton *button = [[TMButton alloc]init];
        [button setTitle:@"收入" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:kSelectColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(clickIncomeBtn:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        
        _incomeBtn = button;
    }
    return _incomeBtn;
}

- (UICollectionView *)expenCategoryCollectionView {
    if (!_expenCategoryCollectionView) {
        _expenCategoryCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, (kCollectionCellWidth+20 + 10) * 4 - 10) collectionViewLayout:[[TMCategoryCollectionViewFlowLayout alloc] init]];
        _expenCategoryCollectionView.delegate = self;
        _expenCategoryCollectionView.dataSource = self;
        _expenCategoryCollectionView.backgroundColor = [UIColor whiteColor];
    }
    return _expenCategoryCollectionView;
}
- (UICollectionView *)expenCategoryCollectionView2
{
    if (!_expenCategoryCollectionView2) {
        _expenCategoryCollectionView2 = [[UICollectionView alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width, 0, SCREEN_SIZE.width, (kCollectionCellWidth+20 + 10) * 4 -10) collectionViewLayout:[[TMCategoryCollectionViewFlowLayout alloc] init]];
        _expenCategoryCollectionView2.delegate = self;
        _expenCategoryCollectionView2.dataSource = self;
        _expenCategoryCollectionView2.backgroundColor = [UIColor whiteColor];
    }
    return _expenCategoryCollectionView2;
}
- (UICollectionView *)incomeCategoryCollectionView
{
    if (!_incomeCategoryCollectionView) {
        _incomeCategoryCollectionView = [[UICollectionView alloc] initWithFrame:kCollectionFrame collectionViewLayout:[[TMCategoryCollectionViewFlowLayout alloc] init]];
        _incomeCategoryCollectionView.delegate = self;
        _incomeCategoryCollectionView.dataSource = self;
        _incomeCategoryCollectionView.backgroundColor = [UIColor whiteColor];
    }
    return _incomeCategoryCollectionView;
}

- (UIScrollView *)expendCategoryScrollView
{
    if (!_expendCategoryScrollView) {
        _expendCategoryScrollView = [[UIScrollView alloc] initWithFrame:kCollectionFrame];
        _expendCategoryScrollView.contentSize = CGSizeMake(kCollectionFrame.size.width * 2, kCollectionFrame.size.height);
        _expendCategoryScrollView.delegate = self;
        [_expendCategoryScrollView addSubview:self.expenCategoryCollectionView];
        [_expendCategoryScrollView addSubview:self.expenCategoryCollectionView2];
    }
    return _expendCategoryScrollView;
}
- (UIPageControl *)pageController
{
    if (!_pageController) {
        _pageController = [[UIPageControl alloc] initWithFrame:kPageControllerFrame];
        _pageController.numberOfPages = 2;
        _pageController.userInteractionEnabled = NO;
        _pageController.pageIndicatorTintColor = [UIColor colorWithWhite:0.829 alpha:1.000];
        _pageController.currentPageIndicatorTintColor = kSelectColor;
    }
    return _pageController;
}
- (UIImageView *)selectCategoryImageView
{
    if (!_selectCategoryImageView) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -30, kCollectionCellWidth-20, kCollectionCellWidth-20)];
        imageView.layer.cornerRadius = (kCollectionCellWidth - 20)/2;
//        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _selectCategoryImageView = imageView;
    }
    return _selectCategoryImageView;
}


#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationBar];
    [self layoutSubViews];
    [self collectionViewRegisterClass];
    self.expendCategoryScrollView.pagingEnabled = YES;
    /** 设置滚动条不可见 */
    self.expendCategoryScrollView.showsHorizontalScrollIndicator = NO;
    self.expendBtn.selected = YES;
    //* 非修改状态 */
    if (!self.isUpdade) {
        [self setupBill];
    } else {
        [self setupUpdataBill];
        if (self.bill.isIncome.boolValue) {
            [self updateBillWithIncomeBtn:self.incomeBtn];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /** 设置navigationBar透明 */
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0.0];
    
    [self reloadData];
    
}
/** 刷新数据 */
- (void)reloadData {
    RLMResults *results = [[TMDataBaseManager defaultManager] queryCategorysWithPaymentType:expend];
    
    NSMutableArray *allCategorys = [NSMutableArray array];
    for (TMCategory *category in results) {
        [allCategorys addObject:category];
    }
    NSRange range = NSMakeRange(24, results.count-24);//从0开始 所以 24-1
    self.lastfewExpendCategorys = [allCategorys subarrayWithRange:range];
    [self.incomeCategoryCollectionView reloadData];
    [self.expenCategoryCollectionView2 reloadData];
}
#pragma mark - setupBill
/** 设置更新账单参数 */
- (void)setupUpdataBill {
    [self.headerView categoryImageWithFileName:self.bill.category.categoryImageFileNmae andCategoryName:self.bill.category.categoryTitle];
    CCColorCube *imageColor = [[CCColorCube alloc] init];
    NSArray *colors = [imageColor extractColorsFromImage:self.bill.category.categoryImage flags:CCAvoidBlack count:1];
    self.headerView.backgroundColor = colors.firstObject;
    [self.headerView updateMoney:[NSString stringWithFormat:@"%@.00",self.bill.money.stringValue]];
    self.money = self.bill.money.doubleValue;
    self.updateTimeStr = self.bill.dateStr;
    self.remarks = self.bill.reMarks;
    self.photoData = self.bill.remarkPhoto;
    self.selectedCategory = self.bill.category;
    [self.calculatorView setTimeWtihTimeString:self.bill.dateStr];

    NSArray *colorss = [imageColor extractColorsFromImage:self.bill.category.categoryImage flags:CCAvoidBlack count:1];
    [self.headerView animationWithBgColor:colorss.firstObject];
    self.headerView.backgroundColor = colorss.firstObject;
}
/** 设置账单默认参数 */
- (void)setupBill {
    self.bill = [TMBill new];
    /** 默认数据 */
    self.bill.dateStr = [NSString currentDateStr];
    self.bill.isIncome = @NO;
    self.selectedCategory = [[TMDataBaseManager defaultManager] queryCategorysWithPaymentType:expend].firstObject;
    [self.headerView categoryImageWithFileName:self.selectedCategory.categoryImageFileNmae andCategoryName:self.selectedCategory.categoryTitle];
    [self.headerView animationWithBgColor:[UIColor colorWithRed:0.485 green:0.686 blue:0.667 alpha:1.000]];
    self.headerView.backgroundColor = [UIColor colorWithRed:0.485 green:0.686 blue:0.667 alpha:1.000];
}
/** 当修改账单为收入类型 */
- (void)updateBillWithIncomeBtn:(TMButton *)sender {
    self.income = YES;
    sender.selected = YES;
    self.expendBtn.selected = NO;
    [self.view bringSubviewToFront:self.incomeCategoryCollectionView];
    [self.view bringSubviewToFront:self.headerView];
    [self.view sendSubviewToBack:self.expendCategoryScrollView];
    
    [self.headerView categoryImageWithFileName:self.bill.category.categoryImageFileNmae andCategoryName:self.bill.category.categoryTitle];

    CCColorCube *imageColor = [[CCColorCube alloc] init];
    NSArray *colors = [imageColor extractColorsFromImage:self.bill.category.categoryImage flags:CCAvoidBlack count:1];
    //* 设置HeaderView的背景颜色 */
    [self.headerView animationWithBgColor:colors.firstObject];
    self.pageController.numberOfPages = 1;
    [self.incomeCategoryCollectionView reloadData];
}
#pragma mark - layoutSubviews
/** 布局子控件 */
- (void)layoutSubViews {
    self.headerView = [[TMCreateHeaderView alloc] initWithFrame:kCreateBillHeaderViewFrame];
    [self.view addSubview:self.headerView];
    
    [self.view addSubview:self.selectCategoryImageView];
    [self.view sendSubviewToBack:self.selectCategoryImageView];
    
    [self.view addSubview:self.incomeCategoryCollectionView];
    [self.view sendSubviewToBack:self.incomeCategoryCollectionView];
    
    self.clapboard = [[UIView alloc] initWithFrame:kCollectionFrame];
    self.clapboard.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.clapboard];
    
    [self.view bringSubviewToFront:self.headerView];
    
    [self.view addSubview:self.expendCategoryScrollView];
    
    [self.view addSubview:self.pageController];
    
    self.categoryEditContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.categoryEditContainerView];
    
    TMModifyCategoryNameView * modifyView = [[TMModifyCategoryNameView alloc] initWithFrame:CGRectMake(37.5, 166, 300, 140)];
    self.categoryNameView = modifyView;
    [self.categoryEditContainerView addSubview:modifyView];
    [self.view sendSubviewToBack:self.categoryEditContainerView];

    //* --------------------------ACTION----------------------------- */
    WEAKSELF
    self.headerView.clickCategoryName = ^ {
        weakSelf.categoryNameView.category = weakSelf.selectedCategory;
        //* 设置子视图不跟随父视图透明 */
        weakSelf.categoryEditContainerView.backgroundColor = [UIColor colorWithWhite:0.750 alpha:0.3] ;
        [weakSelf.view bringSubviewToFront:weakSelf.categoryEditContainerView];
        [weakSelf.categoryNameView becomeFirstResponder];
    };
    
    self.categoryNameView.clickSureBtn = ^ {
        if ([weakSelf.categoryNameView.categoryName isEqualToString:@""] || weakSelf.categoryNameView.categoryName.length>3) {
            [weakSelf showSVProgressHUD:@"长度错误!"];
        } else {
            [weakSelf.selectedCategory modifyCategoryTitle:weakSelf.categoryNameView.categoryName];
            [weakSelf.headerView categoryImageWithFileName:weakSelf.selectedCategory.categoryImageFileNmae andCategoryName:weakSelf.selectedCategory.categoryTitle];
            [weakSelf.incomeCategoryCollectionView reloadData];
            [weakSelf.expenCategoryCollectionView reloadData];
            [weakSelf.expenCategoryCollectionView2 reloadData];
        }
    };
    
    self.calculatorView.passValuesBlock = ^ (NSString *string){
        [weakSelf.headerView updateMoney:string];
        if (!weakSelf.isUpdade) {
            weakSelf.bill.money = @(string.doubleValue);
        } else {
            if (string.floatValue > 0.0) {
                weakSelf.money = string.doubleValue;
            }
        }
    };
    self.calculatorView.didClickSaveBtnBlock = ^ {
        if (!weakSelf.isUpdade) {
            if (weakSelf.bill.money.floatValue <= 0.0) {
                [weakSelf showSVProgressHUD:@"请输入有效金额!"];
                [weakSelf.headerView shakingAnimation];
            } else {
                weakSelf.bill.category = weakSelf.selectedCategory;
                NSString *bookID = [NSString readUserDefaultOfSelectedBookID];
                TMBooks *book = [[TMDataBaseManager defaultManager] queryBooksWithBookID:bookID];
                weakSelf.bill.books = book;
                [[TMDataBaseManager defaultManager] insertWithBill:weakSelf.bill];
                [weakSelf dismiss];
            }
        } else {
            if (weakSelf.money <= 0.0) {
                [weakSelf showSVProgressHUD:@"请输入有效金额!"];
                [weakSelf.headerView shakingAnimation];
            } else {
                [weakSelf updateBill];
                [weakSelf dismiss];
            }
        }
    };
    self.calculatorView.didClickDateBtnBlock = ^ {
        [weakSelf SZCalendatPicker];
    };
    self.calculatorView.didClickRemarkBtnBlock = ^ {
        NSLog(@"%s,line = %i,%@",__func__,__LINE__,[NSThread currentThread]);
        [weakSelf runInMainQueue:^{
            NSLog(@"%s,line = %i,%@",__func__,__LINE__,[NSThread currentThread]);
           TMRemarkViewController *remarkVC = [[TMRemarkViewController alloc] init];
            remarkVC.passbackBlock = ^(NSString *remarks,NSData *photoData) {
                if (weakSelf.isUpdade) {
                    NSLog(@"line = %i,remarks = %@,photoData = %@",__LINE__,remarks,photoData);
                    weakSelf.remarks = remarks;
                    weakSelf.photoData = photoData;
                } else {
                    weakSelf.bill.reMarks = remarks;
                    weakSelf.bill.remarkPhoto = photoData;
                }
            };
            NSLog(@"%s,line = %i,%@",__func__,__LINE__,[NSThread currentThread]);
            remarkVC.bill = weakSelf.bill;
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:remarkVC];
            [weakSelf presentViewController:navi animated:YES completion:nil];
        }];
    };
    
    [self.view addSubview:self.calculatorView];
}

- (void)updateBill {
    [self.bill updateIncome:@(self.isIcome)];
    [self.bill updateMoney:@(self.money)];
    [self.bill updateDateStr:self.updateTimeStr];
    [self.bill updateRemarks:self.remarks];
    [self.bill updateCategory:self.selectedCategory];
    [self.bill updateRemarkPhoto:self.photoData];
}
/** collectionViewCell 注册class */
- (void)collectionViewRegisterClass {
    [self.incomeCategoryCollectionView registerClass:[TMCategotyCollectionViewCell class] forCellWithReuseIdentifier:collectionIdentifier];
    [self.expenCategoryCollectionView registerClass:[TMCategotyCollectionViewCell class] forCellWithReuseIdentifier:collectionIdentifier];
    [self.expenCategoryCollectionView2 registerClass:[TMCategotyCollectionViewCell class] forCellWithReuseIdentifier:collectionIdentifier];
}
/** 设置NavigationBar */
- (void)setupNavigationBar {

    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    
    self.incomeBtn.frame = CGRectMake(0, 0, self.titleView.bounds.size.width/2, self.titleView.bounds.size.height);
    
    [self.titleView addSubview:self.incomeBtn];

    self.expendBtn.frame = CGRectMake(self.titleView.bounds.size.width/2, 0, self.titleView.bounds.size.width/2, self.titleView.bounds.size.height);
    
    [self.titleView addSubview:self.expendBtn];
    self.navigationItem.titleView = self.titleView;
    
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [backBtn setImage:[UIImage imageNamed:@"btn_item_close"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}
#pragma mark - action

/** 时间选择器 */
- (void)SZCalendatPicker{
    SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
    calendarPicker.today = [NSDate date];
    calendarPicker.date = calendarPicker.today;
    calendarPicker.frame = CGRectMake(0, SCREEN_SIZE.height - (self.calculatorView.bounds.size.height + 50), SCREEN_SIZE.width, self.calculatorView.bounds.size.height + 50);
    WEAKSELF
    calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        NSLog(@"%li-%li-%li", year,month,day);
        NSString *time = nil;
        if (month<10) {
            time = [NSString stringWithFormat:@"%li-0%li-%li",year,month,day];
        }
        if (day<10) {
            time = [NSString stringWithFormat:@"%li-%li-0%li",year,month,day];
        }
        if (month<10 && day <10) {
            time = [NSString stringWithFormat:@"%li-0%li-0%li",year,month,day];
        }
        if (weakSelf.isUpdade) {
            weakSelf.updateTimeStr = time;
        } else {
            weakSelf.bill.dateStr = time;
        }
        [weakSelf.calculatorView setTimeWtihTimeString:time];
        
    };
    
}
//* 通过IncomeBtn和ExpendBtn把对应的界面显示到最上面,把相反界面放到最后面。 */
- (void)clickIncomeBtn:(UIButton *)sender {
    //* ------------ */
    TMCategory *firstIncomeCategory = [[TMDataBaseManager defaultManager] queryCategorysWithPaymentType:income].firstObject;
    self.selectedCategory = firstIncomeCategory;
    if (!self.isUpdade) {
        self.bill.isIncome = @YES;
    } else {
        self.income = YES;
    }
    //* ------------ */
    NSLog(@"click IncomeBtn");
    sender.selected = YES;
    self.expendBtn.selected = NO;
    [self.view bringSubviewToFront:self.incomeCategoryCollectionView];
    [self.view bringSubviewToFront:self.headerView];
    [self.view sendSubviewToBack:self.expendCategoryScrollView];

    [self.headerView categoryImageWithFileName:firstIncomeCategory.categoryImageFileNmae andCategoryName:firstIncomeCategory.categoryTitle];

    CCColorCube *imageColor = [[CCColorCube alloc] init];
    NSArray *colors = [imageColor extractColorsFromImage:firstIncomeCategory.categoryImage flags:CCAvoidBlack count:1];
    //* 设置HeaderView的背景颜色 */
    [self.headerView animationWithBgColor:colors.firstObject];
    self.pageController.numberOfPages = 1;
    [self.incomeCategoryCollectionView reloadData];
}
- (void)clickExpendBtn:(UIButton *)sender {
    //* ------------------------- */
    TMCategory *firstExpendCategory = [[TMDataBaseManager defaultManager] queryCategorysWithPaymentType:expend].firstObject;
    self.selectedCategory = firstExpendCategory;
    if (!self.isUpdade) {
        self.selectedCategory = firstExpendCategory;
        self.bill.isIncome = @NO;
    } else {
        self.income = NO;
    }
    //* ------------------------- */
    sender.selected = YES;
    self.incomeBtn.selected = NO;
    [self.view bringSubviewToFront:self.expendCategoryScrollView];
    [self.view bringSubviewToFront:self.headerView];
    [self.view sendSubviewToBack:self.incomeCategoryCollectionView];

    [self.headerView categoryImageWithFileName:firstExpendCategory.categoryImageFileNmae andCategoryName:firstExpendCategory.categoryTitle];

    CCColorCube *imageColor = [[CCColorCube alloc] init];
    NSArray *colors = [imageColor extractColorsFromImage:firstExpendCategory.categoryImage flags:CCAvoidBlack count:1];
    //* 设置HeaderView的背景颜色 */
    [self.headerView animationWithBgColor:colors.firstObject];
    self.pageController.numberOfPages = 2;
    [self.expenCategoryCollectionView reloadData];
    [self.expenCategoryCollectionView2 reloadData];
}
- (void)dismiss {
    if (self.tmCreateBillDelegate && [self.tmCreateBillDelegate respondsToSelector:@selector(clickDismissBtnWithTMCreateBillViewController:)]) {
        [self.tmCreateBillDelegate clickDismissBtnWithTMCreateBillViewController:self];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView==self.incomeCategoryCollectionView) return [[TMDataBaseManager defaultManager] numberOfCategoryCountWithPaymentType:income] + 1;
    else if (collectionView==self.expenCategoryCollectionView) return 24;
    else return self.lastfewExpendCategorys.count + 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TMCategotyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionIdentifier forIndexPath:indexPath];
    if (collectionView==self.incomeCategoryCollectionView) {//收入类别
        if (indexPath.row == [[TMDataBaseManager defaultManager] numberOfCategoryCountWithPaymentType:income]) {
            TMCategory *category = [TMCategory new];
            category.categoryImageFileNmae = @"type_add";
            category.categoryTitle = @"编辑";
            cell.categoty =category;
        } else {
            cell.categoty = [[TMDataBaseManager defaultManager] queryCategorysWithPaymentType:income][indexPath.row];
        }
    } else if (collectionView==self.expenCategoryCollectionView) {//支出类别1
        cell.categoty = [[TMDataBaseManager defaultManager] queryCategorysWithPaymentType:expend][indexPath.row];
    } else {//支出类别2
        if (indexPath.row == self.lastfewExpendCategorys.count) {
            TMCategory *category = [TMCategory new];
            category.categoryImageFileNmae = @"type_add";
            category.categoryTitle = @"编辑";
            cell.categoty =category;
        } else {
            cell.categoty = self.lastfewExpendCategorys[indexPath.row];
        }
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TMCategotyCollectionViewCell *cell = nil;
    TMCategory *category = nil;
    if (collectionView==self.incomeCategoryCollectionView) {//收入类别
        if (indexPath.row==[[TMDataBaseManager defaultManager] numberOfCategoryCountWithPaymentType:income]) {
            NSLog(@"click 收入编辑");
            [self transitionToIncomeCategoryViewController:YES];
            return;
        }
        cell = (TMCategotyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        category = [[TMDataBaseManager defaultManager] queryCategorysWithPaymentType:income][indexPath.row];
    } else if (collectionView==self.expenCategoryCollectionView) {//支出类别
        cell = (TMCategotyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        category = [[TMDataBaseManager defaultManager] queryCategorysWithPaymentType:expend][indexPath.row];
    } else {//支出类别2
        if (indexPath.row==self.lastfewExpendCategorys.count) {
            NSLog(@"click 支出编辑");
            [self transitionToIncomeCategoryViewController:NO];
            return;
        }
        cell = (TMCategotyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        category = self.lastfewExpendCategorys[indexPath.row];
    }
    
    [self animationWithCell:cell];
    self.selectedCategory = category;
    [self.headerView categoryImageWithFileName:category.categoryImageFileNmae andCategoryName:category.categoryTitle];
    //* 颜色提取 */
    CCColorCube *imageColor = [[CCColorCube alloc] init];
    NSArray *colors = [imageColor extractColorsFromImage:category.categoryImage flags:CCAvoidBlack count:1];
    //* 设置HeaderView的背景颜色 */
    [self.headerView animationWithBgColor:colors.firstObject];
    
    
}
/** 选择类别之后的类别图片动画(应该使用UI Dynamics) */
- (void)animationWithCell:(TMCategotyCollectionViewCell *)cell {
    self.selectCategoryImageView.image = cell.categoryImageView.image;
    CGPoint center = cell.center;
    /** 在collectionView中的y */
    CGFloat y =  CGRectGetMaxY(cell.frame);
    center.y = kMaxNBY + y + 10;
    self.selectCategoryImageView.center = center;
    WEAKSELF
    [UIView animateWithDuration:0.05 animations:^{
        weakSelf.selectCategoryImageView.center = kHeaderCategoryImageCenter;
    } completion:^(BOOL finished) {
        [weakSelf.view sendSubviewToBack:weakSelf.selectCategoryImageView];
    }];
    [self.view bringSubviewToFront:self.selectCategoryImageView];
}
/** 翻页转场动画 */
- (void)transitionToIncomeCategoryViewController:(BOOL)incomeCategory {
    RLMResults *results = nil;
    if (incomeCategory) {
        results = [[TMDataBaseManager defaultManager] queryAddCategorysWithPaymentType:income];
    } else {
        results = [[TMDataBaseManager defaultManager] queryAddCategorysWithPaymentType:expend];
    }
    if (results.count==0) {
        [self showSVProgressHUD:@"图标已用完,快去整理一下你的分类吧~"];
        return;
    }
    
    CATransition *animation = [CATransition animation];
    //设置转场动画的类型
    //* `fade',`moveIn' , `push' and `reveal'. Defaults to `fade'. *
    animation.type = kCATransitionPush;
    //设置动转场画的子类型
    //`fromLeft', `fromRight', `fromTop' and `fromBottom'.
    animation.subtype = @"fromBottom";
    animation.duration = 0.5;
    TMAddCategoryViewController *createBillVC = [[TMAddCategoryViewController alloc] init];
    if (incomeCategory) {
        createBillVC.paymentType = income;
    } else {
        createBillVC.paymentType = expend;
    }
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:createBillVC];
    navi.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:navi animated:YES completion:nil];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    //* round 四舍五入 */
    NSInteger index = round(point.x/scrollView.frame.size.width);
    self.pageController.currentPage = index;
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
