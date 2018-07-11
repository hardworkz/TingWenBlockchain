//
//  ZMyView.m
//  BaseProject
//
//  Created by 泡果 on 2018/6/5.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZMyView.h"
#import "ZMyViewModel.h"
#import "ZMyTableViewCell.h"

@interface ZMyView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) ZView *headerView;

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) ZMyViewModel *viewModel;

@end
@implementation ZMyView
#pragma mark - system

- (instancetype)initWithViewModel:(id<ZViewModelProtocol>)viewModel {
    
    self.viewModel = (ZMyViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [super updateConstraints];
}

#pragma mark - private
- (void)z_setupViews {
    
    [self addSubview:self.mainTableView];
    self.mainTableView.tableHeaderView = self.headerView;

    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
- (void)z_bindViewModel
{
    @weakify(self);
    [self.viewModel.refreshUI subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.mainTableView reloadData];
    }];
}
#pragma mark - action
- (void)headerTap:(UIGestureRecognizer *)gesture
{
    [self.viewModel.headClickSubject sendNext:nil];
}
#pragma mark - lazyLoad
- (ZMyViewModel *)viewModel {
    
    if (!_viewModel) {
        
        _viewModel = [[ZMyViewModel alloc] init];
    }
    
    return _viewModel;
}
- (ZView *)headerView
{
    if (!_headerView) {
        _headerView = [[ZView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
        _headerView.backgroundColor = MAINCOLOR;
        
        //用户头像
        UIImageView *header = [[UIImageView alloc] init];
        [header setImage:ImageNamed(@"icon_head")];
        header.contentMode = UIViewContentModeScaleAspectFill;
        header.clipsToBounds = YES;
        header.layer.cornerRadius = 50;
        header.layer.borderColor = white_color.CGColor;
        header.layer.borderWidth = 3.0;
        WS(weakSelf)
        [header addTapGestureWithTarget:self action:@selector(headerTap:)];
        [_headerView addSubview:header];
        
        //用户昵称
        UILabel *name = [[UILabel alloc] init];
        name.text = @"test";
        name.textColor = white_color;
        name.textAlignment = NSTextAlignmentCenter;
        name.font = FONT(15.0);
        [_headerView addSubview:name];
        
        [header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.headerView);
            make.centerY.equalTo(weakSelf.headerView);
            make.size.equalTo(CGSizeMake(100, 100));
        }];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(header).offset(100 + 20);
            make.centerX.equalTo(header);
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH, 20));
        }];
    }
    return _headerView;
}
- (UITableView *)mainTableView {
    
    if (!_mainTableView) {
        
        _mainTableView = [[UITableView alloc] init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = white_color;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //tableView页面无导航栏时，顶部出现44高度的空白解决方法
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_mainTableView registerClass:[ZMyTableViewCell class] forCellReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([ZMyTableViewCell class])]];
    }
    
    return _mainTableView;
}

#pragma mark - table datasource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ZMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:object_getClassName([ZMyTableViewCell class])] forIndexPath:indexPath];
    
    if (self.viewModel.dataArray.count > indexPath.row) {

        cell.viewModel = self.viewModel.dataArray[indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.viewModel.cellClickSubject sendNext:nil];
}
@end
