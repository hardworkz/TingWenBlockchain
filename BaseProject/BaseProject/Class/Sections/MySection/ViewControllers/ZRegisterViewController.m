//
//  ZRegisterViewController.m
//  BaseProject
//
//  Created by 泡果 on 2018/6/6.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZRegisterViewController.h"
#import "EKAnimationTextField.h"
#import "ACFloatingTextField.h"
#import "Xzb_CountDownButton.h"

@interface ZRegisterViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) ZView *inputView;

@property (nonatomic, strong) ACFloatingTextField *account;

@property (nonatomic, strong) ACFloatingTextField *verifyCode;

@property (nonatomic, strong) UIButton *registerButton;

@property (nonatomic, strong) Xzb_CountDownButton *sendVerifyCodeBtn;

@end

@implementation ZRegisterViewController
#pragma mark - system
- (void)updateViewConstraints
{
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
    [self.view addSubview:self.registerButton];
    [self.inputView addSubview:self.sendVerifyCodeBtn];
    
    RegisterNotify(UITextFieldTextDidChangeNotification, @selector(textFieldDidChange:))
}
- (void)z_layoutNavigation
{
    [self customNavigationBarWithTitle:@"注册" bgColor:white_color backBtn:@"icon_back_black" sel:@selector(dismissClicked) rightBtn:nil sel:nil];
}
#pragma mark - lazyload
- (UIView *)inputView
{
    if (!_inputView) {
        _inputView = [[ZView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 130)];
        
        UIImageView *accoutIcon = [[UIImageView alloc] init];
        accoutIcon.contentMode = UIViewContentModeScaleAspectFit;
        accoutIcon.image = ImageNamed(@"icon_login_phone");
        accoutIcon.frame = CGRectMake(30, 10, 30, 30);
        [_inputView addSubview:accoutIcon];
        
        _account = [[ACFloatingTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(accoutIcon.frame) + 5, accoutIcon.y - 10, SCREEN_WIDTH - CGRectGetMaxX(accoutIcon.frame) - 45, 50)];
        _account.delegate = self;
        _account.lineColor = gray_color;
        _account.selectedLineColor = black_color;
        _account.placeHolderColor = lightGray_color;
        _account.selectedPlaceHolderColor = gray_color;
        _account.errorTextColor = red_color;
        _account.errorLineColor = red_color;
        _account.textColor = black_color;
        _account.placeholder = @"请输入手机号码";
        _account.disableFloatingLabel = YES;
        [_inputView addSubview:_account];
        
        UIImageView *passwordIcon = [[UIImageView alloc] init];
        passwordIcon.contentMode = UIViewContentModeScaleAspectFill;
        passwordIcon.image = ImageNamed(@"icon_login_password");
        passwordIcon.frame = CGRectMake(accoutIcon.x, CGRectGetMaxY(accoutIcon.frame) + 40, 30, 30);
        [_inputView addSubview:passwordIcon];
        
        _verifyCode = [[ACFloatingTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passwordIcon.frame) + 5, passwordIcon.y - 10, _account.width - 120, 50)];
        _verifyCode.delegate = self;
        _verifyCode.secureTextEntry = YES;
        _verifyCode.lineColor = gray_color;
        _verifyCode.selectedLineColor = black_color;
        _verifyCode.placeHolderColor = lightGray_color;
        _verifyCode.selectedPlaceHolderColor = gray_color;
        _verifyCode.errorTextColor = red_color;
        _verifyCode.errorLineColor = red_color;
        _verifyCode.textColor = black_color;
        _verifyCode.placeholder = @"请输入验证码";
        _verifyCode.disableFloatingLabel = YES;
        [_inputView addSubview:_verifyCode];
    }
    return _inputView;
}
- (UIButton *)registerButton
{
    if (!_registerButton) {
        _registerButton = [[UIButton alloc] init];
        _registerButton.frame = CGRectMake(80, CGRectGetMaxY(self.inputView.frame) + 50, SCREEN_WIDTH - 160, 40);
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        _registerButton.backgroundColor = blue_color;
        _registerButton.layer.cornerRadius = 20;
        [_registerButton addTarget:self action:@selector(registerClicked:)];
    }
    return _registerButton;
}
- (Xzb_CountDownButton *)sendVerifyCodeBtn
{
    if (!_sendVerifyCodeBtn) {
        _sendVerifyCodeBtn = [[Xzb_CountDownButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_verifyCode.frame), _verifyCode.y + 10, 120, _verifyCode.height - 10)];
        [_sendVerifyCodeBtn setTitle:@"获取验证码(60)" forState:UIControlStateNormal];
        [_sendVerifyCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendVerifyCodeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
        [_sendVerifyCodeBtn setBackgroundImage:[UIImage imageWithColor:red_color] forState:UIControlStateNormal];
        _sendVerifyCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _sendVerifyCodeBtn.layer.cornerRadius = (_verifyCode.height - 10)/2;
        _sendVerifyCodeBtn.clipsToBounds = YES;
        _sendVerifyCodeBtn.index = 60;
        [_sendVerifyCodeBtn addTarget:self action:@selector(sendVerifyCodeClicked:)];
    }
    return _sendVerifyCodeBtn;
}
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
- (void)registerClicked:(UIButton *)button
{
    
}
- (void)sendVerifyCodeClicked:(Xzb_CountDownButton *)button
{
    [button starWithGCD];
}
- (void)dismissClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
