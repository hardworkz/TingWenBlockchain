//
//  ZHomeCommentListTableViewCell.m
//  BaseProject
//
//  Created by 泡果 on 2018/6/11.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZHomeCommentListTableViewCell.h"

@interface ZHomeCommentListTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end
@implementation ZHomeCommentListTableViewCell
- (void)z_setupViews {
    
    [self.contentView addSubview:self.titleLabel];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
- (void)updateConstraints {
    
    WS(weakSelf)
    
    CGFloat paddingEdge = 10;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(paddingEdge);
        make.centerY.equalTo(weakSelf.contentView);
        make.size.equalTo(CGSizeMake(80, 80));
    }];
    
    [super updateConstraints];
    
}
- (void)setViewModel:(ZHomeCommentListTableViewCellViewModel *)viewModel {
    
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
