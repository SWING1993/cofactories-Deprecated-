//
//  PopularMessageInfoVC.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/9/16.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "PopularMessageInfoVC.h"
#import "CommentViewController.h"


@interface PopularMessageInfoVC ()<UIWebViewDelegate>

@property (nonatomic,assign)int webViewHeight;

@property (nonatomic,retain)UIWebView *webView;

@property (nonatomic,retain)UIToolbar *toolBar;



@end

@implementation PopularMessageInfoVC

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    self.toolBar = nil;
    [self.toolBar removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    webView.frame = CGRectMake(0,0,kScreenW,kScreenH-64-40);
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView sizeToFit];
    [webView loadRequest:urlRequest];
    [self.view addSubview:webView];
//    self.tableView.tableHeaderView = webView;

    //[self createToolbar];
//
    UIToolbar*toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, kScreenH - 40 - 64, kScreenW, 40.0f) ];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton*btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenW/3, 40)];
    btn1.tag = 1;
    [btn1 setImage:[UIImage imageNamed:@"资讯_分享"] forState:UIControlStateNormal];
    
    //btn1.backgroundColor = [UIColor yellowColor];
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


    UIButton*btn3 = [[UIButton alloc]initWithFrame:CGRectMake(2*kScreenW/3, 0, kScreenW/3, 40)];
    btn3.tag = 3;
    [btn3 setImage:[UIImage imageNamed:@"资讯_赞"] forState:UIControlStateNormal];
    //btn3.backgroundColor = [UIColor greenColor];
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
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
//    self.webViewHeight = [height_str intValue];
//    self.webView.userInteractionEnabled = NO;
//
////    [self.tableView reloadData];
//
//    DLog(@"height: %d", self.webViewHeight);
//    DLog(@"--- : %f",webView.scrollView.contentSize.height);
//
//    webView.frame = CGRectMake(0,0,kScreenW,self.webViewHeight-64);
//
//
//    webView.delegate = nil;
//    
//}

- (UIToolbar *)createToolbar {
    if (!self.toolBar) {
        //创建toolbar
        self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, kScreenH - 44, kScreenW, 44.0f) ];

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
        btn2.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [btn2 addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        //创建barbuttonitem
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:btn2];
        [item2 setWidth:kScreenW/3];


        UIButton*btn3 = [[UIButton alloc]initWithFrame:CGRectMake(2*kScreenW/3, 0, kScreenW/3, 40)];
        btn3.tag = 3;
        [btn3 setImage:[UIImage imageNamed:@"资讯_赞"] forState:UIControlStateNormal];
        btn3.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [btn3 addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        //创建barbuttonitem
        UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithCustomView:btn3];
        [item3 setWidth:kScreenW/3];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

        //把item添加到toolbar里
        [self.toolBar setItems:[NSArray arrayWithObjects:item1,flexSpace,item2, flexSpace, item3, nil] animated:YES];
        
        //把toolbar添加到view上
        UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
        [window addSubview:self.toolBar];
    }
    return self.toolBar;
}
- (void)doneAction:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            DLog(@"资讯");
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
            [HttpClient pushLikeWithID:[NSString stringWithFormat:@"%d", self.oid] andBlock:^(int statusCode) {
                switch (statusCode) {
                    case 200:
                    {
                        [Tools showHudTipStr:@"已赞！"];
                        DLog(@"%d", statusCode);
                    }
                        break;
                    case 400:
                    {
                        [Tools showHudTipStr:@"未登录"];
                    }
                        break;
                        
                        
                    default:
                        break;
                }

            }];
            
        }
            break;
            
        default:
            break;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.toolBar removeFromSuperview];

    DLog(@"流行资讯dealloc");
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    // Return the number of sections.
//    return 3;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    // Return the number of rows in the section.
//    if (section == 0) {
//        return 1;
//    }
//    if (section == 1) {
//        return 3;
//    }
//    if (section == 2) {
//        return 3;
//    }
//
//    return 0;
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
//        if (indexPath.section == 0) {
//
////            UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
////            webView.delegate = self;
////            NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
////            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
////            [webView loadRequest:urlRequest];
////
//            [cell addSubview:self.webView];
//
//        }
//
//    }
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
////    if (indexPath.section == 0) {
////        return self.webViewHeight;
////    }else
//        return 44;
//
//}
//
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
