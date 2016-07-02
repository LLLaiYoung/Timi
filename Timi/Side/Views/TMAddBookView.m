//
//  TMAddBookView.m
//  Timi
//
//  Created by chairman on 16/6/28.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "TMAddBookView.h"
#import "Const.h"
#import <Masonry.h>
#import "NSArray+TMNSArray.h"
#import "TMAddBooKCell.h"

static NSString *const addBookCellID = @"addBookCellID";

@interface TMAddBookView()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIView *verticalLineView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) NSIndexPath *previousSelectedIndexPath;
/** 编辑模式 */
@property (nonatomic, assign, getter=isUpdate) BOOL update;

@end
@implementation TMAddBookView
#pragma mark - lazy loading
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [UITextField new];
        _textField.placeholder = @"新建账本";
        _textField.textColor = LineColor;
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.font = [UIFont systemFontOfSize:20.0f];
    }
    return _textField;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        CGFloat itemWidth = ((SCREEN_SIZE.width - 80) - 20 * 2 - 15 * 4)/6;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(itemWidth, 50);
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[TMAddBooKCell class] forCellWithReuseIdentifier:addBookCellID];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}
- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _cancelBtn = button;
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedSureBtn:) forControlEvents:UIControlEventTouchUpInside];

        
        _sureBtn = button;
    }
    return _sureBtn;
}


#pragma mark - system Methods

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        WEAKSELF
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.textField];
        [self.textField makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(10);
            make.centerX.equalTo(weakSelf);
            make.left.equalTo(weakSelf).offset(10);
            make.right.equalTo(weakSelf).offset(-10);
        }];
        self.topLineView = [UIView new];
        self.topLineView.backgroundColor = LineColor;
        [self addSubview:self.topLineView];
        [self.topLineView makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf);
            make.height.equalTo(0.5);
            make.top.equalTo(weakSelf.textField.bottom).offset(10);
            make.centerX.equalTo(weakSelf);
        }];
        
        [self addSubview:self.collectionView];
        [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.textField);
            make.top.equalTo(weakSelf.topLineView.bottom);
            make.bottom.equalTo(weakSelf).offset(-60);
        }];
        
        self.bottomLineView = [UIView new];
        self.bottomLineView.backgroundColor = LineColor;
        [self addSubview:self.bottomLineView];
        [self.bottomLineView makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(weakSelf.topLineView);
            make.centerX.equalTo(weakSelf.topLineView);
            make.top.equalTo(weakSelf.collectionView.bottom).offset(10);
        }];
        self.verticalLineView = [UIView new];
        self.verticalLineView.backgroundColor = LineColor;
        [self addSubview:self.verticalLineView];
        [self.verticalLineView makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(0.5);
            make.top.equalTo(weakSelf.bottomLineView.bottom);
            make.bottom.equalTo(weakSelf);
            make.centerX.equalTo(weakSelf);
        }];
        [self addSubview:self.cancelBtn];
        [self.cancelBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(50);
            make.bottom.equalTo(weakSelf).offset(-10);
        }];
        [self addSubview:self.sureBtn];
        
        [self.sureBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf).offset(-50);
            make.bottom.equalTo(weakSelf.cancelBtn);
        }];

        
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [NSArray bookImageFiles].count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TMAddBooKCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:addBookCellID forIndexPath:indexPath];
    NSString *imageFileName = [NSArray bookImageFiles][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imageFileName];
    if (!self.isUpdate) {//非编辑模式
        if (indexPath.row==0) {//第一次
            cell.selectedImageView.hidden = NO;
            self.previousSelectedIndexPath = indexPath;
        } else {
            cell.selectedImageView.hidden = YES;
        }
    } else {//编辑模式
        if (indexPath.row == self.index) {
            cell.selectedImageView.hidden = NO;
            self.previousSelectedIndexPath = indexPath;
            self.update = NO;
        } else {
            cell.selectedImageView.hidden = YES;
        }
    }
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //* 隐藏上一个 */
    if (indexPath.row != self.previousSelectedIndexPath.row) {
        TMAddBooKCell *cell = (TMAddBooKCell *)[collectionView cellForItemAtIndexPath:self.previousSelectedIndexPath];
        cell.selectedImageView.hidden = YES;
    }
    //* 显示当前 */
    TMAddBooKCell *cell = (TMAddBooKCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selectedImageView.hidden = NO;
    self.previousSelectedIndexPath = indexPath;
}

#pragma mark - action
- (void)clickedCancelBtn:(UIButton *)sender {
    NSLog(@"click CancelBtn");
    if (self.clickCancelBtn) {
        self.clickCancelBtn();
    }
}
- (void)clickedSureBtn:(UIButton *)sender {
    NSLog(@"click SureBtn");
    NSString *bookImageFileName = [NSArray bookImageFiles][self.previousSelectedIndexPath.row];
    if (self.clickSureBtn) {
        self.clickSureBtn(self.textField.text,bookImageFileName,self.previousSelectedIndexPath.row);
    }
}

- (void)becomeFirstResponder {
    self.textField.text = @"";
    [self.textField becomeFirstResponder];
}
- (void)resignFirstResponder {
    [self endEditing:YES];
}
- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - setter
- (void)setText:(NSString *)text {
    _text = text.copy;
    self.textField.text = text;
}
//* 重写setter函数,设置一个bool变量update,刷新collectionView,判断update */
- (void)setIndex:(NSInteger)index {
    _index = index;
    self.update = YES;
    [self.collectionView reloadData];
}

@end
