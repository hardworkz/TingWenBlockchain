//
//  ZNewsProgramTableViewCell.h
//  BaseProject
//
//  Created by 泡果 on 2018/7/5.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZTableViewCell.h"
#import "ZNewsProgramTableViewCellViewModel.h"

@interface ZNewsProgramTableViewCell : ZTableViewCell

@property (nonatomic, strong) ZNewsProgramTableViewCellViewModel *viewModel;

- (CGFloat)cellHeightForViewModel:(ZNewsProgramTableViewCellViewModel *)viewModel ;
@end
