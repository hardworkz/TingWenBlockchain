//
//  ZViewModel.m
//  BaseProject
//
//  Created by 泡果 on 2018/5/28.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZViewModel.h"

@implementation ZViewModel

@synthesize request  = _request;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    ZViewModel *viewModel = [super allocWithZone:zone];
    
    if (viewModel) {
        
        [viewModel z_initialize];
    }
    return viewModel;
}

- (instancetype)initWithModel:(id)model {
    
    self = [super init];
    if (self) {
    }
    return self;
}

- (CMRequest *)request {
    
    if (!_request) {
        
        _request = [CMRequest request];
    }
    return _request;
}

- (void)z_initialize {}


@end
