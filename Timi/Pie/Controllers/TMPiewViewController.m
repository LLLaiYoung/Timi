//
//  TMPiewViewController.m
//  Timi
//
//  Created by chairman on 16/5/27.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "TMPiewViewController.h"
#import "iCarousel.h"
#import "TMDataBaseManager.h"
#import "TMLabel.h"
#import "TMCalculate.h"
#import "TMPieView.h"
#import "TMBill.h"
#import "TMCategory.h"
#import "CCColorCube.h"
#import "TMPiewCategoryDetailViewController.h"
#import "NSArray+TMNSArray.h"
#import "NSString+TMNSString.h"

#define kNameFont 15.0f
#define kMoneyFont 12.0f
#define kICarViewHeight 60

@interface TMPiewViewController ()
<
iCarouselDelegate,
iCarouselDataSource
>
/** 月份数据源 */
@property (nonatomic, strong) NSArray *items;
/** 上一个选择的索引 iCar */
@property (nonatomic, assign) NSInteger prevoiusIndex;
/** 左标题属性字符串 */
@property (nonatomic, copy) NSMutableAttributedString *leftAttributedString;
/** 左金额属性字符串 */
@property (nonatomic, copy) NSMutableAttributedString *leftAttributedString2;
/** 右标题属性字符串 */
@property (nonatomic, copy) NSMutableAttributedString *rightAttributedString;
/** 右金额属性字符串 */
@property (nonatomic, copy) NSMutableAttributedString *rightAttributedString2;
/** 总/月收入 */
@property (nonatomic, strong) UILabel *leftItemLabel;
/** 总/月支出 */
@property (nonatomic, strong) UILabel *rightItemLabel;
/** 年份 */
@property (nonatomic, strong) TMLabel *yearLabel;
/** 滑动View 类似UIScrollView */
@property (nonatomic, strong) iCarousel *iCar;
/** 排序之后的key */
@property (nonatomic, strong) NSArray *sortDicKeys;
/** key:time value:月份 */
@property (nonatomic, strong) NSMutableDictionary *dic;
/** 饼图 */
@property (nonatomic, strong) TMPieView *pieView;
/** key:categoryTitle values:bill(count,percent,categoryImageFileName,money) */
@property (nonatomic, strong) NSDictionary *pieDic;
/** 选择了支出类型 */
@property (nonatomic, assign,getter=isSelectedExpend) BOOL selectedExpend;
/** 当前时间字符串 */
@property (nonatomic, copy) NSString *currentDateString;
/** 类别标题 */
@property (nonatomic, strong) UILabel *categoryTitleLabel;
/** 类别标题下面的金额 */
@property (nonatomic, strong) UILabel *moneyLabel;
/** 类别按钮 */
@property (nonatomic, strong) UIButton *categoryBtn;
/** 百分比 */
@property (nonatomic, strong) UILabel *percentLabel;
/** 笔数 */
@property (nonatomic, strong) UILabel *countLabel;
/** 旋转按钮 */
@property (nonatomic, strong) UIButton *rotateBtn;
/** 当前红线指的layer */
@property (nonatomic, assign) NSInteger currentIndex;
/** 上一个选择的索引,pieView */
@property (nonatomic, assign) NSInteger previousSelectedOfPieViewIndex;
/** 第一次获取max percent */
@property (nonatomic, assign,getter=isFirst) BOOL first;
/** 上一次的allBillCount */
@property (nonatomic, assign) NSInteger previousCount;
/** 上一次选择的账本ID */
@property (nonatomic, strong) NSString *previousBookID;

@end

@implementation TMPiewViewController
#pragma mark - lazy loading
- (NSMutableAttributedString *)leftAttributedString
{
    if (!_leftAttributedString) {
        _leftAttributedString = [[NSMutableAttributedString alloc] initWithString:@"总收入" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kNameFont],NSForegroundColorAttributeName:[UIColor blackColor]}];
    }
    return _leftAttributedString;
}
- (NSMutableAttributedString *)leftAttributedString2
{
    if (!_leftAttributedString2) {
        float money = [TMCalculate queryAllIncomeOrExpendOfBookID:[NSString readUserDefaultOfSelectedBookID] andPaymentType:income];
        _leftAttributedString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%.2f",money] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kMoneyFont],NSForegroundColorAttributeName:kSelectColor}];
    }
    return _leftAttributedString2;
}
- (NSMutableAttributedString *)rightAttributedString
{
    if (!_rightAttributedString) {
        _rightAttributedString = [[NSMutableAttributedString alloc] initWithString:@"总支出" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kNameFont],NSForegroundColorAttributeName:[UIColor blackColor]}];
    }
    return _rightAttributedString;
}
- (NSMutableAttributedString *)rightAttributedString2
{
    if (!_rightAttributedString2) {
        float money = [TMCalculate queryAllIncomeOrExpendOfBookID:[NSString readUserDefaultOfSelectedBookID] andPaymentType:expend];
        _rightAttributedString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%.2f",money] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kMoneyFont],NSForegroundColorAttributeName:kSelectColor} ];
    }
    return _rightAttributedString2;
}


- (NSArray *)items {
    if (!_items) {
        _items = @[@"JAN\n1月",@"FEB\n2月",@"MAR\n3月",@"APR\n4月",@"MAY\n5月",@"JUN\n6月",@"JUL\n7月",@"AUG\n8月",@"SEP\n9月",@"OCT\n10月",@"NOV\n11月",@"DEC\n12月",@"ALL\n全部"];
    }
    return _items;
}


#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dic = [NSMutableDictionary dictionary];
    self.pieDic = [NSDictionary dictionary];
    self.selectedExpend = YES;
    self.first = YES;
    self.currentDateString = @"ALL";
    //* 初始化-1,表示未选择,如果为0,则当第一次的时候,max的index也为0,则不会旋转 */
    self.previousSelectedOfPieViewIndex = -1;
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSDictionary *dic = [[TMDataBaseManager defaultManager] queryNonRepeatWithBookID:[NSString readUserDefaultOfSelectedBookID]];
    self.previousBookID = [NSString readUserDefaultOfSelectedBookID];
    self.previousCount = [[TMDataBaseManager defaultManager] numberOfAllBillCountWithBookID:[NSString readUserDefaultOfSelectedBookID]];
    [self filterMonthWithDateArray:dic.allKeys];

    [self layoutSubviews];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //* 模仿`RLMNotificationToken`,为什么不直接用RLMNoti...,因为RLMNoti...是异步会导致第一次调用iCar的delegate之后,还会掉用`filterMonthWithDateArray`函数里面的[iCar reloadData] */
    /** 判断账本的笔数和是否改变了账本 */
    if ([[TMDataBaseManager defaultManager] numberOfAllBillCountWithBookID:[NSString readUserDefaultOfSelectedBookID]]!=self.previousCount ||
        ![[NSString readUserDefaultOfSelectedBookID] isEqualToString:self.previousBookID])
    {
        self.previousCount = [[TMDataBaseManager defaultManager] numberOfAllBillCountWithBookID:[NSString readUserDefaultOfSelectedBookID]];
        self.previousBookID = [NSString readUserDefaultOfSelectedBookID];
        [self tapRightItemLabel];
        [self.dic removeAllObjects];
        NSDictionary *dic = [[TMDataBaseManager defaultManager] queryNonRepeatWithBookID:[NSString readUserDefaultOfSelectedBookID]];
        [self filterMonthWithDateArray:dic.allKeys];
        [_iCar scrollToItemAtIndex:self.sortDicKeys.count animated:NO];
        
        float expendMoney = [TMCalculate queryAllIncomeOrExpendOfBookID:[NSString readUserDefaultOfSelectedBookID] andPaymentType:expend];
        [self updateMoneyWithAttributedString:self.rightAttributedString withMoneyString:[NSString stringWithFormat:@"%.2f",expendMoney] toView:self.rightItemLabel];
        
        float incomeMoney = [TMCalculate queryAllIncomeOrExpendOfBookID:[NSString readUserDefaultOfSelectedBookID] andPaymentType:income];
        [self updateMoneyWithAttributedString:self.leftAttributedString withMoneyString:[NSString stringWithFormat:@"%.2f",incomeMoney] toView:self.leftItemLabel];
    }
}

#pragma mark - layoutSubviews
- (void)layoutSubviews {
    WEAKSELF
    [self.leftAttributedString appendAttributedString:self.leftAttributedString2];
    self.leftItemLabel = [UILabel new];
    self.leftItemLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *leftTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLeftItemLabel)];
    [self.leftItemLabel addGestureRecognizer:leftTapGR];
    self.leftItemLabel.numberOfLines = 2;
    self.leftItemLabel.attributedText = self.leftAttributedString;
    [self.view addSubview:self.leftItemLabel];
    [self.leftItemLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(25);
    }];
    
    [self.rightAttributedString appendAttributedString:self.rightAttributedString2];
    self.rightItemLabel = [UILabel new];
    self.rightItemLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *rightTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRightItemLabel)];
    [self.rightItemLabel addGestureRecognizer:rightTapGR];
    self.rightItemLabel.numberOfLines = 2;
    self.rightItemLabel.textAlignment = NSTextAlignmentRight;
    self.rightItemLabel.attributedText = self.rightAttributedString;
    [self.view addSubview:self.rightItemLabel];
    
    [self.rightItemLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.centerY.equalTo(weakSelf.leftItemLabel);
    }];

    iCarousel *iCar = [iCarousel new];
    iCar.layer.borderWidth = 0.6;
    /* 设置Btn的边框和颜色 */
    iCar.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1].CGColor;
    iCar.type = iCarouselTypeLinear;
    iCar.delegate = self;
    iCar.dataSource = self;
    iCar.pagingEnabled = YES;
    iCar.bounces = YES;
    iCar.bounceDistance = 1.0f;
    [iCar scrollToItemAtIndex:self.sortDicKeys.count animated:NO];
    [self.view addSubview:iCar];
    
    [iCar makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftItemLabel.bottom).offset(10);
        make.size.equalTo(CGSizeMake(SCREEN_SIZE.width, kICarViewHeight));
    }];
    self.iCar = iCar;
    
    self.yearLabel = [TMLabel new];
    [self.view addSubview:self.yearLabel];

    [self.yearLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iCar.bottom);
        make.centerX.equalTo(weakSelf.view);
    }];
    [self updateYearLabel];
    self.yearLabel.textColor = LineColor;
    self.yearLabel.textAlignment = NSTextAlignmentCenter;
    self.yearLabel.backgroundColor = [UIColor whiteColor];
    self.yearLabel.font = [UIFont systemFontOfSize:12.0f];
    
    
    self.categoryTitleLabel = [UILabel new];
    self.categoryTitleLabel.numberOfLines = 2;
    self.categoryTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.categoryTitleLabel];
    [self.categoryTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.yearLabel.bottom).offset(30);
    }];
    self.categoryTitleLabel.text = @"网购";
    
    self.moneyLabel = [UILabel new];
    [self.view addSubview:self.moneyLabel];
    [self.moneyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.categoryTitleLabel.bottom).offset(5);
    }];
    self.moneyLabel.text = @"56789765.00";
    self.moneyLabel.textColor = LineColor;
    
    
    UIView *redLineView = [UIView new];
    redLineView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redLineView];
    [redLineView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(1);
        make.top.equalTo(weakSelf.moneyLabel.bottom).offset(5);
        make.height.equalTo(20);
        make.centerX.equalTo(weakSelf.view);
    }];
    
    self.pieView = [TMPieView new];
    [self.view addSubview:self.pieView];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPieView:)];
    [self.pieView addGestureRecognizer:tapGR];

    self.pieView.lineWidth = 30;
    self.pieView.animationStrokeColor = LineColor;
    self.pieView.layer.cornerRadius = 200/2;
    self.pieView.layer.masksToBounds = YES;

    [self.pieView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(200, 200));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(redLineView.bottom).offset(5);
    }];
    [self tapRightItemLabel];

    
    self.categoryBtn = [UIButton new];
    [self.categoryBtn addTarget:self action:@selector(clickCategoryBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.categoryBtn];
    [self.categoryBtn makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(97/2.5, 97/2.5));
        make.centerX.equalTo(weakSelf.view);
        make.centerY.equalTo(weakSelf.pieView);
    }];
    [self.categoryBtn setImage:[UIImage imageNamed:@"type_big_1"] forState:UIControlStateNormal];
    
    self.percentLabel = [UILabel new];
    [self.view addSubview:self.percentLabel];
    [self.percentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.categoryBtn.bottom).offset(5);
    }];
    self.percentLabel.text = @"88%";
    
    self.countLabel = [UILabel new];
    self.countLabel.textColor = [UIColor colorWithWhite:0.729 alpha:1.000];
    [self.view addSubview:self.countLabel];
    [self.countLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.pieView.bottom).offset(20);
        make.centerX.equalTo(weakSelf.view);
    }];
    self.countLabel.text = @"1笔";
    
    self.rotateBtn = [UIButton new];
    [self.rotateBtn setImage:[UIImage imageNamed:@"btn_pieChart_rotation"] forState:UIControlStateNormal];
    [self.rotateBtn addTarget:self action:@selector(clickRotateBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rotateBtn];
    [self.rotateBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(self.countLabel.bottom).offset(10);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
}

#pragma mark - action
- (void)tapLeftItemLabel {
    self.first = YES;;
    NSLog(@"tap Left");
    self.selectedExpend = NO;
    [self updateColorWithAttributedString:self.leftAttributedString titleColor:kSelectColor moneyColor:kSelectColor toView:self.leftItemLabel];
    [self updateColorWithAttributedString:self.rightAttributedString titleColor:[UIColor blackColor] moneyColor:LineColor toView:self.rightItemLabel];
    
    self.pieDic = [[TMDataBaseManager defaultManager] getPieDataWithBookID:[NSString readUserDefaultOfSelectedBookID] andDateSting:self.currentDateString andPaymentType:income];
    
    [self reloadPieSectionAndSectionColorsWithDictionary:self.pieDic];
}
- (void)tapRightItemLabel {
    self.first = YES;
    NSLog(@"tap Right");
    self.selectedExpend = YES;
    [self updateColorWithAttributedString:self.rightAttributedString titleColor:kSelectColor moneyColor:kSelectColor toView:self.rightItemLabel];
    [self updateColorWithAttributedString:self.leftAttributedString titleColor:[UIColor blackColor] moneyColor:LineColor toView:self.leftItemLabel];


    
    self.pieDic = [[TMDataBaseManager defaultManager] getPieDataWithBookID:[NSString readUserDefaultOfSelectedBookID] andDateSting:self.currentDateString andPaymentType:expend];
    
    [self reloadPieSectionAndSectionColorsWithDictionary:self.pieDic];
}
- (void)clickCategoryBtn:(UIButton *)sender {
    NSLog(@"click CategoryBtn");
    NSLog(@"line = %i,categoryTitleLabel = %@",__LINE__,self.categoryTitleLabel.text);
    NSLog(@"line = %i,currentDateString = %@",__LINE__,self.currentDateString);
    
    TMPiewCategoryDetailViewController *piewDetailVC = [TMPiewCategoryDetailViewController new];
    piewDetailVC.categoryName = self.categoryTitleLabel.text;
    piewDetailVC.dateString = self.currentDateString;
//    expend,
//    income,
    piewDetailVC.type = self.isSelectedExpend ? expend:income ;
    [self.navigationController pushViewController:piewDetailVC animated:YES];
}
- (void)clickRotateBtn:(UIButton *)sender {
    NSLog(@"click RotateBtn");
    self.currentIndex = self.previousSelectedOfPieViewIndex + 1;
    NSArray *allKeys = self.pieDic.allKeys;
    if (self.currentIndex>allKeys.count-1) {
        self.currentIndex=0;
    }
    CGFloat angle = [self getRotatingAngleWithLayerIndex:self.currentIndex];
    [self rotateAnimationByAngle:angle];

}

- (void)tapPieView:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:tap.view];
    self.currentIndex = [self.pieView getLayerIndexWithPoint:point];
    if (self.currentIndex<0 || self.currentIndex>self.pieDic.allKeys.count-1) {
        return;
    }
    NSLog(@"tap Index = %li",self.currentIndex);
    CGFloat angle = [self getTapRotatingAngleWithLayerIndex:self.currentIndex];
    [self rotateAnimationByAngle:angle];
    
}
/** 根据点击的layer index 刷新饼图附带数据(类别名,金额,类别图标,百分比,笔数) */
- (void)reloadPieViewAttachedDataWithLayerIndex:(NSInteger)index {
    if (self.pieDic.allKeys.count==0 || index>self.pieDic.allKeys.count-1) {
        if (self.isSelectedExpend) {
            [self.categoryBtn setImage:[UIImage imageNamed:@"type_big_1"] forState:UIControlStateNormal];
        } else {
            [self.categoryBtn setImage:[UIImage imageNamed:@"type_big_0"] forState:UIControlStateNormal];
        }
        self.categoryTitleLabel.text = @"一般";
        self.moneyLabel.text = @"0.00";
        self.percentLabel.text = @"0%";
        self.countLabel.text = @"0笔";
        return;
    }
    NSString *key = self.pieDic.allKeys[index];
    TMBill *bill = self.pieDic[key];
    [self.categoryBtn setImage:bill.category.categoryImage forState:UIControlStateNormal];
    self.categoryTitleLabel.text = key;
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",bill.money.floatValue];
    self.percentLabel.text = [NSString stringWithFormat:@"%.2f%%",bill.category.percent];
    self.countLabel.text = [NSString stringWithFormat:@"%li笔",bill.count];
}



#pragma mark - get rotating angle

/** the biggest layer as a currentIndex */
- (NSInteger)getCurrentIndexWithDictionary:(NSDictionary *)pieDic {
    NSArray *allKeys = pieDic.allKeys;
    TMBill *firstBill = pieDic[allKeys.firstObject];
    float maxBill = firstBill.category.percent;
    NSInteger index = 0;
    for (NSInteger i=1; i<pieDic.allValues.count; i++) {
        NSString *key = allKeys[i];
        TMBill *bill = pieDic[key];
        if (maxBill < bill.category.percent) {
            maxBill = bill.category.percent;
            index = i;
        }
    }
    return index;
}
/** 获取旋转弧度 */
/**
 * 第一次(更新饼图)的时候,获取最大的index,计算之前的所有弧度,加上当前最大的这个弧度的一半,return M_PI-angle
 * 非第一次,计算当前选择的layer的一半,加上上一个(layerIndex-1)的一半
 */
- (CGFloat )getRotatingAngleWithLayerIndex:(NSInteger )layerIndex {
    CGFloat angle = 0;
    if (layerIndex == self.previousSelectedOfPieViewIndex) {
        return angle;
    }
    NSArray *alllKays = self.pieDic.allKeys;
    if (alllKays.count==0 || alllKays.count==1) {//当数据为空的时候或者数据只有一个的时候,则不需要旋转
        return angle;
    }
    if (self.isFirst) {//第一次
        self.first = NO;
        NSString *key = alllKays[layerIndex];
        TMBill *indexBill = self.pieDic[key];
        angle += [self getLayerAngleWithBill:indexBill]/2;
    
        for (NSInteger i=0; i<layerIndex ; i++) {
            NSString *key = alllKays[i];
            TMBill *bill = self.pieDic[key];
            angle +=[self getLayerAngleWithBill:bill];
        }
        angle = M_PI - angle;
        self.previousSelectedOfPieViewIndex = layerIndex;
        return angle;
    } else {
        if (layerIndex==0) {
            NSString *firstKey = alllKays.firstObject;
            TMBill *firstBill = self.pieDic[firstKey];
           angle += [self getLayerAngleWithBill:firstBill]/2;
            
            NSString *lastKey = alllKays.lastObject;
            TMBill *lastBill = self.pieDic[lastKey];
            angle += [self getLayerAngleWithBill:lastBill]/2;
        } else {
            NSString *previousKey = alllKays[layerIndex-1];
            TMBill *previousBill = self.pieDic[previousKey];
            angle += [self getLayerAngleWithBill:previousBill]/2;
            NSString *nextKey = alllKays[layerIndex];
            TMBill *nextBill = self.pieDic[nextKey];
            angle += [self getLayerAngleWithBill:nextBill]/2;
        }
        self.previousSelectedOfPieViewIndex = layerIndex;
        return -angle;
    }
}
/** 获取点击的弧度 */
- (CGFloat)getTapRotatingAngleWithLayerIndex:(NSInteger)layerIndex {
    CGFloat angle = 0;
    if (layerIndex == self.previousSelectedOfPieViewIndex) {
        return angle;
    }
    NSArray *alllKays = self.pieDic.allKeys;
    if (alllKays.count==0 || alllKays.count==1) {//当数据为空的时候或者数据只有一个的时候,则不需要旋转
        return angle;
    }
    if (self.previousSelectedOfPieViewIndex<layerIndex) {
        for (NSInteger i=self.previousSelectedOfPieViewIndex; i<=layerIndex; i++) {
            NSString *key = alllKays[i];
            //* 当i=上个选择的和当前选择的,则是一半 */
            if (i==self.previousSelectedOfPieViewIndex||i==layerIndex) {
                TMBill *bill = self.pieDic[key];
                angle += [self getLayerAngleWithBill:bill]/2;
            } else {
                TMBill *theBill = self.pieDic[key];
                angle += [self getLayerAngleWithBill:theBill];
            }
        }
        self.previousSelectedOfPieViewIndex = layerIndex;
        return -angle;
    } else {
        for (NSInteger j=layerIndex; j<=self.previousSelectedOfPieViewIndex; j++) {
            NSString *key = alllKays[j];
            if (j==self.previousSelectedOfPieViewIndex||j==layerIndex) {
                TMBill *bill = self.pieDic[key];
                angle += [self getLayerAngleWithBill:bill]/2;
            } else {
                TMBill *theBill = self.pieDic[key];
                angle += [self getLayerAngleWithBill:theBill];
            }
        }
        self.previousSelectedOfPieViewIndex = layerIndex;
        return angle;
    }
}
/** 获取单个layer的弧度 */
- (CGFloat)getLayerAngleWithBill:(TMBill *)bill {
    float radius = 50;//半径
    float roundS = radius *radius * M_PI;//圆面积 50半径
    float arcS = roundS * bill.category.percent/100;//bill.category.percent.floatValue所占比例 扇形面积
    float arcL = (2 * arcS)/radius;//扇形弧长
    CGFloat angle = 180 * arcL / (M_PI * radius);
    return angle * M_PI/180;
}
#pragma mark - About filter Month
/** 过滤掉同年相同月份 */
- (void)filterMonthWithDateArray:(NSArray *)array {
    for (NSString *dateStr in array) {
        NSString *yearAndMonth = [dateStr substringToIndex:7];
        BOOL contains = [self containsMonth:yearAndMonth];
        if (!contains) {
            NSString *month = [self conversionDateStringIntoMonth:dateStr];
            [self.dic setValue:month forKey:dateStr];
        }
    }
    //* 加上最后一个全部数据 */
    [self.dic setValue:self.items.lastObject forKey:@"ALL"];
    self.sortDicKeys = [NSArray sortArray:self.dic.allKeys ascending:YES];
    [self.iCar reloadData];
}
/** 把时间字符串转换成月份 */
- (NSString *)conversionDateStringIntoMonth:(NSString *)dateString {
    NSRange range = NSMakeRange(5, 2);
    NSString *month = [dateString substringWithRange:range];
    return self.items[month.integerValue - 1];
}
/** 判断字典里面是否已经包含这个对象 */
- (BOOL)containsMonth:(NSString *)yearAndMonth {
    if (self.dic.allKeys.count==0) {
        return NO;
    } else {
        for (NSInteger i=0; i<self.dic.allKeys.count ; i++) {
            if ([self.dic.allKeys[i] isEqualToString:@"ALL"]) {
                continue;
            }
            if ([[self.dic.allKeys[i] substringToIndex:7] isEqualToString:yearAndMonth]) {
                return YES;
            }
        }
    }
    return NO;
}
#pragma mark - about PieView

/** 根据一个字典获取饼图的分组数据和对应的颜色 并重新加载饼图和饼图附带属性,完成动画*/
- (void)reloadPieSectionAndSectionColorsWithDictionary:(NSDictionary *)dic {
    self.pieView.transform = CGAffineTransformIdentity;
    NSArray *allValues = dic.allValues;
    NSMutableArray *sections = [NSMutableArray array];
    NSMutableArray *sectionColors = [NSMutableArray array];
    
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
    self.pieView.sections = sections;
    self.pieView.sectionColors = sectionColors;
    WEAKSELF
    [self.pieView reloadDataCompletion:^{
        weakSelf.currentIndex = [weakSelf getCurrentIndexWithDictionary:weakSelf.pieDic];
        CGFloat angle = [weakSelf getRotatingAngleWithLayerIndex:weakSelf.currentIndex];
        [weakSelf rotateAnimationByAngle:angle];
    }];
}
/** 完成之后再做旋转动画 */
- (void)rotateAnimationByAngle:(CGFloat )angle {
    NSLog(@"%i,angle = %f",__LINE__,angle);
    NSLog(@"currentIndex = %li",self.currentIndex);
    WEAKSELF
    [UIView animateWithDuration:.5f animations:^{
        weakSelf.pieView.transform = CGAffineTransformRotate(weakSelf.pieView.transform, angle);
    } completion:^(BOOL finished) {
        [weakSelf reloadPieViewAttachedDataWithLayerIndex:weakSelf.currentIndex];
    }];
    
}
#pragma mark - about update AttributedString
/** 修改属性字符串颜色 */
- (void)updateColorWithAttributedString:(NSMutableAttributedString *)attributedString
                             titleColor:(UIColor *)titleColor
                             moneyColor:(UIColor *)moneyColor
                                 toView:(UILabel *)sender {
    [attributedString beginEditing];
    NSRange titleRange = NSMakeRange(0, 3);
    [attributedString setAttributes:@{
                                      NSFontAttributeName:[UIFont systemFontOfSize:kNameFont],
                                      NSForegroundColorAttributeName:titleColor
                                      } range:titleRange];
    NSRange moneyRange = NSMakeRange(3, attributedString.length - 3);
    [attributedString setAttributes:@{
                                      NSFontAttributeName:[UIFont systemFontOfSize:kNameFont],
                                      NSForegroundColorAttributeName:moneyColor
                                      } range:moneyRange];
    [attributedString endEditing];
    sender.attributedText = attributedString;
}
/** 修改支出类型('月支出'Or'总支出') */
- (void)updateStringWithAttributedString:(NSMutableAttributedString *)attributedString
                                  toView:(UILabel *)sender
                               withMonth:(BOOL)month{
    [attributedString beginEditing];
    NSRange range = NSMakeRange(0, 1);
    month ? [attributedString replaceCharactersInRange:range withString:@"月"]:[attributedString replaceCharactersInRange:range withString:@"总"];
    [attributedString endEditing];
    sender.attributedText = attributedString;
}
/** 修改金额 */
- (void)updateMoneyWithAttributedString:(NSMutableAttributedString *)attributedString
                        withMoneyString:(NSString *)moneyString
                                 toView:(UILabel *)sender {
    [attributedString beginEditing];
    NSInteger length = attributedString.length;
    NSRange range = NSMakeRange(4, length-4);
    [attributedString replaceCharactersInRange:range withString:moneyString];
    [attributedString endEditing];
    sender.attributedText = attributedString;
}
#pragma mark - iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.sortDicKeys.count;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view {
    UIView *iCarView = view;
    UILabel *label = nil;
    if (!iCarView) {
        iCarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kICarViewHeight, kICarViewHeight)];
        label = [[UILabel alloc] initWithFrame:iCarView.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 1;
        label.numberOfLines = 2;
        label.textColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
        label.font = [UIFont systemFontOfSize:15.0f];
        [iCarView addSubview:label];
    } else {
        label = [view viewWithTag:1];
    }
    NSString *key = self.sortDicKeys[index];
    label.text = self.dic[key];
    return iCarView;
}
#pragma mark - iCarouselDelegate
/** 类似给item加5margin */
- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    return kICarViewHeight + 5.0f;
}
- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    return CATransform3DTranslate(transform, offset * kICarViewHeight, 0, 0);
}

-(void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
//    [self.pieView dismissAnimationByTimeInterval:1.0];
    self.first = YES;
    self.previousSelectedOfPieViewIndex = -1;
    NSString *key = self.sortDicKeys[carousel.currentItemIndex];
    
    /** update yearLabel and switch the corresponding bill */
    if (![key isEqualToString:@"ALL"]) {
        self.yearLabel.text = [key substringToIndex:4];
        self.currentDateString = key;
    } else {
        self.currentDateString = @"ALL";
        [self updateYearLabel];
    }
    /** update income or expend type, and money */
    if (carousel.currentItemIndex!=self.sortDicKeys.count-1) {
        //* update income or expend type */
        [self updateStringWithAttributedString:self.leftAttributedString toView:self.leftItemLabel withMonth:YES];
        [self updateStringWithAttributedString:self.rightAttributedString toView:self.rightItemLabel withMonth:YES];
        //* update money */

        float incomeMoney = [TMCalculate queryMonthAllIncomeOrExpendOfBookID:[NSString readUserDefaultOfSelectedBookID] andDateString:key withPaymentType:income];
        [self updateMoneyWithAttributedString:self.leftAttributedString withMoneyString:[NSString stringWithFormat:@"%.2f",incomeMoney] toView:self.leftItemLabel];
        
        float expendMoney = [TMCalculate queryMonthAllIncomeOrExpendOfBookID:[NSString readUserDefaultOfSelectedBookID] andDateString:key withPaymentType:expend];
        [self updateMoneyWithAttributedString:self.rightAttributedString withMoneyString:[NSString stringWithFormat:@"%.2f",expendMoney] toView:self.rightItemLabel];
        [self reloadPieViewDataWithDateString:key];
    } else {//ALL
        [self updateStringWithAttributedString:self.leftAttributedString toView:self.leftItemLabel withMonth:NO];
        [self updateStringWithAttributedString:self.rightAttributedString toView:self.rightItemLabel withMonth:NO];
        
        float expendMoney = [TMCalculate queryAllIncomeOrExpendOfBookID:[NSString readUserDefaultOfSelectedBookID] andPaymentType:expend];
        [self updateMoneyWithAttributedString:self.rightAttributedString withMoneyString:[NSString stringWithFormat:@"%.2f",expendMoney] toView:self.rightItemLabel];

        float incomeMoney = [TMCalculate queryAllIncomeOrExpendOfBookID:[NSString readUserDefaultOfSelectedBookID] andPaymentType:income];
        [self updateMoneyWithAttributedString:self.leftAttributedString withMoneyString:[NSString stringWithFormat:@"%.2f",incomeMoney] toView:self.leftItemLabel];
        [self reloadPieViewDataWithDateString:@"ALL"];
    }
    /** update item color */
    if (carousel.currentItemIndex != self.prevoiusIndex) {
        UIView *view = [carousel itemViewAtIndex:self.prevoiusIndex];
        UILabel *label = [view viewWithTag:1];
        label.textColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
    }
    UIView *view=carousel.currentItemView;
    self.prevoiusIndex = carousel.currentItemIndex;
    UILabel *label = [view viewWithTag:1];
    label.textColor = kSelectColor;
}
/** 根据时间刷新饼图的数据(颜色,分组) */
- (void)reloadPieViewDataWithDateString:(NSString *)dateString {
    //* reload Pie Data */
    if (self.isSelectedExpend) {

        self.pieDic = [[TMDataBaseManager defaultManager] getPieDataWithBookID:[NSString readUserDefaultOfSelectedBookID] andDateSting:dateString andPaymentType:expend];
        [self reloadPieSectionAndSectionColorsWithDictionary:self.pieDic];
    } else {

        self.pieDic = [[TMDataBaseManager defaultManager] getPieDataWithBookID:[NSString readUserDefaultOfSelectedBookID] andDateSting:dateString andPaymentType:income];
        [self reloadPieSectionAndSectionColorsWithDictionary:self.pieDic];
    }
}
/** 更新年份label */
- (void)updateYearLabel {
    NSString *firstKey = self.sortDicKeys.firstObject;
    NSInteger count = self.sortDicKeys.count;
    if (self.sortDicKeys.count<2) {
        self.yearLabel.text = [NSString stringWithFormat:@"%@",[[NSString currentDateStr] substringToIndex:4]];
        return;
    }
    NSString *lastKey = self.sortDicKeys[count-2];
    //* 判断年份是否为多个年份 */
    if (![[firstKey substringToIndex:4] isEqualToString:[lastKey substringToIndex:4]]) {
        self.yearLabel.text = [NSString stringWithFormat:@"%@~%@",[firstKey substringToIndex:4],[lastKey substringToIndex:4]];
    } else {
        self.yearLabel.text = [NSString stringWithFormat:@"%@",[firstKey substringToIndex:4]];
    }}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    NSLog(@"good by PieViewController");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



//- (void)resetPieView{
//    int oldIndex=0;
//    self.pieView.transform=CGAffineTransformIdentity;
//}
//- (void)tap{
//    int newIndex=getTappedIndex();
//    int oldIndex;
//    double angle=calculateSmallerAnglebetween(newIndex, oldIndex);
//    oldIndex=newIndex;
//    doAnimationByAngle(angle);
//}

@end
