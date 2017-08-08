//
//  UnitLoginViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/3/6.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "UnitLoginViewController.h"
#import "ThemeViewController.h"
#import "LeftViewController.h"
#import "SWRevealViewController.h"
#import "UnitDisplayViewController.h"
#import "RootHttpHelper.h"
#import "HxModel.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "UnitDispayActionViewController.h"
#import "ThemeViewController.h"
#import "NewLoginViewController.h"
#import "UserInfoViewController.h"


@interface UnitLoginViewController ()<SWRevealViewControllerDelegate>
{
    NSString *lpname;
    NSString *lpnameid;
    NSString *hxname;
    NSString *hxnameid;
    NSMutableArray *btnArr;
    NSMutableArray *btnArr1;
    NSMutableArray *lpArr;
    NSMutableArray *hxArr;
}
@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;
@property(nonatomic,strong)NSString *type;//0为其他楼盘 1为楼盘
@property(nonatomic,strong)HxModel *hxModel;
@end

@implementation UnitLoginViewController

- (void)viewWillAppear:(BOOL)animated{
     [self getUserTestResult];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationBarHidden=YES;
     _backImg.image=[UIImage imageNamed:@"loginBackView"];
//    [self getUserTestResult];
    [self getLpInfoDate];
    [self getLpNumInfoDate];
    [self addNoticeForKeyboard];
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    self.returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"colorid"];
    [defaults synchronize];
    
    
    [self freshDate];
    // Do any additional setup after loading the view from its nib.
}
- (void)getUserTestResult
{
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"user/get-boolean-test" andParams:nil andSuccess:^(NSDictionary *successData) {
        if ([[successData objectForKey:@"api_code"] integerValue]==401){
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            NSString *token=[userDefaultes stringForKey:@"usertoken"];
            if ([self isBlankString:token]) {
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的账号已退出，请重新登录！" preferredStyle:UIAlertControllerStyleAlert];
                [alertView addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    NSLog(@"+++++++++++++++退出");
                    UserInfoViewController *theme=[[UserInfoViewController alloc]init];
                    [self.navigationController pushViewController:theme animated:YES];
                    
                }]];
                [self presentViewController:alertView animated:YES completion:nil];
            }else{
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的账号已在别处登陆了，请重新登录！" preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSLog(@"+++++++++++++++退出");
                NewLoginViewController *theme=[[NewLoginViewController alloc]init];
                [self.navigationController pushViewController:theme animated:YES];
                
            }]];
            [self presentViewController:alertView animated:YES completion:nil];
            }
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
            
            //                    [defaults setObject:[styleAttr objectForKey:@"fg_sentence"] forKey:@"fg_sentence"];
            //                    [defaults setObject:[styleAttr objectForKey:@"result_imgs"] forKey:@"result_imgs"];
            [defaults synchronize];

        
        }else{
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还未参加兴趣测试请前往测试吧..." preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSLog(@"+++++++++++++++退出");
                ThemeViewController *theme=[[ThemeViewController alloc]init];
                LeftViewController  *left=[[LeftViewController alloc]init];
                UIViewController *target = nil;
                for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
                    if ([controller isKindOfClass:[left class]]) { //这里判断是否为你想要跳转的页面
                        target = controller;
                        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:theme];
                        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:target];
                        
                        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
                        revealController.delegate = self;
                        [self.navigationController pushViewController:revealController animated:YES];
                    }else{
                        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:theme];
                        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:left];
                        
                        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
                        revealController.delegate = self;
                        [self.navigationController pushViewController:revealController animated:YES];
                    }
                }

                
                
            }]];
            [self presentViewController:alertView animated:YES completion:nil];

        }

    } andError:^(NSError *error) {
        //加载圈圈(显示)
        NSLog(@"%@",error);
    }];
  

    
}
- (void)freshDate{
    _chooseNumBtn.hidden=NO;
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    _type=[userDefaultes stringForKey:@"type"];
    NSString *hxname1=[userDefaultes stringForKey:@"hxname"];
    NSString *hxnameid1=[userDefaultes stringForKey:@"hxnameid"];
    NSString *lpname1=[userDefaultes stringForKey:@"lpname"];
    NSString *lpnameid1=[userDefaultes stringForKey:@"lpnameid"];
    NSString *unitLab=[userDefaultes stringForKey:@"unitLab"];
//    if ([_type integerValue]==0) {
//        [params setValue:hxnameid forKey:@"basic_room_id"];
//    }else{
//        [params setValue:lpnameid forKey:@"building_id"];
//        [params setValue:_unitLab.text forKey:@"room_name"];
//    }
    
//    if ([_type integerValue]==0) {
//        [defaults setObject:hxname forKey:@"hxname"];
//    }else{
//        //           [defaults setObject: _type forKey:@"type"];
//        //           [defaults setObject:hxnameid forKey:@"hxnameid"];
//        [defaults setObject:lpname forKey:@"lpname"];
//        [defaults setObject:_unitLab.text forKey:@"unitLab"];
//    }

    
    if ([_type integerValue]==0) {
        if ([self isBlankString:hxname1]) {
            
        }else{
             _lplab.text=@"其它楼盘";
             _unitLab.text=hxname1;
             hxnameid=hxnameid1;
        }
    }else{
        if ([self isBlankString:lpname1]) {
            
        }else{
            _unitLab.text=unitLab;
            _lplab.text=lpname1;
            lpnameid=lpnameid1;
            _chooseNumBtn.hidden=YES;
            
        }
        
    }
    
}
- (void)getLpNumInfoDate
{
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"room-function" andParams:nil andSuccess:^(NSDictionary *successData) {
        //加载圈圈(显示)
        hxArr=[[NSMutableArray alloc]init];
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
            hxArr=[successData objectForKey:@"data"];
            [self creatHeadView1];
        }
        
    } andError:^(NSError *error) {
        //加载圈圈(显示)
        NSLog(@"%@",error);
    }];
    
}
- (void)getLpInfoDate
{
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"building" andParams:nil andSuccess:^(NSDictionary *successData) {
        //加载圈圈(显示)
        lpArr=[[NSMutableArray alloc]init];
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
            lpArr=[successData objectForKey:@"data"];
            [self creatHeadView];
        }
        
    } andError:^(NSError *error) {
        //加载圈圈(显示)
        [[HudHelper hudHepler] HideHUDAlert:self.view];
        NSLog(@"%@",error);
    }];

//    [self creatHeadView];
}
-(void)creatHeadView1{
    UIView *backView=[[UIView alloc]init];
    backView.backgroundColor=[UIColor clearColor];
    btnArr1=[[NSMutableArray alloc]init];
//    NSArray *arr = @[@"三室二厅",@"三室三厅",@"三室二厅"];
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = 0;//用来控制button距离父视图的高
    for (int i = 0; i < hxArr.count; i++) {
        NSMutableDictionary *hx=[[NSMutableDictionary alloc]init];
        hx=hxArr[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = [[hx objectForKey:@"id"] integerValue];
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(handleClick1:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:UIColorFromRGB(0x808080) forState:UIControlStateNormal];
        [button setTitleColor:colorHead forState:UIControlStateSelected];
        button.titleLabel.font=[UIFont systemFontOfSize:15.f];
        CGColorRef colorref = [UIColor lightGrayColor].CGColor;
        [button.layer setBorderColor:colorref];//边框颜色
        //根据计算文字的大小
        
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0]; //设置矩圆角半径
        [button.layer setBorderWidth:1.0];   //边框宽度
//        NSMutableDictionary *hx=[[NSMutableDictionary alloc]init];
//        hx=hxArr[i];
        //为button赋值
        [button setTitle:[hx objectForKey:@"room_name"] forState:UIControlStateNormal];
        [btnArr1 addObject:button];
        //设置button的frame
        button.frame = CGRectMake(w, h, (334-50)/3 , 40);
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if(w > 334){
            w = 0; //换行时将w置为0
            h = h + button.frame.size.height + 20;//距离父视图也变化
            button.frame = CGRectMake(w, h,(334-50)/3, 40);//重设button的frame
        }
        w = button.frame.size.width + button.frame.origin.x+25;
        backView.frame=CGRectMake(0, 0, 334, h+45);
        [backView addSubview:button];
        _hxnumHeight.constant=backView.frame.size.height;
        [_hxnumBtnView addSubview:backView];
        
    }
    

}
-(void)handleClick1:(UIButton *)btn{
    for (UIButton *Btn in btnArr1) {
        Btn.selected=NO;
        CGColorRef colorref = [UIColor lightGrayColor].CGColor;
        [Btn.layer setBorderColor:colorref];//边框颜色
    }
    btn.selected=YES;
    CGColorRef colorref = colorHead.CGColor;
    [btn.layer setBorderColor:colorref];//边框颜色
    hxname=[btn titleForState:UIControlStateSelected];
    hxnameid=[NSString stringWithFormat:@"%ld",btn.tag];
}
-(void)creatHeadView
{
    UIView *backView=[[UIView alloc]init];
    backView.backgroundColor=[UIColor clearColor];
    btnArr=[[NSMutableArray alloc]init];
//    NSArray *arr = @[@"春江花月",@"春江花月1",@"其它楼盘",@"春江花月2",@"春江花月2",@"春江花月2",@"春江花月2",@"春江花月2",@"春江花月2",@"春江花月2",@"春江花月2",@"春江花月2",@"春江花月2",@"春江花月2",@"春江花月2",@"春江花月2",@"春江花月2",@"春江花月2"];
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = 0;//用来控制button距离父视图的高
    for (int i = 0; i < lpArr.count; i++) {
        NSMutableDictionary *lp=[[NSMutableDictionary alloc]init];
        lp=lpArr[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = [[lp objectForKey:@"id"] integerValue];
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
       [button setTitleColor:UIColorFromRGB(0x808080) forState:UIControlStateNormal];
        [button setTitleColor:colorHead forState:UIControlStateSelected];
        button.titleLabel.font=[UIFont systemFontOfSize:15.f];
        CGColorRef colorref = [UIColor lightGrayColor].CGColor;
        [button.layer setBorderColor:colorref];//边框颜色
        //根据计算文字的大小
        
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0]; //设置矩圆角半径
        [button.layer setBorderWidth:1.0];   //边框宽度
//        NSMutableDictionary *lp=[[NSMutableDictionary alloc]init];
//        lp=lpArr[i];
        //为button赋值
        [button setTitle:[lp objectForKey:@"building_name"] forState:UIControlStateNormal];
        [btnArr addObject:button];
        //设置button的frame
        button.frame = CGRectMake(w, h, (334-50)/3 , 40);
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if(w > 334){
            w = 0; //换行时将w置为0
            h = h + button.frame.size.height + 20;//距离父视图也变化
            button.frame = CGRectMake(w, h,(334-50)/3, 40);//重设button的frame
        }
        w = button.frame.size.width + button.frame.origin.x+25;
        backView.frame=CGRectMake(0, 0, 334, h+45);
        [backView addSubview:button];
         _btnHeight.constant=backView.frame.size.height;
        [_lpBtnView addSubview:backView];
        
    }
  
    
}

- (void)handleClick:(UIButton *)btn{
    for (UIButton *Btn in btnArr) {
        Btn.selected=NO;
        CGColorRef colorref = [UIColor lightGrayColor].CGColor;
        [Btn.layer setBorderColor:colorref];//边框颜色
    }
     btn.selected=YES;
    CGColorRef colorref = colorHead.CGColor;
    [btn.layer setBorderColor:colorref];//边框颜色
    lpname=[btn titleForState:UIControlStateSelected];
    lpnameid=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    
    if ([lpname isEqualToString:@"其它楼盘"]) {
        _chooseNumBtn.hidden=NO;
        _unitLab.placeholder=@"请选择户型号";
        _unitLab.text=@"";
        [self.view endEditing:YES];//结束编辑
        _type=@"0";
        
        
    }else{
        _chooseNumBtn.hidden=YES;
        _unitLab.placeholder=@"请输入户型号";
        _unitLab.text=@"";
        _type=@"1";
    }
    
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
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

- (IBAction)chooseLP:(UIButton *)sender {
    _hxView.hidden=NO;
}

- (IBAction)chooseUnit:(UIButton *)sender {
    _HxNumView.hidden=NO;
}
- (IBAction)check:(UIButton *)sender {
    
    if ([self isBlankString:_lplab.text]) {
        [[HudHelper hudHepler] showTips:self.view tips:@"楼盘不能为空！"];
    }else if([self isBlankString:_unitLab.text])
    {
      [[HudHelper hudHepler] showTips:self.view tips:@"户型不能为空！"];
    }else{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:_type forKey:@"type"];
        if ([_type integerValue]==0) {
          [params setValue:hxnameid forKey:@"basic_room_id"];
        }else{
          [params setValue:lpnameid forKey:@"building_id"];
          [params setValue:_unitLab.text forKey:@"room_name"];
        }
      [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"foor-plan" andParams:params andSuccess:^(NSDictionary *successData) {
//            //加载圈圈(显示)
            if ([[successData objectForKey:@"api_code"] integerValue]==200) {
                
            _hxModel=[[HxModel alloc]initWithDictionary:successData error:nil];
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            [defaults setObject: _type forKey:@"type"];
            if ([_type integerValue]==0) {
             [defaults setObject:hxname forKey:@"hxname"];
             [defaults setObject:hxnameid forKey:@"hxnameid"];
            }else{
//           [defaults setObject: _type forKey:@"type"];
             [defaults setObject:lpnameid forKey:@"lpnameid"];
             [defaults setObject:_lplab.text forKey:@"lpname"];
             [defaults setObject:_unitLab.text forKey:@"unitLab"];
            }
           [defaults synchronize];

                //发通知侧边栏可以点击展开测试结果界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"toback" object:nil];
            [self bandRoom];
//            UnitDispayActionViewController *theme=[[UnitDispayActionViewController alloc]init];
//            theme.type=_type;
//            theme.hxModel=_hxModel;
//            [self.navigationController pushViewController:theme animated:YES];

            }else{
                [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
            }
          
        } andError:^(NSError *error) {
            //加载圈圈(显示)
            [[HudHelper hudHepler] HideHUDAlert:self.view];
            NSLog(@"%@",error);
        }];

    }
}
-(void)bandRoom
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_type forKey:@"type"];
    if ([_type integerValue]==0) {
        [params setValue:hxnameid forKey:@"basic_room_id"];
    }else{
        [params setValue:lpnameid forKey:@"building_id"];
        [params setValue:_unitLab.text forKey:@"room_name"];
    }
    [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"bind-room" andParams:params andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
            
            NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
            dic=[successData objectForKey:@"roomFunction"];
            _hxModel=[[HxModel alloc]initWithDictionary:dic error:nil];
            UnitDispayActionViewController *next=[[UnitDispayActionViewController alloc]init];
            next.hxModel=_hxModel;
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            [defaults setObject:[successData objectForKey:@"id"] forKey:@"pad_user_room_function_id"];
            [defaults synchronize];
//            //发通知侧边栏可以点击展开测试结果界面
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLeft1" object:_hxModel];
             next.roomModelArr=[successData objectForKey:@"roomFunctionDefault"];
             next.pad_user_room_id=[successData objectForKey:@"id"];
            [self.navigationController pushViewController:next animated:YES];
            
        }else{
            [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
        }
        
    } andError:^(NSError *error) {
        //加载圈圈(显示)
        [[HudHelper hudHepler] HideHUDAlert:self.view];
        NSLog(@"%@",error);
    }];
    
    
}

- (IBAction)hxName:(UIButton *)sender {
    _lplab.text=lpname;
}


- (IBAction)chooseHxOk:(UIButton *)sender {
    _hxView.hidden=YES;
    _lplab.text=lpname;
}

- (IBAction)choosehxNumOk:(UIButton *)sender {
    _HxNumView.hidden=YES;
    _unitLab.text=hxname;
}
- (IBAction)cancal:(UIButton *)sender {
    _hxView.hidden=YES;
}

#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
    
//    //注册键盘出现的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide4:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    //    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = _height.constant-40;
    
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
- (void) keyboardWillHide4:(NSNotification *)notify {
//    // 键盘动画时间
//    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    
//    //视图下沉恢复原状
//    [UIView animateWithDuration:duration animations:^{
//        _height.constant=165;
//    }];
    if (_lplab.isEditing) {

    if ([self isBlankString:_lplab.text]) {
        [[HudHelper hudHepler] showTips:self.view tips:@"楼盘不能为空！"];
    }else if([self isBlankString:_unitLab.text])
    {
        [[HudHelper hudHepler] showTips:self.view tips:@"户型不能为空！"];
    }else{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:_type forKey:@"type"];
        if ([_type integerValue]==0) {
            [params setValue:hxnameid forKey:@"basic_room_id"];
        }else{
            [params setValue:lpnameid forKey:@"building_id"];
            [params setValue:_unitLab.text forKey:@"room_name"];
        }
        [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"foor-plan" andParams:params andSuccess:^(NSDictionary *successData) {
            //            //加载圈圈(显示)
            if ([[successData objectForKey:@"api_code"] integerValue]==200) {
                
                _hxModel=[[HxModel alloc]initWithDictionary:successData error:nil];
                UnitDisplayViewController *theme=[[UnitDisplayViewController alloc]init];
                theme.hxModel=_hxModel;
                LeftViewController  *left=[[LeftViewController alloc]init];
                UIViewController *target = nil;
                for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
                    if ([controller isKindOfClass:[left class]]) { //这里判断是否为你想要跳转的页面
                        target = controller;
                        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:theme];
                        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:target];
                        
                        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
                        revealController.delegate = self;
                        [self.navigationController pushViewController:revealController animated:YES];
                    }else{
                        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:theme];
                        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:left];
                        
                        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
                        revealController.delegate = self;
                        [self.navigationController pushViewController:revealController animated:YES];
                    }
                }
//                UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:theme];
//                UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:target];
//                
//                SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
//                revealController.delegate = self;
//                [self.navigationController pushViewController:revealController animated:YES];
                
            }else{
                [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
            }
            
        } andError:^(NSError *error) {
            //加载圈圈(显示)
            [[HudHelper hudHepler] HideHUDAlert:self.view];
            NSLog(@"%@",error);
        }];
        //        UnitDisplayViewController *theme=[[UnitDisplayViewController alloc]init];
        //        LeftViewController  *left=[[LeftViewController alloc]init];
        //        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:theme];
        //        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:left];
        //
        //        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
        //        revealController.delegate = self;
        //        [self.navigationController pushViewController:revealController animated:YES];
        
    }
    }

}

- (IBAction)cancalHxNumView:(UIButton *)sender {
    _HxNumView.hidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
