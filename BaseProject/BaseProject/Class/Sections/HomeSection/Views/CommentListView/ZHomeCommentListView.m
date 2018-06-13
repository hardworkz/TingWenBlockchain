//
//  ZHomeCommentListView.m
//  BaseProject
//
//  Created by 泡果 on 2018/6/11.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZHomeCommentListView.h"
#import "ZHomeCommentListViewModel.h"
#import "ZHomeCommentListTableViewCell.h"
#import "ZHomeCommentListTableView.h"

@interface ZHomeCommentListView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZHomeCommentListTableView *mainTableView;

@property (strong, nonatomic) ZHomeCommentListViewModel *viewModel;
@end
@implementation ZHomeCommentListView
#pragma mark - system

- (instancetype)initWithViewModel:(id<ZViewModelProtocol>)viewModel {
    
    self.viewModel = (ZHomeCommentListViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {

    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(50, 0, 0, 0));
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
}
#pragma mark - lazyLoad
- (ZHomeCommentListViewModel *)viewModel {
    
    if (!_viewModel) {
        
        _viewModel = [[ZHomeCommentListViewModel alloc] init];
    }
    
    return _viewModel;
}

- (ZHomeCommentListTableView *)mainTableView {
    
    if (!_mainTableView) {
        
        _mainTableView = [[ZHomeCommentListTableView alloc] init];
        _mainTableView.panEnable = YES;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = white_color;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //tableView页面无导航栏时，顶部出现44高度的空白解决方法
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_mainTableView registerClass:[ZHomeCommentListTableViewCell class] forCellReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([ZHomeCommentListTableViewCell class])]];
        
        WS(weakSelf)
        _mainTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            
            [weakSelf.viewModel.nextPageCommand execute:nil];
        }];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [_mainTableView addGestureRecognizer:pan];
    }
    
    return _mainTableView;
}
- (UIButton *)cover
{
    if (!_cover) {
        _cover = [UIButton buttonWithType:UIButtonTypeCustom];
        _cover.backgroundColor = clear_color;
        _cover.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [_cover addTarget:self action:@selector(coverClicked:)];
    }
    return _cover;
}
#pragma makr - action
- (void)coverClicked:(UIButton *)cover {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [cover removeFromSuperview];
    }];
}
#pragma mark - table datasource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ZHomeCommentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:object_getClassName([ZHomeCommentListTableViewCell class])] forIndexPath:indexPath];
    
    if (self.viewModel.dataArray.count > indexPath.row) {
        
        cell.viewModel = self.viewModel.dataArray[indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 49;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.viewModel.cellClickSubject sendNext:nil];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //设置tableView顶部弹簧效果
    if (scrollView.contentOffset.y <= 10) {
        scrollView.bounces = NO;
    }else{
        scrollView.bounces = YES;
    }
}
#pragma mark - pan
- (void)panAction:(UIPanGestureRecognizer *)gesture
{
    //点相对于上一个点的位置
    CGPoint moviePoint = [gesture translationInView:gesture.view];
    
    //点的速度(正负可判断滑动趋势)
//    CGPoint velocity = [gesture velocityInView:gesture.view];

    //设置view的y值
    self.y += moviePoint.y;
    //判断是否移动view
    if (self.y < SCREEN_HEIGHT * 0.3) {
        self.y = SCREEN_HEIGHT * 0.3;
    }
    //判断是否移动view
    if (self.mainTableView.contentOffset.y > 0) {
        self.y = SCREEN_HEIGHT * 0.3;
    }
    //增量置为0
    [gesture setTranslation:CGPointZero inView:self];
    
    //松开手指时判断滑动趋势让其归位
    if (gesture.state == UIGestureRecognizerStateEnded) {
        //判断当前y的值是否移动超过一半，超过则收起评论View，未超过移回原来位置
        if (self.y <= (SCREEN_HEIGHT * 0.3 + SCREEN_HEIGHT * 0.7 * 0.3)) {
            [UIView animateWithDuration:0.25 animations:^{
                self.y = SCREEN_HEIGHT * 0.3;
            }];
        }else{
            [UIView animateWithDuration:0.25 animations:^{
                self.y = SCREEN_HEIGHT;
            }completion:^(BOOL finished) {
                [self.cover removeFromSuperview];
            }];
        }
    }
}

@end
