//
//  XXServiceView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/6/4.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXServiceView.h"
#import <WebKit/WebKit.h>

@interface XXServiceView ()

@property (nonatomic, strong) WKWebView *webview;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) XXButton *sureBtn;
@property (nonatomic, strong) XXButton *isAgreeButton;

@end

@implementation XXServiceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUI];

    }
    return self;
}

- (void)buildUI {

    [self addSubview:self.webview];
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.isAgreeButton];
    [self.bottomView addSubview:self.sureBtn];
}

- (WKWebView *)webview {
    if (!_webview) {
        _webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreen_Width, kScreen_Height - 168 - kStatusBarHeight)];
        //加载网址
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
//        [_webview loadRequest:request];

        //加载本地html
        NSString *htmlPath;
        NSString *language = [[LocalizeHelper sharedLocalSystem] getRequestHeaderLanguageCode];
        if ([language isEqualToString:@"zh-cn"]) { // 中文
            htmlPath = [[NSBundle mainBundle] pathForResource:@"service" ofType:@"html"];
        } else {
            htmlPath = [[NSBundle mainBundle] pathForResource:@"service_en" ofType:@"html"];
        }
        NSURL * url = [NSURL fileURLWithPath:[[NSBundle mainBundle]bundlePath]];
        NSError *error = nil;
        NSString *html = [[NSString alloc] initWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:&error];
        if (error == nil) {
            [_webview loadHTMLString:html baseURL:url];
        }
    }
    return _webview;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 168, kScreen_Width, 168)];
    }
    return _bottomView;
}

- (XXButton *)isAgreeButton {
    if (_isAgreeButton == nil) {
        MJWeakSelf
        _isAgreeButton = [XXButton buttonWithFrame:CGRectMake(K375(24), 10, kScreen_Width - K375(48), 30) block:^(UIButton *button) {
            weakSelf.isAgreeButton.selected = !weakSelf.isAgreeButton.selected;
            if (weakSelf.isAgreeButton.selected) {
                weakSelf.sureBtn.enabled = YES;
                weakSelf.sureBtn.backgroundColor = kPrimaryMain;
            } else {
                weakSelf.sureBtn.enabled = NO;
                weakSelf.sureBtn.backgroundColor = kGray100;
            }
        }];
        [_isAgreeButton.titleLabel setFont:kFont13];
        _isAgreeButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        _isAgreeButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_isAgreeButton setImage:[UIImage subTextImageName:@"unSelected"] forState:UIControlStateNormal];
        [_isAgreeButton setImage:[UIImage mainImageName:@"selected"] forState:UIControlStateSelected];
        _isAgreeButton.selected = KUser.agreeService;
        [_isAgreeButton setTitle:LocalizedString(@"ReadAndAgree") forState:UIControlStateNormal];
        _isAgreeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_isAgreeButton setTitleColor:kGray500 forState:UIControlStateNormal];
    }
    return _isAgreeButton;
}

- (XXButton *)sureBtn {
    if (!_sureBtn) {
        MJWeakSelf
        _sureBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.isAgreeButton.frame) + 10, kScreen_Width - K375(32), kBtnHeight) title:LocalizedString(@"Sure") font:kFontBold18 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
                KUser.agreeService = YES;
                [weakSelf.viewController dismissViewControllerAnimated:YES completion:nil];
        }];
        _sureBtn.backgroundColor = KUser.agreeService ? kPrimaryMain : kGray100;
        _sureBtn.layer.cornerRadius = kBtnBorderRadius;
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.enabled = KUser.agreeService;
    }
    return _sureBtn;
}

@end
