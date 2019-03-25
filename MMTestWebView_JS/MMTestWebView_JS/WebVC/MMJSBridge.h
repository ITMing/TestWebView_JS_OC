//
//  MMJSBridge.h
//  MMTestWebView_JS
//
//  Created by mmzhao on 2019/3/20.
//  Copyright © 2019 mmzhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MMJSExport <JSExport>

- (void)callCamera;
- (void)share:(NSString *)shareString;

@end

@interface MMJSBridge : NSObject<MMJSExport>

@property (nonatomic, weak) NSObject *delegate;

+ (void)registerJSCallBack:(JSContext *)context delegate:(NSObject *)delegate;

+ (void)clearJsContext:(JSContext *)jsContext;

@end

NS_ASSUME_NONNULL_END
