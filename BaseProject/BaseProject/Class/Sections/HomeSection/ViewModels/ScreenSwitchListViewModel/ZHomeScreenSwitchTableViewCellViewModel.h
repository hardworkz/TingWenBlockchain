//
//  ZHomeScreenSwitchTableViewCellViewModel.h
//  BaseProject
//
//  Created by 泡果 on 2018/5/30.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZViewModel.h"

/*
 "id": 431,
 "title": "公告 | Coincheck停止日元 美元的跨境存汇款服务",
 "content": "日本交易所Coincheck称将停止日元、美元的跨境存汇款服务。",
 "date": "2018-06-29 15:30:13",
 "bull": 0,
 "bear": 0,
 "f_id": 37199,
 "link": ""
 */
@interface ZHomeScreenSwitchTableViewCellViewModel : ZViewModel

@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *bull;
@property (strong, nonatomic) NSString *bear;
@property (strong, nonatomic) NSString *f_id;
@property (strong, nonatomic) NSString *link;

@end
