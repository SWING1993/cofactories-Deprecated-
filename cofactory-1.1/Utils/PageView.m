//
//  PageView.m
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/11.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "PageView.h"
#import "UIImageView+WebCache.h"

@implementation PageView

- (instancetype)initWithFrame:(CGRect)frame andImageArray:(NSArray *)imageArray {
    self = [super initWithFrame:frame];
    if (self) {
        // 实例化控件
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scrollView.bounces = NO;// 不能弹性滚动
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.contentSize = CGSizeMake(frame.size.width * 3, frame.size.height);
        // 添加图片
        for (int i = 1; i <= 3; ++i) {
            NSString *url = [NSString stringWithFormat:@"http://cofactories.bangbang93.com/images/banner/banner%d.png", i];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode=UIViewContentModeScaleAspectFill;
            [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
            [imageView setFrame:CGRectMake((i - 1) * frame.size.width, 0, frame.size.width, frame.size.height)];
            [scrollView addSubview:imageView];
        }
        self.scrollView = scrollView;
        [self addSubview:scrollView];
        
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        pageControl.numberOfPages = 3;
        pageControl.center = CGPointMake(frame.size.width / 2, frame.size.height - 10);
        self.pageControl = pageControl;
        [self addSubview:pageControl];
        // 定时器
        [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
    }
    return self;
}

#pragma mark - UIScrollViewDelegate 方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 求出 pageControl 当前的页面位置
    self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}

- (void)scrollToNextPage:(NSTimer *)timer {
    CGSize size = [[UIScreen mainScreen] bounds].size;
    self.pageControl.currentPage = (self.pageControl.currentPage + 1) % 3;
    [self.scrollView setContentOffset:CGPointMake(size.width * self.pageControl.currentPage, 0) animated:YES];
}



@end
