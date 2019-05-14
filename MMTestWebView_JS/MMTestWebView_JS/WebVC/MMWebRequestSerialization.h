//
//  MMWebRequestSerialization.h
//  MMTestWebView_JS
//
//  Created by mmzhao on 2019/3/25.
//  Copyright © 2019 mmzhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol BaseWebRequestSerialization <NSObject>

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType navigationController:(UIViewController *)controller;

@end


@interface MMWebRequestSerialization : NSObject<BaseWebRequestSerialization>



@end
