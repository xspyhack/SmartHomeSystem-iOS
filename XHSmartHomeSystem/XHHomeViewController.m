//
//  XHHomeViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/11/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHHomeViewController.h"
#import "XHRoomTableViewCell.h"
#import "XHRoomModel.h"
#import "XHChartViewController.h"
#import "XHGaugeViewController.h"
#import "XHCmdLineViewController.h"
#import "XHStatusViewController.h"
#import "XHSocketThread.h"
#import "XHRoomTools.h"
#import "XHDatabase.h"

@interface XHHomeViewController ()<XHSocketThreadDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSMutableArray *modelCells;
@property (nonatomic, copy) NSMutableArray *roomModels;
@property (nonatomic, getter=isFirstTimeTodayReadData) BOOL firstTimeTodayReadData;
@property (nonatomic, assign) NSUInteger existRoom;
@property (nonatomic, strong) XHRoomTools *roomTools;
@property (nonatomic, assign) NSUInteger displayCellCount;

@end

@implementation XHHomeViewController

#pragma mark - life cycle

//- (instancetype)init
//{
//    if (self = [super init]) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRoomModel:) name:XHUpdateRoomModelNotification object:nil];
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.firstTimeTodayReadData = YES;
    self.displayCellCount = 0;
    self.existRoom = 0;
    
    // set navigationbar button
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_chart" highLightedImageName:@"nav_chart_highLighted" target:self action:@selector(chartButtonItemClicked)];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_status" highLightedImageName:@"nav_status_highLighted" target:self action:@selector(statusButtonItemClicked)];
    
    [self setupData];
    [self setupTabelView];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRoomModel:) name:XHUpdateRoomModelNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [XHSocketThread shareInstance].delegate = self;
    //[[XHSocketThread shareInstance] disconnect];
    //[[XHSocketThread shareInstance] connect];
    
    self.roomTools = [[XHRoomTools alloc] init];

    [self prepareVisibleCellsForAnimation];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"XHCmdLineMode"]) {
        UILongPressGestureRecognizer *longPressGuesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(barButtonItemLongPress:)];
        longPressGuesture.minimumPressDuration = 1.0f;
        [self.navigationItem.leftBarButtonItem.customView addGestureRecognizer:longPressGuesture];
    } else {
        for (UIGestureRecognizer *gestureRecognizer in [self.navigationItem.leftBarButtonItem.customView gestureRecognizers]) {
            [self.navigationItem.leftBarButtonItem.customView removeGestureRecognizer:gestureRecognizer];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self animateVisibleCells];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //[[XHSocketThread shareInstance] disconnect];
}

- (void)dealloc
{
    //XHLocate();
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - initialization

- (void)setupTabelView
{
    // create Plain style UITableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (void)setupData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    _roomModels = [[NSMutableArray alloc] init];
    _modelCells = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_roomModels addObject:[XHRoomModel roomModelWithDictionary:obj]];
        XHRoomTableViewCell *cell = [[XHRoomTableViewCell alloc] init];
        [_modelCells addObject:cell];
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.roomModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UITableViewCellIdenfifierKey";
    XHRoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[XHRoomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:0.8];
    
    XHRoomModel *model = self.roomModels[indexPath.row];
    cell.roomModel = model;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHRoomTableViewCell *cell = self.modelCells[indexPath.row];
    cell.roomModel = self.roomModels[indexPath.row];
    return cell.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"XHGaugeMode"]) {
        XHRoomModel *model = self.roomModels[indexPath.row];
        
        // here use GCD to present ViewController, if not ,it will delay...
        dispatch_async(dispatch_get_main_queue(), ^ {
            XHGaugeViewController *gVC = [[XHGaugeViewController alloc] init];
            gVC.roomId = model.Id;
            [self presentViewController:gVC animated:YES completion:nil]; // modal
        });
    } else {
        [self alertWithTitle:@"Failed" message:@"gauge mode is disable, if you want to use the mode you need to enable it via \"Settings\"->\"General\"->\"Display\" on this app."];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.displayCellCount < self.roomModels.count) {
        CATransform3D rotation;
        rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, .9, 0.4);
        rotation.m34 = 1.0/ -600;
        
        cell.layer.shadowColor = [[UIColor blackColor]CGColor];
        cell.layer.shadowOffset = CGSizeMake(10, 10);
        cell.alpha = 0;
        cell.layer.transform = rotation;
        cell.layer.anchorPoint = CGPointMake(0, 0.5);
        
        
        [UIView beginAnimations:@"XHRotation" context:NULL];
        [UIView setAnimationDuration:0.8];
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        cell.layer.shadowOffset = CGSizeMake(0, 0);
        [UIView commitAnimations];
        self.displayCellCount++;
    }
}

#pragma mark - XHSocketThreadDelegate

- (void)didReadBuffer:(NSString *)buffer
{
    int i = 1;
    for (XHRoomModel *model in [self.roomTools roomModelWithString:buffer]) {
        if (model) {
            XHRoomModel *roomModel = self.roomModels[model.Id]; // cell room model
            if (roomModel) {
                roomModel.temperature = model.temperature;
                roomModel.humidity = model.humidity;
                
//                NSIndexPath *path = [NSIndexPath indexPathForRow:model.Id inSection:0];
//                [self.tableView reloadRowsAtIndexPaths:@[ path ] withRowAnimation:UITableViewRowAnimationNone];
                
                [UIView animateWithDuration:.5f
                                      delay:i * .1f
                                    options:UIViewAnimationOptionTransitionCurlUp
                                 animations:^{
                                     // update one row at once
                                     NSIndexPath *path = [NSIndexPath indexPathForRow:model.Id inSection:0];
                                     [self.tableView reloadRowsAtIndexPaths:@[ path ] withRowAnimation:UITableViewRowAnimationRight];
                                 }
                                 completion:nil];
                // save
                if (![self isExists:model.Id]) {
                    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        if ([XHRoomTools saveIfIsFirstDataOfToday:model]) {
                            //XHLog(@"first data today");
                        }
                    });
                }
            }
        }
        i++;
    }
}

#pragma mark - event

//- (void)updateRoomModel:(NSNotification *)notification
//{
//    if ([notification.name isEqualToString:XHUpdateRoomModelNotification]) {
//        NSString *buffer = [notification.userInfo objectForKey:@"BUFFER"];
//        NSLog(@"buffer: %@", buffer);
//        XHRoomModel *model = [XHRoomTools roomModelWithString:buffer];
//        
//        // update row
//        XHRoomModel *roomModel = self.roomModels[model.Id];
//        if (roomModel) {
//            roomModel.temperature = model.temperature;
//            roomModel.humidity = model.humidity;
//            NSIndexPath *path = [NSIndexPath indexPathForRow:model.Id inSection:0];
//            [self.tableView reloadRowsAtIndexPaths:@[ path ] withRowAnimation:UITableViewRowAnimationRight];
//            XHLog(@"update row: %ld", model.Id);
//        }
//    }
//}

- (void)statusButtonItemClicked
{
    XHStatusViewController *statusVC = [[XHStatusViewController alloc] init];
    [self.navigationController pushViewController:statusVC animated:YES];
}

- (void)barButtonItemLongPress:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        XHCmdLineViewController *cmdLineVC = [[XHCmdLineViewController alloc] init];
        [self presentViewController:cmdLineVC animated:YES completion:nil];
    }
}

- (void)chartButtonItemClicked
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"XHChartMode"]) {
        XHRoomModel *model = self.roomModels[0];
        XHChartViewController *chartVC = [[XHChartViewController alloc] init];
        chartVC.roomId = model.Id;
        chartVC.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:chartVC animated:YES];
    } else {
        [self alertWithTitle:@"Failed" message:@"chart mode is disable, if you want to use the mode you need to enable it via \"Settings\"->\"General\"->\"Display\" on this app."];
    }
}

#pragma mark - private methods

// deselect alter 0.5s
- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)prepareVisibleCellsForAnimation {
    for (int i = 0; i < [self.tableView.visibleCells count]; i++) {
        XHRoomTableViewCell *cell = (XHRoomTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.frame = CGRectMake(-CGRectGetWidth(cell.bounds), cell.frame.origin.y, CGRectGetWidth(cell.bounds), CGRectGetHeight(cell.bounds));
        cell.alpha = 0.f;
    }
}

- (void)animateVisibleCells {
    for (int i = 0; i < [self.tableView.visibleCells count]; i++) {
        XHRoomTableViewCell *cell = (XHRoomTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.alpha = 1.f;
        
        [UIView animateWithDuration:.25f
                              delay:i * .1f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             cell.frame = CGRectMake(0.f, cell.frame.origin.y, CGRectGetWidth(cell.bounds), CGRectGetHeight(cell.bounds));
                         }
                         completion:nil];
    }
}

- (BOOL)isExists:(NSUInteger)roomId
{
    NSUInteger temp = (NSUInteger)pow(2, roomId);
    if ((temp & self.existRoom) == temp) {
        return YES;
    } else {
        self.existRoom += temp;
        return NO;
    }
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
