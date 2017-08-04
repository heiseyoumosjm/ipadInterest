//
//  RoomColorViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/3/9.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "RoomColorViewController.h"
#import "SWRevealViewController.h"
#import "3DDigitalViewController.h"
#import "RootHttpHelper.h"
#import "SpaceProductViewController.h"
#import "LoadingAnimationView.h"
#import "All3DViewController.h"
#import "NewLoginViewController.h"

@interface RoomColorViewController ()
{
    SWRevealViewController *revealController;
    NSMutableArray *arr;
    UIView *backView;
    BOOL isopen;
    UIButton *next;
    LoadingAnimationView *loading;
}
@property(strong,nonatomic)NSMutableArray *dataArr;
@end

@implementation RoomColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationBarHidden=NO;
     self.view.backgroundColor=[UIColor whiteColor];
     self.title=@"颜色选择";
    
    //    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //     self.navigationController.navigationBar.translucent = true;
    //    //去掉透明后导航栏下边的黑边
    //    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
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
    next = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    next.frame = CGRectMake(20, 0, 60, 30);
    [next addTarget: self action: @selector(nextStep) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc]initWithCustomView:next];
    [next setTitle:@"下一步" forState:UIControlStateNormal];
    [next setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSMutableArray *buttonItems1 = [NSMutableArray array];
    [buttonItems1 addObject:nextItem];
    self.navigationItem.rightBarButtonItems = buttonItems1;
    //
    
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    [_backImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",_sceneModel.flat_img]] placeholderImage:[UIImage imageNamed:@"默认"]];
     _backImg.contentMode = UIViewContentModeScaleToFill;

    [self getColorDate];
//    [self initView];
//    [self getColorDate];
    // Do any additional setup after loading the view from its nib.
}

- (void)getColorDate{
     arr=[[NSMutableArray alloc]init];
     NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_colorId forKey:@"pad_user_scene_picture_id"];
    
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"product-goods/scene-color" andParams:params andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
            arr=[successData objectForKey:@"data"];
            [self initView];
        }
        else if ([[successData objectForKey:@"api_code"] integerValue]==401){
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的账号已在别处登陆了，请重新登录！" preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSLog(@"+++++++++++++++退出");
                NewLoginViewController *theme=[[NewLoginViewController alloc]init];
                [self.navigationController pushViewController:theme animated:YES];
                
            }]];
            [self presentViewController:alertView animated:YES completion:nil];
        }
        else{
            [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
        }
        
    } andError:^(NSError *error) {
        //加载圈圈(显示)
        [[HudHelper hudHepler] HideHUDAlert:self.view];
        NSLog(@"%@",error);
    }];

//    [arr addObject:@"alltype"];
//    [arr addObject:@"1"];
//    [arr addObject:@"2"];
//    [arr addObject:@"3"];
//    [arr addObject:@"4"];
    
//    [self initView];
//    
}
- (void)initView{
    isopen=NO;
//    backView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT, 75*(arr.count)+20, 65)];
//    backView.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
//    backView.layer.masksToBounds=YES;
//    backView.layer.cornerRadius=5.0;
//    [self.view addSubview:backView];

    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    for (int i = 0; i <arr.count; i++) {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
     button.tag = 100+i;
     button.hidden=YES;
     button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
//    [button setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
    [button sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",[arr[i]objectForKey:@"icon"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认"]];
     //根据计算文字的大小
     button.layer.masksToBounds=YES;
     button.layer.cornerRadius=18.f;
     button.frame = CGRectMake(SCREEN_WIDTH-45-36-2, SCREEN_HEIGHT-45-36-64-2, 36 , 36);
     w = button.frame.size.width + button.frame.origin.x;
    [self.view addSubview:button];

}
    [self.view addSubview:_colorbtn];
//    UIButton *allType=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 45, 45)];
//    [allType setImage:[UIImage imageNamed:@"alltype"] forState:UIControlStateNormal];
//    [allType addTarget:self action:@selector(chooseColor) forControlEvents:UIControlEventTouchUpInside];
//    [backView addSubview:allType];
  
}
- (void)handleClick:(UIButton *)btn{
    if (btn.tag-100>=0) {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_colorId forKey:@"pad_user_scene_picture_id"];
    [params setValue:[arr[btn.tag-100]objectForKey:@"id"] forKey:@"scene_color_id"];
    
    [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"product-goods/scene-picture" andParams:params andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
            _sceneModel=[[SceneModel alloc]initWithDictionary:[successData objectForKey:@"scenePicture"] error:nil
                         ];
            _colorId=[successData objectForKey:@"id"];
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
           [defaults setObject:[arr[btn.tag-100]objectForKey:@"id"] forKey:@"colorid"];
           [defaults synchronize];

            [_backImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",_sceneModel.flat_img]] placeholderImage:[UIImage imageNamed:@"默认"]];
        }else{
            [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
        }
        
    } andError:^(NSError *error) {
        //加载圈圈(显示)
        [[HudHelper hudHepler] HideHUDAlert:self.view];
        NSLog(@"%@",error);
    }];
 }
    
//    _backImg.image=[UIImage imageNamed:arr[btn.tag]];
//    if (isopen) {
//        [UIView animateWithDuration:.5 animations:^{
//            backView.frame = CGRectMake(SCREEN_WIDTH-75, 55, 75*(arr.count+1)+20, 65);
//        }];
//        
//        
//    }else{
//    [UIView animateWithDuration:.5 animations:^{
//        backView.frame = CGRectMake(SCREEN_WIDTH-75*(arr.count+1), 55, 75*(arr.count+1)+20, 65);
//    }];
//    }
//    isopen=!isopen;
    
}
- (void)chooseColor{
//    [UIView animateWithDuration:.5 animations:^{
//        backView.frame = CGRectMake(SCREEN_WIDTH-65, 55, 75*(arr.count-1)+20, 65);
//    }];
   
}
-(void)delayMethod{
//            loading.hidden=YES;
    
            _dataArr=[[NSMutableArray alloc]init];
    
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            NSString *pad_user_room_function_id=[userDefaultes stringForKey:@"pad_user_room_function_id"];
            [params setValue:pad_user_room_function_id forKey:@"pad_user_room_id"];
    
            [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"product-goods/user-scene-picture" andParams:params andSuccess:^(NSDictionary *successData) {
                //            //加载圈圈(显示)
                if ([[successData objectForKey:@"api_code"] integerValue]==200) {
                    _dataArr=[successData objectForKey:@"data"];
                    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                    dic=[_dataArr[0]objectForKey:@"scenePicture" ];
                    _DDigitalViewController *room=[[_DDigitalViewController alloc]init];
                    room.ImgString=[dic objectForKey:@"space_img"];
                    room.roomDataArr=_roomDataArr;
                    room.dataArr=_dataArr;
                    room.index=@"0";
                    room.picindex=@"0";
                    [self.navigationController pushViewController:room animated:YES];
                }else{
                    [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
                }
    
            } andError:^(NSError *error) {
                //加载圈圈(显示)
                [[HudHelper hudHepler] HideHUDAlert:self.view];
                NSLog(@"%@",error);
            }];
    
    
    
    //            _DDigitalViewController *room=[[_DDigitalViewController alloc]init];
    //            room.ImgString=_sceneModel.space_img;
    //            room.roomDataArr=_roomDataArr;
    //            room.index=@"0";
    //            [self.navigationController pushViewController:room animated:YES];
    //        All3DViewController *all=[[All3DViewController alloc]init];
    //        [self.navigationController pushViewController:all animated:YES];
}
- (void)nextStep{
    
    if ([_index integerValue]+1<=_roomDataArr.count-1) {
        SpaceProductViewController *room=[[SpaceProductViewController alloc]init];
        room.roomDataArr=_roomDataArr;
        room.index=[NSString stringWithFormat:@"%ld",[_index integerValue]+1];
        [self.navigationController pushViewController:room animated:YES];
    }else{
        NSLog(@"+++++++++++++++选完空间产品了已经");
        All3DViewController *all=[[All3DViewController alloc]init];
        [self.navigationController pushViewController:all animated:YES];
//         next.hidden=YES;
//         loading = [[LoadingAnimationView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) andGif:@"progress"];
//         MBProgressHUD *progress;
//         progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//         progress.mode = MBProgressHUDModeCustomView;
//         progress.customView = loading;
//         progress.color = [UIColor clearColor];
        
//        
//        [progress hide:YES afterDelay:3.0f];
//        [[AppDelegate appDelegate].window addSubview:loading];
//        [self delayMethod]; 先暂时隐藏三维效果图
//        [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
//        _dataArr=[[NSMutableArray alloc]init];
//       
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//        NSString *pad_user_room_function_id=[userDefaultes stringForKey:@"pad_user_room_function_id"];
//        [params setValue:pad_user_room_function_id forKey:@"pad_user_room_id"];
//        
//        [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"product-goods/user-scene-picture" andParams:params andSuccess:^(NSDictionary *successData) {
//            //            //加载圈圈(显示)
//            if ([[successData objectForKey:@"api_code"] integerValue]==200) {
//                _dataArr=[successData objectForKey:@"data"];
//                NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//                dic=[_dataArr[0]objectForKey:@"scenePicture" ];
//                _DDigitalViewController *room=[[_DDigitalViewController alloc]init];
//                room.ImgString=[dic objectForKey:@"space_img"];
//                room.roomDataArr=_roomDataArr;
//                room.dataArr=_dataArr;
//                room.index=@"0";
//                room.picindex=@"0";
//                [self.navigationController pushViewController:room animated:YES];
//            }else{
//                [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
//            }
//            
//        } andError:^(NSError *error) {
//            //加载圈圈(显示)
//            [[HudHelper hudHepler] HideHUDAlert:self.view];
//            NSLog(@"%@",error);
//        }];
        

        
//            _DDigitalViewController *room=[[_DDigitalViewController alloc]init];
//            room.ImgString=_sceneModel.space_img;
//            room.roomDataArr=_roomDataArr;
//            room.index=@"0";
//            [self.navigationController pushViewController:room animated:YES];
//        All3DViewController *all=[[All3DViewController alloc]init];
//        [self.navigationController pushViewController:all animated:YES];
        
    }
    
//    _DDigitalViewController *room=[[_DDigitalViewController alloc]init];
//    room.ImgString=_sceneModel.space_img;
//    room.roomDataArr=_roomDataArr;
//    room.index=_index;
//    [self.navigationController pushViewController:room animated:YES];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)colorChangeBtn:(UIButton *)sender {
    if (!isopen) {
    for (int i = 0; i < arr.count; i ++) {
     UIButton *btn = (UIButton *)[self.view viewWithTag:100+(arr.count-1-i)];
     CGFloat x = SCREEN_WIDTH-45-38;
     CGFloat y = SCREEN_HEIGHT-115-45*i-64-18;
//     btn.hidden=NO;
    [UIView animateWithDuration:0.1*(i+1) delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
     btn.frame = CGRectMake(x, y,36,36);
     btn.hidden=NO;
    
    } completion:nil];
    }
    }else{
        for (int i = 0; i < arr.count; i ++) {
            UIButton *btn = (UIButton *)[self.view viewWithTag:100+(arr.count-1-i)];
            CGFloat x = SCREEN_WIDTH-45-36-2;
            CGFloat y = SCREEN_HEIGHT-45-36-64-2;
            btn.hidden=YES;
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                btn.frame = CGRectMake(x, y,36,36);
                
            } completion:nil];
        }

        
    }
    isopen=!isopen;
    
}
@end
