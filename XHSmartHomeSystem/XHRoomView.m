//
//  XHRoomView.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/13/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHRoomView.h"
#import "XHRoomModel.h"
#import "XHColorTools.h"

#define xhTableViewCellControlSpaceing 15 // widget space
#define xhTableViewCellBackgroundColor XHColor(240, 240, 240)
#define xhTableViewCellHeight 100 // cell height
#define xhGrayColor XHColor(50, 50, 50, 1)
#define xhLightGrayColor XHColor(120, 120, 120, 1)
#define xhTableViewCellIconWidth 60 // icon width
#define xhTableViewCellIconHeight xhTableViewCellIconWidth //icon height
#define xhTableViewCellLabelWidth 100
#define xhTableViewCellLabelHeight 20
#define xhTableViewCellRoomNameFontSize 15
#define xhTableViewCellUpdateTimeFontSize 12
#define xhTableViewCellValueFontSize 15
#define xhTableViewCellValueWidth 120
#define xhTableViewCellValueHeight 20

@implementation XHRoomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //self.layer.borderWidth = 0.2;
        //self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowRadius = 1;
        [self setupSubView];
    }
    return self;
}

#pragma mark - setup sub view

- (void)setupSubView
{
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat iconViewX = xhTableViewCellControlSpaceing, iconViewY = xhTableViewCellControlSpaceing;
    CGRect iconViewRect = CGRectMake(iconViewX, iconViewY, xhTableViewCellIconWidth, xhTableViewCellIconHeight);
    self.iconView = [[UIImageView alloc] initWithFrame:iconViewRect];
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = xhTableViewCellIconWidth / 2;
    self.iconView.layer.shadowOffset = CGSizeMake(2.0, 2.0);
    self.iconView.layer.shadowOpacity = 0.5;
    [self addSubview:self.iconView];
    
    CGFloat roomNameLabelX = CGRectGetMaxX(iconViewRect) + xhTableViewCellControlSpaceing;
    CGFloat roomNameLabelY = iconViewY;
    CGRect roomNameLabelRect = CGRectMake(roomNameLabelX, roomNameLabelY, xhTableViewCellLabelWidth, xhTableViewCellLabelHeight);
    self.roomNameLabel = [[UILabel alloc] initWithFrame:roomNameLabelRect];
    self.roomNameLabel.font = [UIFont systemFontOfSize:xhTableViewCellRoomNameFontSize];
    self.roomNameLabel.textColor = [XHColorTools themeColor];
    [self addSubview:self.roomNameLabel];
    
    CGFloat updateTimeLabelX = roomNameLabelX;
    CGFloat updateTimeLabelY = CGRectGetMaxY(iconViewRect) - xhTableViewCellLabelHeight;
    CGRect updateTimeRect = CGRectMake(updateTimeLabelX, updateTimeLabelY, xhTableViewCellLabelWidth, xhTableViewCellLabelHeight);
    self.updateTimeLabel = [[UILabel alloc] initWithFrame:updateTimeRect];
    self.updateTimeLabel.textColor = XHOrangeColor;
    self.updateTimeLabel.font = [UIFont systemFontOfSize:xhTableViewCellUpdateTimeFontSize];
    [self addSubview:self.updateTimeLabel];
    
    CGFloat temperatureLabelX = self.frame.size.width - xhTableViewCellValueWidth - xhTableViewCellControlSpaceing;
    CGFloat temperatureLabelY = roomNameLabelY;
    CGRect temperatureLabelRect = CGRectMake(temperatureLabelX, temperatureLabelY, xhTableViewCellValueWidth, xhTableViewCellValueHeight);
    self.temperatureLabel = [[UILabel alloc] initWithFrame:temperatureLabelRect];
    self.temperatureLabel.textColor = [XHColorTools temperatureColor];
    self.temperatureLabel.textAlignment = NSTextAlignmentRight;
    self.temperatureLabel.font = [UIFont systemFontOfSize:xhTableViewCellValueFontSize];
    [self addSubview:self.temperatureLabel];
    
    CGFloat humidityLabelX = temperatureLabelX;
    CGFloat humidityLabelY = updateTimeLabelY;
    CGRect humidityLabelRect = CGRectMake(humidityLabelX, humidityLabelY, xhTableViewCellValueWidth, xhTableViewCellValueHeight);
    self.humidityLabel = [[UILabel alloc] initWithFrame:humidityLabelRect];
    self.humidityLabel.textColor = [XHColorTools humidityColor];
    self.humidityLabel.textAlignment = NSTextAlignmentRight;
    self.humidityLabel.font = [UIFont systemFontOfSize:xhTableViewCellValueFontSize];
    [self addSubview:self.humidityLabel];
    
    CGRect rect = CGRectMake(0, xhTableViewCellControlSpaceing - 3, self.frame.size.width, CGRectGetMaxY(self.iconView.frame) + xhTableViewCellControlSpaceing);
    self.frame = rect;
}

- (void)setRoomModel:(XHRoomModel *)roomModel
{
    _roomModel = roomModel;
    _iconView.image = [UIImage imageNamed:roomModel.iconName];
    _roomNameLabel.text = roomModel.name;
    _temperatureLabel.text = roomModel.temperature;
    _humidityLabel.text = roomModel.humidity;
}

- (void)setUpdateTime:(NSDate *)updateTime
{
    _updateTime = updateTime;
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setTimeStyle:NSDateFormatterShortStyle];
    _updateTimeLabel.text = [NSString stringWithFormat:@"update at %@", [formater stringFromDate:updateTime]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
