//
//  XHMessageModel.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/14/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHMessageModel.h"
#import "UUMessage.h"
#import "UUMessageFrame.h"
#import "XHMessageTools.h"

@implementation XHMessageModel

- (void)populateRandomDataSource {
    self.dataSource = [NSMutableArray array];
    [self.dataSource addObjectsFromArray:[self getMessages]];
}

// 添加聊天item（一个cell内容）
- (NSArray *)additems:(NSInteger)number
{
    NSMutableArray *result = [NSMutableArray array];
    
    for (int i=0; i<number; i++) {
        
        NSDictionary *dataDic = [self getDic];
        UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
        UUMessage *message = [[UUMessage alloc] init];
        [message setWithDict:dataDic];
        [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
        messageFrame.showTime = message.showDateLabel;
        [messageFrame setMessage:message];
        
        if (message.showDateLabel) {
            previousTime = dataDic[@"strTime"];
        }
        [result addObject:messageFrame];
    }
    return result;
}

static NSString *previousTime = nil;
- (NSArray *)getMessages
{
    NSMutableArray *messages = [NSMutableArray array];
    NSArray *arrays = [XHMessageTools latestMessageWithNumber:10];
    for (NSMutableDictionary *dict in arrays) {
        [dict setObject:@(UUMessageFromOther) forKey:@"from"];
        
        UUMessageFrame *messageFrame = [[UUMessageFrame alloc] init];
        UUMessage *message = [[UUMessage alloc] init];
        [message setWithDict:dict];
        [message minuteOffSetStart:previousTime end:dict[@"strTime"]];
        messageFrame.showTime = message.showDateLabel;
        [messageFrame setMessage:message];
        if (message.showDateLabel) {
            previousTime = dict[@"strTime"];
        }
        
        [messages addObject:messageFrame];
    }
    return messages;
}

//// 添加自己的item
//- (void)addSpecifiedItem:(NSDictionary *)dic
//{
//    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
//    UUMessage *message = [[UUMessage alloc] init];
//    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
//    
//    NSString *URLStr = @"http://img0.bdstatic.com/img/image/shouye/xinshouye/mingxing16.jpg";
//    [dataDic setObject:@(UUMessageFromMe) forKey:@"from"];
//    [dataDic setObject:[[NSDate date] description] forKey:@"strTime"];
//    [dataDic setObject:@"Hello,Sister" forKey:@"strName"];
//    [dataDic setObject:URLStr forKey:@"strIcon"];
//    
//    [message setWithDict:dataDic];
//    [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
//    messageFrame.showTime = message.showDateLabel;
//    [messageFrame setMessage:message];
//    
//    if (message.showDateLabel) {
//        previousTime = dataDic[@"strTime"];
//    }
//    [self.dataSource addObject:messageFrame];
//}


// 如下:群聊（groupChat）
static int dateNum = 10;
- (NSDictionary *)getDic
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    int randomNum = arc4random()%5;
    if (randomNum == UUMessageTypePicture) {
        [dictionary setObject:[UIImage imageNamed:@"headImage"] forKey:@"picture"];
    }else{
        // 文字出现概率4倍于图片
        randomNum = UUMessageTypeText;
        [dictionary setObject:[self getRandomString] forKey:@"strContent"];
    }
    NSDate *date = [[NSDate date]dateByAddingTimeInterval:arc4random()%1000*(dateNum++) ];
    //NSDate *date = [NSDate date];
    [dictionary setObject:@(UUMessageFromOther) forKey:@"from"];
    [dictionary setObject:@(randomNum) forKey:@"type"];
    [dictionary setObject:[date description] forKey:@"strTime"];
    
    int index =  arc4random()%6;
    [dictionary setObject:[self getName:index] forKey:@"strName"];
    [dictionary setObject:@"headImage" forKey:@"strIcon"];
    
    return dictionary;
}

- (NSString *)getRandomString {
    
    NSString *lorumIpsum = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent non quam ac massa viverra semper. Maecenas mattis justo ac augue volutpat congue. Maecenas laoreet, nulla eu faucibus gravida, felis orci dictum risus, sed sodales sem eros eget risus. Morbi imperdiet sed diam et sodales.";
    
    NSArray *lorumIpsumArray = [lorumIpsum componentsSeparatedByString:@" "];
    
    int r = arc4random() % [lorumIpsumArray count];
    r = MAX(6, r); // no less than 6 words
    NSArray *lorumIpsumRandom = [lorumIpsumArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, r)]];
    
    return [NSString stringWithFormat:@"%@!!", [lorumIpsumRandom componentsJoinedByString:@" "]];
}

- (NSString *)getImageStr:(NSInteger)index{
    NSArray *array = @[@"http://www.120ask.com/static/upload/clinic/article/org/201311/201311061651418413.jpg",
                       @"http://p1.qqyou.com/touxiang/uploadpic/2011-3/20113212244659712.jpg",
                       @"http://www.qqzhi.com/uploadpic/2014-09-14/004638238.jpg",
                       @"http://e.hiphotos.baidu.com/image/pic/item/5ab5c9ea15ce36d3b104443639f33a87e950b1b0.jpg",
                       @"http://ts1.mm.bing.net/th?&id=JN.C21iqVw9uSuD2ZyxElpacA&w=300&h=300&c=0&pid=1.9&rs=0&p=0",
                       @"http://ts1.mm.bing.net/th?&id=JN.7g7SEYKd2MTNono6zVirpA&w=300&h=300&c=0&pid=1.9&rs=0&p=0"];
    return array[index];
}

- (NSString *)getName:(NSInteger)index{
    NSArray *array = @[@"Hi,Daniel",@"Hi,Juey",@"Hey,Jobs",@"Hey,Bob",@"Hah,Dane",@"Wow,Boss"];
    return array[index];
}

@end
