//
//  ZLoginViewController.m
//  BaseProject
//
//  Created by 泡果 on 2018/6/5.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZLoginViewController.h"
#import "EKAnimationTextField.h"
#import "ACFloatingTextField.h"
#import "SubmitView.h"

@interface ZLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) ZView *inputView;

@property (nonatomic, strong) ZView *bottomView;

@property (nonatomic, strong) ACFloatingTextField *account;

@property (nonatomic, strong) ACFloatingTextField *password;

@property (nonatomic, strong) UIButton *loginButton;

//@property (nonatomic, strong) SubmitView *subView;

@end

@implementation ZLoginViewController
#pragma mark - system
- (void)updateViewConstraints
{
    WS(weakSelf)
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.height.equalTo(weakSelf.view.height * 0.5);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.inputView).offset(50);
        make.bottom.equalTo(weakSelf.inputView).offset(- 50);
        make.right.equalTo(weakSelf.inputView).offset(- 50);
        make.height.equalTo(40);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.height.equalTo(weakSelf.view.height * 0.5);
    }];
    [super updateViewConstraints];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
#pragma mark - private
- (void)z_addSubviews
{
    [self.view addSubview:self.inputView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.loginButton];
    
    RegisterNotify(UITextFieldTextDidChangeNotification, @selector(textFieldDidChange:))
}
- (void)z_layoutNavigation
{
    [self customNavigationBarWithTitle:@"登录" bgColor:white_color backBtn:@"icon_back_black" sel:@selector(dismissClicked) rightBtn:nil sel:nil];
}
#pragma mark - lazyload
- (UIView *)inputView
{
    if (!_inputView) {
        _inputView = [[ZView alloc] init];
        
        UIImageView *accoutIcon = [[UIImageView alloc] init];
        accoutIcon.contentMode = UIViewContentModeScaleAspectFit;
        accoutIcon.image = ImageNamed(@"icon_login_phone");
        [_inputView addSubview:accoutIcon];
        
        _account = [[ACFloatingTextField alloc] init];
        _account.delegate = self;
        _account.lineColor = lightGray_color;
        _account.selectedLineColor = MAINCOLOR;
        _account.placeHolderColor = lightGray_color;
        _account.selectedPlaceHolderColor = gray_color;
        _account.errorTextColor = red_color;
        _account.errorLineColor = red_color;
        _account.textColor = black_color;
        _account.tintColor = MAINCOLOR;
        _account.placeholder = @"请输入手机号码";
        _account.disableFloatingLabel = YES;
        [_inputView addSubview:_account];
        
        UIImageView *passwordIcon = [[UIImageView alloc] init];
        passwordIcon.contentMode = UIViewContentModeScaleAspectFill;
        passwordIcon.image = ImageNamed(@"icon_login_password");
        [_inputView addSubview:passwordIcon];
        
        _password = [[ACFloatingTextField alloc] init];
        _password.delegate = self;
        _password.secureTextEntry = YES;
        _password.lineColor = lightGray_color;
        _password.selectedLineColor = MAINCOLOR;
        _password.placeHolderColor = lightGray_color;
        _password.selectedPlaceHolderColor = gray_color;
        _password.errorTextColor = red_color;
        _password.errorLineColor = red_color;
        _password.textColor = black_color;
        _password.tintColor = MAINCOLOR;
        _password.placeholder = @"请输入密码";
        _password.disableFloatingLabel = YES;
        [_inputView addSubview:_password];
        
        CGFloat height = 40;
        CGFloat padding = 40;
        WS(weakSelf)
        [accoutIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.inputView).offset(padding);
            make.top.equalTo(weakSelf.inputView).offset(kNavHeight + 60);
            make.size.equalTo(CGSizeMake(height, height));
        }];
        [_account mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(accoutIcon).offset(padding);
            make.top.equalTo(weakSelf.inputView).offset(kNavHeight + 60);
            make.right.equalTo(weakSelf.inputView).offset(-padding);
            make.height.equalTo(height);
        }];
        [passwordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.inputView).offset(padding);
            make.top.equalTo(accoutIcon).offset(60);
            make.size.equalTo(CGSizeMake(height, height));
        }];
        [_password mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(passwordIcon).offset(padding);
            make.top.equalTo(weakSelf.account).offset(60);
            make.right.equalTo(weakSelf.inputView).offset(-padding);
            make.height.equalTo(height);
        }];
    }
    return _inputView;
}
- (ZView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[ZView alloc] init];
        
        UIButton *registerBtn = [[UIButton alloc] init];
        [registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
        [registerBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
        registerBtn.titleLabel.font = FONT(15);
        [registerBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        registerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [registerBtn addTarget:self action:@selector(registerClicked)];
        [_bottomView addSubview:registerBtn];
        
        UIView *devider = [[UIView alloc] init];
        devider.backgroundColor = MAINCOLOR;
        [_bottomView addSubview:devider];
        
        UIButton *forgetPasswordBtn = [[UIButton alloc] init];
        [forgetPasswordBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [forgetPasswordBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
        forgetPasswordBtn.titleLabel.font = FONT(15);
        [forgetPasswordBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        forgetPasswordBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [forgetPasswordBtn addTarget:self action:@selector(forgetPasswordBtnClicked)];
        [_bottomView addSubview:forgetPasswordBtn];
        
        UILabel *loginTipLabel = [[UILabel alloc] init];
        loginTipLabel.text = @"使用社交账号";
        loginTipLabel.font = FONT(15.0);
        loginTipLabel.textAlignment = NSTextAlignmentCenter;
        loginTipLabel.textColor = MAINCOLOR;
        [_bottomView addSubview:loginTipLabel];
        
        UIButton *QQLogin = [[UIButton alloc] init];
        [QQLogin setImage:ImageNamed(@"icon_qq") forState:UIControlStateNormal];
        QQLogin.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [QQLogin addTarget:self action:@selector(QQLoginClicked)];
        [_bottomView addSubview:QQLogin];
        
        UIButton *wechatLogin = [[UIButton alloc] init];
        [wechatLogin setImage:ImageNamed(@"icon_wechat") forState:UIControlStateNormal];
        wechatLogin.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [wechatLogin addTarget:self action:@selector(wechatLoginClicked)];
        [_bottomView addSubview:wechatLogin];
        
        WS(weakSelf)
        [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.bottomView);
            make.top.equalTo(weakSelf.bottomView);
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH * 0.5 - 0.5, 30));
        }];
        [forgetPasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.bottomView);
            make.top.equalTo(weakSelf.bottomView);
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH * 0.5 - 0.5, 30));
        }];
        [devider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.bottomView);
            make.top.equalTo(weakSelf.bottomView).offset(5);
            make.size.equalTo(CGSizeMake(1, 20));
        }];
        [loginTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.bottomView);
            make.top.equalTo(weakSelf.bottomView).offset(100);
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH, 30));
        }];
        [wechatLogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.bottomView);
            make.bottom.equalTo(weakSelf.bottomView).offset(-60 - kTabBarHeight);
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH * 0.5, 100));
        }];
        [QQLogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.bottomView);
            make.bottom.equalTo(weakSelf.bottomView).offset(-60 - kTabBarHeight);
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH * 0.5, 100));
        }];
    }
    return _bottomView;
}
- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] init];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        _loginButton.titleLabel.font = FONT(15);
        _loginButton.backgroundColor = MAINCOLOR;
        _loginButton.layer.cornerRadius = 20;
        [_loginButton addTarget:self action:@selector(login:)];
    }
    return _loginButton;
}
//- (SubmitView *)subView
//{
//    if (!_subView) {
//        _subView = [[SubmitView alloc] initWithFrame:CGRectMake(50, self.view.height * 0.5 - 50, SCREEN_WIDTH - 100, 50)];
//        WS(weakSelf)
//        _subView.clickedSubmitBlock = ^(SubmitButton *button) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [weakSelf.subView loadCompletefailure];
//            });
//        };
//    }
//    return _subView;
//}
#pragma mark - textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    ZLog(@"%@",textField.text);
    return YES;
}
#pragma mark - action
- (void)textFieldDidChange:(NSNotification *)note {
    
    ACFloatingTextField *textField = note.object;
    if ([textField isEqual:self.account]) {
        if (textField.text.length > 11) {
            [textField showErrorWithText:@"输入的号码有误"];
        }
    }else{
    }
}
- (void)login:(UIButton *)button
{
}
- (void)dismissClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)registerClicked
{
    ZRegisterViewController *registerVC = [[ZRegisterViewController alloc] init];
    [self presentViewController:registerVC animated:YES completion:nil];
}
- (void)forgetPasswordBtnClicked {
    
}
- (void)QQLoginClicked {
    
}
- (void)wechatLoginClicked {
    
}
@end
