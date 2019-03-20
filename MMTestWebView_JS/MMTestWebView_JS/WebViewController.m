//
//  WebViewController.m
//  MMTestWebView_JS
//
//  Created by mmzhao on 2019/3/20.
//  Copyright © 2019 mmzhao. All rights reserved.
//

#import "WebViewController.h"
#import "MMJSBridge.h"

@interface WebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) JSContext *context;

@end

@implementation WebViewController

- (void)dealloc
{
    if (self.context != nil) {
        [MMJSBridge clearJsContext:self.context];
        self.context = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    
    [self reloadRequest];
}

#pragma mark - reload WebView
- (void)reloadRequest
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:url]];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = title;
    
    if (self.context != nil) {
        [MMJSBridge clearJsContext:self.context];
        self.context = nil;
    }
    
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [MMJSBridge registerJSCallBack:self.context delegate:self];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

#pragma mark - setter && getter
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
        _webView.delegate = self;
    }
    return _webView;
}



@end
