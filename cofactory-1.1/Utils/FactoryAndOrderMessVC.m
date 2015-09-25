//
//  FactoryAndOrderMessVC.m
//  cofactory-1.1
//
//  Created by gt on 15/7/23.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "FactoryAndOrderMessVC.h"
#import "Header.h"

@interface FactoryAndOrderMessVC () <UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *listData;
@property (nonatomic, strong) NSArray *pickList;
@property (nonatomic, strong) NSArray *pickList0;
@property (nonatomic, strong) NSArray *pickList1;

@property (nonatomic, assign) int type;

@property (nonatomic,strong) UIPickerView *orderPicker;
@property (nonatomic,strong) UIToolbar *pickerToolbar;

@property (nonatomic,strong) UIPickerView *servicePicker;
@property (nonatomic,strong) UIToolbar *serviceToolbar;

@property (nonatomic,strong) UIPickerView *scalePicker;
@property (nonatomic,strong) UIToolbar *scaleToolbar;





@end

@implementation FactoryAndOrderMessVC
{

    UITextField*dateTextField;
    UITextField*scalTextField;
    UITextField*ServiceRangeTextField;

    NSString*ServiceRangeString;
    NSString*numberString;
    NSString*scalString;

    UILabel *_lineLabel;

    UIButton *pushOrderBtn;

    NSMutableArray *_messArray;


    //发送推送数据

    int _pushFacYype;
    NSNumber *_pushDistenceMin;
    NSNumber *_pushDistenceMax;
    NSNumber *_pushPeopleMin;
    NSNumber *_pushPeopleMax;
    NSString *_pushBusinessType;
    NSNumber *_pushWorkingTimeMin;
    NSNumber *_pushWorkingTimeMax;

}



- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.facType == 0)
    {
        self.navigationItem.title = @"添加工厂信息";
    }
    if (self.facType == 1)
    {
        self.navigationItem.title = @"添加服装厂外发订单";
    }

    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;


    NSArray*btnTitleArray = @[@"加工厂",@"代裁厂",@"锁眼钉扣厂"];
    UIView*headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    for (int i=0; i<3; i++) {

        UIButton*typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        typeBtn.frame = CGRectMake((kScreenW-240)/4+i*((kScreenW-240)/4+80), 10, 80 , 30);
        [typeBtn setTitleColor: [UIColor grayColor] forState:UIControlStateNormal];
        if (i==0) {
            //设置与按钮同步的下划线Label
            _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(typeBtn.frame.origin.x, 40, 80,2 )];
            _lineLabel.backgroundColor = [UIColor redColor];
            [headerView addSubview:_lineLabel];
        }
        typeBtn.tag=i;
        typeBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
        [typeBtn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        [typeBtn addTarget:self action:@selector(clickTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:typeBtn];
    }
    self.tableView.tableHeaderView=headerView;

    if ([self.types isEqualToString:@"factory"]) {

        self.listData = @[@[@"业务类型", @"距离", @"规模"], @[@"距离", @"规模"], @[@"距离", @"规模"]];

        self.pickList =@[@[@"不限类型",@"针织", @"梭织"],@[@"不限距离",@"10公里以内", @"10-50公里", @"50-100公里",@"100-200公里",@"200-300公里",@"300公里以上"],@[@"不限规模",@"2-4人", @"4-10人", @"10-20人",@"20人以上"]];

        self.pickList0 =@[@[@"不限类型",@"针织", @"梭织"],@[@"不限距离",@"10公里以内", @"10-50公里", @"50-100公里",@"100-200公里",@"200-300公里",@"300公里以上"],@[@"不限规模",@"2-4人", @"4-10人", @"10-20人",@"20人以上"]];

        self.pickList1 =@[@[@"不限类型",@"针织", @"梭织"],@[@"不限距离",@"1公里以内", @"1-5公里", @"5-10公里"],@[@"不限规模",@"2-4人", @"4人以上"]];
    }

    if ([self.types isEqualToString:@"order"]) {

        self.listData = @[@[@"业务类型", @"数量", @"期限"], @[ @"数量", @"期限"], @[ @"数量", @"期限"]];
        self.pickList =@[@[@"不限类型",@"针织", @"梭织"],@[@"不限数量",@"500件以内", @"500-1000件", @"1000-2000件",@"2000-5000件",@"5000件以上"],@[@"不限期限",@"3天", @"5天", @"5天以上"]];
       self.pickList0 =@[@[@"不限类型",@"针织", @"梭织"],@[@"不限数量",@"500件以内", @"500-1000件", @"1000-2000件",@"2000-5000件",@"5000件以上"],@[@"不限期限",@"3天", @"5天", @"5天以上"]];
        self.pickList1 =@[@[@"不限类型",@"针织", @"梭织"],@[@"不限数量",@"500件以内", @"500-1000件", @"1000-2000件",@"2000-5000件",@"5000件以上"],@[@"不限期限",@"1天", @"1-3天", @"3天以上"]];
    }




    self.type = 0;


    ServiceRangeTextField=[[UITextField alloc]initWithFrame:CGRectMake(kScreenW/2-30, 7, kScreenW/2+  10, 30)];
    ServiceRangeTextField.text=@"不限类型";
    ServiceRangeTextField.inputView = [self fecthSizePicker];
    ServiceRangeTextField.inputAccessoryView = [self fecthToolbar];
    ServiceRangeTextField.font=[UIFont systemFontOfSize:15.0f];
    ServiceRangeTextField.delegate=self;
    ServiceRangeTextField.borderStyle=UITextBorderStyleRoundedRect;

    dateTextField=[[UITextField alloc]initWithFrame:CGRectMake(kScreenW/2-30, 7, kScreenW/2+10, 30)];
    dateTextField.inputView = [self fecthServicePicker];
    dateTextField.inputAccessoryView = [self fecthServiceToolbar];
    dateTextField.delegate =self;
    dateTextField.font=[UIFont systemFontOfSize:15.0f];
    dateTextField.borderStyle=UITextBorderStyleRoundedRect;



    scalTextField=[[UITextField alloc]initWithFrame:CGRectMake(kScreenW/2-30, 7, kScreenW/2+10, 30)];
    scalTextField.inputView = [self scalesPicker];
    scalTextField.inputAccessoryView = [self scalesToolbar];
    scalTextField.delegate=self;
    scalTextField.font=[UIFont systemFontOfSize:15.0f];
    scalTextField.borderStyle=UITextBorderStyleRoundedRect;

    if ([self.types isEqualToString:@"factory"]) {

        dateTextField.text=@"不限距离";
        scalTextField.text=@"不限规模";

    }

    if ([self.types isEqualToString:@"order"]) {

        dateTextField.text=@"不限数量";
        scalTextField.text=@"不限期限";
    }

    pushOrderBtn = [[UIButton alloc]init];
    pushOrderBtn.frame=CGRectMake(30, 220, kScreenW-60, 40);
    [pushOrderBtn setTitle:@"确定" forState:UIControlStateNormal];
    [pushOrderBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [pushOrderBtn addTarget:self action:@selector(pushOrderBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:pushOrderBtn];

    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancleButtonClicked)];
    [setButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = setButton;

}

- (void)cancleButtonClicked
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dic"];


    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)clickTypeBtn:(UIButton *)sender
{
    UIButton*button=(UIButton *)sender;


    // 控制下划线Label与按钮的同步
    [UIView animateWithDuration:0.2 animations:^{
        _lineLabel.frame = CGRectMake(button.frame.origin.x, 40, button.frame.size.width, 2);
    }];

    switch (button.tag) {
        case 0:
        {
            self.type=0;
            pushOrderBtn.frame=CGRectMake(30, 220, kScreenW-60, 40);
            self.pickList = self.pickList0;
            // 刷新数据
            if ([self.types isEqualToString:@"factory"]) {

                dateTextField.text=@"不限距离";
                scalTextField.text=@"不限规模";

            }

            if ([self.types isEqualToString:@"order"]) {

                dateTextField.text=@"不限数量";
                scalTextField.text=@"不限期限";
            }

            ServiceRangeTextField.text = @"不限类型";
            [self.orderPicker reloadAllComponents];
            [self.servicePicker reloadAllComponents];
            [self.scalePicker reloadAllComponents];
            [self.tableView reloadData];
        }
            break;
        case 1:
        {
            self.type=1;
            pushOrderBtn.frame=CGRectMake(30, 160, kScreenW-60, 40);
            self.pickList = self.pickList1;
            // 刷新数据
            if ([self.types isEqualToString:@"factory"]) {

                dateTextField.text=@"不限距离";
                scalTextField.text=@"不限规模";

            }

            if ([self.types isEqualToString:@"order"]) {

                dateTextField.text=@"不限数量";
                scalTextField.text=@"不限期限";
            }

            ServiceRangeTextField.text = nil;
            [self.orderPicker reloadAllComponents];
            [self.servicePicker reloadAllComponents];
            [self.scalePicker reloadAllComponents];
            [self.tableView reloadData];

        }
            break;
        case 2:
        {
            self.type=2;
            pushOrderBtn.frame=CGRectMake(30, 160, kScreenW-60, 40);
            self.pickList = self.pickList1;
            // 刷新数据
            if ([self.types isEqualToString:@"factory"]) {

                dateTextField.text=@"不限距离";
                scalTextField.text=@"不限规模";

            }

            if ([self.types isEqualToString:@"order"]) {

                dateTextField.text=@"不限数量";
                scalTextField.text=@"不限期限";
            }

            ServiceRangeTextField.text = nil;
            [self.orderPicker reloadAllComponents];
            [self.servicePicker reloadAllComponents];
            [self.scalePicker reloadAllComponents];
            [self.tableView reloadData];
        }
            break;


        default:
            break;
    }
}
//sizePicker
- (UIPickerView *)fecthSizePicker{
    if (!self.orderPicker) {
        self.orderPicker = [[UIPickerView alloc] init];
        self.orderPicker.tag=1;
        self.orderPicker.delegate = self;
        self.orderPicker.dataSource = self;
        [self.orderPicker selectRow:0 inComponent:0 animated:NO];
    }
    return self.orderPicker;
}
- (UIToolbar *)fecthToolbar{
    if (!self.pickerToolbar) {
        self.pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ensure)];
        self.pickerToolbar.items = [NSArray arrayWithObjects:left,space,right,nil];
    }
    return self.pickerToolbar;
}

-(void)cancel{

    ServiceRangeString = nil;
    [ServiceRangeTextField endEditing:YES];
}

-(void)ensure{

    if (ServiceRangeString) {
        ServiceRangeTextField.text = ServiceRangeString;
        ServiceRangeString = nil;
    }
    [ServiceRangeTextField endEditing:YES];
}

//service
- (UIPickerView *)fecthServicePicker{
    if (!self.servicePicker) {
        self.servicePicker = [[UIPickerView alloc] init];
        self.servicePicker.tag=2;
        self.servicePicker.delegate = self;
        self.servicePicker.dataSource = self;
        [self.servicePicker selectRow:0 inComponent:0 animated:NO];
    }
    return self.servicePicker;
}

- (UIToolbar *)fecthServiceToolbar{

    if (!self.serviceToolbar) {
        self.serviceToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(serviceCancel)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(serviceEnsure)];
        self.serviceToolbar.items = [NSArray arrayWithObjects:left,space,right,nil];
    }
    return self.serviceToolbar;
}

-(void)serviceCancel{

    numberString = nil;
    [dateTextField endEditing:YES];
}

-(void)serviceEnsure{

    if (numberString) {
        dateTextField.text = numberString;
        numberString = nil;
    }
    [dateTextField endEditing:YES];
}

// scales
- (UIPickerView *)scalesPicker{
    if (!self.scalePicker) {
        self.scalePicker = [[UIPickerView alloc] init];
        self.scalePicker.tag=3;
        self.scalePicker.delegate = self;
        self.scalePicker.dataSource = self;
        [self.scalePicker selectRow:0 inComponent:0 animated:NO];
    }
    return self.scalePicker;
}

- (UIToolbar *)scalesToolbar{

    if (!self.scaleToolbar) {
        self.scaleToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(scalesCancel)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(scalesEnsure)];
        self.scaleToolbar.items = [NSArray arrayWithObjects:left,space,right,nil];
    }
    return self.scaleToolbar;
}

-(void)scalesCancel{

    scalString = nil;
    [scalTextField endEditing:YES];
}

-(void)scalesEnsure{

    if (scalString) {
        scalTextField.text = scalString;
        scalString = nil;
    }
    [scalTextField endEditing:YES];
}


#pragma mark - UIPickerView datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 1)
    {
        return [self.pickList[0] count];
    }
    else if(pickerView.tag == 2)
    {
        return [self.pickList[1] count];
    }
    else
    {
        return [self.pickList[2] count];
    }
}



- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag==1)
    {
        return [self.pickList[0] objectAtIndex:row];

    }
    else if (pickerView.tag==2)
    {
        return [self.pickList[1] objectAtIndex:row];
    }
    else
    {
        return [self.pickList[2] objectAtIndex:row];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag==1) {
        ServiceRangeString = [self pickerView:pickerView titleForRow:row forComponent:component];
    }
    if (pickerView.tag==2) {
        numberString = [self pickerView:pickerView titleForRow:row forComponent:component];    }
    else{
        scalString = [self pickerView:pickerView titleForRow:row forComponent:component];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.listData[self.type] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.font=[UIFont systemFontOfSize:15.0f];
//        NSMutableArray*cellArr=[[NSMutableArray alloc]initWithCapacity:0];
        NSArray*cellArr=self.listData[self.type];
        cell.textLabel.text=cellArr[indexPath.section];


        if (self.type==0) {
            switch (indexPath.section) {
                case 0:
                {
                    [cell addSubview:ServiceRangeTextField];
                }
                    break;
                case 1:
                {
                    [cell addSubview:dateTextField];
                }
                    break;
                case 2:
                {
                    [cell addSubview:scalTextField];
                }
                    break;
                case 3:
                {
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

                }
                    break;

                default:
                    break;
            }
        }
        if (self.type==1 || self.type==2) {
            switch (indexPath.section) {
                case 0:
                {
                    [cell addSubview:dateTextField];

                }
                    break;
                case 1:
                {
                    [cell addSubview:scalTextField];

                }
                    break;
                case 2:
                {
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

                }
                    break;

                default:
                    break;
            }
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


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.tableView endEditing:YES];
//}


- (void)pushOrderBtn
{
    DLog(@"types=%@",self.types);

    if (self.type == 0)
    {

    }
    if (!self.type == 0)
    {
        ServiceRangeTextField.text = @"";
    }

    //  NSLog(@"type=%d>>dateTextField=%@>>ServiceRangeTextField=%@>>ServiceRangeTextField=%@",self.type,dateTextField.text,scalTextField.text,ServiceRangeTextField.text);


    switch (self.type) {
        case 0:
            _pushFacYype = 1;
            break;
        case 1:
            _pushFacYype = 2;
            break;
        case 2:
            _pushFacYype = 3;
            break;

        default:
            break;
    }


    if ([self.types isEqualToString:@"factory"])
    {

        _pushWorkingTimeMin = nil;
        _pushWorkingTimeMax = nil;

        if ([dateTextField.text isEqualToString:@"不限距离"]) {

            _pushDistenceMin = @0;
            _pushDistenceMax = @50000000;

        }else if ([dateTextField.text isEqualToString:@"10公里以内"]){
            _pushDistenceMin = @0;
            _pushDistenceMax = @10000;

        }else if ([dateTextField.text isEqualToString:@"10-50公里"]){
            _pushDistenceMin = @10000;
            _pushDistenceMax = @50000;
        }else if ([dateTextField.text isEqualToString:@"50-100公里"]){
            _pushDistenceMin = @50000;
            _pushDistenceMax = @100000;
        }else if ([dateTextField.text isEqualToString:@"100-200公里"]){
            _pushDistenceMin = @100000;
            _pushDistenceMax = @200000;
        }else if ([dateTextField.text isEqualToString:@"200-300公里"]){
            _pushDistenceMin = @200000;
            _pushDistenceMax = @300000;
        }else if ([dateTextField.text isEqualToString:@"300公里以上"]){
            _pushDistenceMin = @300000;
            _pushDistenceMax = @100000000;
        }else if ([dateTextField.text isEqualToString:@"1公里以内"]){
            _pushDistenceMin = @0;
            _pushDistenceMax = @1000;
        }else if ([dateTextField.text isEqualToString:@"1-5公里"]){
            _pushDistenceMin = @1000;
            _pushDistenceMax = @5000;
        }else if ([dateTextField.text isEqualToString:@"5-10公里"]){
            _pushDistenceMin = @5000;
            _pushDistenceMax = @10000;
        }

        if ([scalTextField.text isEqualToString:@"不限规模"]) {
            _pushPeopleMin = @0;
            _pushPeopleMax = @500;
        }else if ([scalTextField.text isEqualToString:@"2-4人"]){
            _pushPeopleMin = @2;
            _pushPeopleMax = @4;
        }else if ([scalTextField.text isEqualToString:@"4-10人"]){
            _pushPeopleMin = @4;
            _pushPeopleMax = @10;
        }else if ([scalTextField.text isEqualToString:@"10-20人"]){
            _pushPeopleMin = @10;
            _pushPeopleMax = @20;
        }else if ([scalTextField.text isEqualToString:@"20人以上"]){
            _pushPeopleMin = @20;
            _pushPeopleMax = @400;
        }else if ([scalTextField.text isEqualToString:@"4人以上"]){
            _pushPeopleMin = @4;
            _pushPeopleMax = @400;
        }


    }


    else
    {

        _pushDistenceMin = nil;
        _pushDistenceMax = nil;


        if ([dateTextField.text isEqualToString:@"不限数量"])
        {

            _pushPeopleMin = @0;
            _pushPeopleMax = @5000000;

        }else if ([dateTextField.text isEqualToString:@"500件以内"]){
            _pushPeopleMin = @0;
            _pushPeopleMax = @500;
        }else if ([dateTextField.text isEqualToString:@"500-1000件"]){
            _pushPeopleMin = @500;
            _pushPeopleMax = @1000;
        }else if ([dateTextField.text isEqualToString:@"1000-2000件"]){
            _pushPeopleMin = @1000;
            _pushPeopleMax = @2000;
        }else if ([dateTextField.text isEqualToString:@"2000-5000件"]){
            _pushPeopleMin = @2000;
            _pushPeopleMax = @5000;
        }else if ([dateTextField.text isEqualToString:@"5000件以上"]){
            _pushPeopleMin = @5000;
            _pushPeopleMax = @500000;
        }




        if ([scalTextField.text isEqualToString:@"不限期限"]) {


            _pushWorkingTimeMin = @0;
            _pushWorkingTimeMax = @5000000;
        }
        else if ([scalTextField.text isEqualToString:@"3天"]){
            _pushWorkingTimeMin = @3;
            _pushWorkingTimeMax = @3;

        }else if ([scalTextField.text isEqualToString:@"5天"]){
            _pushWorkingTimeMin = @5;
            _pushWorkingTimeMax = @5;
        }
        else if ([scalTextField.text isEqualToString:@"5天以上"]){
            _pushWorkingTimeMin = @5;
            _pushWorkingTimeMax = @50000;
        }else if ([scalTextField.text isEqualToString:@"1天"]){
            _pushWorkingTimeMin = @1;
            _pushWorkingTimeMax = @1;
        }else if ([scalTextField.text isEqualToString:@"3天以上"]){
            _pushWorkingTimeMin = @3;
            _pushWorkingTimeMax = @500000;
        }else if ([scalTextField.text isEqualToString:@"1-3天"]){
            _pushWorkingTimeMin = @1;
            _pushWorkingTimeMax = @3;
        }


    }




    DLog(@"+==+++_pushFacYype=%d,,ServiceRangeTextField=%@,,_pushDistenceMin=%@,,_pushDistenceMax=%@,,_pushPeopleMin=%@,,_pushPeopleMax=%@,,self.types=%@,,_pushWorkingTimeMin=%@,_pushWorkingTimeMax=%@",_pushFacYype,ServiceRangeTextField.text,_pushDistenceMin,_pushDistenceMax,_pushPeopleMin,_pushPeopleMax,self.types,_pushWorkingTimeMin,_pushWorkingTimeMax);

    [HttpClient addPushSettingWithFactoryType:_pushFacYype Type:self.types FactoryServiceRange:ServiceRangeTextField.text factorySizeMin:_pushPeopleMin factorySizeMax:_pushPeopleMax factoryDistanceMin:_pushDistenceMin factoryDistanceMax:_pushDistenceMax factoryWorkingTimeMin:_pushWorkingTimeMin factoryWorkingTimeMax:_pushWorkingTimeMax andBlock:^(int code) {
        DLog(@"%d",code);
                if (code == 200) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加推送成功"
                                                                        message:nil
                                                                       delegate:self
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
        
                    [alertView show];
                }else if (code == 400){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加推送失败"
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
        
                    [alertView show];
                }

    }];
    
 //   [HttpClient addPushSettingWithFactoryType:_pushFacYype Type:self.types FactoryServiceRange:ServiceRangeTextField.text factorySizeMin:_pushPeopleMin factorySizeMax:_pushPeopleMax factoryDistanceMin:_pushDistenceMin factoryDistanceMax:_pushDistenceMax andBlock:^(int code) {
//        DLog(@"%d",code);
//        if (code == 200) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加推送成功"
//                                                                message:nil
//                                                               delegate:self
//                                                      cancelButtonTitle:@"确定"
//                                                      otherButtonTitles:nil];
//
//            [alertView show];
//        }else if (code == 400){
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加推送失败"
//                                                                message:nil
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"确定"
//                                                      otherButtonTitles:nil];
//
//            [alertView show];
//        }
//    }];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

@end
