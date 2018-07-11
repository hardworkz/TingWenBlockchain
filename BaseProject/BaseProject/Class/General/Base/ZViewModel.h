//
//  ZViewModel.h
//  BaseProject
//
//  Created by 泡果 on 2018/5/28.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZViewModelProtocol.h"

@interface ZViewModel : NSObject <ZViewModelProtocol>

@property (assign, nonatomic) CGFloat cellHeight;

@end
