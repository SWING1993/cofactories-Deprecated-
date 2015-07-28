//
//  ActivityViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/24.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "ActivityViewController.h"

@interface ActivityViewController ()

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:kScreenBounds];
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView loadRequest:urlRequest];
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
