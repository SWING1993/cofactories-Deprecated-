//
//  CommentViewController.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/17.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "CommentViewController.h"
#define kRowInset 5

@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate> {
    UIView *tableViewHeadView;
    UITextView *commentTextView;
}

@end

static NSString *commentCellIdentifier = @"comment";
@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";
    //设置Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked)];
    self.navigationItem.leftBarButtonItem = setButton;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:commentCellIdentifier];
    [self creatHeadView];
}
- (void)buttonClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)creatHeadView {
    tableViewHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 130)];
    commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 15, kScreenW - 40, 60)];
    commentTextView.backgroundColor=[UIColor whiteColor];
    commentTextView.scrollEnabled = NO;
    commentTextView.editable = YES;
    commentTextView.delegate = self;
    commentTextView.layer.borderColor = [UIColor grayColor].CGColor;
    commentTextView.layer.borderWidth = 0.5;
    commentTextView.layer.cornerRadius = 5.0f;
    commentTextView.clipsToBounds = YES;
    commentTextView.keyboardType = UIKeyboardTypeDefault;
    commentTextView.text = @"请写下你的评论......";
    commentTextView.textColor = [UIColor grayColor];
    [tableViewHeadView addSubview:commentTextView];
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(20, CGRectGetMaxY(commentTextView.frame) + 10, (kScreenW - 40) / 2 - 20, 30);
    cancleButton.layer.cornerRadius=5.0f;
    cancleButton.layer.masksToBounds=YES;
    cancleButton.layer.borderColor = [UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f].CGColor;
    cancleButton.layer.borderWidth = 1.0f;
    cancleButton.backgroundColor = [UIColor whiteColor];
    
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(clickbBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tableViewHeadView addSubview:cancleButton];

    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    doneButton.frame = CGRectMake(CGRectGetMaxX(<#CGRect rect#>) + 20, CGRectGetMaxY(commentTextView.frame) + 10, (kScreenW - 40) / 2 - 20, 30);
    doneButton.layer.cornerRadius=5.0f;
    doneButton.layer.masksToBounds=YES;
    doneButton.layer.borderColor = [UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f].CGColor;
    doneButton.layer.borderWidth = 1.0f;
    doneButton.backgroundColor = [UIColor whiteColor];
    
    [doneButton setTitle:@"确定" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(clickbBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tableViewHeadView addSubview:doneButton];
    self.tableView.tableHeaderView = tableViewHeadView;
}

- (void)clickbBtn:(UIButton *)button {
    DLog(@"提交评论");
    
    
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
     if ([commentTextView.text isEqualToString:@"请写下你的评论......"]) {
        commentTextView.text = @"";
    }
    
    
}


//结束编辑

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (commentTextView.text.length == 0) {
        commentTextView.text = @"请写下你的评论......";
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
    return kRowInset;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
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
