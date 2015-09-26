//
//  PageView.h
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/11.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageView : UIView<UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic,strong) UIButton *imageButton1;
@property (nonatomic,strong) UIButton *imageButton2;
@property (nonatomic,strong) UIButton *imageButton3;

- (instancetype)initWithFrame:(CGRect)frame andImageArray:(NSArray *)imageArray isNetWork:(BOOL)isNetWork;
- (void)scrollToNextPage:(NSTimer *)timer;
@end
