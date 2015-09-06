//
//  CompeteViewController.m
//  cofactory-1.1
//
//  Created by gt on 15/9/6.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#define kSizeThumbnailCollectionView  ([UIScreen mainScreen].bounds.size.width-10)/3

#import "CompeteViewController.h"

@interface CompeteViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    NSMutableArray *_contentArray;
    NSArray *_imageArray;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *collectionImage;
@end

@implementation CompeteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单投标";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认投标" style:UIBarButtonItemStyleBordered target:self action:@selector(confirmBid)];
    
    _imageArray = @[@"公司名称",@"公司规模",@"公司类型"];
    _collectionImage = [@[] mutableCopy];
    _contentArray = [@[] mutableCopy];
    [_contentArray addObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"factoryName"]];
    [_contentArray addObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"factoryServiceRange"]];
    [_contentArray addObject:[Tools SizeWith:[[NSUserDefaults standardUserDefaults] objectForKey:@"factorySize"]]];
    DLog(@"\n%@,%@,%@",_contentArray[0],_contentArray[1],_contentArray[2]);
    
//    [HttpClient registBidWithOid:self.oid commit:@"memeda" completionBlock:^(int statusCode) {
//        DLog(@"statusCode==%d",statusCode);
//    }];
    [self.view addSubview:self.collectionView];
    [self creatUI];
}

- (void)creatUI{
    for (int i=0; i<3; i++) {
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(i*((kScreenW-240)/2.0+80),0 ,60 ,60 )];
        view.image = [UIImage imageNamed:_imageArray[i]];
        [self.view addSubview:view];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kSizeThumbnailCollectionView, kSizeThumbnailCollectionView);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 2.0;
        layout.minimumInteritemSpacing = 2.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, kScreenW, kScreenW) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  //  return [self.collectionImage count];
    return 8;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
//    UIImageView*imageView = [[UIImageView alloc]init];
//    imageView.userInteractionEnabled = YES;
//    imageView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
////    imageView.image = self.collectionImage[indexPath.row];
//    imageView.backgroundColor = [UIColor redColor];
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    imageView.clipsToBounds = YES;
//    [cell addSubview:imageView];
//    
//    UIButton*deleteBtn = [[UIButton alloc]init];
//    deleteBtn.frame = CGRectMake(imageView.frame.size.width-25, 0, 25, 25);
//    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"删除图片"] forState:UIControlStateNormal];
//    deleteBtn.tag = indexPath.row;
//    [deleteBtn addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
//    [imageView addSubview:deleteBtn];
    
    cell.backgroundColor = [UIColor redColor];
    return cell;
}



- (void)confirmBid{
    DLog(@"234");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
