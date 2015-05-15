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
#import "XHSocketThread.h"
#import "XHRoomTools.h"

@interface XHHomeViewController ()<XHSocketThreadDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSMutableArray *modelCells;
@property (nonatomic, copy) NSMutableArray *roomModels;

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
    
    // set navigationbar button
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_chart" highLightedImageName:@"nav_chart_highLighted" target:self action:@selector(chartButtonItemClicked)];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_gauge" highLightedImageName:@"nav_gauge_hightLighted" target:self action:@selector(gaugeButtonItemClicked)];
    UILongPressGestureRecognizer *longPressGuesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    longPressGuesture.minimumPressDuration = 1.5f;
    [self.navigationItem.leftBarButtonItem.customView addGestureRecognizer:longPressGuesture];
    
    [self setupData];
    [self setupTabelView];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRoomModel:) name:XHUpdateRoomModelNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [XHSocketThread shareInstance].delegate = self;
//    [[XHSocketThread shareInstance] disconnect];
//    [[XHSocketThread shareInstance] connect];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //[[XHSocketThread shareInstance] disconnect];
}

- (void)dealloc
{
    XHLocate();
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
    XHRoomModel *model = self.roomModels[indexPath.row];
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        XHGaugeViewController *gVC = [[XHGaugeViewController alloc] init];
        gVC.roomId = model.Id;
        [self presentViewController:gVC animated:YES completion:nil]; // modal
    });
    
//    XHGaugeViewController *gVC = [[XHGaugeViewController alloc] init];
//    gVC.roomId = model.Id;
//    [self.navigationController pushViewController:gVC animated:YES];
}

- (void)didReadBuffer:(NSString *)buffer
{
    XHRoomModel *model = [XHRoomTools roomModelWithString:buffer];
    
    // update row
    XHRoomModel *roomModel = self.roomModels[model.Id];
    if (roomModel) {
        roomModel.temperature = model.temperature;
        roomModel.humidity = model.humidity;
        NSIndexPath *path = [NSIndexPath indexPathForRow:model.Id inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[ path ] withRowAnimation:UITableViewRowAnimationRight];
        XHLog(@"update row: %ld", model.Id);
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

- (void)gaugeButtonItemClicked
{
    //XHGaugeViewController *gVC = [[XHGaugeViewController alloc] init];
    //[self.navigationController pushViewController:gVC animated:YES];
    //[self presentViewController:gVC animated:YES completion:nil]; // modal
    
    XHCmdLineViewController *cmdLineVC = [[XHCmdLineViewController alloc] init];
    [self presentViewController:cmdLineVC animated:YES completion:nil];
}

- (void)longPress
{
    //    XHCmdLineViewController *cmdLineVC = [[XHCmdLineViewController alloc] init];
    //    [self presentViewController:cmdLineVC animated:YES completion:nil];
}

- (void)chartButtonItemClicked
{
    XHRoomModel *model = self.roomModels[0];
    XHChartViewController *chartVC = [[XHChartViewController alloc] init];
    chartVC.roomId = model.Id;
    chartVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:chartVC animated:YES];
}

#pragma mark - private methods

// deselect alter 0.5s
- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
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
