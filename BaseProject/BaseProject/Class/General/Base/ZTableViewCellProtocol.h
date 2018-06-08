//
//  ZTableViewCellProtocol.h
//  BaseProject
//
//  Created by 泡果 on 2018/5/28.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZTableViewCellProtocol <NSObject>
@optional

- (void)z_setupViews;
- (void)z_bindViewModel;
@end
