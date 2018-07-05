//
//  ZNewsProgramTableViewCellViewModel.h
//  BaseProject
//
//  Created by 泡果 on 2018/7/5.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZViewModel.h"

@interface ZNewsProgramTableViewCellViewModel : ZViewModel

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSArray *column;

@property (assign, nonatomic) CGFloat cellHeight;

@end
