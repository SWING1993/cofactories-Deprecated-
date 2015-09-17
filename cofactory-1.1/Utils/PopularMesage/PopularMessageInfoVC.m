//
//  PopularMessageInfoVC.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/9/16.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "PopularMessageInfoVC.h"

@interface PopularMessageInfoVC ()<UIWebViewDelegate>

@property (nonatomic,assign)int webViewHeight;

@property (nonatomic,retain)UIWebView *webView;

@end

@implementation PopularMessageInfoVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
    webView.frame = CGRectMake(0,0,kScreenW,kScreenH-64-64);
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView sizeToFit];
    [webView loadRequest:urlRequest];
    self.tableView.tableHeaderView = webView;


    //创建toolbar
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, kScreenH - 44, kScreenW, 44.0f) ];


    //创建barbuttonitem
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"收藏" style:UIBarButtonItemStyleBordered target:self action:@selector(test:)];

         //创建barbuttonitem
          UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:nil];

        //创建一个segmentController
            UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"牛扒", @"排骨", nil] ];

          //设置style
            [seg setSegmentedControlStyle:UISegmentedControlSegmentCenter];


            [seg addTarget:self action:@selector(segmentControllerItem:) forControlEvents:UIControlEventValueChanged];

           //创建一个内容是view的uibarbuttonitem
           UIBarButtonItem *itemSeg = [[UIBarButtonItem alloc] initWithCustomView:seg];

      //创建barbuttonitem,样式是flexible,这个种barbuttonitem用于两个barbuttonitem之间
         //调整两个item之间的距离.flexible表示距离是动态的,fixed表示是固定的
         UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

          //把item添加到toolbar里
           [toolBar setItems:[NSArray arrayWithObjects:item1,flexible,itemSeg,flexible,item2, nil] animated:YES];


    //把toolbar添加到view上


    //UIWindow* window = [[[UIApplication sharedApplication] delegate] window];

    AppDelegate *app =[UIApplication sharedApplication].delegate;
    [app.window addSubview:toolBar];

}
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
//    self.webViewHeight = [height_str intValue];
//
//    [self.tableView reloadData];
//    DLog(@"height: %d", self.webViewHeight);
//
//    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
//
//    CGRect newFrame = webView.frame;
//    newFrame.size.height = actualSize.height;
//    webView.frame = newFrame;
//
//    webView.delegate = nil;
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 3;
    }
    if (section == 2) {
        return 3;
    }

    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        if (indexPath.section == 0) {

//            UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
//            webView.delegate = self;
//            NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
//            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//            [webView loadRequest:urlRequest];
//
//            [cell addSubview:self.webView];

        }

    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        return self.webViewHeight;
//    }else
        return 44;

}

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
