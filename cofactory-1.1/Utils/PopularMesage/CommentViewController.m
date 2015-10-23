//
//  CommentViewController.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/17.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentCell.h"
#import "MJRefresh.h"

#define kRowInset 5
#define kPlaceholder @"写下你想说的......"

static NSString *commentCellIdentifier = @"commentCell";

@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate> {
    UIView *tableViewHeadView;
    UITextView *commentTextView;
    int _refrushCount;
}



@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";
    
    
    [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:commentCellIdentifier];
    [self creatHeadView];
    [self creatCancleItem];
//    _refrushCount = 1;
//    [self netWork];
//    [self setupRefresh];

}

#pragma mark - 创建UI

- (void)creatCancleItem {
    //设置Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked)];
    self.navigationItem.leftBarButtonItem = setButton;
}

- (void)creatHeadView {
    tableViewHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 125)];
    commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 15, kScreenW - 40, 60)];
    commentTextView.backgroundColor=[UIColor whiteColor];
    //commentTextView.scrollEnabled = NO;
    commentTextView.editable = YES;
    commentTextView.delegate = self;
    commentTextView.layer.borderColor = [UIColor grayColor].CGColor;
    commentTextView.layer.borderWidth = 0.5;
    commentTextView.layer.cornerRadius = 5.0f;
    commentTextView.clipsToBounds = YES;
    commentTextView.keyboardType = UIKeyboardTypeDefault;
    
    commentTextView.font = [UIFont systemFontOfSize:17];
    commentTextView.text = kPlaceholder;
    commentTextView.textColor = [UIColor grayColor];
    [tableViewHeadView addSubview:commentTextView];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(20, CGRectGetMaxY(commentTextView.frame) + 10, (kScreenW - 40) / 4, 25);
    cancleButton.layer.cornerRadius=5.0f;
    cancleButton.layer.masksToBounds=YES;
    cancleButton.layer.borderColor = [UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f].CGColor;
    cancleButton.layer.borderWidth = 1.0f;
    cancleButton.backgroundColor = [UIColor whiteColor];
    
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(clickCanclebBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tableViewHeadView addSubview:cancleButton];

    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(CGRectGetMaxX(commentTextView.frame) - (kScreenW - 40) / 4, CGRectGetMaxY(commentTextView.frame) + 10, (kScreenW - 40) / 4, 25);
    doneButton.layer.cornerRadius=5.0f;
    doneButton.layer.masksToBounds=YES;
    doneButton.layer.borderColor = [UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f].CGColor;
    doneButton.layer.borderWidth = 1.0f;
    doneButton.backgroundColor = [UIColor whiteColor];
    
    [doneButton setTitle:@"确定" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(clickDonebBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tableViewHeadView addSubview:doneButton];
    [self.view addSubview:tableViewHeadView];
}


#pragma mark - 网络请求
//
//- (void)netWork {
//    [HttpClient getCommentWithOid:self.oid page:1 andBlock:^(NSDictionary *responseDictionary) {
//        DLog(@"%@", responseDictionary);
//        NSArray *jsonArray = responseDictionary[@"responseArray"];
//        self.commentArray = [NSMutableArray arrayWithCapacity:0];
//        for (NSDictionary *dictionary in jsonArray) {
//            CommentModel *comment = [CommentModel getModelWith:dictionary];
//            DLog(@"%@", comment);
//            [self.commentArray addObject:comment];
//        }
//        [self.tableView reloadData];
//    }];
//}
//
//- (void)setupRefresh
//{
//    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
//    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
//    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
//    self.tableView.footerRefreshingText = @"加载中。。。";
//}
//
//- (void)footerRereshing
//{
//    _refrushCount++;
//    DLog(@"???????????%d",_refrushCount);
//    [HttpClient getCommentWithOid:self.oid page:_refrushCount andBlock:^(NSDictionary *responseDictionary) {
//        DLog(@"%d", self.oid);
//        NSArray *jsonArray = (NSArray *)responseDictionary[@"responseArray"];
//        
//        for (NSDictionary *dictionary in jsonArray) {
//            CommentModel *comment = [CommentModel getModelWith:dictionary];
//            [self.commentArray addObject:comment];
//        }
//        
//        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
//        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
//    }];
//    
//    [self.tableView footerEndRefreshing];
//}
//
#pragma mark - UITextViewDelegate

//开始编辑

- (void)textViewDidBeginEditing:(UITextView *)textView {
     if ([commentTextView.text isEqualToString:kPlaceholder]) {
         commentTextView.text = @"";
         //commentTextView.textColor = [UIColor blackColor];
     } 
    commentTextView.textColor = [UIColor blackColor];
}


//结束编辑

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (commentTextView.text.length == 0) {
        commentTextView.text = kPlaceholder;
        commentTextView.textColor = [UIColor grayColor];
    }
    DLog(@"编辑结束");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.commentArray.count;
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier forIndexPath:indexPath];
//    CommentModel *comment = self.commentArray[indexPath.row];
//    cell.comment = comment;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//    return cell;
//}
//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return @"全部评论";
//}
//
//
//
#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    CommentModel *comment = self.commentArray[indexPath.row];
//    return [CommentCell heightOfCell:comment];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//   
//    return 30;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.5;
//}
//


#pragma mark - Action

- (void)clickDonebBtn:(UIButton *)button {
    
    [commentTextView resignFirstResponder];
    if (commentTextView.text.length == 0 || [commentTextView.text isEqualToString:kPlaceholder]) {
        [Tools showErrorWithStatus:@"评论内容不能为空！"];
    } else {
        [HttpClient pushCommentWithID:[NSString stringWithFormat:@"%d", self.oid] content:commentTextView.text andBlock:^(int statusCode) {
            switch (statusCode) {
                case 200:
                {
                    [Tools showSuccessWithStatus:@"评论成功！"];
                    commentTextView.text = kPlaceholder;
                    commentTextView.textColor = [UIColor grayColor];
                    [self dismissViewControllerAnimated:YES completion:nil];
//                    [self netWork];
                }
                    break;
                    
                default:
                {
                    [Tools showErrorWithStatus:@"评论失败！"];
                }
                    
                    break;
            }
            
        }];
        
    }
    
    
}
- (void)clickCanclebBtn:(UIButton *)button {
    DLog(@"取消评论");
    [commentTextView resignFirstResponder];
    commentTextView.text = @"";
}

- (void)buttonClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
