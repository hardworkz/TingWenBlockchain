//
//  ZHomeListTableViewCell.h
//  BaseProject
//
//  Created by 泡果 on 2018/5/31.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZTableViewCell.h"
#import "ZHomeListTableViewCellViewModel.h"

@interface ZHomeListTableViewCell : ZTableViewCell

@property (strong, nonatomic) ZHomeListTableViewCellViewModel *viewModel;
/**
 根绝重复计算cell的高度
 @return cell的高度
 */
//- (CGFloat)cellHeightForViewModel:(ZHomeListTableViewCellViewModel *)viewModel;
@end
