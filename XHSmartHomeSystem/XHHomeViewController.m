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

@interface XHHomeViewController ()

@end

@implementation XHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // set navigationbar button
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_chart"] style:UIBarButtonItemStyleDone target:self action:@selector(chart)];
    // use category
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_chart" highLightedImageName:@"nav_chart_highLighted" target:self action:@selector(chart)];
    
    [self setupData];
    [self setupTabelView];
}

#pragma mark - Event

- (void)chart
{
    XHRoomModel *model = _model[0];
    XHLog(@"chart");
    XHChartViewController *chartVC = [[XHChartViewController alloc] init];
    chartVC.roomId = model.Id;
    [self.navigationController pushViewController:chartVC animated:YES];
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

#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _model.count;
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
    
    XHRoomModel *model = _model[indexPath.row];
    cell.roomModel = model;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHRoomTableViewCell *cell = _modelCells[indexPath.row];
    cell.roomModel = _model[indexPath.row];
    return cell.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHRoomModel *model = _model[indexPath.row];
    XHChartViewController *chartVC = [[XHChartViewController alloc] init];
    chartVC.roomId = model.Id;
    [self.navigationController pushViewController:chartVC animated:YES];
}

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
