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
    
    UIButton *openLocalH5 = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-100)/2, 50, 100, 100)];
    openLocalH5.backgroundColor = [UIColor orangeColor];
    [openLocalH5 setTitle:@"Local H5" forState:UIControlStateNormal];
    [openLocalH5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:openLocalH5];
    [openLocalH5 addTarget:self action:@selector(openLocalH5Page) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *openH5 = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-100)/2, 200, 100, 100)];
    openH5.backgroundColor = [UIColor orangeColor];
    [openH5 setTitle:@"web H5" forState:UIControlStateNormal];
    [openH5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:openH5];
    [openH5 addTarget:self action:@selector(openH5Page) forControlEvents:UIControlEventTouchUpInside];
}

- (void)openLocalH5Page
{
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.hidesBottomBarWhenPushed = YES;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
    webVC.url = url;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)openH5Page
{
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.url = [NSURL URLWithString:@"https://8.jrj.com.cn/m/JRJ"];
    [self.navigationController pushViewController:webVC animated:YES];
}


@end
