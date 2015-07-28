//
//  StatusViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/15.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "StatusViewController.h"

#import "CalendarHomeViewController.h"
#import "CalendarViewController.h"
#import "Color.h"


#define CellIdentifier @"Cell"

@interface StatusViewController ()
@property (nonatomic,copy)NSArray * cellTitleArr;
//@property (nonatomic, strong) THDatePickerViewController * datePicker;
@property (nonatomic, strong) UILabel*timeLabel;


@property (nonatomic, retain) NSDate * curDate;
@property (nonatomic, retain) NSDateFormatter * formatter;

@end

@implementation StatusViewController {

    CalendarHomeViewController *chvc;


}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"设置状态";
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    if (self.factoryType==1) {
        self.cellTitleArr=@[@"设置空闲时间",@"有无自备货车"];
        self.timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(kScreenW-120, 7, 100, 30)];
        self.timeLabel.textAlignment=NSTextAlignmentRight;
        self.timeLabel.font=[UIFont systemFontOfSize:15.0f];
        if (self.factoryFreeTime) {
            NSString*timeString=[[Tools WithTime:self.factoryFreeTime] firstObject];
            self.timeLabel.text=timeString;
        }
        self.curDate = [NSDate date];
        self.formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy/MM/dd"];
    }else{
        self.cellTitleArr=@[@"公司空闲开关"];
    }
    self.tableView.scrollEnabled=NO;
    self.tableView.rowHeight=44.0f;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.cellTitleArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font=[UIFont systemFontOfSize:15.0f];
        cell.textLabel.text = self.cellTitleArr[indexPath.section];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        if (self.factoryType==1) {
            if (indexPath.section==0) {
                [cell addSubview:self.timeLabel];
            }
            if (indexPath.section==1) {
                UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenW-70.0f, 7.0f, 60.0f, 28.0f)];
                if (self.hasTruck==0) {
                    switchView.on = NO;//没货车
                }else{
                    switchView.on = YES;//设置忙碌一边
                }
                switchView.tag=indexPath.section;
                [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
                [cell addSubview:switchView];
            }

        }else{
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenW-70.0f, 7.0f, 60.0f, 28.0f)];
            if ([self.factoryFreeStatus isEqualToString:@"空闲"]) {
                switchView.on = NO;//设置初始为ON的一边

            }else{
                switchView.on = YES;//设置初始为ON的一边
            }
            switchView.tag=indexPath.section;
            switchView.tag=indexPath.section;
            [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:switchView];
        }
            }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (void)switchAction:(UISwitch *)sender {
    UISwitch* switchBtn = (UISwitch *)sender;
    NSLog(@"%d",switchBtn.on);
    switch (switchBtn.tag) {
        case 0:{
            if (switchBtn.on==YES) {
                [HttpClient updateFactoryProfileWithFactoryName:nil factoryAddress:nil factoryServiceRange:nil factorySizeMin:nil factorySizeMax:nil factoryLon:nil factoryLat:nil factoryFree:@"忙碌" factoryDescription:nil andBlock:^(int statusCode) {
                    if (statusCode==200) {
                        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"公司状态为忙绿" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alertView show];
                    }else{
                        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"公司状态修改失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alertView show];
                        switchBtn.on=!switchBtn.on;
                    }
                }];
            }
            if (switchBtn.on==NO) {
                [HttpClient updateFactoryProfileWithFactoryName:nil factoryAddress:nil factoryServiceRange:nil factorySizeMin:nil factorySizeMax:nil factoryLon:nil factoryLat:nil factoryFree:@"空闲" factoryDescription:nil andBlock:^(int statusCode) {
                    if (statusCode==200) {
                        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"公司状态为空闲" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alertView show];
                    }else{
                        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"公司状态修改失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alertView show];
                        switchBtn.on=!switchBtn.on;
                    }
                }];
            }
        }
            break;
        case 1:{
            NSLog(@"自备货车");
            if (switchBtn.on==YES) {
                [HttpClient updateFactoryProfileWithHasTruck:@1 andBlock:^(int statusCode) {
                    if (statusCode==200) {
                        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"自备货车" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alertView show];
                    }else{
                        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"状态修改失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alertView show];
                        switchBtn.on=!switchBtn.on;
                    }
                }];
            }
            if (switchBtn.on==NO) {
                [HttpClient updateFactoryProfileWithHasTruck:@0 andBlock:^(int statusCode) {
                    if (statusCode==200) {
                        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"不自备货车" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alertView show];
                    }else{
                        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"状态修改失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alertView show];
                        switchBtn.on=!switchBtn.on;
                    }

                }];
            }
        }
            break;
               default:
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (!chvc) {

        chvc = [[CalendarHomeViewController alloc]init];

        chvc.calendartitle = @"空闲日期";

        [chvc setAirPlaneToDay:365 ToDateforString:nil];//飞机初始化方法

    }
    chvc.calendarblock = ^(CalendarDayModel *model){

        NSLog(@"\n---------------------------");
        NSLog(@"1星期 %@",[model getWeek]);
        NSLog(@"2字符串 %@",[model toString]);
        NSLog(@"3节日  %@",model.holiday);

        self.timeLabel.text=[NSString stringWithFormat:@"%@",[model toString]];
        [HttpClient updateFactoryProfileWithFactoryName:nil factoryAddress:nil factoryServiceRange:nil factorySizeMin:nil factorySizeMax:nil factoryLon:nil factoryLat:nil factoryFree:[model toString] factoryDescription:nil andBlock:^(int statusCode) {
            if (statusCode==200) {
                UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"空闲时间到%@",[model toString]] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }else{
                UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"空闲时间设置失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }
        }];

    };
    [self.navigationController pushViewController:chvc animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
