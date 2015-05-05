//
//  XHRoomTableViewCell.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/16/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHRoomTableViewCell.h"
#import "XHRoomModel.h"
#import "XHRoomView.h"

#define XHTableViewCellControlSpaceing 2

@implementation XHRoomTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark - setup view

- (void)setupSubView
{
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, 0);
    _roomView = [[XHRoomView alloc] initWithFrame:rect];
    _roomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_roomView];
}

// over write
- (void)setFrame:(CGRect)frame
{
    frame.size.width = [[UIScreen mainScreen] applicationFrame].size.width;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setRoomModel:(XHRoomModel *)roomModel
{
    _roomView.roomModel = roomModel;
    _roomView.updateTime = [NSDate date];
    
    _height = CGRectGetMaxY(_roomView.frame) + XHTableViewCellControlSpaceing;
}

@end
