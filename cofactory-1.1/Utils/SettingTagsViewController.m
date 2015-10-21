//
//  SettingTagsViewController.m
//  Coding_iOS
//
//  Created by 王 原闯 on 14-10-11.
//  Copyright (c) 2014年 Coding. All rights reserved.
//


#define kCCellIdentifier_Tag @"TagCCell"


#import "Header.h"
#import "SettingTagsViewController.h"
#import "TagCCell.h"
//#import "TagsManager.h"
@interface SettingTagsViewController ()
@property (strong, nonatomic) UICollectionView *tagsView;
@property (nonatomic,retain)NSMutableArray*mySelectedTagsArr;
@end

@implementation SettingTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    _mySelectedTags = [_selectedTags mutableCopy];


//    self.allTags = [NSArray array];
//    self.allTags = @[@"排版好",@"工期快",@"设备齐全",@"节省布料",@"自备货车"];


    self.mySelectedTagsArr = [[NSMutableArray alloc]initWithCapacity:0];

    self.title = @"个性标签";
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.tagsView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.tagsView setBackgroundColor:[UIColor whiteColor]];
    [self.tagsView registerClass:[TagCCell class] forCellWithReuseIdentifier:kCCellIdentifier_Tag];
    self.tagsView.dataSource = self;
    self.tagsView.delegate = self;
    [self.view addSubview:self.tagsView];

    //确定Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnClicked)];
    self.navigationItem.rightBarButtonItem = setButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)doneBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
//    if (self.doneBlock) {
//        self.doneBlock(_mySelectedTags);
//    }
}

#pragma mark Collection M
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _allTags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TagCCell *ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_Tag forIndexPath:indexPath];
    NSString *curTag = [_allTags objectAtIndex:indexPath.row];
    ccell.curTag = curTag;
    ccell.hasBeenSelected = YES;
    [self.mySelectedTagsArr addObject:ccell];
    return ccell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [TagCCell ccellSizeWithObj:[_allTags objectAtIndex:indexPath.row]];
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    for (TagCCell *ccell in self.mySelectedTagsArr) {
        ccell.hasBeenSelected = YES;
    }
    TagCCell *ccell = self.mySelectedTagsArr[indexPath.row];
    ccell.hasBeenSelected = NO;

    NSString *curTag = [_allTags objectAtIndex:indexPath.row];

    [HttpClient updateFactoryTag:curTag andBlock:^(int statusCode) {
        [Tools showShimmeringString:[NSString stringWithFormat:@"您选择的标签为%@",curTag ]];
    }];
}



@end
