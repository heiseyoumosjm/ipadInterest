//
//  LoginViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/3/1.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "LoginViewController.h"
#import "NewLoginViewController.h"
#import "RootHttpHelper.h"
#import "UserModel.h"
#import "MickeyTools.h"
#import "ThemeViewController.h"
#import "SWRevealViewController.h"
#import "LeftViewController.h"
#import "NewLoginViewController.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "HttpHelper.h"
#import "ResultViewController.h"
#import "UserInfoViewController.h"
#import "NewInterestTestViewController.h"

@interface LoginViewController ()<SWRevealViewControllerDelegate>
@property(nonatomic,strong)UserModel *userModel;
@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    _backImg.image=[UIImage imageNamed:@"loginBackView"];
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
- (IBAction)tologin:(UIButton *)sender {
    NSLog(@"++++++++++++登陆按钮点击事件");
    NSString *name = _phone.text;
    NSString *pass = _password.text;
    if(![name isEqualToString:@""] && ![pass isEqualToString:@""])
    {
        if (![[ToolHelper toolHelper] validatePhone:name]) {
            [[HudHelper hudHepler] showTips:self.view tips:@"请输入正确的手机号码"];
        }else{
        //加载圈圈(显示)
        [[HudHelper hudHepler] ShowHUDAlert:self.view];
        
        //退回到LoginHome页面
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:name forKey:@"mobile"];
        [params setValue:pass forKey:@"password"];
        [[RootHttpHelper httpHelper] postAchieveListParamsURL:@"auth/login" andParams:params andSuccess:^(NSDictionary *successData) {
        //加载圈圈(显示)
       [[HudHelper hudHepler] HideHUDAlert:self.view];
//            
            NSError *err = nil;
            _userModel = [[UserModel alloc] initWithDictionary:successData error:&err];
            
            if([_userModel.code isEqualToString:@"200"])
            {
                [[RootHttpHelper httpHelper] setUserToken:_userModel.token];
                [[HttpHelper httpHelper] setUserToken:_userModel.token];
                NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                [defaults setObject:_userModel.token forKey:@"usertoken"];
                [defaults setObject:_userModel.avatar forKey:@"avator"];
                [defaults synchronize];
                //发通知侧边栏可以点击展开测试结果界面
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginin" object:nil];
                [self setUserInfo];
                [self getUserTestResult];
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
                [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"message"]];
            }
            
        } andError:^(NSError *error) {
            //加载圈圈(显示)
            [[HudHelper hudHepler] HideHUDAlert:self.view];
            NSLog(@"%@",error);
            if ([[MickeyTools getErrorStringWithError:error] isEqualToString:@"登陆信息过期,需要重新登陆"]) {
                
            }else{
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
            if ([_type integerValue]==3) {
             ResultViewController *theme=[[ResultViewController alloc]init];
            [self.navigationController pushViewController:theme animated:YES];
                
            }else{
            ThemeViewController *theme=[[ThemeViewController alloc]init];
            LeftViewController  *left=[[LeftViewController alloc]init];
            UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:theme];
            UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:left];
            
            SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
            revealController.delegate = self;
            [self.navigationController pushViewController:revealController animated:YES];
            }
        
        }else{
            if ([_type integerValue]==3) {
                ThemeViewController *theme=[[ThemeViewController alloc]init];
                [self.navigationController pushViewController:theme animated:YES];
                
            }else{
            ThemeViewController *theme=[[ThemeViewController alloc]init];
            LeftViewController  *left=[[LeftViewController alloc]init];
            UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:theme];
            UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:left];
            
            SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
            revealController.delegate = self;
            [self.navigationController pushViewController:revealController animated:YES];
            
        }
        }
        
    } andError:^(NSError *error) {
        //加载圈圈(显示)
        NSLog(@"%@",error);
    }];
    
    
    
}


- (IBAction)forgetPsw:(UIButton *)sender {
    NewLoginViewController *setPsw=[[NewLoginViewController alloc]init];
    setPsw.type=@"2";
    [self.navigationController pushViewController:setPsw animated:YES];
    
}

- (IBAction)toRegister:(UIButton *)sender {
    NewLoginViewController *toregister=[[NewLoginViewController alloc]init];
    toregister.type=@"1";
   [self.navigationController pushViewController:toregister animated:YES];
}

#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
    
//    //注册键盘出现的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide1:)
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
- (void) keyboardWillHide1:(NSNotification *)notify {
    // 键盘动画时间
//    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    
//    //视图下沉恢复原状
//    [UIView animateWithDuration:duration animations:^{
//        _height.constant=165;
//    }];
    if (_password.isEditing) {
        
    NSString *name = _phone.text;
    NSString *pass = _password.text;
    if(![name isEqualToString:@""] && ![pass isEqualToString:@""])
    {
        if (![[ToolHelper toolHelper] validatePhone:name]) {
            [[HudHelper hudHepler] showTips:self.view tips:@"请输入正确的手机号码"];
        }else{
            //加载圈圈(显示)
            [[HudHelper hudHepler] ShowHUDAlert:self.view];
            
            //退回到LoginHome页面
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:name forKey:@"mobile"];
            [params setValue:pass forKey:@"password"];
            [[RootHttpHelper httpHelper] postAchieveListParamsURL:@"auth/login" andParams:params andSuccess:^(NSDictionary *successData) {
                //加载圈圈(显示)
                [[HudHelper hudHepler] HideHUDAlert:self.view];
                //
                NSError *err = nil;
                _userModel = [[UserModel alloc] initWithDictionary:successData error:&err];
                
                if([_userModel.code isEqualToString:@"200"])
                {
                    [[RootHttpHelper httpHelper] setUserToken:_userModel.token];
                    [[HttpHelper httpHelper] setUserToken:_userModel.token];
                    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                    [defaults setObject:_userModel.token forKey:@"usertoken"];
                    [defaults setObject:_userModel.avatar forKey:@"avator"];
                    [defaults synchronize];
                    //发通知侧边栏可以点击展开测试结果界面
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginin" object:nil];
                    [self setUserInfo];
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
                    [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"message"]];
                }
                
            } andError:^(NSError *error) {
                //加载圈圈(显示)
                [[HudHelper hudHepler] HideHUDAlert:self.view];
                NSLog(@"%@",error);
                if ([[MickeyTools getErrorStringWithError:error] isEqualToString:@"登陆信息过期,需要重新登陆"]) {
                    
                }else{
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
