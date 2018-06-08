//
//  ZMyTableViewCell.m
//  BaseProject
//
//  Created by 泡果 on 2018/6/5.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZMyTableViewCell.h"

@interface ZMyTableViewCell ()

@property (nonatomic, strong) UIImageView *icon;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *devider;

@end
@implementation ZMyTableViewCell
- (void)z_setupViews {
    
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.devider];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
- (void)updateConstraints {
    
    WS(weakSelf)
    
    CGFloat paddingEdge = 10;
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(paddingEdge + 5);
        make.bottom.equalTo(weakSelf.contentView).offset(-paddingEdge - 5);
        make.left.equalTo(weakSelf.contentView).offset(paddingEdge);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(30 + 10);
        make.centerY.equalTo(weakSelf.contentView);
        make.size.equalTo(CGSizeMake(80, 50));
    }];
    [self.devider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView).offset(paddingEdge);
        make.size.equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
    }];
    
    [super updateConstraints];
    
}
- (void)setViewModel:(ZMyTableViewCellViewModel *)viewModel {
    
    if (!viewModel) {
        return;
    }
    
    _viewModel = viewModel;
    
    self.titleLabel.text = viewModel.title;
    
    self.icon.image = ImageNamed(viewModel.icon);

}

#pragma mark - lazyLoad
- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return _icon;
}
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = MAIN_BLACK_TEXT_COLOR;
        _titleLabel.font = SYSTEMFONT(17);
    }
    return _titleLabel;
}
- (UIView *)devider
{
    if (!_devider) {
        _devider = [[UIView alloc] init];
        _devider.backgroundColor = lightGray_color;
    }
    return _devider;
}
@end
