//
//  TMCalculatorView.m
//  Timi
//
//  Created by chairman on 16/5/26.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "TMCalculatorView.h"
#import "TMButton.h"
#import "Const.h"
#import "NSString+TMNSString.h"
@interface TMCalculatorView()
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *month_dayLabel;
/** 小数点前的字符串 */
@property (nonatomic, copy) NSString *beforSting;
/** 小数点后的字符串 */
@property (nonatomic, copy) NSString *afterString;
/** 当前字符串 */
@property (nonatomic, copy) NSString *currentString;
/** 做运算之前的字符串 */
@property (nonatomic, copy) NSString *previousString;
/** 选择了小数点 */
@property (nonatomic, assign, getter=isSelectedPoint) BOOL selectedPoint;
/** 选择了`＋`号运输符 */
@property (nonatomic, assign, getter=isSelectedPlusOperation) BOOL selectedPlusOperation;
/** 选择了运行操作符号 */
@property (nonatomic, assign, getter=isSelectedOperation) BOOL selectedOperation;
/** 第一次做运算操作 */
@property (nonatomic, assign, getter=isFirstOperation) BOOL firstOperation;
@end

@implementation TMCalculatorView
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initializesWithPreparation];
}
/** 初始化准备 */
- (void)initializesWithPreparation {
    self.beforSting = @"0";
    self.afterString = @"00";
    self.currentString = [NSString stringWithFormat:@"%@.%@",self.beforSting,self.afterString];
    self.selectedPoint = NO;
    self.selectedPlusOperation = NO;
    self.selectedOperation = NO;
    self.previousString = @"";
}
- (IBAction)didClickBtn:(UIButton *)sender {
    NSString *text = sender.currentTitle;
    
    if ([text isEqualToString:@"."]) {
        self.selectedPoint = YES;
        return;
    } else if ([text isEqualToString:@"清零"]) {
        [self initializesWithPreparation];
        NSLog(@"results = %@",self.currentString);
        if (self.passValuesBlock) {
            self.passValuesBlock(self.currentString);
        }
        return;
    } else if ([text isEqualToString:@"+"] || [text isEqualToString:@"-"] ) {
        if ([text isEqualToString:@"+"]) {//加号
            self.selectedPlusOperation = YES;
            //* 和 */
           float sum = self.previousString.floatValue + self.currentString.floatValue;
            self.currentString = [NSString stringWithFormat:@"%.2f",sum];
        } else {//减号
            //* 差 */
            if (self.previousString.floatValue != 0) {
                float poor = self.previousString.floatValue - self.currentString.floatValue;
                self.currentString = [NSString stringWithFormat:@"%.2f",poor];
            }
            self.selectedPlusOperation = NO;
        }
        NSLog(@"results = %@",self.currentString);
        if (self.passValuesBlock) {
            self.passValuesBlock(self.currentString);
        }
        self.previousString = self.currentString;
        self.beforSting = @"0";
        self.afterString = @"00";
        self.selectedPoint = NO;
        self.selectedOperation = YES;
        return;
    } else if ([text isEqualToString:@"OK"]) {//* ------------------------------------- */
        if (self.isSelectedOperation) {//当用户选择了运输操作符则进行运算,没有则直接输出
            if (self.isSelectedPlusOperation) {
                float sum = self.previousString.floatValue + self.currentString.floatValue;
                self.currentString = [NSString stringWithFormat:@"%.2f",sum];
            } else {
                float poor = self.previousString.floatValue - self.currentString.floatValue;
                self.currentString = [NSString stringWithFormat:@"%.2f",poor];
            }
        }
        //* 传值 */
        NSLog(@"OK results = %@",self.currentString);
        if (self.passValuesBlock) {
            self.passValuesBlock(self.currentString);
        }
        if (self.didClickSaveBtnBlock) {
            self.didClickSaveBtnBlock();
        }
        [self initializesWithPreparation];
        return;
    }
    if (self.isSelectedPoint) {//小数点后
        self.afterString = [NSString stringWithFormat:@"%@0",text];
    } else {//小数点前
        if ([self.beforSting isEqualToString:@"0"]) {//第一次输入或者用户输入为0
            self.beforSting = text;
        } else {
            self.beforSting = [NSString stringWithFormat:@"%@%@",self.beforSting,text];
        }
    }
    self.currentString = [NSString stringWithFormat:@"%@.%@",self.beforSting,self.afterString];
    NSLog(@"results = %@",self.currentString);
    if (self.passValuesBlock) {
        self.passValuesBlock(self.currentString);
    }
}
- (IBAction)clickSelectDateBtn:(UIButton *)sender {
    NSLog(@"click DateBtn");
    if (self.didClickDateBtnBlock) {
        self.didClickDateBtnBlock();
    }
}
- (IBAction)clickRemarkBtn:(TMButton *)sender {
    NSLog(@"click RemarkBtn");
    if (self.didClickRemarkBtnBlock) {
        self.didClickRemarkBtnBlock();
    }
}

- (void)setTimeWtihTimeString:(NSString *)timeString {
    
    NSLog(@"time = %@",timeString);
    if (![timeString isEqualToString:[NSString currentDateStr]]) {//选择的日期不是今天
        NSString *year = [timeString substringToIndex:4];
        self.yearLabel.text = year;
        self.yearLabel.textColor = kSelectColor;
        NSRange monthRange = NSMakeRange(5, 2);
        NSString *month = [timeString substringWithRange:monthRange];
        NSString *day = [timeString substringFromIndex:8];
        NSString *month_day = [NSString stringWithFormat:@"%@月%@日",month,day];
        self.month_dayLabel.text = month_day;
        self.month_dayLabel.textColor = kSelectColor;
    } else {//选择的日期是今天
        self.yearLabel.text = [[NSString currentDateStr] substringToIndex:4];
        self.yearLabel.textColor = [UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1.00];
        self.month_dayLabel.text = @"今天";
        self.month_dayLabel.textColor = [UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1.00];
    }
}
@end
