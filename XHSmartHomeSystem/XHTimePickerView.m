//
//  XHTimePickerView.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/27/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHTimePickerView.h"

@interface XHTimePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *timeArray;

@property (nonatomic, strong) UIBarButtonItem *startTimeItem;
@property (nonatomic, strong) UIBarButtonItem *endTimeItem;

@end

@implementation XHTimePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupToolBar];
        [self setupPickerView];
    }
    
    return self;
}

- (void)setStartTime:(NSString *)startTime
{
    _startTime = startTime;
    self.startTimeItem.title = startTime;
}

- (void)setEndTime:(NSString *)endTime
{
    _endTime = endTime;
    self.endTimeItem.title = endTime;
}

#pragma mark - setup

- (void)setupToolBar
{
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    self.toolBar.layer.borderWidth = .0f; //self.toolBar.layer.borderColor = [UIColor clearColor].CGColor;
    self.toolBar.layer.masksToBounds = YES;
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:5];
    
    UIBarButtonItem *from = [[UIBarButtonItem alloc] initWithTitle:@"start" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.startTimeItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];

    UIBarButtonItem *to = [[UIBarButtonItem alloc] initWithTitle:@"to" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.endTimeItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:self
                                          action:nil];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickDone)];
    
    [items addObject:from];
    [items addObject:self.startTimeItem];
    [items addObject:to];
    [items addObject:self.endTimeItem];
    
    [items addObject:flexibleSpaceItem];
    [items addObject:done];
    
    [self.toolBar setItems:items];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popPickerView)];
    [self.toolBar addGestureRecognizer:tap];
    
    [self addSubview:self.toolBar];
}

- (void)popPickerView
{
    XHLog(@"tap");
    self.pickerView.hidden = NO;
}

- (void)pickDone
{
    self.pickerView.hidden = YES;
    // save
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.startTimeItem.title forKey:@"XHNotificationStartTime"];
    [defaults setObject:self.endTimeItem.title forKey:@"XHNotificationEndTime"];
}

- (void)setupPickerView
{
    CGRect rect = CGRectMake(0, 50, self.frame.size.width, self.frame.size.height - 40);
    self.pickerView = [[UIPickerView alloc] initWithFrame:rect];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.hidden = YES;
    
    [self addSubview:self.pickerView];
}

- (NSMutableArray *)timeArray
{
    if (!_timeArray) {
        _timeArray = [NSMutableArray array];
        for (int i = 0; i < 24; i++) {
            NSString *str = [NSString stringWithFormat:@"%d:00", i];
            [_timeArray addObject:str];
        }
    }
    return _timeArray;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.timeArray count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.frame.size.width / 2 ;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0f;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    CGFloat width = [self pickerView:pickerView widthForComponent:component];
    CGFloat height = 40.0f;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    label.text = [self.timeArray objectAtIndex:row];
    label.textAlignment = NSTextAlignmentCenter;
    
    UIView *singleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [singleView addSubview:label];
    
    return singleView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.startTimeItem.title = [self.timeArray objectAtIndex:[pickerView selectedRowInComponent:0]];
    self.endTimeItem.title = [self.timeArray objectAtIndex:[pickerView selectedRowInComponent:1]];
}

@end
