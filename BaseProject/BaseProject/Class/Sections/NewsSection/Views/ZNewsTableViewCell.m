//
//  ZNewsTableViewCell.m
//  BaseProject
//
//  Created by 泡果 on 2018/6/21.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZNewsTableViewCell.h"

@interface ZNewsTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *newsImageView;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *sizeLabel;

//@property (nonatomic, strong) UIImageView *downloadImageView;

@property (nonatomic, strong) UIView *devider;

@end
@implementation ZNewsTableViewCell
- (void)z_setupViews {
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.newsImageView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.sizeLabel];
//    [self.contentView addSubview:self.downloadImageView];
    [self.contentView addSubview:self.devider];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
- (void)updateConstraints {
    
    WS(weakSelf)
    
    CGFloat paddingEdge = 15;
    [self.newsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(paddingEdge);
        make.bottom.equalTo(weakSelf.contentView).offset(-paddingEdge);
        make.trailing.equalTo(-paddingEdge);
        make.width.equalTo(110);
        make.height.equalTo(90);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(paddingEdge);
        make.top.equalTo(weakSelf.contentView).offset(paddingEdge);
        make.trailing.equalTo(weakSelf.newsImageView.mas_leading).offset(-paddingEdge);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(paddingEdge);
        make.bottom.equalTo(weakSelf.contentView).offset(-paddingEdge);
    }];
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(weakSelf.newsImageView.mas_leading).offset(-paddingEdge);
        make.bottom.equalTo(weakSelf.contentView).offset(-paddingEdge);
    }];
    [self.devider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(paddingEdge);
        make.trailing.equalTo(-paddingEdge);
        make.bottom.equalTo(weakSelf.contentView);
        make.height.equalTo(0.5);
    }];
    [super updateConstraints];
    
}
- (void)setViewModel:(ZNewsTableViewCellViewModel *)viewModel {
    
    if (!viewModel) {
        return;
    }
    
    _viewModel = viewModel;
    
    [self.newsImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.smeta]];
    
    self.titleLabel.text = viewModel.post_title;
    
    NSDate *date = [NSDate dateFromString:viewModel.post_modified];
    self.timeLabel.text = [date showTimeByTypeA];
    
    self.sizeLabel.text = [NSString stringWithFormat:@"%.1lf%@",[viewModel.post_size intValue] / 1024.0 / 1024.0,@"M"];
    
}

#pragma mark - lazyLoad
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = MAIN_BLACK_TEXT_COLOR;
        _titleLabel.font = BOLDSYSTEMFONT(17);
        _titleLabel.numberOfLines = 3;
    }
    return _titleLabel;
}
- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = MAIN_BLACK_TEXT_COLOR;
        _timeLabel.font = SYSTEMFONT(14);
        _timeLabel.numberOfLines = 0;
    }
    return _timeLabel;
}
- (UILabel *)sizeLabel {
    
    if (!_sizeLabel) {
        
        _sizeLabel = [[UILabel alloc] init];
        _sizeLabel.textColor = MAIN_BLACK_TEXT_COLOR;
        _sizeLabel.font = SYSTEMFONT(12);
        _sizeLabel.textAlignment = NSTextAlignmentRight;
        _sizeLabel.numberOfLines = 0;
    }
    return _sizeLabel;
}
- (UIImageView *)newsImageView
{
    if (!_newsImageView) {
        _newsImageView = [[UIImageView alloc] init];
        _newsImageView.contentMode = UIViewContentModeScaleAspectFill;
        _newsImageView.clipsToBounds = YES;
    }
    return _newsImageView;
}
//- (UIImageView *)downloadImageView
//{
//    if (!_downloadImageView) {
//        _downloadImageView = [[UIImageView alloc] initWithImage:ImageNamed(@"download")];
//        _downloadImageView.contentMode = UIViewContentModeScaleAspectFill;
//    }
//    return _downloadImageView;
//}
- (UIView *)devider
{
    if (!_devider) {
        _devider = [[UIView alloc] init];
        _devider.backgroundColor = lightGray_color;
    }
    return _devider;
}
@end
