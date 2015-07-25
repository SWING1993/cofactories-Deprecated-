//
//  PhotoViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/25.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "FactoryPhotoViewController.h"

@interface FactoryPhotoViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation FactoryPhotoViewController {
    UICollectionView *CollectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title=@"公司相册";

    UIImageView*bgView = [[UIImageView alloc]initWithFrame:kScreenBounds];
    bgView.image=[UIImage imageNamed:@"登录bg"];
    [self.view addSubview:bgView];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenW/4-10, kScreenW/4-10);
    layout.sectionInset = UIEdgeInsetsMake(25, 5, 5, 5);

    CollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64) collectionViewLayout:layout];
    CollectionView.backgroundColor=[UIColor clearColor];
    CollectionView.delegate=self;
    CollectionView.dataSource=self;
    CollectionView.showsHorizontalScrollIndicator=NO;
    [CollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:CollectionView];

}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section==0) {
        return [self.equipment count];

    }
    if (section==1) {
        return [self.environment count];

    }else{
        return [self.employee count];

    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView*photoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW/4-10, kScreenW/4-10)];
    if (indexPath.section==0) {
        NSString*urlString =[NSString stringWithFormat:@"http://cdn.cofactories.com%@",self.equipment[indexPath.row]];
        [photoView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"placeholder232"] ];
    }
    if (indexPath.section==1) {
        NSString*urlString =[NSString stringWithFormat:@"http://cdn.cofactories.com%@",self.environment[indexPath.row]];
        [photoView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"placeholder232"] ];
    }if (indexPath.section==2){
        NSString*urlString =[NSString stringWithFormat:@"http://cdn.cofactories.com%@",self.employee[indexPath.row]];
        [photoView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"placeholder232"] ];
    }

    photoView.contentMode=UIViewContentModeScaleAspectFill;
    photoView.clipsToBounds=YES;
    [cell addSubview:photoView];

    return cell;
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
