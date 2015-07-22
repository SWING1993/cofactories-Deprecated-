//
//  PushHelperModel.m
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/11.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "PushHelperModel.h"

@implementation PushHelperModel

- (instancetype)init {
    self = [super init];
    if (self) {
        CGSize size = [[UIScreen mainScreen] bounds].size;
         //自定义样式
        self.scrollDirection = UICollectionViewScrollDirectionVertical;// 竖直滚动
        self.minimumLineSpacing = 15.0f;
        self.itemSize = CGSizeMake(size.width - 18.0f, 120);
        self.sectionInset = UIEdgeInsetsMake(18.0f, 0, 18.0f, 0);
        self.headerReferenceSize = CGSizeMake(size.width, 50);
        self.footerReferenceSize = CGSizeMake(size.width, 40);
    }
    return self;
}


@end
