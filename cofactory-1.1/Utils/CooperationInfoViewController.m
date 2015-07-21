//
//  CooperationInfoViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/18.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "CooperationInfoViewController.h"

@interface CooperationInfoViewController ()

@end

@implementation CooperationInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];


    //UIToolbar

    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, kScreenH-49, kScreenW, 49.0f) ];
    NSMutableArray *buttons = [[NSMutableArray alloc]initWithCapacity:2];


//    UIBarButtonItem *Item1 = [[UIBarButtonItem alloc]
//            initWithImage:[UIImage imageNamed:@"set_号码"]
//            style:UIBarButtonItemStylePlain
//            target:self
//            action:@selector(decrement:)];
//    [buttons addObject:Item1];
//
//    UIBarButtonItem *Item2 = [[UIBarButtonItem alloc]
//                              initWithImage:[UIImage imageNamed:@"set_收藏"]
//                              style:UIBarButtonItemStylePlain
//                              target:self
//                              action:@selector(decrement:)];
//    [buttons addObject:Item2];
//
//    [toolBar setItems:buttons animated:YES];

//    [toolBar sizeToFit];


    [self.view addSubview:toolBar];

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
