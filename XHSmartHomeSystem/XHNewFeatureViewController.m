//
//  XHNewFeatureViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/11/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHNewFeatureViewController.h"
#import "XHTabBarController.h"
#import "XHColorTools.h"
#import "XHButton.h"

@interface XHNewFeatureViewController ()

@end

@implementation XHNewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // add UIScrollView
    [self setupScrollView];
    
    // add PageControl
    [self setupPageControl];
}

- (void)setupScrollView
{
    // create UIScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    // add picture
    // set up picture's width and height equal to scollView
    CGFloat imageWidth = scrollView.frame.size.width;
    CGFloat imageHeight = scrollView.frame.size.height;
    
    for (int i = 0; i < XHNewFeatureImageCount; i++) {
        // create imageView
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *name = [NSString stringWithFormat:@"new_feature_%d", i];
        
        imageView.image = [UIImage imageNamed:name];
        
        [scrollView addSubview:imageView];
        
        // set up imageView frame
        CGFloat imageView_X = imageWidth * i;
        CGFloat imageView_Y = 0;
        
        CGRect frame = CGRectMake(imageView_X, imageView_Y, imageWidth, imageHeight);
        imageView.frame = frame;
        
        if (i == XHNewFeatureImageCount - 1) {
            [self setupLastImageView:(UIImageView *)imageView];
        }
    }
    
    // set up other propear
    scrollView.contentSize = CGSizeMake(XHNewFeatureImageCount * imageWidth, 0);
    scrollView.backgroundColor = [UIColor orangeColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = YES; // bounces
    scrollView.pagingEnabled = YES;
    
    self.scrollView = scrollView;
}

- (void)setupPageControl
{
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = XHNewFeatureImageCount;
    
    //pageControl.center.x = self.view.frame.size.width * 0.5;
    [pageControl setCenter:CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height - 30)];
    
    // set color
    pageControl.currentPageIndicatorTintColor = XHOrangeColor;
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [pageControl addTarget:self action:@selector(pageChange) forControlEvents:UIControlEventValueChanged];
    
    self.pageControl = pageControl;
    
    [self.view addSubview:pageControl];
}

- (void)setupLastImageView:(UIImageView *)imageView
{
    // set userInteraction enable
    imageView.userInteractionEnabled = YES;
    
    // add start button
    [self setupStartButton:imageView];
}

- (void)setupStartButton:(UIImageView *)imageView
{
    // set background image
    //[startButtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    //[startButtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    
    // set button frame
    CGFloat width = 60;
    CGFloat height = width;
    CGPoint center = CGPointMake(self.view.center.x, self.view.frame.size.height * 0.8);
    
    XHButton *startButton = [[XHButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [startButton setCenter:center];
    [startButton setTitle:NSLocalizedString(@"Go!", nil) forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [imageView addSubview:startButton];
}

- (void)pageChange
{
    //[self.scrollView setContentOffset:CGPointMake(self.view.bounds.size.width * self.pageControl.currentPage, self.scrollView.bounds.origin.y) animated:YES];
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * self.pageControl.currentPage;
    bounds.origin.y = 0;
    [self.scrollView scrollRectToVisible:bounds animated:YES];
}

- (void)startButtonClicked
{    
    // show main controller, tabbar viewController
    XHTabBarController *tabbarVC = [[XHTabBarController alloc] init];
    
    // three method to switch viewController
    // push
    //[self.navigationController pushViewController:tabbarVC animated:YES];
    
    // model
    //[self presentViewController:tabbarVC animated:YES completion:nil];
    
    // window.rootViewController
    // self.view.window // warning, don't use this method to get main window
    [UIApplication sharedApplication].keyWindow.rootViewController = tabbarVC;
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

#pragma mark - hide status bar

- (BOOL)prefersStatusBarHidden
{
    return YES;
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
