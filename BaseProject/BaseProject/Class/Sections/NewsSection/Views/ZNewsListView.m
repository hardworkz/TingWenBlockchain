//
//  ZNewsListView.m
//  BaseProject
//
//  Created by 泡果 on 2018/6/21.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZNewsListView.h"
#import "ZNewsListViewModel.h"
#import "ZNewsTableViewCell.h"
#import "ZNewsTableViewCellViewModel.h"
#import "ZNewsProgramTableViewCell.h"
#import "ZNewsProgramTableViewCellViewModel.h"

@interface ZNewsListView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) ZNewsListViewModel *viewModel;

@property (nonatomic, strong) ZNewsProgramTableViewCell *tempCell;

@end
@implementation ZNewsListView
#pragma mark - system

- (instancetype)initWithViewModel:(id<ZViewModelProtocol>)viewModel {
    
    self.viewModel = (ZNewsListViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf);
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
    }];
    [super updateConstraints];
}

#pragma mark - private
- (void)z_setupViews {
    
    [self addSubview:self.mainTableView];
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

    [self.viewModel.cellClickSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        //点击cell操作
        NSInteger index = [x integerValue];
        
        //设置播放器播放列表数据
        NSArray *dictArray = self.viewModel.dictDataArray;
        NSArray *listArray = self.viewModel.dataArray;
        
        //设置播放器播放完成自动加载更多block
        WS(weakSelf)
        [ZRT_PlayerManager manager].loadMoreList = ^(NSInteger currentSongIndex) {
            [weakSelf.viewModel.nextPageCommand execute:nil];
        };
        //播放内容切换后刷新对应的播放列表
        [ZRT_PlayerManager manager].playReloadList = ^(NSInteger currentSongIndex) {
            [weakSelf.mainTableView reloadData];
        };
        
        id object = [self nextResponder];
        
        while (![object isKindOfClass:[UINavigationController class]] &&
               object != nil) {
            object = [object nextResponder];
        }
        UINavigationController *vc = (UINavigationController *)object;
        
        
        int j = 0;
        for (int i = 0; i<index+1; i++) {
            NSDictionary *dict = listArray[i];
            if ([dict isKindOfClass:[ZNewsProgramTableViewCellViewModel class]]) {
                j++;
            }
        }
        index = index - j;
        
        //判断是否是点击当前正在播放的新闻，如果是则直接跳转
        NSString *post_id = dictArray[index][@"id"];
        
        ZLog(@"现在播放index：%ld",index);
        
//        if ([[DataCache loadCache:currenPlayID] isEqualToString:viewModel.Id]) {
//            [vc pushViewController:[ZPlayerViewController shareManager] animated:YES];
//        }else{
            //设置播放器播放数组
            [ZRT_PlayerManager manager].songList = dictArray;
            //设置新闻ID
            [ZPlayerViewController shareManager].post_id = post_id;
            //调用播放对应Index方法
            [[ZRT_PlayerManager manager] loadSongInfoFromIndex:index];
            //跳转播放界面
            [vc pushViewController:[ZPlayerViewController shareManager] animated:YES];
            [self.mainTableView reloadData];
        
//        }
    }];
}
#pragma mark - action

#pragma mark - lazyLoad
- (ZNewsListViewModel *)viewModel {
    
    if (!_viewModel) {
        
        _viewModel = [[ZNewsListViewModel alloc] init];
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
        [_mainTableView registerClass:[ZNewsTableViewCell class] forCellReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([ZNewsTableViewCell class])]];
        [_mainTableView registerClass:[ZNewsProgramTableViewCell class] forCellReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([ZNewsProgramTableViewCell class])]];
        
        
        WS(weakSelf)
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakSelf.viewModel.refreshDataCommand execute:nil];
        }];
        _mainTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            
            [weakSelf.viewModel.nextPageCommand execute:nil];
        }];
        
        self.tempCell = [[ZNewsProgramTableViewCell alloc] initWithStyle:0 reuseIdentifier:[NSString stringWithUTF8String:object_getClassName([ZNewsTableViewCell class])]];
     }
    
    return _mainTableView;
}
#pragma mark - table datasource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ZViewModel *viewModel = self.viewModel.dataArray[indexPath.row];
    if ([viewModel isKindOfClass:[ZNewsTableViewCellViewModel class]]) {
        ZNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:object_getClassName([ZNewsTableViewCell class])] forIndexPath:indexPath];
        
        if (self.viewModel.dataArray.count > indexPath.row) {
            
            cell.viewModel = self.viewModel.dataArray[indexPath.row];
        }
        
        return cell;
    }else{
        ZNewsProgramTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:object_getClassName([ZNewsProgramTableViewCell class])] forIndexPath:indexPath];
        
        if (self.viewModel.dataArray.count > indexPath.row) {
            
            cell.viewModel = self.viewModel.dataArray[indexPath.row];
        }
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZViewModel *viewModel = self.viewModel.dataArray[indexPath.row];
    if ([viewModel isKindOfClass:[ZNewsTableViewCellViewModel class]]) {
        return 110;
    }else{
        ZNewsProgramTableViewCellViewModel *programViewModel = (ZNewsProgramTableViewCellViewModel *)viewModel;
        if (programViewModel.cellHeight == 0) {
            CGFloat cellHeight = [self.tempCell cellHeightForViewModel:programViewModel];
            
            // 缓存给model
            programViewModel.cellHeight = cellHeight;
            
            return cellHeight;
        } else {
            return programViewModel.cellHeight;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZViewModel *viewModel = self.viewModel.dataArray[indexPath.row];
    if ([viewModel isKindOfClass:[ZNewsTableViewCellViewModel class]]) {
        [self.viewModel.cellClickSubject sendNext:[NSNumber numberWithInteger:indexPath.row]];
    }else{
        
    }
}
@end
