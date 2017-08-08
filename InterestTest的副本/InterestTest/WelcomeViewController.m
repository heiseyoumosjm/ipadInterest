//
//  WelcomeViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/3/4.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "WelcomeViewController.h"
#import "WSRollView.h"
#import "NewLoginViewController.h"
#import "JTSlideShadowAnimation.h"


@interface WelcomeViewController ()
{
     BOOL isAnimated;
}
@property (strong, nonatomic) JTSlideShadowAnimation *shadowAnimation;
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    WSRollView *wsRoll = [[WSRollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    wsRoll.backgroundColor = [UIColor whiteColor];
    wsRoll.timeInterval = 0.05; //移动一次需要的时间
    wsRoll.rollSpace = 0.5; //每次移动的像素距离
    wsRoll.image = [UIImage imageNamed:@"bg"];//本地图片
    [wsRoll startRoll]; //开始滚动
    [self.view addSubview:wsRoll];
    
    UIImageView *lineImg=[[UIImageView alloc]initWithFrame:CGRectMake(30, 30, SCREEN_WIDTH-60, SCREEN_HEIGHT-60)];
    lineImg.image=[UIImage imageNamed:@"welcome"];
    [self.view addSubview:lineImg];
    
    UIImageView *lineImg1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    lineImg1.image=[UIImage imageNamed:@"bg1"];
    [self.view addSubview:lineImg1];
    
//    UIView *bg1=[[UIView alloc]initWithFrame:CGRectMake(30, 30, SCREEN_WIDTH-60, SCREEN_HEIGHT-60)];
//    bg1.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    [self.view addSubview:bg1];
    
    
    UILabel *wel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-150, 300, 300, 50)];
    wel.text=@"welcome";
    wel.textColor=[UIColor whiteColor];
    wel.textAlignment=NSTextAlignmentCenter;
    wel.font = [UIFont boldSystemFontOfSize:70];
    [self.view addSubview:wel];
    
//    self.shadowAnimation = [JTSlideShadowAnimation new];
//    self.shadowAnimation.animatedView = wel;
//    self.shadowAnimation.shadowWidth = 40.;
    
    
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *user_name=[userDefaultes stringForKey:@"user_name"];
    NSString *user_sex=[userDefaultes stringForKey:@"user_sex"];
    NSString *sex;
    switch ([user_sex integerValue]) {
        case 0:
            sex=@"女士";
            break;
        case 1:
            sex=@"先生";
            break;
            
        default:
            break;
    }
    UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-150, 300+50+40, 300, 50)];
    name.text=[NSString stringWithFormat:@"%@  %@",user_name,sex];
    name.textColor=[UIColor whiteColor];
    name.textAlignment=NSTextAlignmentCenter;
    name.font = [UIFont systemFontOfSize:37];
    [self.view addSubview:name];
    
    UILabel *detail=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-250, 300+50+40+50+10, 500, 50)];
    detail.text=@"开启发现之旅,没有人比我更懂你!";
    detail.textColor=[UIColor whiteColor];
    detail.textAlignment=NSTextAlignmentCenter;
    detail.font = [UIFont systemFontOfSize:24];
    [self.view addSubview:detail];
    
//    self.shadowAnimation = [JTSlideShadowAnimation new];
//    self.shadowAnimation.animatedView = detail;
//    self.shadowAnimation.shadowWidth = 40.;
    
    
    

    
    UIButton *enter=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-265/2, SCREEN_HEIGHT-180, 265, 44)];
    [enter setBackgroundImage:[UIImage imageNamed:@"icon_log"] forState:UIControlStateNormal];
    [enter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [enter setTitle:@"进入测试" forState:UIControlStateNormal];
     enter.titleLabel.font=[UIFont systemFontOfSize:20.f];
    [enter addTarget:self action:@selector(enterNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enter];
//        self.shadowAnimation = [JTSlideShadowAnimation new];
//        self.shadowAnimation.animatedView = enter;
//        self.shadowAnimation.shadowWidth = 40.;

    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    isAnimated = YES;
    [self.shadowAnimation start];
}
- (void)enterNext
{
    if(isAnimated){
        [self.shadowAnimation stop];
    }
    else{
        [self.shadowAnimation start];
    }
    
    isAnimated = !isAnimated;
    
     NewLoginViewController *register1=[[NewLoginViewController alloc]init];
     register1.typeinfp=_type;
    [self.navigationController pushViewController:register1 animated:YES];
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
