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
    
    /**
     * 如果不实现<MMJSExport>协议，测试可以使用contextg获取js的mmzhao对象的callCamera方法，点击回调操作可用block进行回调
     * 如果实现<MMJSExport>协议，测试必须实现协议中的方法，js才能够调用oc的代码
     * 注意：方法一定定好，不能出错，方便多端交互使用
     */
    
    
    //如果调用的是aler操作，不可用dispatch_async(dispatch_get_main_queue(),会早仓竞争主线程卡死，用如下方法
    context[@"mmzhao"][@"callCamera"] = ^{
        [weakSelf performSelectorOnMainThread:@selector(callCamera) withObject:nil waitUntilDone:NO];
    };
    
    context[@"mmzhao"][@"share"] = ^(JSValue *paramsValue) {
        [weakSelf performSelectorOnMainThread:@selector(share:) withObject:[paramsValue toString] waitUntilDone:NO];
    };
    
//    context[@"mmzhao"][@"callCamera"] = ^{
//        dispatch_async(dispatch_get_main_queue(), ^{ // js调用原生方法 操纵UI需要放在主线程中
//            [weakSelf callCamera];
//        });
//    };

//    context[@"mmzhao"][@"share"] = ^(JSValue *paramsValue) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf share:[paramsValue toString]];
//        });
//    };
    
    
    context[@"mmzhao"][@"outPutValue"] = ^(JSValue *funValue,JSValue *paramValue) {
        dispatch_async(dispatch_get_main_queue(), ^{ // js调用原生方法 操纵UI需要放在主线程中
            [weakSelf jsCallNativeValue:[funValue toInt32] paramString:[paramValue toString]];
        });
    };
}

/**
 *  @brief 清空jsContext  注意：容易不释放jsContext造成内存泄漏
 */
+ (void)clearJsContext:(JSContext *)jsContext
{
    if (jsContext) {
        jsContext[@"mmzhao"][@"callCamera"] = NULL;
        jsContext[@"mmzhao"][@"share"] = NULL;
        jsContext[@"mmzhao"] = nil;
        jsContext = nil;
    }
}

#pragma mark - JSExport 协议中的方法
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

#pragma mark - outPutBridgeValue
- (void)jsCallNativeValue:(NSInteger)funValue paramString:(NSString *)paramString
{
    if (paramString) {
        NSData *data = [paramString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *params = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (!error) {
            [self callNative:funValue params:params];
        } else {
            [self callNative:funValue params:nil];
        }
    } else {
        [self callNative:funValue params:nil];
    }
}

- (void)callNative:(NSInteger)funValue params:(NSDictionary *)params
{
    switch (funValue) {
        case 2019:
        {
            if (params) {
                NSLog(@"\n\n###########: %@\n\n",params[@"desc"]);
            }
        }
            break;
            
        default:
            break;
    }
}

@end
