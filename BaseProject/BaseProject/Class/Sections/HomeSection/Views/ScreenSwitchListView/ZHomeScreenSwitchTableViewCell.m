//
//  ZHomeScreenSwitchTableViewCell.m
//  BaseProject
//
//  Created by 泡果 on 2018/5/30.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZHomeScreenSwitchTableViewCell.h"

@interface ZHomeScreenSwitchTableViewCell ()

@property (nonatomic, strong) UIImageView *bgImage;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *content;

//@property (nonatomic, strong) UILabel *goodLabel;
//
//@property (nonatomic, strong) UILabel *badLabel;

@end
@implementation ZHomeScreenSwitchTableViewCell
- (void)z_setupViews {
    
    [self.contentView addSubview:self.bgImage];
    [self.bgImage addSubview:self.titleLabel];
    [self.bgImage addSubview:self.content];
    [self.bgImage addSubview:self.good];
//    [self.bgImage addSubview:self.goodLabel];
    [self.bgImage addSubview:self.bad];
//    [self.bgImage addSubview:self.badLabel];
    [self.bgImage addSubview:self.comment];
    [self.bgImage addSubview:self.share];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
- (void)updateConstraints {
    
    WS(weakSelf)
    
    CGFloat paddingEdge = 10;
    CGFloat width = 40;
    CGFloat height = 40;
    
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgImage).offset(kNavHeight + 30);
        make.leading.equalTo(width);
        make.trailing.equalTo(-width);
    }];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(30);
        make.leading.equalTo(width);
        make.trailing.equalTo(-width);
    }];
    [self.share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(- MARGIN_5);
        make.bottom.equalTo(weakSelf.bgImage).offset(-100);
        make.size.equalTo(CGSizeMake(width, height));
    }];
    [self.comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(- MARGIN_5);
        make.bottom.equalTo(weakSelf.share).offset(- paddingEdge - height);
        make.size.equalTo(CGSizeMake(width, height));
    }];
//    [self.badLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo( - paddingEdge);
//        make.bottom.equalTo(weakSelf.comment).offset(- paddingEdge - height);
//        make.size.equalTo(CGSizeMake(width, height));
//    }];
    [self.bad mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(- MARGIN_5);
        make.bottom.equalTo(weakSelf.comment).offset( - paddingEdge- height);
        make.size.equalTo(CGSizeMake(width, height));
    }];
//    [self.goodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo( - paddingEdge);
//        make.bottom.equalTo(weakSelf.bad).offset(- paddingEdge - height);
//        make.size.equalTo(CGSizeMake(width, height));
//    }];
    [self.good mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(- MARGIN_5);
        make.bottom.equalTo(weakSelf.bad).offset( - paddingEdge- height);
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
    
    self.content.text = viewModel.content;
}

#pragma mark - lazyLoad
- (UIImageView *)bgImage
{
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc] init];//WithImage:ImageNamed(@"icon_background")
        _bgImage.contentMode = UIViewContentModeScaleAspectFill;
        _bgImage.userInteractionEnabled = YES;
    }
    return _bgImage;
}
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = MAIN_BLACK_TEXT_COLOR;
        _titleLabel.font = FZYANS_JW_FONT_TYPE_FZYANS(20);
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
- (UILabel *)content {
    
    if (!_content) {
        
        _content = [[UILabel alloc] init];
        _content.textColor = MAIN_BLACK_TEXT_COLOR;
        _content.font = FZYANS_JW_FONT_TYPE_FZYANS(16);
        _content.numberOfLines = 0;
    }
    return _content;
}
//- (UILabel *)goodLabel
//{
//    if (!_goodLabel) {
//
//        _goodLabel = [[UILabel alloc] init];
//        _goodLabel.textColor = MAIN_BLACK_TEXT_COLOR;
//        _goodLabel.font = SYSTEMFONT(14);
//        _goodLabel.text = @"利好\n100";
//        _goodLabel.numberOfLines = 2;
//        _goodLabel.textAlignment = NSTextAlignmentCenter;
//
//    }
//    return _goodLabel;
//}
//- (UILabel *)badLabel
//{
//    if (!_badLabel) {
//
//        _badLabel = [[UILabel alloc] init];
//        _badLabel.textColor = MAIN_BLACK_TEXT_COLOR;
//        _badLabel.font = SYSTEMFONT(14);
//        _badLabel.text = @"利空\n100";
//        _badLabel.numberOfLines = 2;
//        _badLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _badLabel;
//}
- (UIButton *)good
{
    if (!_good) {
        _good = [[UIButton alloc] init];
        [_good setImage:ImageNamed(@"LH") forState:UIControlStateNormal];
        [_good setImage:ImageNamed(@"LH0") forState:UIControlStateSelected];
        WS(weakSelf)
        [[_good rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            weakSelf.good.selected = YES;
        }];
    }
    return _good;
}
- (UIButton *)bad
{
    if (!_bad) {
        _bad = [[UIButton alloc] init];
        [_bad setImage:ImageNamed(@"LK") forState:UIControlStateNormal];
        [_bad setImage:ImageNamed(@"LK0") forState:UIControlStateSelected];
        WS(weakSelf)
        [[_bad rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            weakSelf.bad.selected = YES;
        }];
    }
    return _bad;
}
- (UIButton *)comment
{
    if (!_comment) {
        _comment = [[UIButton alloc] init];
        [_comment setImage:ImageNamed(@"pl") forState:UIControlStateNormal];
    }
    return _comment;
}
- (UIButton *)share
{
    if (!_share) {
        _share = [[UIButton alloc] init];
        [_share setImage:ImageNamed(@"zf") forState:UIControlStateNormal];
    }
    return _share;
}
@end
