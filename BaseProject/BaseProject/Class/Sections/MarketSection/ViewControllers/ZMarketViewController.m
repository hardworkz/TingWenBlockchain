//
//  ZMarketViewController.m
//  BaseProject
//
//  Created by 泡果 on 2018/5/31.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZMarketViewController.h"
#import "PSSSegmentViewController.h"
#import "ZMarketSortEditViewController.h"

@interface ZMarketViewController ()<PSSSegmentVCDelegate>

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, strong) PSSSegmentViewController *segmentViewController;

@end

@implementation ZMarketViewController
#pragma mark - system
- (void)updateViewConstraints {
    
    [super updateViewConstraints];
}

#pragma mark - private
- (void)z_addSubviews {
    
    [self.view addSubview:self.segmentedControl];
    
    [self.view addSubview:self.segmentViewController.view];
}
- (void)z_layoutNavigation {
    [self hideNavigationBar:YES animated:NO];
    self.title = @"行情";
    [self customNavigationBarWithTitle:@"行情" bgColor:white_color backBtn:nil sel:nil rightBtn:@"icon_edit" sel:@selector(editClicked)];
}
#pragma mark - action
- (void)editClicked {
    ZMarketSortEditViewController *sortEditVC = [ZMarketSortEditViewController new];
    [self.navigationController pushViewController:sortEditVC animated:YES];
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    
    // segment滚到了这一页
    [self.segmentViewController pss_scrollToItemWithIndex:segmentedControl.selectedSegmentIndex animated:NO];
}
#pragma mark - layzLoad
- (HMSegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        // Segmented control with scrolling
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"自选", @"市值", @"基础链", @"金融服务", @"社交通讯", @"分叉币", @"平台币", @"体育娱乐", @"真实性验证", @"广告传媒", @"AI", @"数据存储", @"物联网/DAG", @"内容与版权", @"钱包/交易", @"匿名币", @"AR/VR", @"生物/医疗健康", @"开发者/智能合约"]];
        _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _segmentedControl.frame = CGRectMake(0,0, SCREEN_WIDTH, 50);
        _segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(10, 10, 0, 10);
        _segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionIndicatorColor = MAINCOLOR;
        _segmentedControl.selectionIndicatorHeight = 3;
        [_segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
            NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor grayColor]}];
            return attString;
        }];
        [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}
- (PSSSegmentViewController *)segmentViewController
{
    if (!_segmentViewController) {
        // 初始化 segmentVC
        NSMutableArray *vcModelArr = [NSMutableArray new];
        NSArray *titleArr = @[@"自选", @"市值", @"基础链", @"金融服务", @"社交通讯", @"分叉币", @"平台币", @"体育娱乐", @"真实性验证", @"广告传媒", @"AI", @"数据存储", @"物联网/DAG", @"内容与版权", @"钱包/交易", @"匿名币", @"AR/VR", @"生物/医疗健康", @"开发者/智能合约"];
        for (int i = 0; i < titleArr.count; i++) {
            PSSViewControllerModel *vcModel = [[PSSViewControllerModel alloc] init];
            vcModel.vcClass = [ZMarketSegmentContentController class];
            vcModel.vcID =  i;
            [vcModelArr addObject:vcModel];
        }
        _segmentViewController = [[PSSSegmentViewController alloc] initWithViewControllers:vcModelArr];
        _segmentViewController.view.frame = CGRectMake(0, CGRectGetMaxY(self.segmentedControl.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.segmentedControl.frame) - (iPhoneX?IPHONEX_BOTTOM_BACK_BAR_H:0));
        [self.view addSubview:_segmentViewController.view];
        [self addChildViewController:_segmentViewController];
        
        // 默认在第几页
        _segmentViewController.defaultIndex = 1;
        
        // 控制器12秒刷新一次缓存
        _segmentViewController.refreshTime = 0;
        
        _segmentViewController.delegate = self;
    }
    return _segmentViewController;
}
#pragma mark - PSSSegmentViewControllerDelegate
- (void)pss_segmentVCModel:(PSSViewControllerModel *)vcModel didShowWithIndex:(NSInteger)index
{
    // 分页滚到了这一页
    [self.segmentedControl setSelectedSegmentIndex:index animated:YES];
}
// 在控制器调用ViewDidLoad之前调用
- (void)pss_segmentVCModel:(PSSViewControllerModel *)vcModel didLoadItemWithIndex:(NSInteger)index
{
    ZMarketSegmentContentController *testVC = (ZMarketSegmentContentController *)vcModel.viewController;
    testVC.ID = vcModel.vcID;
}
- (void)pss_segmengVCModel:(PSSViewControllerModel *)vcModel timeOutItemWithIndex:(NSInteger)index
{
    // vc达到缓存时间时调用;
    // 如果实现了这个代理方法，就不会删除控制器和视图；如果没实现这个方法，到时间之后帮你清除控制器
}

@end
