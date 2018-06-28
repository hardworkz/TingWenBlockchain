//
//  ZPlayerViewContentTextTableViewCellViewModel.h
//  BaseProject
//
//  Created by 泡果 on 2018/6/27.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZViewModel.h"

/*
 "id": "91928",
 "post_title": "区块链能实现资产数字化？至少要十年",
 "post_mp": "http:\/\/tingwen-1254240285.file.myqcloud.com\/mp3\/5b32ff9bae421.mp3",
 "post_modified": "2018-06-27 11:06:49",
 "post_size": "1366833",
 "smeta": "http:\/\/tingwen-1254240285.file.myqcloud.com\/Uploads\/2018-06-27\/crop_5b32ff85442ed.jpg",
 "post_time": "85000",
 "post_excerpt": "",
 "post_lai": "锌财经"
 */
@interface ZPlayerViewContentTextTableViewCellViewModel : ZViewModel

@property (nonatomic, copy) NSString *post_title;
@property (nonatomic, copy) NSString *post_mp;
@property (nonatomic, copy) NSString *post_modified;
@property (nonatomic, copy) NSString *post_size;
@property (nonatomic, copy) NSString *smeta;
@property (nonatomic, copy) NSString *post_time;
@property (nonatomic, copy) NSString *post_excerpt;
@property (nonatomic, copy) NSString *post_lai;

@property (assign, nonatomic) CGFloat cellHeight;

@end
