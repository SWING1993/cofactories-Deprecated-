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

- (instancetype)initWithFrame:(CGRect)frame andImageArray:(NSArray *)imageArray pageCount:(int)pageCount isNetWork:(BOOL)isNetWork netWork:(BOOL)netWork {
    self = [super initWithFrame:frame];
    if (self) {
        // 实例化控件
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scrollView.bounces = NO;// 不能弹性滚动
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.contentSize = CGSizeMake(frame.size.width * pageCount, frame.size.height);
        // 添加图片
        if (isNetWork) {
            for (int i = 1; i <= pageCount; i++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                if (netWork) {
                    [button sd_setBackgroundImageWithURL:[NSURL URLWithString:imageArray[i - 1]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@""]];
                } else {
                    [button setImage:[UIImage imageNamed:imageArray[i-1]] forState:UIControlStateNormal];
                }
                
//                [button setImage:[UIImage imageNamed:imageArray[i-1]] forState:UIControlStateNormal];
                //[button setBackgroundImage:[UIImage imageNamed:imageArray[i-1]] forState:UIControlStateNormal];
                 [button setFrame:CGRectMake((i - 1) * frame.size.width, 0, frame.size.width, frame.size.height)];
//                button.imageView.contentMode = UIViewContentModeScaleAspectFill;

                button.tag = i-1;
                [scrollView addSubview:button];
                switch (i) {
                    case 1:
                        _imageButton1 = button;
                          break;
                        
                    case 2:
                        _imageButton2 = button;
                        break;
                        
                    case 3:
                        _imageButton3 = button;
                        break;
                        
                    case 4:
                        _imageButton4 = button;
                        break;

                        
                    default:
                        break;
                }
            }
        }if (!isNetWork) {
            for (int i = 1; i <= pageCount; i++) {
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;
                imageView.image = [UIImage imageNamed:imageArray[i-1]];
                [imageView setFrame:CGRectMake((i - 1) * frame.size.width, 0, frame.size.width, frame.size.height)];
                [scrollView addSubview:imageView];
            }

        }
        self.scrollView = scrollView;
        [self addSubview:scrollView];
        
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        pageControl.numberOfPages = pageCount;
        pageControl.center = CGPointMake(frame.size.width / 2, frame.size.height - 10);
        self.pageControl = pageControl;
        [self addSubview:pageControl];
        // 定时器
        [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(scrollToNextPage:) userInfo:@(pageCount) repeats:YES];
        
    }
    return self;
}

#pragma mark - UIScrollViewDelegate 方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 求出 pageControl 当前的页面位置
    self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}

- (void)scrollToNextPage:(NSTimer *)timer {
    int pageCount = [timer.userInfo intValue];
    CGSize size = [[UIScreen mainScreen] bounds].size;
    self.pageControl.currentPage = (self.pageControl.currentPage + 1) % pageCount;
    [self.scrollView setContentOffset:CGPointMake(size.width * self.pageControl.currentPage, 0) animated:YES];
}






@end
