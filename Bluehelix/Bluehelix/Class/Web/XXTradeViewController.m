//
//  XXTradeViewController.m
//  Bhex
//
//  Created by YiHeng on 2020/3/24.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXTradeViewController.h"
#import <WebKit/WebKit.h>
#import "XXFailureView.h"
#import "NJKWebViewProgressView.h"
#import "XXVisitAddressAlert.h"
#import "XXChangeAccountAlert.h"
#import "XXPayInfoView.h"
#import "XXWebMenuAlert.h"
#import "WKWebViewJavascriptBridge.h"
#import "XXMsgRequest.h"
#import "XXMsg.h"
#import "XXPasswordAlertView.h"
#import "XXTokenModel.h"

@interface XXTradeViewController () <WKUIDelegate, WKNavigationDelegate>

/** webView */
@property (strong, nonatomic, nullable) WKWebView *webView;
@property (strong, nonatomic, nullable) NJKWebViewProgressView *progressView;;
@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;

/** 失败视图 */
@property (nonatomic, strong) XXFailureView *failureView;

/// 交易请求
@property (strong, nonatomic) XXMsgRequest *signRequest;

@property (copy, nonatomic) WVJBResponseCallback responseCallback; //签名后回调函数
@end

@implementation XXTradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self initBridge];
    [self loadRequest];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [KSystem statusBarSetUpDarkColor];
}

#pragma mark - 1. 初始化页面
- (void)setupUI {
    self.navView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.leftButton setImage:[UIImage imageNamed:@"icon_back_0"] forState:UIControlStateNormal];
    self.leftButton.hidden = YES;
    [self.rightButton setImage:[UIImage imageNamed:@"dapp_refresh"] forState:UIControlStateNormal];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.failureView];
    [self.view addSubview:self.progressView];
    if (!IsEmpty(self.navTitle)) {
        self.titleLabel.text = self.navTitle;
    }
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    //    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)initBridge {
    MJWeakSelf;
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [WKWebViewJavascriptBridge enableLogging];
    [self.bridge registerHandler:@"connect" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *callBackDic = @{@"code":@200,@"msg":@"OK",@"data":@""};
        responseCallback([callBackDic mj_JSONString]);
    }];
    [self.bridge registerHandler:@"get_account" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *dataDic = @{@"address":KUser.address};
        NSDictionary *callBackDic = @{@"code":@200,@"msg":@"OK",@"data":dataDic};
        responseCallback([callBackDic mj_JSONString]);
    }];
    [self.bridge registerHandler:@"sign" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *type = data[@"type"];
        if ([type isEqualToString:kMsgAddLiquidity] || [type isEqualToString:kMsgRemoveLiquidity] || [type isEqualToString:kMsgSwapExactOut] || [type isEqualToString:kMsgSwapExactIn]) {
            if (responseCallback) {
                weakSelf.responseCallback = responseCallback;
            }
            XXPayInfoModel *model = [[XXPayInfoModel alloc] initWithData:data];
            [XXPayInfoView showWithSureBlock:^{
                [weakSelf alertPassword:data];
            } model:model];
        } else {
            if (responseCallback) {
                weakSelf.responseCallback = responseCallback;
            }
            [weakSelf alertPassword:data];
        }
        NSLog(@"=========js%@",data);
    }];
    [self.bridge setWebViewDelegate:self];
}

/// 弹出密码
- (void)alertPassword:(id)data {
    if (KUser.showPassword) {
        MJWeakSelf
        [XXPasswordAlertView showWithSureBtnBlock:^(NSString * _Nonnull text) {
            [weakSelf requestWebTrade:text data:data];
        }];
    } else {
        [self requestWebTrade:kText data:data];
    }
}

- (void)requestWebTrade:(NSString *)text data:(id)data {
    XXTokenModel *mainToken = [[XXSqliteManager sharedSqlite] tokenBySymbol:kMainToken];
    NSDecimalNumber *feeAmountDecimal = [NSDecimalNumber decimalNumberWithString:kMinFee];
    NSString *feeAmount = [[feeAmountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(mainToken.decimals)] stringValue];
    
    XXMsg *model = [[XXMsg alloc] initWithFeeAmount:feeAmount feeDenom:kMainToken msg:data memo:@"" text:text];
    _signRequest = [[XXMsgRequest alloc] init];
    MJWeakSelf
    _signRequest.msgSendSuccessBlock = ^(id  _Nonnull responseObject) {
        if (weakSelf.responseCallback) {
            NSDictionary *callBackDic = @{@"code":@200,@"msg":@"OK",@"data":responseObject};
            weakSelf.responseCallback([callBackDic mj_JSONString]);
            weakSelf.responseCallback = nil;
        }
    };
    _signRequest.msgSendFaildBlock = ^(NSString * _Nonnull msg) {
        if (weakSelf.responseCallback) {
            NSDictionary *callBackDic = @{@"code":@0,@"msg":msg,@"data":@""};
            weakSelf.responseCallback([callBackDic mj_JSONString]);
            weakSelf.responseCallback = nil;
        }
    };
    [_signRequest sendMsg:model];
}

#pragma mark - 3. WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"didStartProvisionalNavigation");
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"didCommitNavigation");
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
     NSLog(@"didFinishNavigation");
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
    //    [self.webView.scrollView.mj_header endRefreshing];
    self.failureView.hidden = NO;
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"didReceiveServerRedirectForProvisionalNavigation");
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    self.leftButton.hidden = [navigationAction.request.URL.absoluteString containsString:kWebUrl];
    
    if ([navigationAction.request.URL.absoluteString hasPrefix:@"sms:"]
        || [navigationAction.request.URL.absoluteString hasPrefix:@"tel:"]
        || [navigationAction.request.URL.absoluteString hasPrefix:@"mailto:"]
        || [navigationAction.request.URL.absoluteString rangeOfString:@"itunes.apple.com"].location != NSNotFound) {
        if ([[UIApplication sharedApplication] canOpenURL:navigationAction.request.URL]) {
            [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    //解决target='_blank'，导致WKWebView无法加载点击后的网页的问题。
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView evaluateJavaScript:@"var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}" completionHandler:nil];
    }
    
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}

#pragma mark - 4. WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:LocalizedString(@"QueDing") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(alertController.textFields.lastObject.text);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:LocalizedString(@"QueDing") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(YES);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:LocalizedString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(NO);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:LocalizedString(@"QueDing") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 5.1 加载Request
- (void)loadRequest {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:request];
}

#pragma mark - 6. 监听加载进度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object != self.webView) {
        [super observeValueForKeyPath:keyPath ofObject:object  change:change context:context];
        return;
    }
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) { // 加载进度
        if(self.webView.estimatedProgress >=1.0f) {
            
            [self.progressView setProgress:self.webView.estimatedProgress];
            [UIView animateWithDuration:0.25f animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        } else {
            self.progressView.alpha = 1.0f;
            [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        }
    }
    //    else if ([keyPath isEqualToString:@"title"]) { // 标题
    //        if (!self.navTitle) {
    //            self.titleLabel.text = self.webView.title;
    //        }
    //    }
}

#pragma mark - 7. 关闭按钮点击事件
- (void)dismissButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 8. 返回按钮
- (void)leftButtonClick:(UIButton *)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.webView reload];
    }
}

- (void)rightButtonClick:(UIButton *)sender {
//    [self.webView reload];
    [self loadRequest];
}

#pragma mark - Dealloc
- (void)dealloc {
    if (_webView) {
        [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
        //        [_webView removeObserver:self forKeyPath:@"title"];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//#pragma mark - || 懒加载
- (void)setUrlString:(NSString *)urlString {
    if ([urlString containsString:@"?"]) {
        _urlString = [NSString stringWithFormat:@"%@&lang=%@", urlString, [[LocalizeHelper sharedLocalSystem] getRequestHeaderLanguageCode]];
    } else {
        _urlString = [NSString stringWithFormat:@"%@?lang=%@", urlString, [[LocalizeHelper sharedLocalSystem] getRequestHeaderLanguageCode]];
    }
    _urlString = [_urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

/** webView */
- (WKWebView *)webView {
    if (_webView == nil) {
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences.minimumFontSize = 10;
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavHeight+2, kScreen_Width, kScreen_Height - kNavHeight - kTabbarHeight - 2) configuration:config];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.UIDelegate = self;
        
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _webView;
}

/** 失败视图 */
- (XXFailureView *)failureView {
    if (_failureView == nil) {
        _failureView = [[XXFailureView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight)];
        _failureView.hidden = YES;
        MJWeakSelf
        _failureView.reloadBlock = ^{
            [weakSelf.webView reload];
            weakSelf.failureView.hidden = YES;
        };
    }
    return _failureView;
}

- (NJKWebViewProgressView *)progressView {
    if (_progressView == nil) {
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, 2)];
        _progressView.progress = 0;
    }
    return _progressView;
}
@end
