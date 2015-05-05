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

@interface XHHomeViewController ()

@end

@implementation XHHomeViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // set navigationbar button
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_chart"] style:UIBarButtonItemStyleDone target:self action:@selector(chart)];
    // use category
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_chart" highLightedImageName:@"nav_chart_highLighted" target:self action:@selector(chart)];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_gauge" highLightedImageName:@"nav_gauge_hightLighted" target:self action:@selector(gauge)];
    UILongPressGestureRecognizer *longPressGuesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    longPressGuesture.minimumPressDuration = 1.5f;
    [self.navigationItem.leftBarButtonItem.customView addGestureRecognizer:longPressGuesture];
    
    [self setupData];
    [self setupTabelView];
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
    _model = [[NSMutableArray alloc] init];
    _modelCells = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_model addObject:[XHRoomModel roomModelWithDict:obj]];
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
    return self.model.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UITableViewCellIdenfifierKey";
    XHRoomTableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[XHRoomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:0.8];
    
    XHRoomModel *model = self.model[indexPath.row];
    cell.roomModel = model;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHRoomTableViewCell *cell = self.modelCells[indexPath.row];
    cell.roomModel = self.model[indexPath.row];
    return cell.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHRoomModel *model = self.model[indexPath.row];
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        XHGaugeViewController *gVC = [[XHGaugeViewController alloc] init];
        gVC.roomId = model.Id;
        [self presentViewController:gVC animated:YES completion:nil]; // modal
    });
    
//    XHGaugeViewController *gVC = [[XHGaugeViewController alloc] init];
//    gVC.roomId = model.Id;
//    [self.navigationController pushViewController:gVC animated:YES];
}

#pragma mark - event

- (void)gauge
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

- (void)chart
{
    XHRoomModel *model = _model[0];
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
