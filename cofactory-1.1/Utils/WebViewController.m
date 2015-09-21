//
//  WebViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/24.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor=[UIColor whiteColor];
    AFOAuthCredential *credential=[HttpClient getToken];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSString*token = credential.accessToken;
    NSString*string = [NSString stringWithFormat:@"http://app2.cofactories.com/draw/draw.html#%@",token];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView loadRequest:urlRequest];
    [self.view addSubview:webView];

    //设置Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBackClicked)];
    self.navigationItem.leftBarButtonItem = setButton;


}


- (void)goBackClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
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
