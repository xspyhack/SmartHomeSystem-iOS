//
//  XHEncryptTypeViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/4/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHEncryptTypeViewController.h"
#import "XHTableViewCellGroup.h"
#import "XHTableViewCellCheckmarkItem.h"

typedef enum _EMEncryptType {
    EMNONE = 0,
    EMMD5 = 1,
    EMAES = 2,
} EMEncryptType;

@implementation XHEncryptTypeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTypeGroup];
}

- (void)setupTypeGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger index = [defaults integerForKey:@"XHEncryptType"];
    
    XHTableViewCellCheckmarkItem *noneItem = [XHTableViewCellCheckmarkItem itemWithTitle:@"None"];
    noneItem.clicked = ^{ [self setCheckmark:EMNONE]; };
    
    XHTableViewCellCheckmarkItem *md5Itme = [XHTableViewCellCheckmarkItem itemWithTitle:@"MD5"];
    md5Itme.clicked = ^{ [self setCheckmark:EMMD5]; };
    XHTableViewCellCheckmarkItem *aesItem = [XHTableViewCellCheckmarkItem itemWithTitle:@"AES"];
    aesItem.clicked = ^{ [self setCheckmark:EMAES]; };
    
    if (index == EMNONE) {
        noneItem.type = UITableViewCellAccessoryCheckmark;
    } else if (index == EMMD5) {
        md5Itme.type = UITableViewCellAccessoryCheckmark;
    } else {
        aesItem.type = UITableViewCellAccessoryCheckmark;
    }
    
    group.items = @[ noneItem, md5Itme, aesItem ];
}

- (void)setCheckmark:(NSInteger)index
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    switch (index) {
        case EMNONE:
            [defaults setInteger:EMNONE forKey:@"XHEncryptType"];
            break;
        case EMMD5:
            [defaults setInteger:EMMD5 forKey:@"XHEncryptType"];
            break;
        case EMAES:
            [defaults setInteger:EMAES forKey:@"XHEncryptType"];
            break;
        default:
            break;
    }
}

@end
