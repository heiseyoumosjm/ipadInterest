//
//  GetCodeViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/3/1.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "GetCodeViewController.h"
#import "RootHttpHelper.h"
#import "SettingPswViewController.h"
#import "LoginViewController.h"


@interface GetCodeViewController ()
{
    NSTimer *timer;       //计时器
    NSInteger second;     //定义秒数
}
@end

@implementation GetCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationBarHidden=YES;
     _backImg.image=[UIImage imageNamed:@"loginBackView"];
    [self initview];
    [self addNoticeForKeyboard];
    // Do any additional setup after loading the view from its nib.
}
-(void)initview
{
     _auteCodeBut.userInteractionEnabled = NO;
     second = 60;
    //发送验证码
    [self getCodeNum:_name];
    
}
#pragma mark - 发送验证码
-(void)getCodeNum:(NSString *)name
{
    if ([_type integerValue]==1) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:name forKey:@"mobile"];
        //加载圈圈(显示)
        [[HudHelper hudHepler] ShowHUDAlert:self.view];
        
        [[RootHttpHelper httpHelper] postAchieveListParamsURL:@"sms/register" andParams:params andSuccess:^(NSDictionary *successData) {
            //加载圈圈(显示)
            [[HudHelper hudHepler] HideHUDAlert:self.view];
            if([[successData objectForKey:@"code"] integerValue]==200)
            {
                
                [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"message"] ] ;
                 timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerCounter) userInfo:nil repeats:YES];
              
            }
            else
            {

                [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"message"] ] ;
                [self.navigationController popViewControllerAnimated:YES];
            }

        } andError:^(NSError *error) {
            //加载圈圈(显示)
            [[HudHelper hudHepler] HideHUDAlert:self.view];
            NSLog(@"%@",error);
            if ([[self getErrorStringWithError:error] isEqualToString:@"登陆信息过期,需要重新登陆"]) {
                
            }else{
                [[HudHelper hudHepler] showTips:self.view tips:[self getErrorStringWithError:error] ] ;
            }
        
        }];

        
    }else{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:name forKey:@"mobile"];
    //加载圈圈(显示)
    [[HudHelper hudHepler] ShowHUDAlert:self.view];
    
    [[RootHttpHelper httpHelper] postAchieveListParamsURL:@"sms/reset/password" andParams:params andSuccess:^(NSDictionary *successData) {
        //加载圈圈(显示)
        [[HudHelper hudHepler] HideHUDAlert:self.view];
        if([[successData objectForKey:@"code"] integerValue]==200)
        {
            [self.view makeToast:[successData objectForKey:@"message"] duration:1.5 position:ToastDefaultPositionTop];
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerCounter) userInfo:nil repeats:YES];
     
        }
        else
        {
            [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"message"] ] ;
            [self.navigationController popViewControllerAnimated:YES];

        }
//        //加载圈圈(显示)
//        [[HudHelper hudHepler] HideHUDAlert:self.view];
    } andError:^(NSError *error) {
        //加载圈圈(显示)
        [[HudHelper hudHepler] HideHUDAlert:self.view];
        NSData *data = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"===========%@-----%@",error,str);
        NSLog(@"%@",error);
        if ([[self getErrorStringWithError:error] isEqualToString:@"登陆信息过期,需要重新登陆"]) {
            
        }else{
            [[HudHelper hudHepler] showTips:self.view tips:[self getErrorStringWithError:error] ] ;
        }
       
    }];
    }
}

#pragma mark - 倒计时，计时器
- (void)timerCounter
{
    second = second - 1;
    if (second == 0)
    {
        [_auteCodeBut setTitle:@"发送验证码" forState:UIControlStateNormal];
        [timer invalidate];
        _auteCodeBut.userInteractionEnabled = YES;
        second = 60;
    }
    else
    {
        [_auteCodeBut setTitle:[NSString stringWithFormat:@"%lds重新获取", (long)second] forState:UIControlStateNormal];
         _auteCodeBut.userInteractionEnabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)getCode:(UIButton *)sender {
    _auteCodeBut.userInteractionEnabled = NO;
    second = 60;
    //发送验证码
    [self getCodeNum:_name];
}

- (IBAction)next:(UIButton *)sender {
    if ([self isBlankString:_codelab.text]) {
        
      [[HudHelper hudHepler] showTips:self.view tips:@"验证码不能为空"];
    }else{
        SettingPswViewController *set=[[SettingPswViewController alloc]init];
        set.type=_type;
        set.phone=_name;
        set.code=_codelab.text;
        [self.navigationController pushViewController:set animated:YES];
    }
}

- (IBAction)tologin:(UIButton *)sender {
     LoginViewController *login=[[LoginViewController alloc]init];
    [self.navigationController pushViewController:login animated:YES];
}
-(NSString *)getErrorStringWithError:(NSError *)error
{
    NSString *errString = nil;
    switch (error.code) {
        case NSURLErrorTimedOut:
            errString = @"请求超时";
            break;
        case NSURLErrorNotConnectedToInternet:
            errString = @"无法连接网络,请检查您的网络设置";
            break;
        case NSURLErrorBadServerResponse:
            errString = error.localizedDescription;
            if ([errString isEqualToString:@"Request failed: internal server error (500)"]) {
                
            }else{
                errString = @"登陆信息过期,需要重新登陆";
//                [[UserDBHelper userDBHelper] executeUpdateSql:@"DELETE FROM user"];
//                [AppDelegate appDelegate].usertoken = nil;
//                [[RootHttpHelper httpHelper] setUserToken:[AppDelegate appDelegate].usertoken];
//                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//                [defaults removeObjectForKey:@"fileName"];
//                [defaults removeObjectForKey:@"fileDetaile"];
//                [defaults removeObjectForKey:@"usertoken"];
//                [defaults removeObjectForKey:@"pushState"];
//                [defaults synchronize];
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOut" object:nil];
                //                UINavigationController *nav=[[UINavigationController alloc]init];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"signIn" object:nil];
                //                LoginHomeViewController *login=[[LoginHomeViewController alloc]init];
                //                [nav.tabBarController.childViewControllers[tabBarController.selectedIndex] presentViewController:login animated:YES completion:^{
                //
                //                }];
                
            }
            break;
        default:
            errString = error.localizedDescription;
            break;
    }
    return errString;
}

#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
    
//    //注册键盘出现的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    //    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    if (_codelab.isEditing) {
        if ([self isBlankString:_codelab.text]) {
            
            [[HudHelper hudHepler] showTips:self.view tips:@"验证码不能为空"];
        }else{
            SettingPswViewController *set=[[SettingPswViewController alloc]init];
            set.type=_type;
            set.phone=_name;
            set.code=_codelab.text;
            [self.navigationController pushViewController:set animated:YES];
        }
        
    }
    
//    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
//    CGFloat offset = _height.constant-155;
//    
//    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
//    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    
//    //将视图上移计算好的偏移
//    if(offset > 0) {
//        [UIView animateWithDuration:duration animations:^{
//            _height.constant=offset;
//            //            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
//        }];
//    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        _height.constant=165;
    }];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
@end
