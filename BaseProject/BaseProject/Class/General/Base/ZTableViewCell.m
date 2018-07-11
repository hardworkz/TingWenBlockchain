//
//  ZTableViewCell.m
//  BaseProject
//
//  Created by 泡果 on 2018/5/28.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZTableViewCell.h"

@implementation ZTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self z_setupViews];
        [self z_bindViewModel];
    }
    return self;
}

- (void)z_setupViews{}

- (void)z_bindViewModel{}

/**
 根绝数据计算cell的高度
 */
- (CGFloat)cellHeightForViewModel:(ZViewModel *)viewModel {
    [self layoutIfNeeded];
    
    CGFloat cellHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    return cellHeight;
}
@end
