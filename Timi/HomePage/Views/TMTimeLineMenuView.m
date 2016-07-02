//
//  TMTimeLineMenuView.m
//  Timi
//
//  Created by chairman on 16/5/20.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "TMTimeLineMenuView.h"
#import "Const.h"
#import "TMTimeLineCell.h"
/** 默认updateBtn,deleteBtn按钮的frame 缺省 y */
#define kDefaulBtnFrame(y) CGRectMake((SCREEN_SIZE.width-kTimeLineBtnWidth)/2, y, kTimeLineBtnWidth, kTimeLineBtnWidth)

@interface TMTimeLineMenuView()
@property (nonatomic, strong) UIButton *categoryBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *updateBtn;
@property (nonatomic, assign) CGRect receiveRect;///<接收到的rect
@end
@implementation TMTimeLineMenuView
#pragma mark - lazy loading
- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        //* -30 在屏幕外 */
        UIButton *button = [[UIButton alloc]initWithFrame:kDefaulBtnFrame(-30)];
        [button addTarget:self action:@selector(clickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"item_delete"] forState:UIControlStateNormal];
        _deleteBtn = button;
    }
    return _deleteBtn;
}
- (UIButton *)updateBtn
{
    if (!_updateBtn) {
        UIButton *button = [[UIButton alloc]initWithFrame:kDefaulBtnFrame(-30)];
        [button addTarget:self action:@selector(clickUpdateBtn:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"item_edit"] forState:UIControlStateNormal];
        _updateBtn = button;
    }
    return _updateBtn;
}
- (UIButton *)categoryBtn
{
    if (!_categoryBtn) {
        UIButton *button = [[UIButton alloc]initWithFrame:kDefaulBtnFrame(-30)];
        [button addTarget:self action:@selector(clickCategoryBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _categoryBtn = button;
    }
    return _categoryBtn;
}
#pragma mark - system Methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.deleteBtn];
        [self addSubview:self.updateBtn];
        [self addSubview:self.categoryBtn];
    }
    return self;
}

#pragma mark - action
- (void)clickDeleteBtn:(UIButton *)sender {
    NSLog(@"click delete Btn");
    if (self.timeLineMenuDelegate && [self.timeLineMenuDelegate respondsToSelector:@selector(clickDeleteBtn)]) {
        [self.timeLineMenuDelegate clickDeleteBtn];
    }
}

- (void)clickUpdateBtn:(UIButton *)sender {
    NSLog(@"click Update Btn");
    if (self.timeLineMenuDelegate && [self.timeLineMenuDelegate respondsToSelector:@selector(clickUpdateBtn)]) {
        [self.timeLineMenuDelegate clickUpdateBtn];
    }
}
- (void)clickCategoryBtn:(UIButton *)sender {
    NSLog(@"click category btn");
    [self dismiss];
}
#pragma mark - Public Methods
- (void)showTimeLineMenuViewWithRect:(CGRect)receiveRect {
    self.receiveRect = receiveRect;
    [self.categoryBtn setImage:self.currentImage forState:UIControlStateNormal];
    /** 隐藏cell的label */
    if ([self.timeLineMenuDelegate respondsToSelector:@selector(hiddenCellLabelWithBool:)]) {
        [self.timeLineMenuDelegate hiddenCellLabelWithBool:YES];
    }
    
    WEAKSELF
    //* 64为cell的height,-5因为图片距离底部5 */
    receiveRect.origin.y +=64-kTimeLineBtnWidth-5;
    CGRect rect = kDefaulBtnFrame(receiveRect.origin.y);
    weakSelf.deleteBtn.frame = rect;
    weakSelf.updateBtn.frame = rect;
    weakSelf.categoryBtn.frame = rect;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        weakSelf.deleteBtn.frame = CGRectMake((SCREEN_SIZE.width-kTimeLineBtnWidth)/2 - kBlankWidth , rect.origin.y, kTimeLineBtnWidth, kTimeLineBtnWidth);
        weakSelf.updateBtn.frame = CGRectMake((SCREEN_SIZE.width-kTimeLineBtnWidth)/2 + kBlankWidth , rect.origin.y, 30, 30);
        //* 置顶 */
        [weakSelf.superview bringSubviewToFront:weakSelf];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    NSLog(@"%s,%d",__func__,__LINE__);
    WEAKSELF
    [UIView animateWithDuration:kAnimationDuration animations:^{
        CGRect rect = self.receiveRect;
        rect.origin.y += 64-kTimeLineBtnWidth-5;
        weakSelf.deleteBtn.frame = CGRectMake((SCREEN_SIZE.width-kTimeLineBtnWidth)/2 , rect.origin.y, kTimeLineBtnWidth, kTimeLineBtnWidth);
        NSLog(@"%d",__LINE__);
        weakSelf.updateBtn.frame = CGRectMake((SCREEN_SIZE.width-kTimeLineBtnWidth)/2 , rect.origin.y, kTimeLineBtnWidth, kTimeLineBtnWidth);
    } completion:^(BOOL finished) {
        //* 放到最底层 */
        [weakSelf.superview sendSubviewToBack:weakSelf];
        [self.categoryBtn setImage:nil forState:UIControlStateNormal];
        //* 数据置空,防止数据出错 */
        self.receiveRect = CGRectZero;
        NSLog(@"%d",__LINE__);
        //* 显示cell的label */
        if ([weakSelf.timeLineMenuDelegate respondsToSelector:@selector(hiddenCellLabelWithBool:)]) {
            [weakSelf.timeLineMenuDelegate hiddenCellLabelWithBool:NO];
        }
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}
@end
