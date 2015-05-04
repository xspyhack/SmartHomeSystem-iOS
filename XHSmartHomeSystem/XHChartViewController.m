//
//  XHChartViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/17/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHChartViewController.h"
#import "XHDataAnalysisViewController.h"
#import "XHChartView.h"
#import "XHColorTools.h"

#define XHChartViewCount 4

@implementation XHChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Line Chart";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Data analysis" style:UIBarButtonItemStylePlain target:self action:@selector(dataAnalysis)];
    
    // add UIScrollView
    [self setupScrollView];
    
    // add PageControl
    [self setupPageControl];
}

#pragma mark - set up methods

- (void)setupScrollView
{
    // create UIScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    // add chartView
    // set up view width and height equal to scollView
    CGFloat chartViewWidth = scrollView.frame.size.width;
    CGFloat chartViewHeight = scrollView.frame.size.height;
    
    for (int i = 0; i < XHChartViewCount; i++) {
        // init chartView with frame
        CGFloat chartView_X = chartViewWidth * i;
        CGFloat chartView_Y = 0;
        CGRect rect = CGRectMake(chartView_X, chartView_Y, chartViewWidth, chartViewHeight);

        XHChartView *chartView = [[XHChartView alloc] initWithFrame:rect];
        chartView.roomId = i;
        [scrollView addSubview:chartView];
    }
    
    // set up other propear
    scrollView.contentSize = CGSizeMake(XHChartViewCount * chartViewWidth, 0);
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = YES; // bounces
    scrollView.pagingEnabled = YES;
    
    self.scrollView = scrollView;
}

- (void)setupPageControl
{
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = XHChartViewCount;
    
    //pageControl.center.x = self.view.frame.size.width * 0.5;
    [pageControl setCenter:CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height - 30)];
    
    // set color
    pageControl.currentPageIndicatorTintColor = [XHColorTools themeColor];
    pageControl.pageIndicatorTintColor = [XHColorTools defaultColor];
    //[pageControl addTarget:self action:@selector(pageChange) forControlEvents:UIControlEventTouchUpInside];
    
    self.pageControl = pageControl;
    self.pageControl.currentPage = self.roomId; // set currentPage
    [self setPage];
    
    [self.view addSubview:pageControl];
}

#pragma mark - private methods

- (void)dataAnalysis
{
    XHLog(@"data analysis");
    XHDataAnalysisViewController *analysisVC = [[XHDataAnalysisViewController alloc] init];
    [self.navigationController pushViewController:analysisVC animated:YES];
}

- (void)setPage
{
    [self.scrollView setContentOffset:CGPointMake(self.view.bounds.size.width * self.pageControl.currentPage, self.scrollView.bounds.origin.y) animated:YES];
}

#pragma  mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double doublePage = scrollView.contentOffset.x / scrollView.frame.size.width;
    int nearestPage = (int)(doublePage + 0.5);
    
    // maybe
    if (self.pageControl.currentPage != nearestPage) {
        self.pageControl.currentPage = nearestPage;
        if (scrollView.dragging) {
            [self.pageControl updateCurrentPageDisplay];
        }
        
    }
    //[self.scrollView setContentOffset:CGPointMake(self.view.bounds.size.width * self.pageControl.currentPage, self.scrollView.bounds.origin.y) animated:NO];
}

@end
