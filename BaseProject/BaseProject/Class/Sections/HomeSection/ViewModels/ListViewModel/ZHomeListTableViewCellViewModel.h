//
//  ZHomeListTableViewCellViewModel.h
//  BaseProject
//
//  Created by 泡果 on 2018/5/31.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZViewModel.h"

/*
 {
 bear = 0;
 bull = 0;
 content = "";
 date = "2018-07-09 17:18:55";
 "f_id" = 39077;
 id = 2282;
 link = "";
 title = "";
 }
 */
@interface ZHomeListTableViewCellViewModel : ZViewModel

@property (strong, nonatomic) NSString *Id;

@property (strong, nonatomic) NSString *bear;

@property (strong, nonatomic) NSString *bull;

@property (strong, nonatomic) NSString *content;

@property (strong, nonatomic) NSString *date;

@property (strong, nonatomic) NSString *f_id;

@property (strong, nonatomic) NSString *link;

@property (strong, nonatomic) NSString *title;

@end
