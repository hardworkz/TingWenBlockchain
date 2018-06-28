//
//  ZPlayerViewContentTextTableViewCell.m
//  BaseProject
//
//  Created by 泡果 on 2018/6/27.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZPlayerViewContentTextTableViewCell.h"

@interface ZPlayerViewContentTextTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *timeAndFrom;

@property (nonatomic, strong) UILabel *content;

@end
@implementation ZPlayerViewContentTextTableViewCell
- (void)z_setupViews {
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeAndFrom];
    [self.contentView addSubview:self.content];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
- (void)updateConstraints {
    
    WS(weakSelf)
    
    CGFloat paddingEdge = 10;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.contentView).offset(paddingEdge*3);
        make.leading.equalTo(paddingEdge*2);
        make.trailing.equalTo(-paddingEdge*2);
    }];
    [self.timeAndFrom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(15);
        make.trailing.equalTo(-15);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(30);
    }];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(10);
        make.trailing.equalTo(-10);
        make.top.equalTo(weakSelf.timeAndFrom.mas_bottom).offset(30);
        make.bottom.equalTo(weakSelf.contentView).offset(- 30);
    }];
    
    [super updateConstraints];
    
}
- (void)setViewModel:(ZPlayerViewContentTextTableViewCellViewModel *)viewModel {
    
    if (!viewModel.post_title) {
        return;
    }
    
    _viewModel = viewModel;
    
    self.titleLabel.text = viewModel.post_title;
    
    NSDate *date = [NSDate dateFromString:viewModel.post_modified];
    NSString *dateStr = [date showTimeByTypeA];
    
    self.timeAndFrom.text = [NSString stringWithFormat:@"#来自 %@ %@",viewModel.post_lai,dateStr];
    
    self.content.text = viewModel.post_excerpt;
    
    // 自动适配并重新布局
//    [self.titleLabel sizeToFit];// 可以得到label的正确高度
//    [self.timeAndFrom sizeToFit];// 可以得到label的正确高度
//    [self.content sizeToFit];// 可以得到label的正确高度
//    [self layoutIfNeeded];//会重新调用一次LayoutSubViews
}

/**
 根绝数据计算cell的高度
 */
- (CGFloat)cellHeightForViewModel:(ZPlayerViewContentTextTableViewCellViewModel *)viewModel {
    [self setViewModel:viewModel];
    [self layoutIfNeeded];
    
    CGFloat cellHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    return cellHeight;
}
#pragma mark - lazyLoad
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = MAIN_TEXT_COLOR;
        _titleLabel.font = BOLDSYSTEMFONT(20);
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        //设置该属性，让label撑开cell的高度，否则只会计算一行高度
        _titleLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 2*20;
    }
    return _titleLabel;
}
- (UILabel *)timeAndFrom {
    
    if (!_timeAndFrom) {
        _timeAndFrom = [[UILabel alloc] init];
        _timeAndFrom.textColor = MAIN_TEXT_COLOR;
        _timeAndFrom.font = BOLDSYSTEMFONT(15);
        _timeAndFrom.numberOfLines = 0;
        _timeAndFrom.textAlignment = NSTextAlignmentCenter;
        //设置该属性，让label撑开cell的高度，否则只会计算一行高度
        _timeAndFrom.preferredMaxLayoutWidth = SCREEN_WIDTH - 2*15;
    }
    return _timeAndFrom;
}
- (UILabel *)content {
    
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.textColor = MAIN_TEXT_COLOR;
        _content.font = BOLDSYSTEMFONT(15);
        _content.numberOfLines = 0;
        _content.textAlignment = NSTextAlignmentCenter;
        //设置该属性，让label撑开cell的高度，否则只会计算一行高度
        _content.preferredMaxLayoutWidth = SCREEN_WIDTH - 2*10;
    }
    return _content;
}
@end
