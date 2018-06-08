//
//  ZMyTableViewCell.h
//  BaseProject
//
//  Created by 泡果 on 2018/6/5.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZTableViewCell.h"
#import "ZMyTableViewCellViewModel.h"

@interface ZMyTableViewCell : ZTableViewCell

@property (nonatomic, strong) ZMyTableViewCellViewModel *viewModel;

@end
