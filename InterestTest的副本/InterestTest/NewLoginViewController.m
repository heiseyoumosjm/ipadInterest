//
//  NewLoginViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/3/1.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "NewLoginViewController.h"
#import "LoginViewController.h"
#import "GetCodeViewController.h"
#import "IQKeyboardReturnKeyHandler.h"

@interface NewLoginViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;
@end

@implementation NewLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationBarHidden=YES;
     self.view.backgroundColor=[UIColor yellowColor];
     _backImg.image=[UIImage imageNamed:@"loginBackView"];
     _phoneLab.delegate=self;
    //_backImg.backgroundColor=[UIColor redColor];
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    self.returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    [self addNoticeForKeyboard];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
#pragma mark - 输入结束时代理方法
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _phoneLab)
    {
        NSString *name = _phoneLab.text;
        //使用正则表达式判断手机号码或邮箱号码是否正确
        if(![[ToolHelper toolHelper] validateEmail:name] && ![[ToolHelper toolHelper] validatePhone:name])
        {
            [[HudHelper hudHepler] showStillShortTips:self.view tips:@"请输入正确的手机号码"];
             _loginBtn.backgroundColor=UIColorFromRGB(0xcccccc);
            [_loginBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        else
        {
            _loginBtn.backgroundColor=[UIColor clearColor];
          [_loginBtn setBackgroundImage:[UIImage imageNamed:@"icon_log"] forState:UIControlStateNormal];
          
        }
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == _phoneLab)
    {
        NSString *name = _phoneLab.text;
        //使用正则表达式判断手机号码或邮箱号码是否正确
        if(![[ToolHelper toolHelper] validateEmail:name] && ![[ToolHelper toolHelper] validatePhone:name])
        {
            
             _loginBtn.backgroundColor=UIColorFromRGB(0xcccccc);
            [_loginBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            
        }
        else
        {
            _loginBtn.backgroundColor=[UIColor clearColor];
            [_loginBtn setBackgroundImage:[UIImage imageNamed:@"icon_log"] forState:UIControlStateNormal];
            
        }
    }

}


- (IBAction)next:(UIButton *)sender {
    if(![[ToolHelper toolHelper] validatePhone:_phoneLab.text])
    {
        [[HudHelper hudHepler] showStillShortTips:self.view tips:@"请输入正确的手机号码"];
         _loginBtn.backgroundColor=UIColorFromRGB(0xcccccc);
        [_loginBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    else
    {
        _loginBtn.backgroundColor=[UIColor clearColor];
        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"icon_log"] forState:UIControlStateNormal];
        GetCodeViewController *getcode=[[GetCodeViewController alloc]init];
        if ([self isBlankString:_type]) {
         getcode.type=@"1";
        }else{
        getcode.type=_type;
        }
        getcode.name=_phoneLab.text;
        [self.navigationController pushViewController:getcode animated:YES];

        
    }

}

- (IBAction)goLogin:(UIButton *)sender {
    LoginViewController *login=[[LoginViewController alloc]init];
    login.type=_typeinfp;
    [self.navigationController pushViewController:login animated:YES];
}

#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
    
//    //注册键盘出现的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide2:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    //    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = _height.constant-155;
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            _height.constant=offset;
            //            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide2:(NSNotification *)notify {
    // 键盘动画时间
//    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    
//    //视图下沉恢复原状
//    [UIView animateWithDuration:duration animations:^{
//        _height.constant=165;
//    }];
    if (_phoneLab.isEditing) {
        
    if(![[ToolHelper toolHelper] validatePhone:_phoneLab.text])
    {
        [[HudHelper hudHepler] showStillShortTips:self.view tips:@"请输入正确的手机号码"];
        _loginBtn.backgroundColor=UIColorFromRGB(0xcccccc);
        [_loginBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    else
    {
        _loginBtn.backgroundColor=[UIColor clearColor];
        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"icon_log"] forState:UIControlStateNormal];
        GetCodeViewController *getcode=[[GetCodeViewController alloc]init];
        if ([self isBlankString:_type]) {
            getcode.type=@"1";
        }else{
            getcode.type=_type;
        }
        getcode.name=_phoneLab.text;
        [self.navigationController pushViewController:getcode animated:YES];
        
        
    }
    }
}

@end
