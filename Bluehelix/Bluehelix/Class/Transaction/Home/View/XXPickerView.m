//
//  XXPickerView.m
//  Bhex
//
//  Created by Bhex on 2018/9/9.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "XXPickerView.h"

@interface XXPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

/** 数组 */
@property (strong, nonatomic) NSMutableArray *dataArray;

/** 蒙版 */
@property (strong, nonatomic) UIVisualEffectView *mengView;

/** 按钮 */
@property (strong, nonatomic) XXButton *cancelBigButton;

/** 版式图 */
@property (strong, nonatomic) UIView *banView;

/** 取消按钮 */
@property (strong, nonatomic) XXButton *cancelButton;

/** 确认确认按钮 */
@property (strong, nonatomic) XXButton *okButton;

/** 拾取器 */
@property (strong, nonatomic) UIPickerView *pickerView;

/** block */
@property (strong, nonatomic) void(^pickerBlock)(NSInteger row0, NSInteger row1);

/** 第一列选中的行 */
@property (assign, nonatomic) NSInteger row0;

/** 第二列选中的行 */
@property (assign, nonatomic) NSInteger row1;

@end

@implementation XXPickerView

static XXPickerView *pickerView = nil;


#pragma mark - 1.0 展示拾取器
+ (void)showPickerViewDataArray:(NSMutableArray *)dataArray
                           row0:(NSInteger)row0
                           row1:(NSInteger)row1
                          block:(void(^)(NSInteger row0, NSInteger row1))block {
    
    if (!pickerView) {
        pickerView = [[XXPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
        pickerView.backgroundColor = [UIColor clearColor];
        [pickerView setupUI];
    }
    pickerView.pickerBlock = block;
    pickerView.dataArray = dataArray;
    [pickerView.pickerView reloadAllComponents];
    
    pickerView.row0 = row0;
    pickerView.row1 = row1;
    
    [pickerView.pickerView selectRow:row0 inComponent:0 animated:YES];
    [pickerView.pickerView selectRow:row1 inComponent:1 animated:YES];
    
    [pickerView.cancelButton setTitle:LocalizedString(@"Cancel") forState:UIControlStateNormal];
    pickerView.cancelButton.frame = CGRectMake(0, 0, K375(48) + [NSString widthWithText:LocalizedString(@"Cancel") font:kFontBold16], 55);
    
    [pickerView.okButton setTitle:LocalizedString(@"QueDing") forState:UIControlStateNormal];
    pickerView.okButton.frame = CGRectMake(kScreen_Width - (K375(48) + [NSString widthWithText:LocalizedString(@"QueDing") font:kFontBold16]), 0, K375(48) + [NSString widthWithText:LocalizedString(@"QueDing") font:kFontBold16], 55);
    
    [pickerView show];

}

#pragma mark - 2.1 展示拾取器
- (void)show {
    self.banView.top = kScreen_Height;
    self.mengView.alpha = 0.0f;
    [KWindow addSubview:self];
    [UIView animateWithDuration:0.25f animations:^{
        self.banView.top = kScreen_Height - 211;
        self.mengView.alpha = 0.92f;
    }];
}
- (void)dismiss {
    [UIView animateWithDuration:0.25f animations:^{
        self.mengView.alpha = 0.0f;
        self.banView.top = kScreen_Height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 3. 初始化UI
- (void)setupUI {
    
    [self addSubview:self.mengView];
    [self addSubview:self.cancelBigButton];
    [self addSubview:self.banView];
    [self.banView addSubview:self.cancelButton];
    [self.banView addSubview:self.okButton];
    [self.banView addSubview:self.pickerView];
}

#pragma mark - 4. 代理
//返回列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.dataArray.count;
}
//返回每列行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSMutableArray *array = self.dataArray[component];
    return array.count;
}
//每行高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

//每个item的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return kScreen_Width/2;
}

//改变选中那行的字体和颜色
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view){
        view = [[UIView alloc]init];
    }
    
    //设置分割线的颜色

    for(UIView*singleLine in pickerView.subviews) {
    
        if(singleLine.frame.size.height<1) {

            singleLine.backgroundColor = kDark50;
        }
    }
    
    UILabel *textLabel = [[UILabel alloc] init];
    if (component == 0) {
        textLabel.frame = CGRectMake(K375(24), 0, kScreen_Width/2 - K375(24), 40);
        textLabel.textAlignment = NSTextAlignmentLeft;
    } else {
        textLabel.frame = CGRectMake(0, 0, kScreen_Width/2 - K375(24), 40);
        textLabel.textAlignment = NSTextAlignmentRight;
    }
    textLabel.text = self.dataArray[component][row];
    textLabel.textColor = kDark100;
    [view addSubview:textLabel];
    return view;
}

//被选择的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.row0 = row;
    } else if (component == 1) {
        self.row1 = row;
    }
}

#pragma mark - || 懒加载
- (UIVisualEffectView *)mengView {
    if (_mengView == nil) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:kIsNight ? UIBlurEffectStyleLight : UIBlurEffectStyleDark];
        _mengView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _mengView.alpha = 0.98f;
        _mengView.frame = self.frame;
    }
    return _mengView;
}

- (XXButton *)cancelBigButton {
    if (_cancelBigButton == nil) {
        MJWeakSelf
        _cancelBigButton = [XXButton buttonWithFrame:self.bounds block:^(UIButton *button) {
            [weakSelf dismiss];
        }];
        _cancelBigButton.backgroundColor = [UIColor clearColor];
    }
    return _cancelBigButton;
}

- (UIView *)banView {
    if (_banView == nil) {
        _banView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height, kScreen_Width, 211)];
        _banView.backgroundColor = kWhite100;
    }
    return _banView;
}

- (XXButton *)cancelButton {
    if (_cancelButton== nil) {
        MJWeakSelf
        _cancelButton = [XXButton buttonWithFrame:CGRectMake(0, 0, K375(48) + [NSString widthWithText:LocalizedString(@"Cancel") font:kFontBold16], 55) title:LocalizedString(@"Cancel") font:kFontBold16 titleColor:kDark100 block:^(UIButton *button) {
            [weakSelf dismiss];
        }];
    }
    return _cancelButton;
}

- (XXButton *)okButton {
    if (_okButton == nil) {
        MJWeakSelf
        _okButton = [XXButton buttonWithFrame:CGRectMake(kScreen_Width - (K375(48) + [NSString widthWithText:LocalizedString(@"QueDing") font:kFontBold16]), 0, K375(48) + [NSString widthWithText:LocalizedString(@"QueDing") font:kFontBold16], 55) title:LocalizedString(@"QueDing") font:kFontBold16 titleColor:kGreen100 block:^(UIButton *button) {
            [weakSelf dismiss];
            if (weakSelf.pickerBlock) {
                weakSelf.pickerBlock(weakSelf.row0, weakSelf.row1);
            }
        }];
    }
    return _okButton;
}

- (UIPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 55, kScreen_Width, 140)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

@end
