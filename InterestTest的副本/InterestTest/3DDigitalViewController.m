//
//  3DDigitalViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/3/26.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "3DDigitalViewController.h"
#import "SWRevealViewController.h"
#import "SpaceProductViewController.h"
#import "All3DViewController.h"
#import "LoadingAnimationView.h"
@interface _DDigitalViewController ()
{
    SWRevealViewController *revealController;
    LoadingAnimationView *loading;
}
@end

@implementation _DDigitalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     loading = [[LoadingAnimationView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) andGif:@"progress"];
    [[AppDelegate appDelegate].window addSubview:loading];
    [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"三维效果";
    
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
    UIButton *next = [UIButton buttonWithType:UIButtonTypeRoundedRect];
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
    
    _backImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_backImg];
    [_backImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",_ImgString]] placeholderImage:[UIImage imageNamed:@"默认"]];
//    _backImg.backgroundColor=[UIColor redColor];
    _backImg.contentMode = UIViewContentModeScaleToFill;
    // Do any additional setup after loading the view from its nib.
}
-(void)delayMethod{
    loading.hidden=YES;
}
-(void)nextStep
{
            if ([_picindex integerValue]+1<=_dataArr.count-1) {
                NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                dic=[_dataArr[[_picindex integerValue]+1]objectForKey:@"scenePicture" ];
                _DDigitalViewController *room=[[_DDigitalViewController alloc]init];
                room.ImgString=[dic objectForKey:@"space_img"];
                room.roomDataArr=_roomDataArr;
                room.dataArr=_dataArr;
                room.picindex=[NSString stringWithFormat:@"%ld",[_picindex integerValue]+1];
                room.index=[NSString stringWithFormat:@"%ld",[_index integerValue]+1];
                [self.navigationController pushViewController:room animated:YES];

            }else{
                 NSLog(@"+++++++++++++++选完空间产品了已经");
                All3DViewController *all=[[All3DViewController alloc]init];
                [self.navigationController pushViewController:all animated:YES];
                
            }

//    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您对三维效果图是否满意？" preferredStyle:UIAlertControllerStyleAlert];
//    [alertView addAction:[UIAlertAction actionWithTitle:@"不满意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//        NSLog(@"+++++++++++++++退出");
//        
//        SpaceProductViewController *room=[[SpaceProductViewController alloc]init];
//        room.roomDataArr=_roomDataArr;
//        room.index=@"0";
//        room.picindex=@"0";
//        [self.navigationController pushViewController:room animated:YES];
//        
//   
//    }]];
//    [alertView addAction:[UIAlertAction actionWithTitle:@"满意" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
//        NSLog(@"+++++++++++++++确定");
//        //重连
//        if ([_picindex integerValue]+1<=_dataArr.count-1) {
//            NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//            dic=[_dataArr[[_picindex integerValue]+1]objectForKey:@"scenePicture" ];
//            _DDigitalViewController *room=[[_DDigitalViewController alloc]init];
//            room.ImgString=[dic objectForKey:@"space_img"];
//            room.roomDataArr=_roomDataArr;
//            room.dataArr=_dataArr;
//            room.picindex=[NSString stringWithFormat:@"%ld",[_picindex integerValue]+1];
//            room.index=[NSString stringWithFormat:@"%ld",[_index integerValue]+1];
//            [self.navigationController pushViewController:room animated:YES];
////            SpaceProductViewController *room=[[SpaceProductViewController alloc]init];
////            room.roomDataArr=_roomDataArr;
////            room.picindex=[NSString stringWithFormat:@"%ld",[_picindex integerValue]+1];
////            room.index=[NSString stringWithFormat:@"%ld",[_index integerValue]+1];
////            [self.navigationController pushViewController:room animated:YES];
//        }else{
//             NSLog(@"+++++++++++++++选完空间产品了已经");
//            All3DViewController *all=[[All3DViewController alloc]init];
//            [self.navigationController pushViewController:all animated:YES];
//            
//        }
////        SpaceProductViewController *room=[[SpaceProductViewController alloc]init];
////        room.roomDataArr=_roomDataArr;
////        room.index=[NSString stringWithFormat:@"%ld",[_index integerValue]+1];
////        [self.navigationController pushViewController:room animated:YES];
//        
//    }]];
//    [self presentViewController:alertView animated:YES completion:nil];
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
