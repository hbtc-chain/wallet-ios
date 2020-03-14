
//
//  XCQrCodeTool.m
//  XCCreateQrCode
//
//  Created by Chang_Mac on 2017/5/10.
//  Copyright © 2017年 Chang_Mac. All rights reserved.
//

#import "XCQrCodeTool.h"
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#define UIStyle_Color Nav_Main_Color
#define RGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
@interface XCQrCodeTool ()


@end

@implementation XCQrCodeTool

/**
 生成二维码(中间有小图片)
 data：所需字符串
 centerImage：二维码中间的image对象
 */
+(UIImage *)createQrCodeWithContent:(id)data centerImage:(UIImage *)centerImage {
    
    // 创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 将字符串转换成 NSdata
    NSData *dataString = [data dataUsingEncoding:NSUTF8StringEncoding];
    
    // 设置过滤器的输入值, KVC赋值
    [filter setValue:dataString forKey:@"inputMessage"];
    
    // 获得滤镜输出的图像
    CIImage *outImage = [filter outputImage];
    
    // 图片小于(27,27),我们需要放大
    outImage = [outImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    
    // 将CIImage类型转成UIImage类型
    UIImage *startImage = [UIImage imageWithCIImage:outImage];
    
    // 开启绘图, 获取图形上下文
    UIGraphicsBeginImageContext(startImage.size);
    
    // 把二维码图片画上去 (这里是以图形上下文, 左上角为(0,0)点
    [startImage drawInRect:CGRectMake(0, 0, startImage.size.width, startImage.size.height)];
    
    // 再把小图片画上去
    CGFloat icon_imageW = startImage.size.width * 0.27;
    CGFloat icon_imageH = icon_imageW;
    CGFloat icon_imageX = (startImage.size.width - icon_imageW) * 0.5;
    CGFloat icon_imageY = (startImage.size.height - icon_imageH) * 0.5;
    
    [centerImage drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];
    
    // 获取当前画得的这张图片
    UIImage *qrImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    
    //返回二维码图像
    return qrImage;
}

+(UIImage *)createQrCodeWithContent:(id)data{
    return [[XCQrCodeTool new] createQrCodeWithContent:data];
    
}

+(void)readQrCode:(UIViewController *)vc callBack:(qrCodeData)content{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
//        [XYHAlertView showAlertViewWithTitle:nil message:NSLocalizedFormatString(LocalizedString(@"SettingCameraAndMicrophone"), kApp_Name) titlesArray:@[LocalizedString(@"Setting")] andBlock:^(NSInteger index) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//        }];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self readQrCode:vc callBack:content];
                });
            }
        }];
        
    } else {
        [qrCodeVC readQrCode:vc callBack:content];
    }
}


+(id)readQrCodeWithImage:(UIImage *)qrCodeImag{
    return [[XCQrCodeTool new] readQrCodeWithImage:qrCodeImag];
}

-(UIImage *)createQrCodeWithContent:(id)data{
    if (!data) {
        data = @"";
    }
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];

    [filter setValue:[data dataUsingEncoding:NSUTF8StringEncoding] forKeyPath:@"inputMessage"];
    
    CIImage *image = [filter outputImage];
    UIImage *qrCodeImage = [self createNonInterpolatedUIImageFormCIImage:image withSize:1000];
    
    return qrCodeImage;
}



-(id)readQrCodeWithImage:(UIImage *)qrCodeImag{
    
    NSData *data = UIImagePNGRepresentation(qrCodeImag);
    CIImage *ciimage = [CIImage imageWithData:data];
    if (ciimage) {
        CIDetector *qrDetector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:[CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer:@(YES)}] options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
        NSArray *resultArr = [qrDetector featuresInImage:ciimage];
        if (resultArr.count >0) {
            CIFeature *feature = resultArr[0];
            CIQRCodeFeature *qrFeature = (CIQRCodeFeature *)feature;
            NSString *result = qrFeature.messageString;
            
            return result;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}


- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end

@interface qrCodeVC  () <AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;

@property (copy, nonatomic) qrCodeData content;

@end

@implementation qrCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = LocalizedString(@"QRCode");
    
    [self.rightButton setTitle:LocalizedString(@"Album") forState:UIControlStateNormal];
    
}

+(void)readQrCode:(UIViewController *)vc callBack:(qrCodeData)content{
    [[qrCodeVC new] readQrCode:vc callBack:content];
}

-(void)readQrCode:(UIViewController *)vc callBack:(qrCodeData)content{
    
    [self settingView];
    
    // Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    _output.rectOfInterest = CGRectMake((Height-Width*0.9)/2/Height, 0.15, Width*0.7/Height,0.7 );
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
    
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    [vc.navigationController pushViewController:self animated:YES];
    [_session startRunning];
    
    self.content = content;
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] >0){
        //停止扫描
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        [self.navigationController popViewControllerAnimated:NO];
        stringValue = metadataObject.stringValue;
                if (self.content) {
                    self.content(stringValue);
                }
//        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)settingView{

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)cornerRadius:0];
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(Width*0.15,(Height-Width*0.9)/2,Width*0.7,Width*0.7)cornerRadius:0];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule =kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity =0.5;
    
    [self.view.layer addSublayer:fillLayer];
    
    UIBezierPath *leftTop = [UIBezierPath bezierPath];
    [leftTop moveToPoint:CGPointMake(Width*0.15, (Height-Width*0.9)/2+10)];
    [leftTop addLineToPoint:CGPointMake(Width*0.15, (Height-Width*0.9)/2)];
    [leftTop addLineToPoint:CGPointMake(Width*0.15+10, (Height-Width*0.9)/2)];
    
    UIBezierPath *rightTop = [UIBezierPath bezierPath];
    [rightTop moveToPoint:CGPointMake(Width*0.85-10, (Height-Width*0.9)/2)];
    [rightTop addLineToPoint:CGPointMake(Width*0.85, (Height-Width*0.9)/2)];
    [rightTop addLineToPoint:CGPointMake(Width*0.85, (Height-Width*0.9)/2+10)];
    
    UIBezierPath *leftBottom = [UIBezierPath bezierPath];
    [leftBottom moveToPoint:CGPointMake(Width*0.15, (Height-Width*0.9)/2+Width*0.7-10)];
    [leftBottom addLineToPoint:CGPointMake(Width*0.15,(Height-Width*0.9)/2+Width*0.7)];
    [leftBottom addLineToPoint:CGPointMake(Width*0.15+10,(Height-Width*0.9)/2+Width*0.7)];
    
    UIBezierPath *rightBottom = [UIBezierPath bezierPath];
    [rightBottom moveToPoint:CGPointMake(Width*0.85-10, (Height-Width*0.9)/2+Width*0.7)];
    [rightBottom addLineToPoint:CGPointMake(Width*0.85, (Height-Width*0.9)/2+Width*0.7)];
    [rightBottom addLineToPoint:CGPointMake(Width*0.85, (Height-Width*0.9)/2+Width*0.7-10)];
    
    [leftTop appendPath:rightTop];
    [leftTop appendPath:leftBottom];
    [leftTop appendPath:rightBottom];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 2;
    shapeLayer.path = leftTop.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = (kBlue100).CGColor;
    
    [self.view.layer addSublayer:shapeLayer];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(Width*0.15, CGRectGetMaxY(circlePath.bounds)+Width*0.03, Width*0.7, 0.04*Width)];
    label.textColor = kDark100;
    label.text = LocalizedString(@"QRCodeAlertKey");
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:Width*0.04];

    [self.view addSubview:label];
    [self createView];

}
-(void)createView{
    
    //创建CGContextRef
    UIGraphicsBeginImageContext(self.view.bounds.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    //创建CGMutablePathRef
    CGMutablePathRef path1 = CGPathCreateMutable();
    
    //绘制Path
    CGRect rect = CGRectMake(Width*0.15, (Height-Width*0.9)/2, Width*0.7, 3);
    CGPathMoveToPoint(path1, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path1, NULL, CGRectGetMaxX(rect)/2, CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path1, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPathCloseSubpath(path1);
    
    //绘制渐变
    [self drawLinearGradient:gc path:path1 startColor:(kBlue100).CGColor centerColor:(kBlue100).CGColor endColor:(kBlue100).CGColor];
    
    //注意释放CGMutablePathRef
    CGPathRelease(path1);
    
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    
    [self.view addSubview:imgView];

    CAKeyframeAnimation *keyAnimation =[CAKeyframeAnimation animation];
    keyAnimation.keyPath = @"position";
    keyAnimation.values = @[
                            [NSValue valueWithCGRect:CGRectMake(Width*0.5, (Height-Width*0.7)/2+Width*0.35, Width*0.7, 3)],
                            [NSValue valueWithCGRect:CGRectMake(Width*0.5, (Height-Width*0.7)/2+Width*1.03, Width*0.7, 3)],
                            ];
    keyAnimation.duration = 2;
    keyAnimation.repeatCount = 1000;
    keyAnimation.removedOnCompletion = NO;
    keyAnimation.fillMode = kCAFillModeBackwards;
    [imgView.layer addAnimation:keyAnimation forKey:@"animation"];
    
    
}

- (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
               centerColor:(CGColorRef)centerColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 0.5,1.0 };
    
    NSArray *colors = @[(__bridge id) startColor,(__bridge id)centerColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMidY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMidY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}
-(void)rightButtonClick:(UIButton *)sender{
    
    //----第一次不会进来
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied){
        // 无权限 做一个友好的提示
//        [XYHAlertView showAlertViewWithTitle:nil message:NSLocalizedFormatString(LocalizedString(@"SettingPrivacyPhotos"), kApp_Name) titlesArray:@[LocalizedString(@"Setting")] andBlock:^(NSInteger index) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//        }];
        return;
    }
    
    //----每次都会走进来
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            NSLog(@"Authorized");
            [self addPhoto];
        }else{
            NSLog(@"Denied or Restricted");
            //----为什么没有在这个里面进行权限判断，因为会项目会蹦。。。
        }
    }];
}

/**
 *  调用相册
 */
- (void)addPhoto {
    
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.navigationBar.barTintColor = KNavigation_BackgroundColor;
    [imagePickerController.navigationBar setTintColor:KNavigationBar_TitleColor];
    [imagePickerController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : KNavigationBar_TitleColor}];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

/**
 *  相册和相机回调方法
 */
#pragma mark --UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    id data = [XCQrCodeTool readQrCodeWithImage:image];
    [self.navigationController popViewControllerAnimated:NO];
    if (self.content) {
        self.content(data);
    }
    [picker dismissViewControllerAnimated:NO completion:nil];
//    [self dismissViewControllerAnimated:NO completion:nil];
}

@end

