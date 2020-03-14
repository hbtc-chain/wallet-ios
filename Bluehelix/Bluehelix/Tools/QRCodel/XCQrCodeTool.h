//
//  XCQrCodeTool.h
//  XCCreateQrCode
//
//  Created by Chang_Mac on 2017/5/10.
//  Copyright © 2017年 Chang_Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BaseViewController.h"

@class qrCodeVC;
@interface XCQrCodeTool : NSObject

typedef void(^qrCodeData)(id data);
//生成二维码
+(UIImage *)createQrCodeWithContent:(id)data;

/**
 生成二维码(中间有小图片)
 data：所需字符串
 centerImage：二维码中间的image对象
 */
+(UIImage *)createQrCodeWithContent:(id)data centerImage:(UIImage *)centerImage;

//扫描二维码
+(void)readQrCode:(UIViewController *)vc callBack:(qrCodeData)content;
//识别图片二维码
+(id)readQrCodeWithImage:(UIImage *)qrCodeImage;

@property (copy, nonatomic) qrCodeData content;


@end

@interface qrCodeVC : BaseViewController

+(void)readQrCode:(UIViewController *)vc callBack:(qrCodeData)content;

@end
