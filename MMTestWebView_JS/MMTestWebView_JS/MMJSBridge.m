//
//  MMJSBridge.m
//  MMTestWebView_JS
//
//  Created by mmzhao on 2019/3/20.
//  Copyright © 2019 mmzhao. All rights reserved.
//

/** 备注1
 *  @brief 对象修饰
 *    __unsafe_unretained: 不会对对象进行retain,当对象销毁时,会依然指向之前的内存空间(野指针)
 *    __weak: 不会对对象进行retain,当对象销毁时,会自动指向nil
 */


#import "MMJSBridge.h"

@interface MMJSBridge ()

@property (nonatomic, strong) JSContext *jsContext;

@end

@implementation MMJSBridge

- (void)dealloc
{
    NSLog(@"⭐️MMJSBridge dealloc = %@",self);
}

+ (void)registerJSCallBack:(JSContext *)context delegate:(NSObject *)delegate
{
    MMJSBridge *bridge = [[MMJSBridge alloc] init];
    bridge.delegate = delegate;
    __unsafe_unretained MMJSBridge *weakSelf = bridge; //详解见备注1
    weakSelf.jsContext = context;
    context[@"mmzhao"] = weakSelf; //注入mmzhao对象
    context[@"mmzhao"][@"callCamera"] = ^{
        [weakSelf callCamera];
    };

    context[@"mmzhao"][@"share"] = ^(JSValue *paramsValue) {
        [weakSelf share:[paramsValue toString]];
    };
}

+ (void)clearJsContext:(JSContext *)jsContext
{
    if (jsContext) {
        jsContext[@"mmzhao"][@"callCamera"] = NULL;
        jsContext[@"mmzhao"][@"share"] = NULL;
        jsContext[@"mmzhao"] = nil;
        jsContext = nil;
    }
}

//操作
- (void)callCamera
{
    NSLog(@"callCamera");
    // 获取到照片之后在回调js的方法picCallback把图片传出去
    JSValue *picCallback = self.jsContext[@"picCallback"];
    [picCallback callWithArguments:@[@"oc->js回传图片对象"]];
}

- (void)share:(NSString *)shareString
{
    NSLog(@"share:%@", shareString);
    // 分享成功回调js的方法shareCallback
    JSValue *shareCallback = self.jsContext[@"shareCallback"];
    [shareCallback callWithArguments:nil];
}

#pragma mark -


@end
