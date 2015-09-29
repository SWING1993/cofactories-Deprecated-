//
//  ActivityViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/24.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "ActivityViewController.h"

@interface ActivityViewController () {
    UIWebView *activityWebView;
}

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;

    
    
    self.view.backgroundColor=[UIColor whiteColor];
    activityWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64)];
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [activityWebView loadRequest:urlRequest];
    [self.view addSubview:activityWebView];

    DLog(@"%@",url);

}

- (void) back
{
    if ([activityWebView canGoBack]) {
        [activityWebView goBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
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
