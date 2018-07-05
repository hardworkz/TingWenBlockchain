//
//  ZNewsProgramCollectionViewCell.m
//  BaseProject
//
//  Created by 泡果 on 2018/7/5.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZNewsProgramCollectionViewCell.h"

@interface ZNewsProgramCollectionViewCell ()

@property (nonatomic, strong) UIImageView *contentImage;

@property (nonatomic, strong) UILabel *titleLabel;

@end
@implementation ZNewsProgramCollectionViewCell
- (void)z_setupViews {
    
    [self.contentView addSubview:self.contentImage];
    [self.contentView addSubview:self.titleLabel];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
- (void)updateConstraints {
    
    WS(weakSelf)
    [self.contentImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 30, 0));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentImage.mas_bottom);
        make.leading.trailing.equalTo(0);
        make.height.equalTo(30);
    }];
    [super updateConstraints];
    
}
- (void)setViewModel:(ZNewsProgramCollectionViewCellViewModel *)viewModel {
    
    if (!viewModel) {
        return;
    }
    
    _viewModel = viewModel;
    
    self.titleLabel.text = viewModel.c_name;
    
    [self.contentImage sd_setImageWithURL:[NSURL URLWithString:viewModel.images]];
}

#pragma mark - lazyLoad
- (UIImageView *)contentImage
{
    if (!_contentImage) {
        _contentImage = [[UIImageView alloc] init];
        _contentImage.clipsToBounds = YES;
        _contentImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _contentImage;
}
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = MAIN_TEXT_COLOR;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = BOLDSYSTEMFONT(13);
    }
    return _titleLabel;
}
@end
