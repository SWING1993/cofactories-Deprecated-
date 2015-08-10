//
//  AddressViewController.h
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/12.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>{

    UIPickerView *picker;
    UIButton *button;

    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;

    NSString *selectedProvince;

    NSString *addressString;
    
    
}


@end
