//
//  ZHomeScreenSwitchTableViewCell.h
//  BaseProject
//
//  Created by 泡果 on 2018/5/30.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZTableViewCell.h"
#import "ZHomeScreenSwitchTableViewCellViewModel.h"

@interface ZHomeScreenSwitchTableViewCell : ZTableViewCell

@property (nonatomic, strong) UIButton *good;

@property (nonatomic, strong) UIButton *bad;

@property (nonatomic, strong) UIButton *comment;

@property (nonatomic, strong) UIButton *share;

@property (strong, nonatomic) ZHomeScreenSwitchTableViewCellViewModel *viewModel;

@end
