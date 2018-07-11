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

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *goodLabel;

@property (nonatomic, strong) UILabel *badLabel;

@property (nonatomic, strong) UIView *devider;

@end
@implementation ZHomeListTableViewCell
- (void)z_setupViews {
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.goodLabel];
    [self.contentView addSubview:self.badLabel];
    [self.contentView addSubview:self.devider];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
- (void)updateConstraints {
    
    WS(weakSelf)
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(MARGIN_20);
        make.trailing.equalTo(-MARGIN_20);
        make.top.equalTo(MARGIN_15);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(MARGIN_20);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(MARGIN_20);
    }];
    [self.badLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(-MARGIN_20);
        make.centerY.equalTo(weakSelf.timeLabel);
    }];
    [self.goodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(weakSelf.badLabel.mas_leading).offset(-MARGIN_20-30);
        make.centerY.equalTo(weakSelf.timeLabel);
    }];
    [self.devider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.timeLabel.mas_bottom).offset(MARGIN_15);
        make.leading.trailing.equalTo(0);
        make.bottom.equalTo(weakSelf.contentView);
        make.height.equalTo(0.5);
    }];

    
    [super updateConstraints];
    
}

- (void)setViewModel:(ZHomeListTableViewCellViewModel *)viewModel {
    
    if (!viewModel) {
        return;
    }
    
    _viewModel = viewModel;
    
    self.titleLabel.text = viewModel.title;
    
    self.timeLabel.text = viewModel.date;
    
    self.goodLabel.text = [NSString stringWithFormat:@"利好：%@",viewModel.bull];
    
    self.badLabel.text = [NSString stringWithFormat:@"利空：%@",viewModel.bear];
}
/**
 根绝数据计算cell的高度
 */
//- (CGFloat)cellHeightForViewModel:(ZHomeListTableViewCellViewModel *)viewModel {
//    [self setViewModel:viewModel];
//    [self layoutIfNeeded];
//    
//    CGFloat cellHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    
//    return cellHeight;
//}
#pragma mark - lazyLoad
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = MAIN_BLACK_TEXT_COLOR;
        _titleLabel.font = SYSTEMFONT(15);
        _titleLabel.numberOfLines = 3;
        //设置该属性，让label撑开cell的高度，否则只会计算一行高度
        _titleLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 2*MARGIN_20;
    }
    
    return _titleLabel;
}
- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = MAIN_BLACK_TEXT_COLOR;
        _timeLabel.font = SYSTEMFONT(12);
    }
    
    return _timeLabel;
}
- (UILabel *)goodLabel {
    
    if (!_goodLabel) {
        
        _goodLabel = [[UILabel alloc] init];
        _goodLabel.textColor = MAIN_BLACK_TEXT_COLOR;
        _goodLabel.font = SYSTEMFONT(12);
        _goodLabel.textAlignment = NSTextAlignmentRight;
    }
    
    return _goodLabel;
}
- (UILabel *)badLabel {
    
    if (!_badLabel) {
        
        _badLabel = [[UILabel alloc] init];
        _badLabel.textColor = MAIN_BLACK_TEXT_COLOR;
        _badLabel.font = SYSTEMFONT(12);
        _badLabel.textAlignment = NSTextAlignmentRight;
    }
    
    return _badLabel;
}
- (UIView *)devider
{
    if (!_devider) {
        _devider = [[UIView alloc] init];
        _devider.backgroundColor = MAIN_LINE_COLOR;
    }
    return _devider;
}
@end
