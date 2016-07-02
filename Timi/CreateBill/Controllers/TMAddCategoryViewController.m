//
//  TMAddCategoryViewController.m
//  Timi
//
//  Created by chairman on 16/6/22.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "TMAddCategoryViewController.h"
#import "TMButton.h"
#import "TMAddCategoryCollectionViewCell.h"
#import "TMAddCategory.h"
#import "TMCategory.h"

#define kItemWidth 97/2.5

static NSString *collectionCellIdentifier = @"categoryCell";

@interface TMAddCategoryViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *contaierView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) TMAddCategory *selectedCategory;

@end

@implementation TMAddCategoryViewController

#pragma mark - lazy loading
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        RLMResults *results = [[TMDataBaseManager defaultManager] queryAddCategorysWithPaymentType:self.paymentType];
        for (TMAddCategory *category in results) {
            [_dataSource addObject:category];
        }
    }
    return _dataSource;
}

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationBar];
    [self layoutSubviews];
    
    self.selectedCategory = self.dataSource.firstObject;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0.0];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
#pragma mark - setup View

- (void)setupNavigationBar {
    TMButton *cancelBtn = [[TMButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [cancelBtn setImage:[UIImage imageNamed:@"btn_item_close"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    label.text = @"添加分类";
    label.font = [UIFont systemFontOfSize:15.0f];
    self.navigationItem.titleView = label;
    
    TMButton *completeBtn = [[TMButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    completeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [completeBtn setTitleColor:LineColor forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(clickCompleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:completeBtn];
}

- (void)layoutSubviews {
    self.contaierView = [UIView new];
    [self.view addSubview:self.contaierView];
    self.contaierView.layer.borderWidth = 0.6;
    self.contaierView.layer.borderColor = LineColor.CGColor;
    WEAKSELF
    [self.contaierView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.mas_topLayoutGuide);
        make.height.equalTo(@50);
    }];
    
    self.imageView = [UIImageView new];
    TMAddCategory *category = self.dataSource.firstObject;
    self.imageView.image = category.image;
    [self.contaierView addSubview:self.imageView];
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(kItemWidth, kItemWidth));
        make.left.equalTo(weakSelf.contaierView).offset(10);
        make.centerY.equalTo(weakSelf.contaierView);
    }];
    
    self.textField = [UITextField new];
    self.textField.font = [UIFont systemFontOfSize:15.0f];
    self.textField.placeholder = @"输入分类名称";
    [self.contaierView addSubview:self.textField];
    [self.textField makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contaierView);
        make.left.equalTo(weakSelf.imageView.right).offset(5);
        make.right.equalTo(weakSelf.contaierView);
        make.height.equalTo(weakSelf.imageView);
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(kItemWidth, kItemWidth);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    /** 解决当界面内容不超过界面大小时不会滑动 */
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[TMAddCategoryCollectionViewCell class] forCellWithReuseIdentifier:collectionCellIdentifier];
    [self.view addSubview:self.collectionView];
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contaierView.bottom);
        make.left.right.bottom.equalTo(weakSelf.view);
    }];
}

#pragma mark - action

- (void)cancelBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)clickCompleteBtn:(UIButton *)sender {
    if (self.textField.text.length < 1) {
        [self showSVProgressHUD:@"请输入分类名称"];
    }else if (self.textField.text.length > 3) {
      [self showSVProgressHUD:@"分类名称不能超过4个字"];
    } else {
        TMCategory *category = [TMCategory new];
        category.categoryTitle = self.textField.text;
        category.categoryImageFileNmae = self.selectedCategory.categoryImageFileName;
        category.isIncome = self.selectedCategory.isIncome;
        [[TMDataBaseManager defaultManager] insertCategory:category];
        [[TMDataBaseManager defaultManager] deleteWithAddCategory:self.selectedCategory];
        [self cancelBtn:sender];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TMAddCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellIdentifier forIndexPath:indexPath];
    TMAddCategory *category = self.dataSource[indexPath.row];
    cell.imageView.image = category.image;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.textField becomeFirstResponder];
    TMAddCategory *category = self.dataSource[indexPath.row];
    self.imageView.image = category.image;
    self.selectedCategory = category;
}
// 长按某item，弹出copy和paste的菜单
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
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
