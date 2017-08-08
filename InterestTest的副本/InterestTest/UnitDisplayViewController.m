//
//  UnitDisplayViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/3/8.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "UnitDisplayViewController.h"
#import "SWRevealViewController.h"
#import "UnitDispayActionViewController.h"
#import "RootHttpHelper.h"
#import "NewLoginViewController.h"

@interface UnitDisplayViewController ()
{
    SWRevealViewController *revealController;
}

@end

@implementation UnitDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor=[UIColor whiteColor];
     self.title=@"户型展示";
     self.navigationController.navigationBarHidden=NO;
    
    revealController = [self revealViewController];
    
    //设置按钮
    UIButton *_setBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _setBut.frame = CGRectMake(20, 0, 14, 11);
    [_setBut addTarget: revealController action: @selector(revealToggle:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *setItem = [[UIBarButtonItem alloc]initWithCustomView:_setBut];
    [_setBut setBackgroundImage:[UIImage imageNamed:@"menu1"] forState:UIControlStateNormal];
    NSMutableArray *buttonItems = [NSMutableArray array];
    [buttonItems addObject:setItem];
    self.navigationItem.leftBarButtonItems = buttonItems;
    
    
    //设置按钮
    UIButton *next = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    next.frame = CGRectMake(20, 0, 60, 30);
    [next addTarget: self action: @selector(next) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc]initWithCustomView:next];
    [next setTitle:@"下一步" forState:UIControlStateNormal];
    [next setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     NSMutableArray *buttonItems1 = [NSMutableArray array];
    [buttonItems1 addObject:nextItem];
    self.navigationItem.rightBarButtonItems = buttonItems1;
//
    
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    [_unitImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",_hxModel.img]] placeholderImage:[UIImage imageNamed:@"默认"]];
    
     _imgHeight.constant=SCREEN_HEIGHT-64-160;
     _imgWidth.constant=[_hxModel.img_width floatValue]*_imgHeight.constant/[_hxModel.img_height floatValue];
   
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void)next{
//    //发通知侧边栏可以点击展开测试结果界面
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLeft1" object:_hxModel];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:_type forKey:@"type"];
    if ([_type integerValue]==0) {
        [params setValue:_basic_room_id forKey:@"basic_room_id"];
    }else{
        [params setValue:_building_id forKey:@"building_id"];
        [params setValue:_room_name forKey:@"room_name"];
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

            next.pad_user_room_id=[successData objectForKey:@"id"];
            [self.navigationController pushViewController:next animated:YES];
            
        }
        else if ([[successData objectForKey:@"api_code"] integerValue]==401){
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的账号已在别处登陆了，请重新登录！" preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSLog(@"+++++++++++++++退出");
                NewLoginViewController *theme=[[NewLoginViewController alloc]init];
                [self.navigationController pushViewController:theme animated:YES];
                
            }]];
            [self presentViewController:alertView animated:YES completion:nil];
        }else{
            [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
        }
        
    } andError:^(NSError *error) {
        //加载圈圈(显示)
        [[HudHelper hudHepler] HideHUDAlert:self.view];
        NSLog(@"%@",error);
    }];

    
//    UnitDispayActionViewController *next=[[UnitDispayActionViewController alloc]init];
//    next.hxModel=_hxModel;
//    [self.navigationController pushViewController:next animated:YES];
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

@end
