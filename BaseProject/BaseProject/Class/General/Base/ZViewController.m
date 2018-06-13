//
//  ZViewController.m
//  BaseProject
//
//  Created by 泡果 on 2018/5/28.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZViewController.h"

@interface ZViewController ()

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, assign) BOOL statusBarHidden;
@property (nonatomic, assign) BOOL changeStatusBarAnimated;

@end

@implementation ZViewController

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    ZViewController *viewController = [super allocWithZone:zone];
    
    @weakify(viewController)
    
    [[viewController rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
        
        @strongify(viewController)
        [viewController z_addSubviews];
        [viewController z_bindViewModel];
    }];
    
    [[viewController rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
        
        @strongify(viewController)
        [viewController z_layoutNavigation];
        [viewController z_getNewData];
    }];
    
    return viewController;
}

- (instancetype)initWithViewModel:(id<ZViewModelProtocol>)viewModel {
    
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setIsExtendLayout:NO];
    
    [self z_removeNavgationBarLine];
    
    [self layoutNavigationBar:ImageNamed(@"navigationBarBG@2x.png") titleColor:black_color titleFont:YC_YAHEI_FONT(18) leftBarButtonItem:nil rightBarButtonItem:nil];
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    self.view.backgroundColor = white_color;
}

#pragma mark - system

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    if (self.statusBarStyle) {
        
        return self.statusBarStyle;
    } else {
        
        return UIStatusBarStyleLightContent;
    }
}

- (BOOL)prefersStatusBarHidden {
    
    return self.statusBarHidden;
}

- (void)dealloc {
    
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
}

#pragma mark - private
/**
 *  去除nav 上的line
 */
- (void)z_removeNavgationBarLine {
    
    UIImageView *navBarHairlineImageView;
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    navBarHairlineImageView.hidden = YES;
}
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)setIsExtendLayout:(BOOL)isExtendLayout {
    
    if (!isExtendLayout) {
        [self initializeSelfVCSetting];
    }
}

- (void)initializeSelfVCSetting {
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
}

- (void)changeStatusBarStyle:(UIStatusBarStyle)statusBarStyle
             statusBarHidden:(BOOL)statusBarHidden
     changeStatusBarAnimated:(BOOL)animated {
    
    self.statusBarStyle=statusBarStyle;
    self.statusBarHidden=statusBarHidden;
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }
    else{
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)hideNavigationBar:(BOOL)isHide
                 animated:(BOOL)animated{
    
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.navigationController.navigationBarHidden=isHide;
        }];
    }
    else{
        self.navigationController.navigationBarHidden=isHide;
    }
}

- (void)layoutNavigationBar:(UIImage*)backGroundImage
                 titleColor:(UIColor*)titleColor
                  titleFont:(UIFont*)titleFont
          leftBarButtonItem:(UIBarButtonItem*)leftItem
         rightBarButtonItem:(UIBarButtonItem*)rightItem {
    
    if (backGroundImage) {
        [self.navigationController.navigationBar setBackgroundImage:backGroundImage forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
    if (titleColor&&titleFont) {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:titleColor,NSFontAttributeName:titleFont}];
    }
    else if (titleFont) {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:titleFont}];
    }
    else if (titleColor){
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:titleColor}];
    }
    if (leftItem) {
        self.navigationItem.leftBarButtonItem=leftItem;
    }
    if (rightItem) {
        self.navigationItem.rightBarButtonItem=rightItem;
    }
}
- (void)customNavigationBarWithTitle:(NSString *)title bgColor:(UIColor *)color backBtn:(NSString *)string sel:(SEL)backSel rightBtn:(NSString *)rightString sel:(SEL)rightAction
{
    UIView *navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kNavHeight)];
    navigationBarView.backgroundColor = color;
    [self.view addSubview:navigationBarView];
    
    if (string) {
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(0, kStatusBarHeight, kTopBarHeight, kTopBarHeight);
        //    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 10)];
        leftBtn.imageView.contentMode = UIViewContentModeCenter;
        [leftBtn setImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:backSel?backSel:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
        [navigationBarView addSubview:leftBtn];
    }
    
    if (title) {
        UILabel *topLab = [[UILabel alloc]initWithFrame:CGRectMake(kTopBarHeight, kStatusBarHeight, SCREEN_WIDTH - 2 * kTopBarHeight, kTopBarHeight)];
        topLab.textColor = [UIColor blackColor];
        topLab.font = [UIFont boldSystemFontOfSize:17.0f];
        topLab.text = title;
        topLab.textAlignment = NSTextAlignmentCenter;
        [navigationBarView addSubview:topLab];
    }
    
    if (rightString) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(SCREEN_WIDTH - kTopBarHeight, kStatusBarHeight, kTopBarHeight, kTopBarHeight);
        rightBtn.imageView.contentMode = UIViewContentModeCenter;
        [rightBtn setImage:[UIImage imageNamed:rightString] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:rightAction forControlEvents:UIControlEventTouchUpInside];
        [navigationBarView addSubview:rightBtn];
    }
    
//    UIView *seperatorLine = [[UIView alloc]initWithFrame:CGRectMake(0, kNavHeight - 0.5, SCREEN_WIDTH, 0.5)];
//    [seperatorLine setBackgroundColor:[UIColor lightGrayColor]];
//    [navigationBarView addSubview:seperatorLine];
}
- (void)backClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 屏幕旋转
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationPortrait;
}

#pragma mark - RAC
/**
 *  添加控件
 */
- (void)z_addSubviews {}

/**
 *  绑定
 */
- (void)z_bindViewModel {}

/**
 *  设置navation
 */
- (void)z_layoutNavigation {}

/**
 *  初次获取数据
 */
- (void)z_getNewData {}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
