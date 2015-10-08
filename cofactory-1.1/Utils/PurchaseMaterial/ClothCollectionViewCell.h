//
//  ClothCollectionViewCell.h
//  cofactory-1.1
//
//  Created by GTF on 15/10/8.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ClothCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)UILabel *messageLable;
@property (nonatomic,strong)UIButton *imageButton;
- (void)initWithUI;
@end
