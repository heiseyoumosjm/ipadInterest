//
//  UnitDispayActionViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/3/8.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "UnitDispayActionViewController.h"
#import "SWRevealViewController.h"
#import "SpaceProductViewController.h"
#import "RoomFunctionModel.h"
#import "RootHttpHelper.h"
#import "roomModel.h"
#import "NewLoginViewController.h"
@interface UnitDispayActionViewController ()
{
    SWRevealViewController *revealController;
    UIView *backView;
}
@property(strong,nonatomic)RoomFunctionModel *roomFunctionModel;
@property(assign,nonatomic)NSInteger functionid;
@property(strong,nonatomic)NSMutableArray *btnArr;
@property(strong,nonatomic)NSMutableArray *funcArr;
@property(strong,nonatomic)roomModel *roomModel1;
@property(strong,nonatomic)NSMutableArray *modelArr;
//@property(strong,nonatomic)NSMutableArray *roomModelArr;
@end

@implementation UnitDispayActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationBarHidden=NO;
    //设置导航栏背景图片为一个空的image，这样就透明了
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//     self.navigationController.navigationBar.translucent = true;
//    //去掉透明后导航栏下边的黑边
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    _modelArr=[[NSMutableArray alloc]init];
    [_modelArr addObject:_hxModel];
    [_modelArr addObject:_roomModelArr];
    //发通知侧边栏可以点击展开测试结果界面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLeft1" object:_modelArr];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"房间功能";
    
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
    [next addTarget: self action: @selector(nextstep) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc]initWithCustomView:next];
    [next setTitle:@"下一步" forState:UIControlStateNormal];
    [next setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSMutableArray *buttonItems1 = [NSMutableArray array];
    [buttonItems1 addObject:nextItem];
    self.navigationItem.rightBarButtonItems = buttonItems1;
    //
    
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
//    [self bandRoom];
    
    [_UnitImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",_hxModel.img]] placeholderImage:[UIImage imageNamed:@"默认"]];
//     _Img_width.constant=[_hxModel.img_width floatValue]/1.2;
//     _imgHeight.constant=[_hxModel.img_height floatValue]/1.2;
     _imgHeight.constant=SCREEN_HEIGHT-64-160;
     _Img_width.constant=[_hxModel.img_width floatValue]*_imgHeight.constant/[_hxModel.img_height floatValue];
    [self addFunctionView];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)bandRoom
{
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
//            UnitDispayActionViewController *next=[[UnitDispayActionViewController alloc]init];
//            next.hxModel=_hxModel;
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            [defaults setObject:[successData objectForKey:@"id"] forKey:@"pad_user_room_function_id"];
            [defaults synchronize];
             _pad_user_room_id=[successData objectForKey:@"id"];
            //发通知侧边栏可以点击展开测试结果界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLeft1" object:_hxModel];
            
//            next.pad_user_room_id=[successData objectForKey:@"id"];
//            [self.navigationController pushViewController:next animated:YES];
            
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
    

}
- (void) shakeToShow:(UIView*)aView

{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = 1.5;// 动画时间
    
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    
    // 这三个数字，我只研究了前两个，所以最后一个数字我还是按照它原来写1.0；前两个是控制view的大小的；
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)]];
    
    animation.values = values;
    
    [aView.layer addAnimation:animation forKey:nil];
    
}


-(void)addFunctionView
{
    _btnArr=[[NSMutableArray alloc]init];
    _funcArr=[[NSMutableArray alloc]init];
    for (int i=0; i<_hxModel.room_function.count; i++) {
        _roomFunctionModel=[[RoomFunctionModel alloc]init];
        _roomFunctionModel=_hxModel.room_function[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.backgroundColor = [UIColor whiteColor];
        btn=[[UIButton alloc]initWithFrame:CGRectMake([_roomFunctionModel.point_x_coordinate floatValue]/([_hxModel.img_height floatValue]/_imgHeight.constant), [_roomFunctionModel.point_y_coordinate floatValue]/([_hxModel.img_height floatValue]/_imgHeight.constant), [_roomFunctionModel.point_width floatValue]/([_hxModel.img_height floatValue]/_imgHeight.constant), [_roomFunctionModel.point_height floatValue]/([_hxModel.img_height floatValue]/_imgHeight.constant))];
        [btn addTarget:self action:@selector(chooseFunction:) forControlEvents:UIControlEventTouchUpInside];
//        [btn setTitle:_roomFunctionModel.room_name forState:UIControlStateNormal];
//         btn.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
         btn.tag=i;
         _UnitImg.userInteractionEnabled = YES;
        [_btnArr addObject:btn];
        [_UnitImg addSubview:btn];
    }
}
- (void)handleClick:(UIButton *)btn{
    [self shakeToShow:btn];
//    _roomFunctionModel=[[RoomFunctionModel alloc]init];
//    _roomFunctionModel=_hxModel.room_function[btn.tag];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    _roomModelArr=[[NSMutableArray alloc]init];
    dic=_roomFunctionModel.rooms[btn.tag];
    for (int i=0; i<_btnArr.count; i++) {
        UIButton *btn=_btnArr[i];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         btn.titleLabel.font=[UIFont systemFontOfSize:12.f];
//        btn.backgroundColor=[UIColor redColor];
        if (btn.tag==_functionid) {
         [btn setTitle:[dic objectForKey:@"room_name"] forState:UIControlStateNormal];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:_pad_user_room_id forKey:@"pad_user_room_id"];
            [params setValue:[dic objectForKey:@"id"] forKey:@"room_function_id"];
            [params setValue:_roomFunctionModel.position forKey:@"position"];
 
            [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"building/set-room-function" andParams:params andSuccess:^(NSDictionary *successData) {
                //            //加载圈圈(显示)
                if ([[successData objectForKey:@"api_code"] integerValue]==200) {
                    
                    _roomModelArr=[successData objectForKey:@"data"];
                    
//
//                    _roomModel1=[[roomModel alloc]initWithDictionary:[successData objectForKey:@"data"] error:nil];
                    
                }else{
                    [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
                }
                
            } andError:^(NSError *error) {
                //加载圈圈(显示)
                [[HudHelper hudHepler] HideHUDAlert:self.view];
                NSLog(@"%@",error);
            }];
           

            if ([_funcArr containsObject: [dic objectForKey:@"id"]]) {
                
            }else{
              [_funcArr addObject:[dic objectForKey:@"id"]];
            }
//         [_funcArr addObject:[dic objectForKey:@"id"]];
        }else{
//         [btn setTitle:[dic objectForKey:@""] forState:UIControlStateNormal];
//            if ([_funcArr containsObject: [dic objectForKey:@"id"]]) {
//               [_funcArr removeObject:[dic objectForKey:@"id"]];
//            }
        }
       
    }
    
//    UILabel *btnlab=[[UILabel alloc]initWithFrame:CGRectMake([_roomFunctionModel.point_x_coordinate floatValue]/1.2, [_roomFunctionModel.point_y_coordinate floatValue]/1.2, [_roomFunctionModel.point_width floatValue]/1.2, [_roomFunctionModel.point_height floatValue]/1.2)];
//   
//    //        [btn setTitle:_roomFunctionModel.room_name forState:UIControlStateNormal];
//    //         btn.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    btnlab.text=[dic objectForKey:@"room_name"];
//    btnlab.textAlignment=NSTextAlignmentCenter;
//    btnlab.font=[UIFont systemFontOfSize:13.f];
//    btnlab.textColor=[UIColor blackColor];
//    btnlab.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
//    [_UnitImg addSubview:btnlab];
    
//    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//    dic=_roomFunctionModel.rooms[btn.tag];
//    SpaceProductViewController *space=[[SpaceProductViewController alloc]init];
//    space.room_function_id=[dic objectForKey:@"id"];
//    [self.navigationController pushViewController:space animated:YES];
    
    
}
-(void)delayMethod{
    if (backView) {
        [backView removeFromSuperview];
    }
    backView=[[UIView alloc]init];
    backView.backgroundColor=[UIColor clearColor];
    //    NSArray *arr = @[@"无知",@"风云变幻",@"施耐庵"];
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = 16;//用来控制button距离父视图的高
    for (int i = 0; i < _roomFunctionModel.rooms.count; i++) {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        dic=_roomFunctionModel.rooms[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setBackgroundImage:[UIImage imageNamed:@"默认"]forState:UIControlStateNormal];
        UILabel *buttonlab = [[UILabel alloc]init];
        //       [btn setTitle:[dic objectForKey:@"room_name"] forState:UIControlStateNormal];
        
        button.tag = i;
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
        buttonlab.text=[dic objectForKey:@"room_name"];
        buttonlab.font=[UIFont systemFontOfSize:13.f];
        buttonlab.textAlignment=NSTextAlignmentCenter;
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",[dic objectForKey:@"icon"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认"]];
       
        //设置button的frame
        button.frame = CGRectMake(10 + w, h, 48 , 48);
        buttonlab.frame=CGRectMake(10 + w, h+48, 48 , 30);
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if(10 + w  > 60){
            w = 0; //换行时将w置为0
            h = h + button.frame.size.height + 30;//距离父视图也变化
            button.frame = CGRectMake(10 + w, h,48, 48);//重设button的frame
            buttonlab.frame=CGRectMake(10 + w, h+48, 48 , 30);
        }
        w = button.frame.size.width + button.frame.origin.x;
        backView.frame=CGRectMake(SCREEN_WIDTH-100, 78, 60, h+30);
        [backView addSubview:button];
        [backView addSubview:buttonlab];
        [self.view addSubview:backView];
    }
 
}
- (void)chooseFunction:(UIButton *)btn{
//    if (backView) {
//        [backView removeFromSuperview];
//    }

    _roomFunctionModel=[[RoomFunctionModel alloc]init];
    _roomFunctionModel=_hxModel.room_function[btn.tag];
    _functionid=btn.tag;
//    if (backView) {
//        [backView removeFromSuperview];
//    }

    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.2f];
    
}
-(void)changeButtonStatus{
    
}
- (void)nextstep
{
    if(_roomModelArr.count>0)
    {
    SpaceProductViewController *space=[[SpaceProductViewController alloc]init];
//    space.room_function_id=_funcArr[0];
    space.roomDataArr=_roomModelArr;
    space.index=@"0";
    [self.navigationController pushViewController:space animated:YES];
    }else
    {
         [[HudHelper hudHepler] showTips:self.view tips:@"请选择房间功能！"];
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

- (IBAction)btnChooseType:(UIButton *)sender {
}
@end
