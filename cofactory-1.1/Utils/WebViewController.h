//
//  WebViewController.h
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/24.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, strong) NSString *url;

@end
