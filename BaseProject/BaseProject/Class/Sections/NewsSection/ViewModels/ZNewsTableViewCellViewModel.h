//
//  ZNewsTableViewCellViewModel.h
//  BaseProject
//
//  Created by 泡果 on 2018/6/21.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZViewModel.h"
/*
 "id": "91891",
 "post_title": "【8分钟区块链】fcoin赢在哪里",
 "post_mp": "http:\/\/tingwen-1254240285.file.myqcloud.com\/mp3\/5b31e23409cab.mp3",
 "post_modified": "2018-06-26 14:49:49",
 "post_size": "3266183",
 "smeta": "http:\/\/tingwen-1254240285.file.myqcloud.com\/Uploads\/2018-06-26\/crop_5b31e2257776f.jpg",
 "post_time": "272000"
 */
@interface ZNewsTableViewCellViewModel : ZViewModel

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *post_title;
@property (nonatomic, strong) NSString *post_mp;
@property (nonatomic, strong) NSString *post_modified;
@property (nonatomic, strong) NSString *post_size;
@property (nonatomic, strong) NSString *smeta;
@property (nonatomic, strong) NSString *post_time;

@end
