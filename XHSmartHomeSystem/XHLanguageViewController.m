//
//  XHLanguageViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/23/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHLanguageViewController.h"
#import "XHTableViewCellGroup.h"
#import "XHTableViewCellItem.h"
#import "XHTableViewCellCheckmarkItem.h"

typedef enum _EMLanguage{
    EMEnglish = 0,
    EMChinese = 1,
    EMSystem = 2,
} EMLanguage;

@implementation XHLanguageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGroup];
}

- (void)setupGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger index = [defaults integerForKey:@"Language"];
    
    XHTableViewCellCheckmarkItem *englishCheckmark = [XHTableViewCellCheckmarkItem itemWithTitle:@"English"];
    englishCheckmark.clicked = ^{ [self setCheckmark:EMEnglish]; };
    
    XHTableViewCellCheckmarkItem *chineseCheckmark = [XHTableViewCellCheckmarkItem itemWithTitle:@"简体中文"];
    chineseCheckmark.clicked = ^{ [self setCheckmark:EMChinese]; };
    
    XHTableViewCellCheckmarkItem *systemCheckmark = [XHTableViewCellCheckmarkItem itemWithTitle:@"System default"];
    systemCheckmark.clicked = ^{ [self setCheckmark:EMSystem]; };
    
    if (index == EMEnglish) {
        englishCheckmark.type = UITableViewCellAccessoryCheckmark;
    } else if (index == EMChinese) {
        chineseCheckmark.type = UITableViewCellAccessoryCheckmark;
    } else {
        systemCheckmark.type = UITableViewCellAccessoryCheckmark;
    }
    
    group.items = @[englishCheckmark, chineseCheckmark, systemCheckmark];
}

- (void)setCheckmark:(NSInteger)index
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    switch (index) {
        case EMEnglish:
            [defaults setInteger:EMEnglish forKey:@"Language"];
            break;
        case EMChinese:
            [defaults setInteger:EMChinese forKey:@"Language"];
            break;
        case EMSystem:
            [defaults setInteger:EMSystem forKey:@"Language"];
            break;
        default:
            break;
    }
}

@end
