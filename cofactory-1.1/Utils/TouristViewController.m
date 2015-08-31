//
//  ViewController.m
//  542134
//
//  Created by gt on 15/7/25.
//  Copyright (c) 2015年 gt. All rights reserved.
//

#import "Header.h"
#import "TouristViewController.h"

@interface TouristViewController ()
{
    NSArray *_array;
}
@end

@implementation TouristViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"游客登录";
    UIImageView*bgView = [[UIImageView alloc]initWithFrame:kScreenBounds];
    bgView.image=[UIImage imageNamed:@"登录bg"];
    [self.view addSubview:bgView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, kScreenW-60, 50)];
    label.text = @"请选择您的游客身份";
    label.textColor = [UIColor whiteColor];
    label.font=[UIFont boldSystemFontOfSize:24.0f];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    
    _array = @[@"服装厂",@"加工厂",@"代裁厂",@"锁眼钉扣厂"];
    for (int i=0; i<_array.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-170)/2.0, 20+50*(i+1), 170, 40);
        button.backgroundColor = [UIColor whiteColor];
        button.tag= i;
        button.alpha=0.8f;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        [button setTitle:_array[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(30, 300, kScreenW-60, 40);
    [button setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [button setTitle:@"上一步" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}


- (void)buttonClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    DLog(@"%ld",(long)button.tag);
    [[NSUserDefaults standardUserDefaults]setInteger:button.tag forKey:@"toursitTag"];
//    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"toursit"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [ViewController TouristLogin];
}

- (void)goBackClick
{    
    DLog(@"toursitTag%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"toursitTag"]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
