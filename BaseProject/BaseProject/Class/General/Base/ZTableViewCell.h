//
//  ZTableViewCell.h
//  BaseProject
//
//  Created by 泡果 on 2018/5/28.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTableViewCellProtocol.h"
#import "ZViewModel.h"

@interface ZTableViewCell : UITableViewCell <ZTableViewCellProtocol>

/**
 根绝数据计算cell的高度
 */
- (CGFloat)cellHeightForViewModel:(ZViewModel *)viewModel;
@end
