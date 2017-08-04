//
//  SettingPswViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/3/1.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "SettingPswViewController.h"
#import "LoginViewController.h"
#import "RootHttpHelper.h"
#import "MickeyTools.h"
#import "ThemeViewController.h"
#import "LeftViewController.h"
#import "SWRevealViewController.h"
#import "UserModel.h"
#import "HttpHelper.h"
#import "NewLoginViewController.h"
#import "ResultViewController.h"
#import "UserInfoViewController.h"

@interface SettingPswViewController ()<SWRevealViewControllerDelegate>

@end

@implementation SettingPswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_type integerValue]==1) {
        
    }else{
         _pswLab.placeholder=@"重置密码";
    }
     self.navigationController.navigationBarHidden=YES;
     _backImg.image=[UIImage imageNamed:@"loginBackView"];
    [self addNoticeForKeyboard];
    // Do any additional setup after loading the view from its nib.
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
-(void)setUserInfo{
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *user_name=[userDefaultes stringForKey:@"user_name"];
    NSString *user_mobile=[userDefaultes stringForKey:@"track_name"];
    NSString *user_sex=[userDefaultes stringForKey:@"user_sex"];
    
    
    //退回到LoginHome页面
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:user_name forKey:@"name"];
    [params setValue:user_mobile forKey:@"track_name"];
    [params setValue:user_sex forKey:@"sex"];
    [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"user/set-message" andParams:params andSuccess:^(NSDictionary *successData) {
        
    } andError:^(NSError *error) {
        //加载圈圈(显示)
    }];
    
    
    
}

- (IBAction)register1:(UIButton *)sender {
    if ([self isBlankString:_pswLab.text]) {
        [[HudHelper hudHepler] showTips:self.view tips:@"密码不能为空" ];
        
    }else{
        if ([_type integerValue]==2) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:_phone forKey:@"mobile"];
            [params setValue:_pswLab.text forKey:@"password"];
            [params setValue:_code forKey:@"verification"];
            [[RootHttpHelper httpHelper] postAchieveListParamsURL:@"auth/reset/password" andParams:params andSuccess:^(NSDictionary *successData) {
                //加载圈圈(显示)
                [[HudHelper hudHepler] HideHUDAlert:self.view];
                if([[successData objectForKey:@"code"] integerValue]==200)
                {
                    ThemeViewController *theme=[[ThemeViewController alloc]init];
                    LeftViewController  *left=[[LeftViewController alloc]init];
                    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:theme];
                    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:left];
                    
                    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
                    revealController.delegate = self;
                    [self.navigationController pushViewController:revealController animated:YES];
                }
                else
                {
                    [self.navigationController popViewControllerAnimated:YES];
                    [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"message"] ] ;
                }
           
            } andError:^(NSError *error) {
                NSLog(@"%@",error);
                [[HudHelper hudHepler] HideHUDAlert:self.view];
                if ([[MickeyTools getErrorStringWithError:error] isEqualToString:@"登陆信息过期,需要重新登陆"]) {
                    
                }else{
                    [[HudHelper hudHepler] showTips:self.view tips:[MickeyTools getErrorStringWithError:error] ] ;
                }

            }];

            
        }else{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:_phone forKey:@"mobile"];
        [params setValue:_pswLab.text forKey:@"password"];
        [params setValue:_code forKey:@"verification"];
        //加载圈圈(显示)
        [[HudHelper hudHepler] ShowHUDAlert:self.view];
        
        [[RootHttpHelper httpHelper] postAchieveListParamsURL:@"auth/register" andParams:params andSuccess:^(NSDictionary *successData) {
            //加载圈圈(显示)
            [[HudHelper hudHepler] HideHUDAlert:self.view];
            NSError *err = nil;
            UserModel *userModel = [[UserModel alloc] initWithDictionary:successData error:&err];
            
            if([[successData objectForKey:@"code"] integerValue]==200)
            {
                [self setUserInfo];
                [self getUserTestResult];
//                //发通知侧边栏可以点击展开测试结果界面
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginin" object:nil];
                [[RootHttpHelper httpHelper] setUserToken:userModel.token];
                [[HttpHelper httpHelper] setUserToken:userModel.token];
                NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                [defaults setObject:userModel.token forKey:@"usertoken"];
                [defaults synchronize];
                
                 //发通知侧边栏可以点击展开测试结果界面
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginin" object:nil];
//                ThemeViewController *theme=[[ThemeViewController alloc]init];
//                LeftViewController  *left=[[LeftViewController alloc]init];
//                UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:theme];
//                UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:left];
//                
//                SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
//                revealController.delegate = self;
//                [self.navigationController pushViewController:revealController animated:YES];
            }
            else
            {
                 [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"message"] ] ;
                 [self.navigationController popViewControllerAnimated:YES];
            }
           
        } andError:^(NSError *error) {
            
            NSLog(@"%@",error);
            [[HudHelper hudHepler] HideHUDAlert:self.view];
            if ([[MickeyTools getErrorStringWithError:error] isEqualToString:@"登陆信息过期,需要重新登陆"]) {
                
            }else{
//                [self.view makeToast:[MickeyTools getErrorStringWithError:error] duration:1.5 position:ToastDefaultPositionTop];
                [[HudHelper hudHepler] showTips:self.view tips:[MickeyTools getErrorStringWithError:error] ] ;
            }
          
        }];
    }
    }

    
    
}
- (void)getUserTestResult
{
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"user/get-boolean-test" andParams:nil andSuccess:^(NSDictionary *successData) {
        if ([[successData objectForKey:@"api_code"] integerValue]==401){
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的账号已在别处登陆了，请重新登录！" preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSLog(@"+++++++++++++++退出");
                UserInfoViewController *theme=[[UserInfoViewController alloc]init];
                [self.navigationController pushViewController:theme animated:YES];
                
            }]];
            [self presentViewController:alertView animated:YES completion:nil];
        }
        if ([[successData objectForKey:@"data"] integerValue]==1) {
            
            NSMutableDictionary *dic=[successData objectForKey:@"test"];
            NSMutableDictionary *colorDic=[[NSMutableDictionary alloc]init];
            colorDic=[dic objectForKey:@"colorAttr"];
            NSMutableDictionary *styleAttr=[[NSMutableDictionary alloc]init];
            styleAttr=[dic objectForKey:@"styleAttr"];
            
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            if ([self isBlankString:[colorDic objectForKey:@"color_sentence"]]) {
                
            }else{
                [defaults setObject:[colorDic objectForKey:@"color_sentence"] forKey:@"color_sentence"];
            }
            if ([self isBlankString:[styleAttr objectForKey:@"fg_sentence"]]) {
                
            }else{
                [defaults setObject:[styleAttr objectForKey:@"fg_sentence"] forKey:@"fg_sentence"];
            }
            if ([styleAttr objectForKey:@"result_imgs"]) {
                [defaults setObject:[styleAttr objectForKey:@"result_imgs"] forKey:@"result_imgs"];
            }
            if ([self isBlankString:[styleAttr objectForKey:@"son_name"]]) {
                if ([styleAttr objectForKey:@"name"]) {
                    [defaults setObject:[styleAttr objectForKey:@"name"] forKey:@"name"];
                }
                
            }else{
                if ([styleAttr objectForKey:@"son_name"]) {
                    [defaults setObject:[styleAttr objectForKey:@"son_name"] forKey:@"name"];
                }
            }
            
            
            [defaults synchronize];
            ResultViewController *theme=[[ResultViewController alloc]init];
            LeftViewController  *left=[[LeftViewController alloc]init];
            UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:theme];
            UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:left];
            
            SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
            revealController.delegate = self;
            [self.navigationController pushViewController:revealController animated:YES];

            
        }else{
            ThemeViewController *theme=[[ThemeViewController alloc]init];
            LeftViewController  *left=[[LeftViewController alloc]init];
            UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:theme];
            UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:left];
            
            SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
            revealController.delegate = self;
            [self.navigationController pushViewController:revealController animated:YES];
            
        }
        
    } andError:^(NSError *error) {
        //加载圈圈(显示)
        NSLog(@"%@",error);
    }];
    
    
    
}

- (IBAction)tologin:(UIButton *)sender {
    LoginViewController *login=[[LoginViewController alloc]init];
    [self.navigationController pushViewController:login animated:YES];
}

#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
//    
//    //注册键盘出现的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide3:)
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
///键盘消失事件
- (void) keyboardWillHide3:(NSNotification *)notify {
//    // 键盘动画时间
//    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    
//    //视图下沉恢复原状
//    [UIView animateWithDuration:duration animations:^{
//        _height.constant=165;
//    }];
    if (_pswLab.isEditing) {
  
    if ([self isBlankString:_pswLab.text]) {
        [[HudHelper hudHepler] showTips:self.view tips:@"密码不能为空" ];
        
    }else{
        if ([_type integerValue]==2) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:_phone forKey:@"mobile"];
            [params setValue:_pswLab.text forKey:@"password"];
            [params setValue:_code forKey:@"verification"];
            [[RootHttpHelper httpHelper] postAchieveListParamsURL:@"auth/reset/password" andParams:params andSuccess:^(NSDictionary *successData) {
                //加载圈圈(显示)
                [[HudHelper hudHepler] HideHUDAlert:self.view];
                if([[successData objectForKey:@"code"] integerValue]==200)
                {
                    ThemeViewController *theme=[[ThemeViewController alloc]init];
                    LeftViewController  *left=[[LeftViewController alloc]init];
                    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:theme];
                    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:left];
                    
                    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
                    revealController.delegate = self;
                    [self.navigationController pushViewController:revealController animated:YES];
                }
                else
                {
                    [self.navigationController popViewControllerAnimated:YES];
                    [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"message"] ] ;
                }
                
            } andError:^(NSError *error) {
                NSLog(@"%@",error);
                [[HudHelper hudHepler] HideHUDAlert:self.view];
                if ([[MickeyTools getErrorStringWithError:error] isEqualToString:@"登陆信息过期,需要重新登陆"]) {
                    
                }else{
                    [[HudHelper hudHepler] showTips:self.view tips:[MickeyTools getErrorStringWithError:error] ] ;
                }
                
            }];
            
            
        }else{
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:_phone forKey:@"mobile"];
            [params setValue:_pswLab.text forKey:@"password"];
            [params setValue:_code forKey:@"verification"];
            //加载圈圈(显示)
            [[HudHelper hudHepler] ShowHUDAlert:self.view];
            
            [[RootHttpHelper httpHelper] postAchieveListParamsURL:@"auth/register" andParams:params andSuccess:^(NSDictionary *successData) {
                //加载圈圈(显示)
                [[HudHelper hudHepler] HideHUDAlert:self.view];
                NSError *err = nil;
                UserModel *userModel = [[UserModel alloc] initWithDictionary:successData error:&err];
                
                if([[successData objectForKey:@"code"] integerValue]==200)
                {
                    [self setUserInfo];
//                    [self getUserTestResult];
                   
                    [[RootHttpHelper httpHelper] setUserToken:userModel.token];
                    [[HttpHelper httpHelper] setUserToken:userModel.token];
                    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                    [defaults setObject:userModel.token forKey:@"usertoken"];
                    [defaults synchronize];
                    
                    //发通知侧边栏可以点击展开测试结果界面
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginin" object:nil];
                    [self getUserTestResult];
                    
//                    ThemeViewController *theme=[[ThemeViewController alloc]init];
//                    LeftViewController  *left=[[LeftViewController alloc]init];
//                    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:theme];
//                    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:left];
//                    
//                    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
//                    revealController.delegate = self;
//                    [self.navigationController pushViewController:revealController animated:YES];
                }
                else
                {
                    [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"message"] ] ;
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            } andError:^(NSError *error) {
                
                NSLog(@"%@",error);
                [[HudHelper hudHepler] HideHUDAlert:self.view];
                if ([[MickeyTools getErrorStringWithError:error] isEqualToString:@"登陆信息过期,需要重新登陆"]) {
                    
                }else{
                    //                [self.view makeToast:[MickeyTools getErrorStringWithError:error] duration:1.5 position:ToastDefaultPositionTop];
                    [[HudHelper hudHepler] showTips:self.view tips:[MickeyTools getErrorStringWithError:error] ] ;
                }
                
            }];
        }
    }
    }

}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
