//
//  ZSegmentListView.m
//  BaseProject
//
//  Created by 泡果 on 2018/6/1.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZSegmentListView.h"
#import "ZSegmentListViewModel.h"
#import "PSSSegmentViewController.h"
#import "ZMarketSegmentContentController.h"
#import "ZSegmentListTableViewCell.h"

@interface ZSegmentListView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) ZView *sortView;

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) ZSegmentListViewModel *viewModel;

@end
@implementation ZSegmentListView
#pragma mark - system

- (instancetype)initWithViewModel:(id<ZViewModelProtocol>)viewModel {
    
    self.viewModel = (ZSegmentListViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    
    WS(weakSelf)
    [self.sortView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf);
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.height.equalTo(40);
    }];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf).offset(40);
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
    }];
    [super updateConstraints];
}

#pragma mark - private
- (void)z_setupViews {
    
    [self addSubview:self.mainTableView];
    [self addSubview:self.sortView];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
- (void)z_bindViewModel
{
    [self.viewModel.refreshDataCommand execute:nil];
    
    @weakify(self);
    
    [self.viewModel.refreshUI subscribeNext:^(id x) {
        
        @strongify(self);
        [self.mainTableView reloadData];
    }];
    
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self);
        
        [self.mainTableView reloadData];
        
        switch ([x integerValue]) {
            case LSHeaderRefresh_HasMoreData: {
                
                [self.mainTableView.mj_header endRefreshing];
                
                if (self.mainTableView.mj_footer == nil) {
                    self.mainTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
                        @strongify(self);
                        [self.viewModel.nextPageCommand execute:nil];
                    }];
                }
            }
                break;
            case LSHeaderRefresh_HasNoMoreData: {
                
                [self.mainTableView.mj_header endRefreshing];
                self.mainTableView.mj_footer = nil;
            }
                break;
            case LSFooterRefresh_HasMoreData: {
                
                [self.mainTableView.mj_header endRefreshing];
                [self.mainTableView.mj_footer resetNoMoreData];
                [self.mainTableView.mj_footer endRefreshing];
            }
                break;
            case LSFooterRefresh_HasNoMoreData: {
                [self.mainTableView.mj_header endRefreshing];
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }
                break;
            case LSRefreshError: {
                
                [self.mainTableView.mj_footer endRefreshing];
                [self.mainTableView.mj_header endRefreshing];
            }
                break;
                
            default:
                break;
        }
    }];
}
#pragma mark - action
- (void)sort_Clicked:(UIButton *)button {
    
}
#pragma mark - lazyLoad
- (ZSegmentListViewModel *)viewModel {
    
    if (!_viewModel) {
        
        _viewModel = [[ZSegmentListViewModel alloc] init];
    }
    
    return _viewModel;
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
        [_mainTableView registerClass:[ZSegmentListTableViewCell class] forCellReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([ZSegmentListTableViewCell class])]];
        
        WS(weakSelf)
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakSelf.viewModel.refreshDataCommand execute:nil];
        }];
        _mainTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            
            [weakSelf.viewModel.nextPageCommand execute:nil];
        }];
    }
    
    return _mainTableView;
}
- (ZView *)sortView
{
    if (!_sortView) {
        _sortView = [[ZView alloc] init];
        _sortView.backgroundColor = lightGray_color;
        
        UIButton *sortScoreBtn = [[UIButton alloc] init];
        [sortScoreBtn setTitle:@"币种评分" forState:UIControlStateNormal];
        [sortScoreBtn setImage:ImageNamed(@"icon_applies") forState:UIControlStateNormal];
        sortScoreBtn.titleLabel.font = BOLDSYSTEMFONT(15);
        sortScoreBtn.backgroundColor = clear_color;
        sortScoreBtn.tag = 100;
        sortScoreBtn.selected = YES;
        [sortScoreBtn addTarget:self action:@selector(sort_Clicked:)];
        [_sortView addSubview:sortScoreBtn];
        [sortScoreBtn edgeInsetsStyle:ImageRight imgTitleSpace:15];
        
        UIButton *sortPriceBtn = [[UIButton alloc] init];
        [sortPriceBtn setTitle:@"最新价" forState:UIControlStateNormal];
        [sortPriceBtn setImage:ImageNamed(@"icon_applies_down") forState:UIControlStateNormal];
        sortPriceBtn.titleLabel.font = BOLDSYSTEMFONT(15);
        sortPriceBtn.backgroundColor = clear_color;
        sortPriceBtn.tag = 101;
        sortPriceBtn.selected = YES;
        [sortPriceBtn addTarget:self action:@selector(sort_Clicked:)];
        [_sortView addSubview:sortPriceBtn];
        [sortPriceBtn edgeInsetsStyle:ImageRight imgTitleSpace:15];
        
        UIButton *sortAppliesBtn = [[UIButton alloc] init];
        [sortAppliesBtn setTitle:@"涨跌幅" forState:UIControlStateNormal];
        [sortAppliesBtn setImage:ImageNamed(@"icon_applies_up") forState:UIControlStateNormal];
        sortAppliesBtn.titleLabel.font = BOLDSYSTEMFONT(15);
        sortAppliesBtn.backgroundColor = clear_color;
        sortAppliesBtn.tag = 102;
        sortAppliesBtn.selected = YES;
        [sortAppliesBtn addTarget:self action:@selector(sort_Clicked:)];
        [_sortView addSubview:sortAppliesBtn];
        [sortAppliesBtn edgeInsetsStyle:ImageRight imgTitleSpace:15];
        
        WS(weakSelf)
        [sortScoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.sortView);
            make.left.equalTo(weakSelf.sortView).offset(20);
            make.bottom.equalTo(weakSelf.sortView);
            make.width.equalTo(100);
        }];
        [sortAppliesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.sortView);
            make.right.equalTo(weakSelf.sortView).offset(- 20);
            make.bottom.equalTo(weakSelf.sortView);
            make.width.equalTo(80);
        }];
        [sortPriceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.sortView);
            make.right.equalTo(weakSelf.sortView).offset(- 100);
            make.bottom.equalTo(weakSelf.sortView);
            make.width.equalTo(80);
        }];
    }
    return _sortView;
}
#pragma mark - table datasource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ZSegmentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:object_getClassName([ZSegmentListTableViewCell class])] forIndexPath:indexPath];
    
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
