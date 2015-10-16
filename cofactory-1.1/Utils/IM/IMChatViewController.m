//
//  IMChatViewController.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/10/15.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "IMChatViewController.h"

@interface IMChatViewController () {
    FactoryModel  *_userModel;
}

@end

@implementation IMChatViewController {
    BOOL _wasKeyboardManagerEnabled;

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:_wasKeyboardManagerEnabled];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}





- (void)didTapCellPortrait:(NSString *)userId {
    DLog(@"%@", userId);
    //解析工厂信息
    
    [HttpClient getUserProfileWithUid:[userId intValue] andBlock:^(NSDictionary *responseDictionary) {
        _userModel = (FactoryModel *)responseDictionary[@"model"];
        CooperationInfoViewController *vc = [CooperationInfoViewController new];
        vc.factoryModel = _userModel;
        [self.navigationController.navigationBar setHidden:NO];
        [self.navigationController pushViewController:vc animated:YES];

    }];

    

    
    
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
