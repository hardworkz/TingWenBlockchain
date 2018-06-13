//
//  ZHomeScreenSwitchTableViewCell.m
//  BaseProject
//
//  Created by 泡果 on 2018/5/30.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZHomeScreenSwitchTableViewCell.h"

@interface ZHomeScreenSwitchTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *goodLabel;

@property (nonatomic, strong) UILabel *badLabel;

@end
@implementation ZHomeScreenSwitchTableViewCell
- (void)z_setupViews {
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.good];
    [self.contentView addSubview:self.goodLabel];
    [self.contentView addSubview:self.bad];
    [self.contentView addSubview:self.badLabel];
    [self.contentView addSubview:self.comment];
    [self.contentView addSubview:self.share];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
- (void)updateConstraints {
    
    WS(weakSelf)
    
    CGFloat paddingEdge = 10;
    CGFloat width = 40;
    CGFloat height = 40;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(paddingEdge);
        make.centerY.equalTo(weakSelf.contentView);
        make.size.equalTo(CGSizeMake(80, 80));
    }];
    [self.share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(- paddingEdge);
        make.bottom.equalTo(weakSelf.contentView).offset(-100);
        make.size.equalTo(CGSizeMake(width, height));
    }];
    [self.comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(- paddingEdge);
        make.bottom.equalTo(weakSelf.share).offset(- paddingEdge - height);
        make.size.equalTo(CGSizeMake(width, height));
    }];
    [self.badLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo( - paddingEdge);
        make.bottom.equalTo(weakSelf.comment).offset(- paddingEdge - height);
        make.size.equalTo(CGSizeMake(width, height));
    }];
    [self.bad mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(- paddingEdge);
        make.bottom.equalTo(weakSelf.badLabel).offset( - height);
        make.size.equalTo(CGSizeMake(width, height));
    }];
    [self.goodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo( - paddingEdge);
        make.bottom.equalTo(weakSelf.bad).offset(- paddingEdge - height);
        make.size.equalTo(CGSizeMake(width, height));
    }];
    [self.good mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(- paddingEdge);
        make.bottom.equalTo(weakSelf.goodLabel).offset( - height);
        make.size.equalTo(CGSizeMake(width, height));
    }];
    
    [super updateConstraints];

}
- (void)setViewModel:(ZHomeScreenSwitchTableViewCellViewModel *)viewModel {
    
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
- (UILabel *)goodLabel
{
    if (!_goodLabel) {
        
        _goodLabel = [[UILabel alloc] init];
        _goodLabel.textColor = MAIN_BLACK_TEXT_COLOR;
        _goodLabel.font = SYSTEMFONT(14);
        _goodLabel.text = @"利好\n100";
        _goodLabel.numberOfLines = 2;
        _goodLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _goodLabel;
}
- (UILabel *)badLabel
{
    if (!_badLabel) {
        
        _badLabel = [[UILabel alloc] init];
        _badLabel.textColor = MAIN_BLACK_TEXT_COLOR;
        _badLabel.font = SYSTEMFONT(14);
        _badLabel.text = @"利空\n100";
        _badLabel.numberOfLines = 2;
        _badLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _badLabel;
}
- (UIButton *)good
{
    if (!_good) {
        _good = [[UIButton alloc] init];
        [_good setImage:ImageNamed(@"icon_good") forState:UIControlStateNormal];
    }
    return _good;
}
- (UIButton *)bad
{
    if (!_bad) {
        _bad = [[UIButton alloc] init];
        [_bad setImage:ImageNamed(@"icon_bad") forState:UIControlStateNormal];
    }
    return _bad;
}
- (UIButton *)comment
{
    if (!_comment) {
        _comment = [[UIButton alloc] init];
        [_comment setImage:ImageNamed(@"icon_comment") forState:UIControlStateNormal];
    }
    return _comment;
}
- (UIButton *)share
{
    if (!_share) {
        _share = [[UIButton alloc] init];
        [_share setImage:ImageNamed(@"icon_share") forState:UIControlStateNormal];
    }
    return _share;
}
@end
