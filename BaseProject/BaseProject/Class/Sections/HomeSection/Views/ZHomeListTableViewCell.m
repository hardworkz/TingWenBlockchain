//
//  ZHomeListTableViewCell.m
//  BaseProject
//
//  Created by 泡果 on 2018/5/31.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZHomeListTableViewCell.h"

@interface ZHomeListTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end
@implementation ZHomeListTableViewCell
- (void)z_setupViews {
    
    [self.contentView addSubview:self.titleLabel];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
- (void)updateConstraints {
    
    WS(weakSelf)
    
    CGFloat paddingEdge = 0;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(paddingEdge);
        make.centerY.equalTo(weakSelf.contentView);
        make.size.equalTo(CGSizeMake(80, 50));
    }];
    
    [super updateConstraints];
    
}
- (void)setViewModel:(ZHomeListTableViewCellViewModel *)viewModel {
    
    if (!viewModel) {
        return;
    }
    
    _viewModel = viewModel;
    
    self.titleLabel.text = viewModel.title;
    
    self.contentView.backgroundColor = randomColor;
}

#pragma mark - lazyLoad
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = MAIN_BLACK_TEXT_COLOR;
        _titleLabel.font = SYSTEMFONT(14);
    }
    
    return _titleLabel;
}

@end
