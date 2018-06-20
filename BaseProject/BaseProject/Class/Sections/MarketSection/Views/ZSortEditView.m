//
//  ZSortEditView.m
//  BaseProject
//
//  Created by 泡果 on 2018/6/12.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZSortEditView.h"
#import "ZSortEditViewModel.h"
#import "ZSortEditTableViewCell.h"

@interface ZSortEditView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (strong, nonatomic) UIView            *editingView;

@property (nonatomic, strong) ZSortEditViewModel *viewModel;

@end
@implementation ZSortEditView
#pragma mark - system

- (instancetype)initWithViewModel:(id<ZViewModelProtocol>)viewModel {
    
    self.viewModel = (ZSortEditViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, kTabBarHeight, 0));
    }];
    
    [self.editingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.height.equalTo(@45);
        make.bottom.equalTo(weakSelf).offset(45 - kTabBarHeight);
    }];
    [super updateConstraints];
}

#pragma mark - private
- (void)z_setupViews {
    
    [self addSubview:self.mainTableView];
    [self addSubview:self.editingView];
//    [self showEitingView:YES];
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
}
#pragma mark - lazyLoad
- (ZSortEditViewModel *)viewModel {
    
    if (!_viewModel) {
        
        _viewModel = [[ZSortEditViewModel alloc] init];
    }
    
    return _viewModel;
}

- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] init];
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.editing = true;
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.tableFooterView = [[UIView alloc] init];
        [_mainTableView registerClass:[ZSortEditTableViewCell class] forCellReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([ZSortEditTableViewCell class])]];
    }
    return _mainTableView;
}

- (UIView *)editingView{
    if (!_editingView) {
        _editingView = [[UIView alloc] init];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor redColor];
        [button setTitle:@"删除" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(p__buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_editingView addSubview:button];
        WS(weakSelf)
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(weakSelf.editingView);
            make.width.equalTo(weakSelf.editingView).multipliedBy(0.5);
        }];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor darkGrayColor];
        [button setTitle:@"全选" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(p__buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_editingView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(weakSelf.editingView);
            make.width.equalTo(weakSelf.editingView).multipliedBy(0.5);
        }];
    }
    return _editingView;
}

#pragma mark - table datasource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ZSortEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:object_getClassName([ZSortEditTableViewCell class])] forIndexPath:indexPath];
    //去除多选的时候cell的整体选中状态
    cell.multipleSelectionBackgroundView = [UIView new];
    
    if (self.viewModel.dataArray.count > indexPath.row) {
        
        cell.viewModel = self.viewModel.dataArray[indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.isEditing) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
// 设置 cell 是否允许移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}
// 移动 cell 时触发
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // 移动cell之后更换数据数组里的循序
    [self.viewModel.dataArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}
#pragma mark -- event response

- (void)p__buttonClick:(UIButton *)sender{
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"删除"]) {
        NSMutableIndexSet *insets = [[NSMutableIndexSet alloc] init];
        [[self.mainTableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [insets addIndex:obj.row];
        }];
        [self.viewModel.dataArray removeObjectsAtIndexes:insets];
        [self.mainTableView deleteRowsAtIndexPaths:[self.mainTableView indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationFade];
        
        /** 数据清空情况下取消编辑状态*/
        if (self.viewModel.dataArray.count == 0) {
            //            self.navigationItem.rightBarButtonItem.title = @"编辑";
            [self.mainTableView setEditing:NO animated:YES];
            [self showEitingView:NO];
            /** 带MJ刷新控件重置状态
             [self.tableView.footer resetNoMoreData];
             [self.tableView reloadData];
             */
        }
        
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全选"]) {
        [self.viewModel.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.mainTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }];
        
        [sender setTitle:@"全不选" forState:UIControlStateNormal];
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全不选"]){
        [self.mainTableView reloadData];
        /** 遍历反选
         [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         [self.tableView deselectRowAtIndexPath:obj animated:NO];
         }];
         */
        
        [sender setTitle:@"全选" forState:UIControlStateNormal];
        
    }
}
- (void)showEitingView:(BOOL)isShow{
    [self.editingView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(isShow?0:45);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}
@end
