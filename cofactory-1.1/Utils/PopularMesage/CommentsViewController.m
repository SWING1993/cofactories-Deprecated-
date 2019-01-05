//
//  CommentsViewController.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/10/23.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "CommentsViewController.h"

#define kRowInset 5
#define kPlaceholder @"写下你想说的......"

@interface CommentsViewController ()<UITextViewDelegate> {
    UIView *tableViewHeadView;
    UITextView *commentTextView;
}
@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatHeadView];
    [self creatCancleItem];


}
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
