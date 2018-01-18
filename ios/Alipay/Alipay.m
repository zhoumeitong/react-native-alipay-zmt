//
//  Alipay.m
//  Alipay
//
//  Created by zmt on 16/8/4.
//  Copyright © 2016年 cn.com.jiuqi. All rights reserved.
//

#import "Alipay.h"
#import <AlipaySDK/AlipaySDK.h>
#import <UIKit/UIKit.h>
static RCTPromiseResolveBlock _resolve;
static RCTPromiseRejectBlock _reject;

@implementation Alipay

RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(pay, payInfo:(NSString *)payInfo resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSArray *urls = [[NSBundle mainBundle] infoDictionary][@"CFBundleURLTypes"];
    NSMutableString *appScheme = [NSMutableString string];
    BOOL multiUrls = [urls count] > 1;
    for (NSDictionary *url in urls) {
        NSArray *schemes = url[@"CFBundleURLSchemes"];
        if (!multiUrls ||
            (multiUrls && [@"Alipay" isEqualToString:url[@"CFBundleURLName"]])) {
            [appScheme appendString:schemes[0]];
            break;
        }
    }
    
    if ([appScheme isEqualToString:@""]) {
        NSString *error = @"scheme cannot be empty";
        reject(@"10000", error, [NSError errorWithDomain:error code:10000 userInfo:NULL]);
        return;
    }
    
    _resolve = resolve;
    _reject = reject;
    
    
    [[AlipaySDK defaultService] payOrder:(NSString *)payInfo fromScheme:appScheme callback:^(NSDictionary *resultDic){
        [Alipay alipayResult:resultDic];
    }];
}


+ (void)alipayResult:(NSDictionary *)result
{
    NSString * resultStatus = [result objectForKey:@"resultStatus"];
    if([resultStatus isEqualToString:@"6001"])
    { //用户取消
        NSLog(@"已取消支付");
        _resolve(@"已取消支付");
    }
    else if ([resultStatus isEqualToString:@"9000"])
    { //验证签名成功，交易结果无篡改
        NSLog(@"支付成功");
        _resolve(@"支付成功");
    }
    else
    {
        NSLog(@"支付宝支付失败");
        _reject(resultStatus, result[@"memo"], [NSError errorWithDomain:result[@"memo"] code:[resultStatus integerValue] userInfo:NULL]);
    }
    

}


#pragma mark - 支付宝支付处理方法
+ (void)aliPayParse:(NSURL *)url
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self alipayResult:resultDic];
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
}

@end
