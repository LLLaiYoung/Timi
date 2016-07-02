//
//  TMSideViewController.m
//  Timi
//
//  Created by chairman on 16/6/25.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "TMSideViewController.h"
#import "TMSideHeaderView.h"
#import "TMSideCell.h"
#import "TMSideButton.h"
#import <UIViewController+MMDrawerController.h>
#import "TMAddBookView.h"
#import "NSString+TMNSString.h"
#import "HomePageViewController.h"

#define kMenuOperationBtnTitleFont [UIFont systemFontOfSize:13.0f]

static NSString *const collectionViewCellID = @"TMSideCell";

@interface TMSideViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
TMSideCellDelegate
>
@property (nonatomic, strong) TMSideHeaderView *headerView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) RLMResults *results;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) TMAddBookView *addBookView;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) NSInteger previousSelectedBook;
/** 编辑模式 非update */
@property (nonatomic, assign, getter=isEdit) BOOL edit;
/** 编辑选择的indexPath */
@property (nonatomic, strong) NSIndexPath *editSelectedIndexPath;
@property (nonatomic, strong) TMSideButton *cancelBtn;
@property (nonatomic, strong) TMSideButton *deleteBtn;
@property (nonatomic, strong) TMSideButton *editBtn;
@property (nonatomic, strong) TMSideButton *exploreBtn;
/** 更新账本数据 */
@property (nonatomic, assign,getter=isUpdate) BOOL update;
/** 编辑的账本 */
@property (nonatomic, strong) TMBooks *editBook;

@end

@implementation TMSideViewController
#pragma mark - lazy loading
- (TMSideButton *)exploreBtn
{
    if (!_exploreBtn) {
        _exploreBtn = [TMSideButton new];
        [_exploreBtn setImage:[UIImage imageNamed:@"Earth"] forState:UIControlStateNormal];
        [_exploreBtn setTitle:@"探索" forState:UIControlStateNormal];
        _exploreBtn.titleLabel.font = kMenuOperationBtnTitleFont;
        [_exploreBtn addTarget:self action:@selector(clickExploreBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exploreBtn;
}

- (TMSideButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [TMSideButton new];
        [_cancelBtn setImage:[UIImage imageNamed:@"menu_operation_cancel"] forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.titleLabel.font = kMenuOperationBtnTitleFont;
    }
    return _cancelBtn;
}
- (TMSideButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [TMSideButton new];
        [_deleteBtn setImage:[UIImage imageNamed:@"menu_operation_delete"] forState:UIControlStateNormal];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(clickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.titleLabel.font = kMenuOperationBtnTitleFont;
    }
    return _deleteBtn;
}
- (TMSideButton *)editBtn
{
    if (!_editBtn) {
        _editBtn = [TMSideButton new];
        [_editBtn setImage:[UIImage imageNamed:@"menu_operation_edit"] forState:UIControlStateNormal];
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(clickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
        _editBtn.titleLabel.font = kMenuOperationBtnTitleFont;
    }
    return _editBtn;
}




#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self layoutSubviews];
    self.results = [[TMDataBaseManager defaultManager] queryAllBooks];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /** 默认为(-1,-1) */
    self.editSelectedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
    [self.headerView reloadData];
    NSString *bookID = [NSString readUserDefaultOfSelectedBookID];
    self.previousSelectedBook = [[TMDataBaseManager defaultManager] bookIndexWithBookID:bookID];
    [self.collectionView reloadData];
    
}
- (void)layoutSubviews {
    WEAKSELF
    CGFloat viewWidth = SCREEN_SIZE.height - 50;
    
    self.headerView = [TMSideHeaderView new];
    [self.view addSubview:self.headerView];
    [self.headerView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(SCREEN_SIZE.width-50);//50 side距离右边50个像素点
        make.height.equalTo(140);
        make.top.equalTo(weakSelf.view);
    }];
    CGFloat width = SCREEN_SIZE.width - 50 - 20 * 2 - 10 * 3 ;
    /** 70底部探索高 */
    CGFloat height = SCREEN_SIZE.height - 140 - 70 - 20 * 2 - kStatusBarHeight;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(width/3, height/3);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 0, 10);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[TMSideCell class] forCellWithReuseIdentifier:collectionViewCellID];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerView.bottom);
        make.left.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-70);
        make.width.equalTo(weakSelf.view);
    }];
    UIView *lineView = [UIView new];
    lineView.backgroundColor = LineColor;
    [self.view addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(viewWidth);
        make.height.equalTo(0.5);
        make.top.equalTo(weakSelf.collectionView.bottom).offset(-2);
    }];
    
    [self.view addSubview:self.exploreBtn];
    [self.exploreBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.size.equalTo(CGSizeMake(60, 60));
        make.bottom.equalTo(weakSelf.view);
    }];
    self.containerView = [UIView new];

    self.window = [UIApplication sharedApplication].windows.lastObject;
    [self.window addSubview:self.containerView];
    self.containerView.backgroundColor = [UIColor colorWithWhite:0.597 alpha:0.300];
    [self.containerView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.addBookView = [TMAddBookView new];
    [self.containerView addSubview:self.addBookView];
    [self.addBookView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(SCREEN_SIZE.width - 80);
        make.height.equalTo(weakSelf.containerView).multipliedBy(0.25);
        make.centerX.equalTo(weakSelf.containerView);
        make.top.equalTo(weakSelf.containerView).offset(150);
    }];
    
    [self layoutMenuOperationBtn];
    
    self.addBookView.clickCancelBtn = ^ {
        weakSelf.containerView.alpha = 0.0;
        [weakSelf.window sendSubviewToBack:weakSelf.containerView];
        [weakSelf.addBookView resignFirstResponder];
        [weakSelf clickCancelBtn:nil];
    };
    self.addBookView.clickSureBtn = ^ (NSString *bookName,NSString *bookImageFileName,NSInteger imageIndex) {
        if (bookName.length>6) {
            [weakSelf showSVProgressHUD:@"最多只能输入6个汉字"];
        } else {
            NSString *name = nil;
            if ([bookName isEqualToString:@""]) {
                name = @"新建账本";
            } else {
                name = bookName;
            }
            if (!weakSelf.isUpdate) {
                TMBooks *book = [TMBooks new];
                book.bookImageFileName = bookImageFileName;
                book.bookName = name;
                book.imageIndex = @(imageIndex);
                [[TMDataBaseManager defaultManager] insertBooks:book];
            } else {
                [weakSelf.editBook updateBookName:bookName];
                [weakSelf.editBook updateImageIndex:@(imageIndex)];
                [weakSelf.editBook updateBookImageFileName:bookImageFileName];
                weakSelf.update = NO;
            }
            weakSelf.containerView.alpha = 0.0;
            [weakSelf.window sendSubviewToBack:weakSelf.containerView];
            [weakSelf.addBookView resignFirstResponder];
            [weakSelf.addBookView reloadData];
            [weakSelf.collectionView reloadData];
            [weakSelf clickCancelBtn:nil];
        }
    };
    self.containerView.alpha = 0.0;
    [self.window sendSubviewToBack:self.containerView];
    
}
- (void)updateBook {
    
}
/** cancelBtn,deleteBtn,editBtn */
- (void)layoutMenuOperationBtn {
    WEAKSELF
    [self.view addSubview:self.cancelBtn];
    [self.cancelBtn makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(60, 60));
        make.left.equalTo(weakSelf.view).offset(20);
        make.bottom.equalTo(weakSelf.view).offset(60);
    }];
    [self.view addSubview:self.deleteBtn];
    [self.deleteBtn makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.cancelBtn);
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.cancelBtn);
    }];
    [self.view addSubview:self.editBtn];
    [self.editBtn makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.cancelBtn);
        make.right.equalTo(weakSelf.collectionView).offset(-20);
        make.bottom.equalTo(weakSelf.cancelBtn);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[TMDataBaseManager defaultManager] numberOfAllBooksCount] + 1;//last Add
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TMSideCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    cell.sideCellDelegate = self;
    cell.indexPath = indexPath;
    TMBooks *book = nil;
    //* previousSelected Book ->true*/
    if (indexPath.row==self.previousSelectedBook) {
        cell.selectedItemImageView.hidden = NO;
    } else {
        cell.selectedItemImageView.hidden = YES;
    }
    //* last item on Add ->true*/
    if (indexPath.row == [[TMDataBaseManager defaultManager] numberOfAllBooksCount]) {
        book = [TMBooks new];
        book.bookImageFileName = @"menu_cell_add";
    } else {
        book = self.results[indexPath.row];
    }
    
    //* edit mode on shake ->ture*/
    if (self.isEdit) {
        if ([indexPath isEqual:self.editSelectedIndexPath]) {
            cell.editSelectedItemImageView.hidden = NO;
        } else {
            cell.editSelectedItemImageView.hidden = YES;
        }
        [self shakeCell:cell];
    } else {
        cell.editSelectedItemImageView.hidden = YES;
        cell.transform = CGAffineTransformIdentity;
    }
    cell.book = book;
    return cell;
}
/** 抖动动画 */
- (void)shakeCell:(TMSideCell *)cell {
    [UIView animateWithDuration:0.1 delay:0 options:0 animations:^{
        cell.transform=CGAffineTransformMakeRotation(-0.02);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse | UIViewAnimationOptionAllowUserInteraction animations:^{
            cell.transform=CGAffineTransformMakeRotation(0.02);
        } completion:nil];
    }];
}
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEdit) {
        return;
    }
    if (indexPath.row==[[TMDataBaseManager defaultManager] numberOfAllBooksCount]) {
        NSLog(@"click last item");
        self.containerView.alpha = 1.0;
        [self.window bringSubviewToFront:self.containerView];
        [self.addBookView becomeFirstResponder];
    } else {
        TMBooks *book = self.results[indexPath.row];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:book.booksID forKey:@"selectBookID"];
        [defaults synchronize];
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:homeReloadNotifiation object:nil];
    }
}
#pragma mark - TMSideCellDelegate
//* 应该在collectionView cellForItemAtIndexPath 里面判断 做显示选择了按钮的操作*/
- (void)TMSideCellWithIndexPath:(NSIndexPath *)indexPath
                  withLongPress:(UILongPressGestureRecognizer *)longPress {
    //* 最后一个不能编辑或者已经是编辑模式 */
    if (indexPath.row == [[TMDataBaseManager defaultManager] numberOfAllBooksCount] || self.isEdit) {
        return;
    }
    if (longPress.state == UIGestureRecognizerStateBegan) {
        self.editSelectedIndexPath = indexPath;     //1
        self.edit = YES;                            //2
        [self.collectionView reloadData];           //3
        [self animationWithAppear];
    }
}

#pragma mark - action
- (void)clickExploreBtn:(TMSideButton *)sender {
    NSLog(@"clcick ExploreBtn");
   
}
-(void)clickCancelBtn:(TMSideButton *)sender {
    self.edit = NO;
    TMSideCell *cell = (TMSideCell *)[self.collectionView cellForItemAtIndexPath:self.editSelectedIndexPath];
    cell.editSelectedItemImageView.hidden = YES;
    [self animationWithDisAppear];
    [self.collectionView reloadData];
}
- (void)clickDeleteBtn:(TMSideButton *)sender {
    if (self.results.count<2) {
        [self showSVProgressHUD:@"请最后留下一个账本"];
        return;
    }
    TMBooks *book = self.results[self.editSelectedIndexPath.row];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"删除“%@”",book.bookName] message:@"若删除,其所有数据也将被删除" preferredStyle:UIAlertControllerStyleAlert];
    WEAKSELF
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf clickCancelBtn:nil];
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"删除账本=%@",book.bookName);
        [[TMDataBaseManager defaultManager] deleteBookWithBookID:book.booksID];
        //* 当删除的账本为选择的账本,则默认选择最后一个对象 */
        if (self.previousSelectedBook == self.editSelectedIndexPath.row) {
            TMBooks *book = self.results.lastObject;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:book.booksID forKey:@"selectBookID"];
            [defaults synchronize];
        }
        [self clickCancelBtn:nil];
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:homeReloadNotifiation object:nil];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)clickEditBtn:(TMSideButton *)sender {
    self.update = YES;
    self.editBook = self.results[self.editSelectedIndexPath.row];
    [self.addBookView becomeFirstResponder];
    self.addBookView.text = self.editBook.bookName;
    self.addBookView.index = self.editBook.imageIndex.intValue;
    self.containerView.alpha = 1.0;
    [self.window bringSubviewToFront:self.containerView];
    
}

//* deleteBtn,editBtn对齐cancelBtn的bottom所以只需要改变cancelBtn的bottom即可 */
/** 出现 ->update delete,cancel,edit explore */
- (void)animationWithAppear {
    WEAKSELF
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.cancelBtn updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.view);
        }];
    } completion:^(BOOL finished) {
        [self.exploreBtn updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.view).offset(60);
        }];
    }];
}
/** 消失 */
- (void)animationWithDisAppear {
    WEAKSELF
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.cancelBtn updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.view).offset(60);
        }];
    } completion:^(BOOL finished) {
        [self.exploreBtn updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.view);
        }];
    }];    
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
