//
//  ZSegmentListTableViewCell.m
//  BaseProject
//
//  Created by 泡果 on 2018/6/1.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZSegmentListTableViewCell.h"

@interface ZSegmentListTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end
@implementation ZSegmentListTableViewCell
- (void)z_setupViews {
    
    [self.contentView addSubview:self.titleLabel];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
- (void)updateConstraints {
    
    WS(weakSelf)
    
    CGFloat paddingEdge = 10;
//    CGFloat width = 40;
//    CGFloat height = 40;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(paddingEdge);
        make.centerY.equalTo(weakSelf.contentView);
        make.size.equalTo(CGSizeMake(80, 50));
    }];
    
    [super updateConstraints];
    
}
- (void)setViewModel:(ZSegmentListTableViewCellViewModel *)viewModel {
    
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
//-(void)layoutSubviews
//{
//    for (UIControl *control in self.subviews){
//        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
//            for (UIView *v in control.subviews)
//            {
//                if ([v isKindOfClass: [UIImageView class]]) {
//                    UIImageView *img=(UIImageView *)v;
//                    if (self.selected) {
//                        img.image=[UIImage imageNamed:@"xuanzhong_icon"];
//                    }else
//                    {
//                        img.image=[UIImage imageNamed:@"weixuanzhong_icon"];
//                    }
//                }
//            }
//        }
//    }
//    [super layoutSubviews];
//}
//
//
////适配第一次图片为空的情况
//- (void)setEditing:(BOOL)editing animated:(BOOL)animated
//{
//    [super setEditing:editing animated:animated];
//    for (UIControl *control in self.subviews){
//        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
//            for (UIView *v in control.subviews)
//            {
//                if ([v isKindOfClass: [UIImageView class]]) {
//                    UIImageView *img=(UIImageView *)v;
//                    if (!self.selected) {
//                        img.image=[UIImage imageNamed:@"weixuanzhong_icon"];
//                    }
//                }
//            }
//        }
//    }
//
//}

@end
