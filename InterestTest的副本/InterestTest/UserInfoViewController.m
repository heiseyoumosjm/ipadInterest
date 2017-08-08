//
//  UserInfoViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/3/2.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "UserInfoViewController.h"
#import "NewLoginViewController.h"
#import "WelcomeViewController.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "UserLIstViewController.h"
#import "RootHttpHelper.h"
#import "MickeyTools.h"

@interface UserInfoViewController ()<UITextFieldDelegate>
@property(nonatomic ,strong)NSString *sex;
@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _sex=@"0";
     self.navigationController.navigationBarHidden=YES;
     self.view.backgroundColor=[UIColor yellowColor];
     _backImg.image=[UIImage imageNamed:@"loginBackView"];
//    [self addNoticeForKeyboard];
    
     self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
     self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
     self.returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    
    
//    _mobile.delegate=self;
//    _name.delegate=self;
    //Adding done button for textField1
//    [_name addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    
 
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//    [self.view endEditing:YES];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)chooseSex:(UIButton *)sender {
    if (sender.tag==1) {
        [_men setImage:[UIImage imageNamed:@"choosed"] forState:UIControlStateNormal];
        [_women setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
        _sex=@"1";
    }else {
        [_women setImage:[UIImage imageNamed:@"choosed"] forState:UIControlStateNormal];
        [_men setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
        _sex=@"0";
    }
    
}
- (IBAction)checkBtn:(UIButton *)sender {
  
    if ([self isBlankString:_mobile.text]||![[ToolHelper toolHelper] validatePhone:_mobile.text])
    {
        [[HudHelper hudHepler] showTips:self.view tips:@"请输入正确的手机号码！"];
    }
    else if ([self isBlankString:_name.text])
    {
        [[HudHelper hudHepler] showTips:self.view tips:@"密码不能为空！"];
    }else
    {
        //退回到LoginHome页面
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:_mobile.text forKey:@"mobile"];
        [params setValue:_name.text forKey:@"password"];
        [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"sale-staff/login" andParams:params andSuccess:^(NSDictionary *successData) {
            //加载圈圈(显示)
            [[HudHelper hudHepler] HideHUDAlert:self.view];
            
            if ([[successData objectForKey:@"api_code"] integerValue]==200&&[[successData objectForKey:@"status"] integerValue]==1) {
                UserLIstViewController *list=[[UserLIstViewController alloc]init];
                list.user_id=[[successData objectForKey:@"user_info"] objectForKey:@"id"];
                [self.navigationController pushViewController:list animated:YES];
            }else{
                [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"error"]];
            }
            //
//            NSError *err = nil;
//            _userModel = [[UserModel alloc] initWithDictionary:successData error:&err];
//            
//            if([_userModel.code isEqualToString:@"200"])
//            {
//                [[RootHttpHelper httpHelper] setUserToken:_userModel.token];
//                [[HttpHelper httpHelper] setUserToken:_userModel.token];
//                NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//                [defaults setObject:_userModel.token forKey:@"usertoken"];
//                [defaults setObject:_userModel.avatar forKey:@"avator"];
//                [defaults synchronize];
//                //发通知侧边栏可以点击展开测试结果界面
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginin" object:nil];
//                [self setUserInfo];
//                [self getUserTestResult];
//                //                ThemeViewController *theme=[[ThemeViewController alloc]init];
//                //                LeftViewController  *left=[[LeftViewController alloc]init];
//                //                UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:theme];
//                //                UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:left];
//                //
//                //                SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
//                //                revealController.delegate = self;
//                //                [self.navigationController pushViewController:revealController animated:YES];
//            }
//            else
//            {
//                [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"message"]];
//            }
            
        } andError:^(NSError *error) {
            //加载圈圈(显示)
            [[HudHelper hudHepler] HideHUDAlert:self.view];
            NSLog(@"%@",error);
            if ([[MickeyTools getErrorStringWithError:error] isEqualToString:@"登陆信息过期,需要重新登陆"]) {
                
            }else{
                [[HudHelper hudHepler] showTips:self.view tips:[MickeyTools getErrorStringWithError:error] ] ;
                
            }
        }];
//         NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//        [defaults setObject:_name.text forKey:@"user_name"];
//        [defaults setObject:_mobile.text forKey:@"track_name"];
//        [defaults synchronize];
//        
//        WelcomeViewController *come=[[WelcomeViewController alloc]init];
//        come.type=_type;
//        [self.navigationController pushViewController:come animated:YES];
//        NewLoginViewController *new=[[NewLoginViewController alloc]init];
//        [self.navigationController pushViewController:new animated:YES];
        
    }
    
    
}


#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
    
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
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
- (void) keyboardWillHide:(NSNotification *)notify {
//    if (_sexLab.isEditing) {
//        if ([self isBlankString:_name.text]) {
//            [[HudHelper hudHepler] showTips:self.view tips:@"姓名不能为空！"];
//        }else if ([self isBlankString:_mobile.text]&&![[ToolHelper toolHelper] validatePhone:_mobile.text])
//        {
//            [[HudHelper hudHepler] showTips:self.view tips:@"请输入正确的手机号码！"];
//        }else if ([self isBlankString:_sexLab.text]){
//            [[HudHelper hudHepler] showTips:self.view tips:@"请输入性别！"];
//        }else
//        {
//            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//            [defaults setObject:_name.text forKey:@"user_name"];
//            [defaults setObject:_mobile.text forKey:@"user_mobile"];
//            if ([_sexLab.text isEqualToString:@"女士"]) {
//                [defaults setObject:@"0" forKey:@"user_sex"];
//            }else{
//                [defaults setObject:@"1" forKey:@"user_sex"];
//            }
//            //        [defaults setObject:_sex forKey:@"user_sex"];
//            [defaults synchronize];
//            
//            WelcomeViewController *come=[[WelcomeViewController alloc]init];
//            [self.navigationController pushViewController:come animated:YES];
//            //        NewLoginViewController *new=[[NewLoginViewController alloc]init];
//            //        [self.navigationController pushViewController:new animated:YES];
//            
//        }
//
//    }
//    if ([self isBlankString:_name.text]) {
//        [[HudHelper hudHepler] showTips:self.view tips:@"姓名不能为空！"];
//    }else if ([self isBlankString:_mobile.text]&&![[ToolHelper toolHelper] validatePhone:_mobile.text])
//    {
//        [[HudHelper hudHepler] showTips:self.view tips:@"请输入正确的手机号码！"];
//    }else if ([self isBlankString:_sexLab.text]){
//        [[HudHelper hudHepler] showTips:self.view tips:@"请输入性别！"];
//    }else
//    {
//        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//        [defaults setObject:_name.text forKey:@"user_name"];
//        [defaults setObject:_mobile.text forKey:@"user_mobile"];
//        if ([_sexLab.text isEqualToString:@"女士"]) {
//           [defaults setObject:@"0" forKey:@"user_sex"];
//        }else{
//           [defaults setObject:@"1" forKey:@"user_sex"];
//        }
////        [defaults setObject:_sex forKey:@"user_sex"];
//        [defaults synchronize];
//        
//        WelcomeViewController *come=[[WelcomeViewController alloc]init];
//        [self.navigationController pushViewController:come animated:YES];
//        //        NewLoginViewController *new=[[NewLoginViewController alloc]init];
//        //        [self.navigationController pushViewController:new animated:YES];
//        
//    }

//    // 键盘动画时间
//    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
//    //视图下沉恢复原状
//    [UIView animateWithDuration:duration animations:^{
//         _height.constant=165;
//    }];
}
//-(void)textFieldDidEndEditing:(UITextField *)textField{
////    if (textField==_mobile) {
////        if ([self isBlankString:_name.text]) {
////            [[HudHelper hudHepler] showTips:self.view tips:@"姓名不能为空！"];
////        }else if ([self isBlankString:_mobile.text]&&![[ToolHelper toolHelper] validatePhone:_mobile.text])
////        {
////            [[HudHelper hudHepler] showTips:self.view tips:@"请输入正确的手机号码！"];
////        }else if ([self isBlankString:_sex]){
////            [[HudHelper hudHepler] showTips:self.view tips:@"请选择性别！"];
////        }else
////        {
////            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
////            [defaults setObject:_name.text forKey:@"user_name"];
////            [defaults setObject:_mobile.text forKey:@"user_mobile"];
////            [defaults setObject:_sex forKey:@"user_sex"];
////            [defaults synchronize];
////            
////            WelcomeViewController *come=[[WelcomeViewController alloc]init];
////            [self.navigationController pushViewController:come animated:YES];
////            //        NewLoginViewController *new=[[NewLoginViewController alloc]init];
////            //        [self.navigationController pushViewController:new animated:YES];
////            
////        }
////        
////
////    }
//    
//}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
