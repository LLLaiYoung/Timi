//
//  TMRemarkViewController.m
//  Timi
//
//  Created by chairman on 16/6/2.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

/**
 *  Bug
 *
 *  选择照片后,替换...
 *  ActionSheetView
 */


#import "TMRemarkViewController.h"
#import <Masonry/Masonry.h>
#import "UITextView+Placeholder.h"
#import "TMButton.h"
#import "TMActionSheetView.h"
#import "TMBill.h"
#import "UIImage+TMUIImage.h"

@interface TMRemarkViewController ()
<
UITextViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>
/** 时间 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 备注内容 */
@property (nonatomic, strong) UITextView *contentTextView;
/** 输入辅助视图,存放camerBtn,limitLabel */
@property (nonatomic, strong) UIView *accessoryView;
/** 相机 */
@property (nonatomic, strong) UIButton *camerBtn;
/** 限制 */
@property (nonatomic, strong) UILabel *limitLabel;
@property (nonatomic, strong) TMActionSheetView *actionSheetView;
/** 显示提示表 default NO */
@property (nonatomic, assign, getter=isDisplayActionSheetView) BOOL displayActionSheetView;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
/** 备注 */
@property (nonatomic, strong) NSString *reMarks;
/** 备注图片 */
@property (nonatomic, strong) NSData *photoData;

@end

@implementation TMRemarkViewController
- (UIImagePickerController *)imagePicker
{
    if (!_imagePicker) {
        _imagePicker = [UIImagePickerController new];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}
#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNavigationBar];
    [self layoutSubviews];
    [self registerNotification];
    [self actionSheetViewEvent];
    self.displayActionSheetView = NO;
    self.contentTextView.text = self.bill.reMarks;
    self.reMarks = self.bill.reMarks;
    self.photoData = self.bill.remarkPhoto;
    if (self.bill.remarkPhoto) {
        [self.camerBtn setImage:[UIImage imageWithData:self.bill.remarkPhoto] forState:UIControlStateNormal];
    }
    NSLog(@"bill = %@",self.bill);
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.contentTextView becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
//- (void)registerNotification {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
//}
- (void)setUpNavigationBar {
    TMButton *cancelBtn = [[TMButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIImage *image = [[UIImage imageNamed:@"btn_item_close"] imageByResizeToSize:cancelBtn.frame.size];
    [cancelBtn setImage:image forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.title = @"备注";
    
    TMButton *completeBtn = [[TMButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    completeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [completeBtn setTitleColor:LineColor forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(clickCompleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:completeBtn];
}
- (void)layoutSubviews {
    WEAKSELF
    self.timeLabel = ({
        UILabel *label = [UILabel new];
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_SIZE.width, 30));
            make.left.equalTo(weakSelf.view).mas_offset(10);
            make.top.mas_equalTo(kMaxNBY);
        }];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor colorWithWhite:0.800 alpha:1.000];
        NSMutableString *dateStr = self.bill.dateStr.mutableCopy;
        [dateStr replaceCharactersInRange:NSMakeRange(4, 1) withString:@"年"];
        [dateStr replaceCharactersInRange:NSMakeRange(7, 1) withString:@"月"];
        [dateStr insertString:@"日" atIndex:10];
        label.text = dateStr;
        label;
    });

    
    self.contentTextView = ({
        UITextView *textView = [UITextView new];
        [self.view addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_SIZE.width, 300));
            make.top.equalTo(weakSelf.timeLabel.mas_bottom);
            make.left.equalTo(weakSelf.timeLabel.mas_left);
        }];
        textView.delegate = self;
        textView.font = [UIFont systemFontOfSize:20.0f];
        textView.placeholder = @"记录花销更记录生活...";
        textView.placeholderColor = LineColor;
        textView;
    });
    
    self.accessoryView = ({
        UIView *view = [UIView new];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_SIZE.width, 50));
            make.left.bottom.equalTo(weakSelf.view);
        }];
        view;
    });
    
    
    self.camerBtn = ({
        UIButton *btn = [UIButton new];
        [self.accessoryView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.left.equalTo(weakSelf.timeLabel);
            make.bottom.equalTo(weakSelf.accessoryView).offset(-10);
        }];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_camera"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickCamerBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });

    
    self.limitLabel = ({
        UILabel *label = [UILabel new];
        [self.accessoryView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 30));
            make.bottom.equalTo(weakSelf.accessoryView).offset(-10);
            make.right.equalTo(weakSelf.accessoryView).offset(-20);
        }];
        label.textColor = LineColor;
        label.text = @"0/40";
        
        label;
    });
    
    self.actionSheetView = ({
        TMActionSheetView *view = [TMActionSheetView new];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_SIZE.width, 0));
            make.left.bottom.right.equalTo(weakSelf.view);
        }];
        view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
        view;
    });

}
#pragma mark - action
/** 提示视图的事件 */
- (void)actionSheetViewEvent {
    WEAKSELF
    _actionSheetView.cancelBtnBlock = ^ {
        [weakSelf.actionSheetView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_SIZE.width, 0));
        }];
        //* 立即掉用layoutSubviews */
        [weakSelf.view layoutIfNeeded];
        [weakSelf.contentTextView becomeFirstResponder];
        weakSelf.view.backgroundColor = [UIColor whiteColor];
        weakSelf.contentTextView.backgroundColor = [UIColor whiteColor];
        weakSelf.displayActionSheetView = NO;
    };
    
    _actionSheetView.albumBtnBlock = ^ {
        [weakSelf readPhoto];
    };
    
    _actionSheetView.camerBtnBlock = ^ {
        [weakSelf camera];
    };
}
- (void)camera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //  相机的调用为照相模式
        self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        //  设置为NO则隐藏了拍照按钮
        self.imagePicker.showsCameraControls = YES;
        //  设置相机摄像头默认为前置
        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        //  设置相机闪光灯开关
        self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
        /**
         * 如果相机是英文
         *  设置info.plist Localized resources can be mixed = YES;
         */
    } else {
        [self showSVProgressHUD:@"当前设备不支持相机调用"];
    }

}
/** 读取相册 */
- (void)readPhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}
- (void)clickCamerBtn:(UIButton *)sender {
    WEAKSELF
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.5f animations:^{
        [weakSelf.actionSheetView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_SIZE.width, 180));
        }];
        //* 立即掉用layoutSubviews */
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        weakSelf.view.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1.00];
        weakSelf.contentTextView.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1.00];
        weakSelf.displayActionSheetView = YES;
    }];
}
- (void)cancelBtn:(TMButton *)sender {
    if (self.contentTextView.text.length>40) {
        [self showSVProgressHUD:@"备注超过最大字数"];
        return;
    }
    WEAKSELF
    [self dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.passbackBlock) {
            weakSelf.passbackBlock(weakSelf.reMarks,weakSelf.photoData);
        }
    }];
}
- (void)clickCompleteBtn:(TMButton *)sender {
    NSLog(@"click ComplectBtn");
    [self cancelBtn:sender];
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil
     ];
}

#pragma mark - Notification Action

- (void)keyboardWillChangeFrameNotification:(NSNotification *)noti {
    CGFloat keyboardHeight = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat keyboardMinY = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat animationDuration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (keyboardMinY == SCREEN_SIZE.height) {
        [UIView animateWithDuration:animationDuration animations:^{
            [self.accessoryView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_SIZE.width, 50));
                make.left.bottom.equalTo(self.view);
            }];
            //* 立即掉用layoutSubviews */
            [self.view layoutIfNeeded];
        }];
        return;
    }
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.accessoryView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-keyboardHeight);
            make.size.mas_equalTo(CGSizeMake(SCREEN_SIZE.width, 50));
            make.left.equalTo(self.view);
        }];
        //* 立即掉用layoutSubviews */
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"text = %@",textView.text);
    self.reMarks = textView.text;
    self.limitLabel.text = [NSString stringWithFormat:@"%lu/40",(unsigned long)textView.text.length];
    if (textView.text.length>40) {
        self.limitLabel.textColor = [UIColor redColor];
    } else {
        self.limitLabel.textColor = LineColor;
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.isDisplayActionSheetView) {
        self.displayActionSheetView = NO;
        [self.actionSheetView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_SIZE.width, 0));
        }];
        //* 立即掉用layoutSubviews */
        [self.view layoutIfNeeded];
        self.view.backgroundColor = [UIColor whiteColor];
        self.contentTextView.backgroundColor = [UIColor whiteColor];
    }
    return YES;
}
#pragma mark - UIImagePickerControllerDelegate
//* 选择好image后做什么 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self.camerBtn setBackgroundImage:info[UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
    NSData *imageData = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage], 0.8);
    self.photoData = imageData;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc {
    NSLog(@"good bye TMRemarkViewController");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
