//
//  PopularMessageInfoVC.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/9/16.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "PopularMessageInfoVC.h"
#import "CommentViewController.h"
#import "UMSocial.h"
#import "QQApiInterface.h"
#import "WXApi.h"


@interface PopularMessageInfoVC ()<UIWebViewDelegate, UMSocialUIDelegate> {
    UIButton *btn3;
}

@property (nonatomic,assign)int webViewHeight;

@property (nonatomic,retain)UIWebView *webView;

@property (nonatomic,assign)BOOL isSelected;


@end

@implementation PopularMessageInfoVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资讯详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.isSelected = NO;
    
    [Tools showLoadString:@"正在加载网页..."];
    
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.frame = CGRectMake(0,0,kScreenW,kScreenH-64-40);
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView sizeToFit];
    [_webView loadRequest:urlRequest];
    [self.view addSubview:_webView];

    [self creatCancleItem];
    [self creatToolbar];

}


#pragma mark - 创建UI

- (void)creatCancleItem {
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
}

- (void)creatToolbar {
    UIToolbar*toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, kScreenH - 40 - 64, kScreenW, 40.0f) ];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton*btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenW/3, 40)];
    btn1.tag = 1;
    [btn1 setImage:[UIImage imageNamed:@"资讯_分享"] forState:UIControlStateNormal];
    btn1.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [btn1 addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    //创建barbuttonitem
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    [item1 setWidth:kScreenW/3];
    
    UIButton*btn2 = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/3, 0, kScreenW/3, 40)];
    btn2.tag = 2;
    [btn2 setImage:[UIImage imageNamed:@"资讯_评论"] forState:UIControlStateNormal];
    //btn2.backgroundColor = [UIColor redColor];
    btn2.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [btn2 addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    //btn2.layer.borderColor = [UIColor grayColor].CGColor;
    //btn2.layer.borderWidth = 1;
    //创建barbuttonitem
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    
    [item2 setWidth:kScreenW/3];
    
    
    btn3 = [[UIButton alloc]initWithFrame:CGRectMake(2*kScreenW/3, 0, kScreenW/3, 40)];
    btn3.tag = 3;
    [btn3 setImage:[UIImage imageNamed:@"资讯_赞"] forState:UIControlStateNormal];
    btn3.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [btn3 addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    //创建barbuttonitem
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithCustomView:btn3];
    [item3 setWidth:kScreenW/3];
    
    
    //把item添加到toolbar里
    [toolBar setItems:[NSArray arrayWithObjects:flexSpace,item1, flexSpace, item2, flexSpace, item3, flexSpace, nil] animated:YES];
    UILabel *leftLine = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW / 3, 7.5, 0.3, 25)];
    leftLine.backgroundColor = [UIColor grayColor];
    [toolBar addSubview:leftLine];
    
    UILabel *rightLine = [[UILabel alloc] initWithFrame:CGRectMake(2*kScreenW / 3, 7.5, 0.3, 25)];
    rightLine.backgroundColor = [UIColor grayColor];
    [toolBar addSubview:rightLine];
    
    //把toolbar添加到view上
    
    [self.view addSubview:toolBar];
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [Tools WSProgressHUDDismiss];
}
//去除链接
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    if(navigationType==UIWebViewNavigationTypeLinkClicked)//判断是否是点击链接
    {
        return NO;
    }
    else
    {
        return YES;
    }
}



#pragma mark - Action

- (void)doneAction:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            if ([WXApi isWXAppInstalled] == NO && [QQApiInterface isQQInstalled] == NO) {
                DLog(@"微信和QQ都没安装");
                [UMSocialSnsService presentSnsIconSheetView:self
                                                     appKey:UMENGAppKey
                                                  shareText:[NSString stringWithFormat:@"%@, %@", self.name, self.urlString]
                                                 shareImage:nil
                                            shareToSnsNames:[NSArray arrayWithObjects:UMShareToSms,nil]
                                                   delegate:self];
            } else {
                //分享多个
                [UMSocialData defaultData].extConfig.wechatSessionData.url = self.urlString;//微信好友
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.urlString;//微信朋友圈
                [UMSocialData defaultData].extConfig.qqData.url = self.urlString;//QQ好友
                [UMSocialData defaultData].extConfig.qzoneData.url = self.urlString;//QQ空间
                [UMSocialSnsService presentSnsIconSheetView:self
                                                    appKey:@"55e03514e0f55a390f003db7"
                                        shareText:self.name
                                        shareImage:[UIImage imageNamed:@"logo"]
                                            shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone]
                                                   delegate:self];
                
                DLog(@"资讯");

            }
                }
            break;

        case 2:
        {
            CommentViewController *commentVC = [[CommentViewController alloc] init];
            UINavigationController *commentNaVC = [[UINavigationController alloc] initWithRootViewController:commentVC];
            commentNaVC.navigationBar.barStyle = UIBarStyleBlack;
            commentVC.oid = self.oid;

            [self presentViewController:commentNaVC animated:YES completion:nil];
            DLog(@"评论");

        }
            break;
        case 3:
        {
            [btn3 setUserInteractionEnabled:NO];
            if (_isSelected == NO) {
                _isSelected = YES;
                [btn3 setImage:[UIImage imageNamed:@"已赞"] forState:UIControlStateNormal];
                [HttpClient pushLikeWithID:[NSString stringWithFormat:@"%d", self.oid] andBlock:^(int statusCode) {
                    switch (statusCode) {
                        case 200:
                        {
                            [Tools showSuccessWithStatus:@"已赞！"];
                            [btn3 setUserInteractionEnabled:YES];
                        }
                            break;
                            
                        default:
                        {
                            [Tools showSuccessWithStatus:@"点赞失败！"];
                            [btn3 setUserInteractionEnabled:YES];
                        }
                            break;
                    }
                    
                }];
                
                
            } else {
                [Tools showErrorWithStatus:@"不能重复点赞！"];
                [btn3 setUserInteractionEnabled:YES];
            }
            

            
            
        }
            break;
            
        default:
            break;
    }

}



- (void) back
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
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

- (void)dealloc {

    DLog(@"流行资讯dealloc");
}


@end
