//
//  Alipay.h
//  Alipay
//
//  Created by zmt on 16/8/4.
//  Copyright © 2016年 cn.com.jiuqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif
@interface Alipay : NSObject<RCTBridgeModule>

+ (void)aliPayParse:(NSURL *)url;


@end
