//
//  XXBusinessProgressView.m
//  Bhex
//
//  Created by BHEX on 2018/7/4.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXBusinessProgressView.h"


@interface XXBusinessProgressView ()

/** 线条1 */
@property (strong, nonatomic) UIView *lineOneView;

/** 线条2 */
@property (strong, nonatomic) UIView *lineTwoView;

/** 底部视图数组 */
@property (strong, nonatomic) NSMutableArray *lowViewsArray;

/** 视图数组 */
@property (strong, nonatomic) NSMutableArray *viewsArray;

/** 拖动视图 */
@property (strong, nonatomic) UIView *progressView;

@end
@implementation XXBusinessProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 1. 初始化视图
- (void)setupUI {
  
   // 17
    self.lineOneView = [[UIView alloc] initWithFrame:CGRectMake(8.5, (self.height - 4)/2, self.width - 17, 4)];
    self.lineOneView.backgroundColor = kGrayColor;
    [self addSubview:self.lineOneView];
    
    self.lineTwoView = [[UIView alloc] initWithFrame:self.lineOneView.frame];
    self.lineTwoView.backgroundColor = kBlue100;
    [self addSubview:self.lineTwoView];
    
    self.lineTwoView.width = self.lineOneView.width * 0.0;
    self.viewsArray = [NSMutableArray array];
    self.lowViewsArray = [NSMutableArray array];
    for (NSInteger i=0; i < 5; i ++) {
        
        UIView *lowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.height, self.height)];
        lowView.backgroundColor = kGrayColor;
        lowView.layer.cornerRadius = lowView.height / 2;
        lowView.layer.masksToBounds = YES;
        lowView.centerX = self.height/2 + (self.lineOneView.width/4)*i;
        [self addSubview:lowView];
        [self.lowViewsArray addObject:lowView];
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.height, self.height)];
        topView.backgroundColor = kBlue100;
        topView.layer.cornerRadius = topView.height / 2;
        topView.centerX = self.height/2 + (self.lineOneView.width/4)*i;
        [self addSubview:topView];
        
        topView.hidden = YES;
        [self.viewsArray addObject:topView];
    }
    
    self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.height, self.height)];
    self.progressView.backgroundColor = kBlue100;
    self.progressView.layer.cornerRadius = self.progressView.height / 2.0;
    self.progressView.layer.masksToBounds = YES;
    [self addSubview:self.progressView];
    
    // 拖动手势
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGRAct:)];
//    [self.progressView setUserInteractionEnabled:YES];
    [self addGestureRecognizer:panGR];
    
    // 点击手势
    UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    tapRecognize.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapRecognize];
}

#pragma mark - 2. 拖动手势
- (void)panGRAct: (UIPanGestureRecognizer *)rec{
    
    CGPoint point = [rec locationInView:self];
    CGFloat centerX = point.x - self.progressView.width/2.0;
    if (centerX < self.height/2) {
        centerX = self.height/2;
    }
    
    if (centerX > self.width - self.height/2) {
        centerX = self.width - self.height/2;
    }
    
    [self gestureRecognizer:centerX isTap:YES];
    
//    CGPoint point = [rec translationInView:self];
//    CGFloat centerX = rec.view.center.x + point.x;
//    if (centerX < self.height/2) {
//        centerX = self.height/2;
//    }
//
//    if (centerX > self.width - self.height/2) {
//        centerX = self.width - self.height/2;
//    }
//
//    [self gestureRecognizer:centerX isTap:YES];
//    [rec setTranslation:CGPointMake(0, 0) inView:self];
}

#pragma mark - 3. 单击手势
-(void)handleTap:(UITapGestureRecognizer *)recognizer {
    
    CGPoint point = [recognizer locationInView:self];
    CGFloat centerX = point.x;
    if (centerX < self.height/2) {
        centerX = self.height/2;
    }
    
    if (centerX > self.width - self.height/2) {
        centerX = self.width - self.height/2;
    }
    
    [self gestureRecognizer:centerX isTap:YES];

}

#pragma mark - 4. 处理手势
- (void)gestureRecognizer:(CGFloat)centerX isTap:(BOOL)isTap {
    
    for (NSInteger i=0; i < self.viewsArray.count; i ++) {
        UIView *topView = self.viewsArray[i];
        if (centerX > topView.centerX) {
            topView.hidden = NO;
        } else {
            topView.hidden = YES;
        }
    }
    
    CGFloat width = 0;
    if (centerX - self.height/2 > 0) {
        width = self.lineOneView.width * ((centerX - self.height/2)/self.lineOneView.width);
    }
    
    self.lineTwoView.width = width;
    self.progressView.centerX = centerX;
    
    if (isTap) {
        if (self.progressProportionBlock) {
            self.progressProportionBlock((centerX - self.height/2) / (self.width - self.height));
        }
    }
}

#pragma mark - 5. 刷新UI
- (void)reloadUI {

    [self gestureRecognizer:self.height/2 isTap:NO];
    self.progressView.backgroundColor = KTrade.coinIsSell ? kBlue100 : kBlue100;
    self.lineTwoView.backgroundColor = KTrade.coinIsSell ? kBlue100 : kBlue100;
    for (NSInteger i=0; i < self.viewsArray.count; i ++) {
        UIView *topView = self.viewsArray[i];
        topView.backgroundColor = KTrade.coinIsSell ? kBlue100 : kBlue100;
    }
}

- (void)setProportion:(double)proportion {
    _proportion = proportion;
    if (_proportion > 1.0) {
        _proportion = 1.0;
    }
    double width = (self.width - self.height)*_proportion;
    [self gestureRecognizer:width + self.height/2 isTap:NO];
}

@end
