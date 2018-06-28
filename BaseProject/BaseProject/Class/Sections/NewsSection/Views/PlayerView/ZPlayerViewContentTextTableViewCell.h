//
//  ZPlayerViewContentTextTableViewCell.h
//  BaseProject
//
//  Created by 泡果 on 2018/6/27.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZTableViewCell.h"
#import "ZPlayerViewContentTextTableViewCellViewModel.h"

@interface ZPlayerViewContentTextTableViewCell : ZTableViewCell

@property (nonatomic, strong) ZPlayerViewContentTextTableViewCellViewModel *viewModel;
/**
 根绝重复计算cell的高度
 @return cell的高度
 */
- (CGFloat)cellHeightForViewModel:(ZPlayerViewContentTextTableViewCellViewModel *)viewModel;
@end
