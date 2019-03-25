//
//  ViewController.m
//  MMTestWebView_JS
//
//  Created by mmzhao on 2019/3/20.
//  Copyright © 2019 mmzhao. All rights reserved.
//

#import "ViewController.h"

#import "WebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"测试";
    
    UIButton *openH5 = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-100)/2, 100, 100, 100)];
    openH5.backgroundColor = [UIColor orangeColor];
    [openH5 setTitle:@"open H5" forState:UIControlStateNormal];
    [openH5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:openH5];
    [openH5 addTarget:self action:@selector(openH5Page) forControlEvents:UIControlEventTouchUpInside];
}

- (void)openH5Page
{
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.hidesBottomBarWhenPushed = YES;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
    webVC.url = url;
    [self.navigationController pushViewController:webVC animated:YES];
}


@end
