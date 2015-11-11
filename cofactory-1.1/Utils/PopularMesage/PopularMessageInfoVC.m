//
//  PopularMessageInfoVC.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/9/16.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "PopularMessageInfoVC.h"
#import "CommentsViewController.h"
#import "UMSocial.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "CommentCell.h"
#import "MJRefresh.h"

static NSString *myCellIdentifier = @"myCell";
static NSString *commentCellIdentifier = @"commentCell";
static NSString *noneCellIdentifier = @"noneCell";
@interface PopularMessageInfoVC ()<UIWebViewDelegate, UMSocialUIDelegate, UITableViewDataSource, UITableViewDelegate> {
    UIButton *btn3;
    int _refrushCount;
    UIWebView *webView1;
}

@property (nonatomic,assign)int webViewHeight;

@property (nonatomic,retain)UIWebView *webView;

@property (nonatomic,assign)BOOL isSelected;

@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic, strong) NSMutableArray *commentArray;

@property (nonatomic, assign) NSInteger totalHeight;

@property (nonatomic, assign) NSString *userAgent;




@end

@implementation PopularMessageInfoVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资讯详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.isSelected = NO;
    
    [Tools showLoadString:@"正在加载网页..."];
    //获取当前UA
    [self createHttpRequest];
    NSString *uaString = [self userAgentString];
    
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.frame = CGRectMake(0,0,kScreenW,15 * kScreenH);
    
    //添加access_token
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    NSString*token = credential.accessToken;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&access_token=%@", self.urlString, token]];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView sizeToFit];
    //原来的ua+原来没有空格 加空格+CoFactories-iOS-版本号
    //修改ua
    NSString *ua = @"";
    //版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if ([uaString rangeOfString:@" CoFactories-iOS-"].location != NSNotFound) {
        ua = uaString;
    } else {
        ua = [[NSString alloc] initWithFormat:@"%@ CoFactories-iOS-%@", uaString, app_build];

    }
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:ua, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    
    [_webView loadRequest:urlRequest];
//    [self.view addSubview:_webView];
    
    [self creatCancleItem];
    
    [self creatTableView];
    [self creatToolbar];
    _refrushCount = 1;
    [self netWork];
    [self setupRefresh];
    self.totalHeight = kScreenH;
    
}

#pragma mark - 获取当前UA
- (void)createHttpRequest {
    webView1 = [[UIWebView alloc] init];
    webView1.delegate = self;
    [webView1 loadRequest:[NSURLRequest requestWithURL:
                           [NSURL URLWithString:@"http://www.google.com"]]];
    NSLog(@"%@", [self userAgentString]);
}
-(NSString *)userAgentString
{
    while (self.userAgent == nil)
    {
        NSLog(@"%@", @"in while");
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return self.userAgent;
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (webView == webView1) {
        self.userAgent = [request valueForHTTPHeaderField:@"User-Agent"];
        // Return no, we don't care about executing an actual request.
        return NO;
    }
    //去除链接，点击没有反应
    if(navigationType==UIWebViewNavigationTypeLinkClicked)//判断是否是点击链接
    {
        return NO;
    }
    else
    {
        return YES;
    }

}
- (void)netWork {
    [HttpClient getCommentWithOid:self.oid page:1 andBlock:^(NSDictionary *responseDictionary) {
//        DLog(@"%@", responseDictionary);
        NSArray *jsonArray = responseDictionary[@"responseArray"];
        self.commentArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dictionary in jsonArray) {
            CommentModel *comment = [CommentModel getModelWith:dictionary];
            [self.commentArray addObject:comment];
        }
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [self.myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }];
}
- (void)setupRefresh
{
    [self.myTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.myTableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.myTableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.myTableView.footerRefreshingText = @"加载中。。。";
}

- (void)footerRereshing
{
    _refrushCount++;
    DLog(@"???????????%d",_refrushCount);
    [HttpClient getCommentWithOid:self.oid page:_refrushCount andBlock:^(NSDictionary *responseDictionary) {
        DLog(@"%d", self.oid);
        NSArray *jsonArray = (NSArray *)responseDictionary[@"responseArray"];
        
        for (NSDictionary *dictionary in jsonArray) {
            CommentModel *comment = [CommentModel getModelWith:dictionary];
            [self.commentArray addObject:comment];
        }
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [self.myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [self.myTableView footerEndRefreshing];
}

#pragma mark - 创建UI

- (void)creatCancleItem {
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
}

- (void)creatTableView {
    
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 104) style:UITableViewStylePlain];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    [self.view addSubview:self.myTableView];
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:myCellIdentifier];
    [self.myTableView registerClass:[CommentCell class] forCellReuseIdentifier:commentCellIdentifier];
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:noneCellIdentifier];
    
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
    self.totalHeight = [[_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] integerValue];
    DLog(@"+++++++++++++%ld", self.totalHeight);
    _webView.frame = CGRectMake(0,0,kScreenW,self.totalHeight);
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [self.myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    [Tools WSProgressHUDDismiss];
}
//去除链接
//- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
//    if(navigationType==UIWebViewNavigationTypeLinkClicked)//判断是否是点击链接
//    {
//        return NO;
//    }
//    else
//    {
//        return YES;
//    }
//}



#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        if (self.commentArray.count == 0) {
            return 1;
        } else {
            return self.commentArray.count;
        }
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier forIndexPath:indexPath];
        UIScrollView *tempView=(UIScrollView *)[_webView.subviews objectAtIndex:0];
        tempView.scrollEnabled=NO;
        [cell addSubview:_webView];
        return cell;
    } else {
        
        if (self.commentArray.count == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noneCellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"暂无任何评论";
            cell.textLabel.font = kFont;
            return cell;
        } else {
            CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            CommentModel *comment = self.commentArray[indexPath.row];
            cell.comment = comment;
            return cell;
        }
        
    }
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"全部评论";
    } else {
        return nil;
    }
    
}


//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess) {
        [Tools showSuccessWithStatus:@"分享成功"];
    } else {
        [Tools showErrorWithStatus:@"分享失败"];
    }
}




#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.totalHeight;
    } else {
        if (self.commentArray.count == 0) {
            return 50;
        } else {
            CommentModel *comment = self.commentArray[indexPath.row];
            return [CommentCell heightOfCell:comment];
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 30;
    } else {
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}


#pragma mark - Action

- (void)doneAction:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            if ( [WXApi isWXAppInstalled] == NO &&[QQApiInterface isQQInstalled] == NO) {
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
            CommentsViewController *commentVC = [[CommentsViewController alloc] init];
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
                            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                            [self.myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];

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
