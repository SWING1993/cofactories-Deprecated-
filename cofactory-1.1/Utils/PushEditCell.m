#import "PushEditCell.h"


@interface PushEditCell()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,strong) UIPickerView *orderPicker;
@property (nonatomic,strong) UIToolbar    *pickerToolbar;
@end

@implementation PushEditCell
{
    NSString *_tmpPickerName;
}



- (void)awakeFromNib {
    // Initialization code

    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.userInteractionEnabled = YES;
    self.textField.inputView = [self fecthPicker];
    self.textField.inputAccessoryView = [self fecthToolbar];
    self.textField.text = _tmpPickerName;
    self.orderPicker.delegate = self;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (UIPickerView *)fecthPicker{
    if (!self.orderPicker) {
        self.orderPicker = [[UIPickerView alloc] init];
        //self.intervalpicker.backgroundColor = [UIColor whiteColor];
        self.orderPicker.delegate = self;
        self.orderPicker.dataSource = self;
        [self.orderPicker selectRow:0 inComponent:0 animated:NO];
    }
    return self.orderPicker;
}

- (UIToolbar *)fecthToolbar{

    if (!self.pickerToolbar) {
        self.pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ensure)];
        self.pickerToolbar.items = [NSArray arrayWithObjects:left,space,right,nil];
    }
    return self.pickerToolbar;
}
#pragma mark - UIPickerView datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return self.cellPickList.count;

}



- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.cellPickList objectAtIndex:row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    _tmpPickerName = [self pickerView:pickerView titleForRow:row forComponent:component];
}

-(void)ensure{

    if (_tmpPickerName) {
        self.textField.text = _tmpPickerName;
        _tmpPickerName = nil;
    }
    [self.textField endEditing:YES];
}
-(void)cancel{

    _tmpPickerName = nil;
    [self.textField endEditing:YES];
}


@end
