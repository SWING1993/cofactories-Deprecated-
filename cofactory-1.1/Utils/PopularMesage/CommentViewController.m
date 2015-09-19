//
//  CommentViewController.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/17.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentCell.h"
#define kRowInset 5
#define kPlaceholder @"写下你想说的......"

static NSString *commentCellIdentifier = @"commentCell";

@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate> {
    UIView *tableViewHeadView;
    UITextView *commentTextView;
}

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";
    //设置Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked)];
    self.navigationItem.leftBarButtonItem = setButton;
    
    [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:commentCellIdentifier];
    [self creatHeadView];
    [self netWork];
}
- (void)buttonClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    self.tableView.tableHeaderView = tableViewHeadView;
}

- (void)clickDonebBtn:(UIButton *)button {
    
    [commentTextView resignFirstResponder];
    if (commentTextView.text.length == 0 || [commentTextView.text isEqualToString:kPlaceholder]) {

        [Tools showHudTipStr:@"评论内容不能为空！"];
    } else {
        [HttpClient pushCommentWithID:[NSString stringWithFormat:@"%d", self.oid] content:commentTextView.text andBlock:^(int statusCode) {
            DLog(@"%d", statusCode);
            switch (statusCode) {
                case 200:
                {
                    [Tools showHudTipStr:@"评论成功！"];
                    commentTextView.text = kPlaceholder;
                    commentTextView.textColor = [UIColor grayColor];
                    [self netWork];
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
    
    
}
- (void)clickCanclebBtn:(UIButton *)button {
    DLog(@"取消评论");
    [commentTextView resignFirstResponder];
    commentTextView.text = @"";
}
- (void)netWork {
    [HttpClient getCommentWithOid:self.oid andBlock:^(NSDictionary *responseDictionary) {
        self.commentArray = [NSMutableArray arrayWithArray:responseDictionary[@"responseArray"]];
        [self.tableView reloadData];
    }];
}


////将要开始编辑
//
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
//    return YES;
//}
//
//
////将要结束编辑
//
//- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
//    return NO;
//}


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




//
////内容将要发生改变编辑
//
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    return YES;
//}
//
//
////内容发生改变编辑
//
//- (void)textViewDidChange:(UITextView *)textView {
//    DLog(@"内容发生改变编辑");
//}
//
//
////焦点发生改变
//
//- (void)textViewDidChangeSelection:(UITextView *)textView {
//    DLog(@"焦点发生改变");
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier forIndexPath:indexPath];
    CommentModel *comment = self.commentArray[indexPath.row];
    cell.comment = comment;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"全部评论";
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentModel *comment = self.commentArray[indexPath.row];
    return [CommentCell heightOfCell:comment];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}




@end
