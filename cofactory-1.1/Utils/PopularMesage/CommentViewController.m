//
//  CommentViewController.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/17.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate> {
    UIView *tableViewHeadView;
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
    tableViewHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 230)];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, kScreenW - 40, 160)];
    textView.backgroundColor=[UIColor whiteColor];
    textView.scrollEnabled = NO;
    textView.editable = YES;
    textView.delegate = self;
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    textView.layer.borderWidth = 0.5;
    
    [tableViewHeadView addSubview:textView];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(20, CGRectGetMaxY(textView.frame) + 10, kScreenW - 40, 30);
    doneButton.layer.cornerRadius=5.0f;
    doneButton.layer.masksToBounds=YES;
    doneButton.layer.borderColor = [UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f].CGColor;
    doneButton.layer.borderWidth = 1.0f;
    doneButton.backgroundColor = [UIColor whiteColor];
    

    [doneButton setTitle:@"提交" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(clickbBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tableViewHeadView addSubview:doneButton];
    
    
    
    
    
    
    self.tableView.tableHeaderView = tableViewHeadView;
}

- (void)clickbBtn:(UIButton *)button {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
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
