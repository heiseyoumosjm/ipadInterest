//
//  LeftViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/2/28.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "LeftViewController.h"
#import "SWRevealViewController.h"
#import "ThemeViewController.h"
#import "ResultViewController.h"
#import "RootHttpHelper.h"
#import "UserInfoViewController.h"
#import "UnitLoginViewController.h"
#import "AvatorInfoViewController.h"
#import "HxModel.h"
#import "UnitDispayActionViewController.h"
#import "SpaceProductViewController.h"
#import "All3DViewController.h"
#import "MyOrderViewController.h"
#import "MyOrderWaitPayViewController.h"
#import "NewLoginViewController.h"
#import "PictureCollectViewController.h"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *user_name;
    NSString *avatorimg;
}
@property (nonatomic,strong)NSMutableArray *sectionArray;
@property (nonatomic,strong)NSMutableArray *flagArray;
@property (nonatomic,strong)NSString *band_user_room_id;
@property (nonatomic,strong)NSString *leftState;
@property (nonatomic,strong)NSString *leftAutoState;
@property (nonatomic,strong)NSString *leftAutoState1;
@property (nonatomic,strong)NSString *leftAutoState2;
@property (nonatomic,strong)NSString *leftAutoState3;
@property (nonatomic,strong)NSString *leftAutoallState;
@property (nonatomic,strong)NSString *user_pay_state;
@property (nonatomic,strong)HxModel *hxModel;
@property (nonatomic,strong)NSMutableArray *roomModelArr;
@property (nonatomic,strong)NSMutableArray *modelArr;
@end

@implementation LeftViewController

@synthesize rearTableView = _rearTableView;

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeData];
     _rearTableView.delegate=self;
     _rearTableView.dataSource=self;
     _rearTableView.separatorStyle = NO;
     self.navigationController.navigationBarHidden=YES;
    
    [_loginOut.layer setMasksToBounds:YES];
    [_loginOut.layer setCornerRadius:5.0]; //设置矩圆角半径
    [_loginOut.layer setBorderWidth:1.0];   //边框宽度
    
    
    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 128.0/255.0, 128.0/255.0, 128.0/255.0, 1 });
    CGColorRef colorref = [UIColor lightGrayColor].CGColor;
    [_loginOut.layer setBorderColor:colorref];//边框颜色
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    user_name=[userDefaultes stringForKey:@"user_name"];
    NSString *user_sex=[userDefaultes stringForKey:@"user_sex"];
    avatorimg=[userDefaultes stringForKey:@"avator"];
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
     _name.text=[NSString stringWithFormat:@"%@ %@",user_name,sex];
    [_avator sd_setImageWithURL:[NSURL URLWithString:avatorimg] placeholderImage:[UIImage imageNamed:@"icon_log_logo"]];
    
    //控制风格测试
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLeft:) name:@"changeLeft" object:nil];
    
    //控制自动化测试空间选择
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLeft1:) name:@"changeLeft1" object:nil];
    //控制自动化测试空间产品
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLeft2:) name:@"changeLeft2" object:nil];
    //控制自动化测试最终三维效果图
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLeft3:) name:@"changeLeft3" object:nil];
    //控制自动化测试最终三维效果图
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLeft4:) name:@"changeLeft4" object:nil];
    
    //控制自动化测试最终三维效果图
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAll:) name:@"getUserProgress" object:nil];
    
    //控制自动化测试最终三维效果图
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut:) name:@"loginOut" object:nil];
    
    //控制自动化测试最终三维效果图
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginin:) name:@"loginin" object:nil];
    
    [self getUserTestResult];
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void)getUserTestResult
{
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"user/get-boolean-test" andParams:nil andSuccess:^(NSDictionary *successData) {
        if ([[successData objectForKey:@"api_code"] integerValue]==401){
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的账号已在别处登陆了，请重新登录！" preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSLog(@"+++++++++++++++退出");
                UserInfoViewController *login=[[UserInfoViewController alloc]init];
                SWRevealViewController *revealController = [self revealViewController];
                [revealController panGestureRecognizer];
                [revealController tapGestureRecognizer];
                
                
                UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:login];
                [revealController setFrontViewController:rearNavigationController  animated:YES];
                [self.navigationController popViewControllerAnimated:YES];

                
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
            
            //                    [defaults setObject:[styleAttr objectForKey:@"fg_sentence"] forKey:@"fg_sentence"];
            //                    [defaults setObject:[styleAttr objectForKey:@"result_imgs"] forKey:@"result_imgs"];
            [defaults synchronize];

            
             _leftState=@"1";
            [_rearTableView reloadData];
        }else{
            
        }
        
    } andError:^(NSError *error) {
        //加载圈圈(显示)
        NSLog(@"%@",error);
    }];
    
    
    
}

- (void)loginin:(NSNotification *)notification
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    user_name=[userDefaultes stringForKey:@"user_name"];
    NSString *user_sex=[userDefaultes stringForKey:@"user_sex"];
    avatorimg=[userDefaultes stringForKey:@"avator"];
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
    _name.text=[NSString stringWithFormat:@"%@ %@",user_name,sex];
    [_avator sd_setImageWithURL:[NSURL URLWithString:avatorimg] placeholderImage:[UIImage imageNamed:@"icon_log_logo"]];
    
    [self getUserTestResult];
//    _avatorBtn.userInteractionEnabled=YES;
}
- (void)loginOut:(NSNotification *)notification
{
    _name.text=@"请登录";
    _avator.image=[UIImage imageNamed:@"icon_log_logo"];
//    _avatorBtn.userInteractionEnabled=NO;
    _leftState=@"0";
    _leftAutoState=@"0";
    _leftAutoState1=@"0";
    _leftAutoState2=@"0";
    _leftAutoState3=@"0";
    _leftAutoallState=@"0";
    [_rearTableView reloadData];
}
- (void)changeLeft:(NSNotification *)notification
{
     _leftState=notification.object;
    [_rearTableView reloadData];
    
}
- (void)changeAll:(NSNotification *)notification
{
    
    _leftAutoState=@"0";
    _leftAutoState1=@"0";
    _leftAutoState2=@"0";
    _leftAutoState3=@"0";
    
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    arr=notification.object;
    _band_user_room_id=arr[0];
    _leftAutoallState=[NSString stringWithFormat:@"%@",arr[1]];
    [_rearTableView reloadData];
    switch ([_leftAutoallState integerValue]) {
        case 2:
        {
             NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:_band_user_room_id forKey:@"pad_user_room_id"];
            [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"building/get-room-function" andParams:params andSuccess:^(NSDictionary *successData) {
                //            //加载圈圈(显示)
                if ([[successData objectForKey:@"api_code"] integerValue]==200) {
                    UnitDispayActionViewController *next=[[UnitDispayActionViewController alloc]init];
                    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                    dic=[successData objectForKey:@"roomFunction"];
                    _hxModel=[[HxModel alloc]initWithDictionary:dic error:nil];
                    next.hxModel=_hxModel;
                    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                    [defaults setObject:[successData objectForKey:@"id"] forKey:@"pad_user_room_function_id"];
                    [defaults synchronize];
                    next.roomModelArr=[successData objectForKey:@"roomFunctionDefault"];
                    next.pad_user_room_id=[successData objectForKey:@"id"];
                    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:next];
                    
                    SWRevealViewController *revealController = [self revealViewController];
                    [revealController setFrontViewController:rearNavigationController  animated:YES];
                    
                    
                }
                else if ([[successData objectForKey:@"api_code"] integerValue]==401){
                    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的账号已在别处登陆了，请重新登录！" preferredStyle:UIAlertControllerStyleAlert];
                    [alertView addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        NSLog(@"+++++++++++++++退出");
                        NewLoginViewController *login=[[NewLoginViewController alloc]init];
                        SWRevealViewController *revealController = [self revealViewController];
                        [revealController panGestureRecognizer];
                        [revealController tapGestureRecognizer];
                        
                        
                        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:login];
                        [revealController setFrontViewController:rearNavigationController  animated:YES];
                        [self.navigationController popViewControllerAnimated:YES];
                        
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
            
            
        }
            break;
        case 3:
        {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:_band_user_room_id forKey:@"pad_user_room_id"];
            [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"building/get-room-functions" andParams:params andSuccess:^(NSDictionary *successData) {
                //            //加载圈圈(显示)
                if ([[successData objectForKey:@"api_code"] integerValue]==200) {
                    SpaceProductViewController *space=[[SpaceProductViewController alloc]init];
                    space.roomDataArr=[successData objectForKey:@"data"];
                    space.index=@"0";
                    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:space];
                     SWRevealViewController *revealController = [self revealViewController];
                    [revealController setFrontViewController:rearNavigationController  animated:YES];
                }else{
                    [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
                }
                
            } andError:^(NSError *error) {
                //加载圈圈(显示)
                [[HudHelper hudHepler] HideHUDAlert:self.view];
                NSLog(@"%@",error);
            }];
            

        }
            break;
        case 4:
        {
            All3DViewController *all=[[All3DViewController alloc]init];
            //  [self.navigationController pushViewController:all animated:YES];
            UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:all];
             SWRevealViewController *revealController = [self revealViewController];
            [revealController setFrontViewController:rearNavigationController  animated:YES];
        }
            break;
        case 5:
        {
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            NSString *pad_user_room_function_id=[userDefaultes stringForKey:@"pad_user_room_function_id"];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:pad_user_room_function_id forKey:@"pad_user_room_id"];
            [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"order/get-order-status" andParams:params andSuccess:^(NSDictionary *successData) {
                SWRevealViewController *revealController = [self revealViewController];
                //            //加载圈圈(显示)
                if ([[successData objectForKey:@"api_code"] integerValue]==200) {
                    _user_pay_state=[successData objectForKey:@"status"];
                    
                        
                        if ([_user_pay_state integerValue]==0||[_user_pay_state integerValue]==1) {
                            MyOrderWaitPayViewController *all=[[MyOrderWaitPayViewController alloc]init];
                            UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:all];
                            [revealController setFrontViewController:rearNavigationController  animated:YES];
                        }else{
                            MyOrderViewController *all=[[MyOrderViewController alloc]init];
                            UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:all];
                            [revealController setFrontViewController:rearNavigationController  animated:YES];
                        }
                    
                }else{
                    MyOrderWaitPayViewController *all=[[MyOrderWaitPayViewController alloc]init];
                    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:all];
                    [revealController setFrontViewController:rearNavigationController  animated:YES];
//                    if (<#condition#>) {
//                        <#statements#>
//                    }
//                    [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
                }
                
            } andError:^(NSError *error) {
                //加载圈圈(显示)
                [[HudHelper hudHepler] HideHUDAlert:self.view];
                NSLog(@"%@",error);
            }];
            

        }
            break;
            
        default:
            break;
    }
}
- (void)changeLeft1:(NSNotification *)notification
{
     _modelArr=[[NSMutableArray alloc]init];
     _modelArr=notification.object;
     _hxModel=_modelArr[0];
     _roomModelArr=_modelArr[1];
     _leftAutoState=@"1";
    [_rearTableView reloadData];
    
//    UnitDispayActionViewController *next=[[UnitDispayActionViewController alloc]init];
//    next.hxModel=_hxModel;
//    [self.navigationController pushViewController:next animated:YES];
}
- (void)changeLeft2:(NSNotification *)notification
{
    _roomModelArr=[[NSMutableArray alloc]init];
    _roomModelArr=notification.object;
    _leftAutoState1=@"2";
    [_rearTableView reloadData];
    
    //    UnitDispayActionViewController *next=[[UnitDispayActionViewController alloc]init];
    //    next.hxModel=_hxModel;
    //    [self.navigationController pushViewController:next animated:YES];
}
- (void)changeLeft3:(NSNotification *)notification
{

    _leftAutoState2=@"3";
    [_rearTableView reloadData];
   
}
- (void)changeLeft4:(NSNotification *)notification
{
  
    _leftAutoState3=@"4";
    [_rearTableView reloadData];

}
/**
 *  处理数据  _sectionArray里面存储数组
 */
- (void)makeData{
    _sectionArray = [NSMutableArray array];
    _flagArray  = [NSMutableArray array];
    NSInteger num = 3;
    for (int i = 0; i < num; i ++) {
        NSMutableArray *rowArray = [NSMutableArray array];
        if(i==0)
        {
            [rowArray addObject:@"开始测试"];
            [rowArray addObject:@"测试结果"];
        }
        else if(i==1){
            [rowArray addObject:@"图库"];
        }
        else if(i==2){
            [rowArray addObject:@"户型登录"];
            [rowArray addObject:@"空间选择"];
            [rowArray addObject:@"空间产品"];
            [rowArray addObject:@"三维效果"];
            [rowArray addObject:@"方案清单"];
        }
        [_sectionArray addObject:rowArray];
        [_flagArray addObject:@"0"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View lifecycle



#pragma marl - UITableView Data Source

//设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sectionArray.count;
}
//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = _sectionArray[section];
    return arr.count;
}
//组头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.f;
}
//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_flagArray[indexPath.section] isEqualToString:@"0"])
        return 0;
    else
        return 60;
}
//组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    UILabel *sectionLabel = [[UILabel alloc] init];
    UIImageView *img=[[UIImageView alloc]init];
    img.frame=CGRectMake(57, 21.5, 17, 17);
    sectionLabel.frame = CGRectMake(92, 0, self.view.frame.size.width, 60);
    UIImageView *img1=[[UIImageView alloc]init];
    img1.frame=CGRectMake(200, 23.5, 12.5, 12.5);
    if ([_flagArray[section] isEqualToString:@"0"]) {
      img1.image=[UIImage imageNamed:@"right"];
    }else{
    img1.image=[UIImage imageNamed:@"down"];
    }
    sectionLabel.textColor = UIColorFromRGB(0x333333);
    if (section==0) {
      sectionLabel.text = @"风格测试";
      img.image=[UIImage imageNamed:@"interest"];
    }else if (section==1){
      sectionLabel.text = @"最In家图库";
      img.image=[UIImage imageNamed:@"pic"];
    }
    else if(section==2){
      sectionLabel.text = @"自动化测试";
      img.image=[UIImage imageNamed:@"auto"];
    }
    sectionLabel.textAlignment = NSTextAlignmentLeft;
    backView.tag = 100 + section;
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"itembg.png"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sectionClick:)];
    [backView addGestureRecognizer:tap];
    [backView addSubview:img];
     [backView addSubview:img1];
    [backView addSubview:sectionLabel];
    return backView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
//    if (cell == nil) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *arr = _sectionArray[indexPath.section];
    UILabel *rowLabel= [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 100, 60)];
    rowLabel.text= arr[indexPath.row];
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
            {
                if ([_leftState integerValue]!=1) {
                    rowLabel.textColor=UIColorFromRGB(0x808080);
                }else{
                    rowLabel.textColor=UIColorFromRGB(0xcccccc);
                }
            }
                break;
            case 1:
            {
                if ([_leftState integerValue]==1) {
                   rowLabel.textColor=UIColorFromRGB(0x808080);
                }else{
                   rowLabel.textColor=UIColorFromRGB(0xcccccc);
                }
            }
                break;
           
                
            default:
                break;
        }
//        if (indexPath.row>=[_leftState integerValue]) {
//            rowLabel.textColor=UIColorFromRGB(0xcccccc);
////            rowLabel.textColor=UIColorFromRGB(0x808080);
//        }else{
//            rowLabel.textColor=UIColorFromRGB(0x808080);
//        }
    }else if(indexPath.section==1){
        if (indexPath.row==0) {
             rowLabel.textColor=UIColorFromRGB(0x808080);
        }
    }
    else if(indexPath.section==2){
        switch (indexPath.row) {
            case 0:
//            {
//                if ([ _leftState integerValue]==1) {
//                 rowLabel.textColor=UIColorFromRGB(0xcccccc);
//                }else{
                 rowLabel.textColor=UIColorFromRGB(0x808080);
//                }
//            }
                break;
            case 1:
                if ([_leftAutoState integerValue]==1) {
                    rowLabel.textColor=UIColorFromRGB(0x808080);
                }else{
                    if ([_leftAutoallState integerValue]>=1) {
                      rowLabel.textColor=UIColorFromRGB(0x808080);
                    }else{
                      rowLabel.textColor=UIColorFromRGB(0xcccccc);
                    }
                }
                break;
            case 2:
                if ([_leftAutoState1 integerValue]==2) {
                    rowLabel.textColor=UIColorFromRGB(0x808080);
                }else{
                    if ([_leftAutoallState integerValue]>2) {
                        rowLabel.textColor=UIColorFromRGB(0x808080);
                    }else{
                        rowLabel.textColor=UIColorFromRGB(0xcccccc);
                    }
                }
                
                break;
            case 3:
                if ([_leftAutoState2 integerValue]==3) {
                    rowLabel.textColor=UIColorFromRGB(0x808080);
                }else{
                    if ([_leftAutoallState integerValue]>3) {
                        rowLabel.textColor=UIColorFromRGB(0x808080);
                    }else{
                        rowLabel.textColor=UIColorFromRGB(0xcccccc);
                    }
                }
                
                break;
            case 4:
                if ([_leftAutoState3 integerValue]==4) {
                        rowLabel.textColor=UIColorFromRGB(0x808080);
                }else{
                    if ([_leftAutoallState integerValue]>4) {
                        rowLabel.textColor=UIColorFromRGB(0x808080);
                    }else{
                        rowLabel.textColor=UIColorFromRGB(0xcccccc);
                    }
                }
                
                break;
                
            default:
                break;
        }
//            rowLabel.textColor=UIColorFromRGB(0x808080);
    }
//    if (indexPath.row<=[_leftState integerValue]) {
//    rowLabel.textColor=UIColorFromRGB(0x808080);
////    rowLabel.textColor=[UIColor lightGrayColor];
//    }else{
//    rowLabel.textColor=UIColorFromRGB(0xcccccc);
//    }
//    rowLabel.textAlignment = NSTextAlignmentRight;
    cell.clipsToBounds = YES;//这句话很重要 不信你就试试
   
    [cell.contentView addSubview:rowLabel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
     SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            if ([_leftState integerValue]==1) {
                
            }else{
            ThemeViewController *theme=[[ThemeViewController alloc]init];
            UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:theme];
            [revealController setFrontViewController:rearNavigationController  animated:YES];
            }
        }else if (indexPath.row==1){
            if (indexPath.row==[_leftState integerValue]) {
            ResultViewController *theme=[[ResultViewController alloc]init];
            UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:theme];
           [revealController setFrontViewController:rearNavigationController  animated:YES];
                
            }
            
        }else{
            
        }
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            PictureCollectViewController *theme=[[PictureCollectViewController alloc]init];
            UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:theme];
            [revealController setFrontViewController:rearNavigationController  animated:YES];
        }
    }
    else if (indexPath.section==2)
    {
        if (indexPath.row==0) {
            UnitLoginViewController *theme=[[UnitLoginViewController alloc]init];
            UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:theme];
            [revealController setFrontViewController:rearNavigationController  animated:YES];
        }
        else if(indexPath.row==1){
            if ([_leftAutoState integerValue]==1&&[self isBlankString:_leftAutoallState]) {
                UnitDispayActionViewController *next=[[UnitDispayActionViewController alloc]init];
                next.hxModel=_hxModel;
                next.roomModelArr=_roomModelArr;

                NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
                NSString *pad_user_room_function_id=[userDefaultes stringForKey:@"pad_user_room_function_id"];
                next.pad_user_room_id=pad_user_room_function_id;
                UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:next];
                [revealController setFrontViewController:rearNavigationController  animated:YES];
            }else if ([_leftAutoallState integerValue]>=1){
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setValue:_band_user_room_id forKey:@"pad_user_room_id"];
                [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"building/get-room-function" andParams:params andSuccess:^(NSDictionary *successData) {
                    //            //加载圈圈(显示)
                    if ([[successData objectForKey:@"api_code"] integerValue]==200) {
                        UnitDispayActionViewController *next=[[UnitDispayActionViewController alloc]init];
                        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                        dic=[successData objectForKey:@"roomFunction"];
                        _hxModel=[[HxModel alloc]initWithDictionary:dic error:nil];
                        next.hxModel=_hxModel;
                        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                        [defaults setObject:[successData objectForKey:@"id"] forKey:@"pad_user_room_function_id"];
                        [defaults synchronize];
                        next.roomModelArr=[successData objectForKey:@"roomFunctionDefault"];
                        next.pad_user_room_id=[successData objectForKey:@"id"];
                        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:next];
                        [revealController setFrontViewController:rearNavigationController  animated:YES];
                        
                        
                    }else{
                        [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
                    }
                    
                } andError:^(NSError *error) {
                    //加载圈圈(显示)
                    [[HudHelper hudHepler] HideHUDAlert:self.view];
                    NSLog(@"%@",error);
                }];

                
            }
        }else if(indexPath.row==2){
            if ([_leftAutoState1 integerValue]==2&&[self isBlankString:_leftAutoallState]) {
//                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//                [defaults removeObjectForKey:@"colorid"];
//                [defaults synchronize];
                SpaceProductViewController *space=[[SpaceProductViewController alloc]init];
                //    space.room_function_id=_funcArr[0];
                space.roomDataArr=_roomModelArr;
                space.index=@"0";
                UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:space];
                [revealController setFrontViewController:rearNavigationController  animated:YES];
            }else if ([_leftAutoallState integerValue]>2){
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setValue:_band_user_room_id forKey:@"pad_user_room_id"];
                [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"building/get-room-functions" andParams:params andSuccess:^(NSDictionary *successData) {
                    //            //加载圈圈(显示)
                    if ([[successData objectForKey:@"api_code"] integerValue]==200) {
                        SpaceProductViewController *space=[[SpaceProductViewController alloc]init];
                        space.roomDataArr=[successData objectForKey:@"data"];
                        space.index=@"0";
                        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:space];
                        [revealController setFrontViewController:rearNavigationController  animated:YES];
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
        else if(indexPath.row==3){
            if ([_leftAutoState2 integerValue]==3&&[self isBlankString:_leftAutoallState]) {
                All3DViewController *all=[[All3DViewController alloc]init];
              //  [self.navigationController pushViewController:all animated:YES];
                UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:all];
                [revealController setFrontViewController:rearNavigationController  animated:YES];
            }else if ([_leftAutoallState integerValue]>3){
                All3DViewController *all=[[All3DViewController alloc]init];
                //  [self.navigationController pushViewController:all animated:YES];
                UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:all];
                [revealController setFrontViewController:rearNavigationController  animated:YES];
            }
        }else{
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            NSString *pad_user_room_function_id=[userDefaultes stringForKey:@"pad_user_room_function_id"];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:pad_user_room_function_id forKey:@"pad_user_room_id"];
            [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"order/get-order-status" andParams:params andSuccess:^(NSDictionary *successData) {
                //            //加载圈圈(显示)
                if ([[successData objectForKey:@"api_code"] integerValue]==200) {
                    _user_pay_state=[successData objectForKey:@"status"];
                    if ([_leftAutoState3 integerValue]==4&&[self isBlankString:_leftAutoallState]) {
                        if ([_user_pay_state integerValue]==0||[_user_pay_state integerValue]==1) {
                            MyOrderWaitPayViewController *all=[[MyOrderWaitPayViewController alloc]init];
                            UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:all];
                            [revealController setFrontViewController:rearNavigationController  animated:YES];
                        }else{
                            MyOrderViewController *all=[[MyOrderViewController alloc]init];
                            UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:all];
                            [revealController setFrontViewController:rearNavigationController  animated:YES];
                        }
                        
                    }else if ([_leftAutoallState integerValue]>4){
                        
                        if ([_user_pay_state integerValue]==0||[_user_pay_state integerValue]==1) {
                            MyOrderWaitPayViewController *all=[[MyOrderWaitPayViewController alloc]init];
                            UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:all];
                            [revealController setFrontViewController:rearNavigationController  animated:YES];
                        }else{
                            MyOrderViewController *all=[[MyOrderViewController alloc]init];
                            UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:all];
                            [revealController setFrontViewController:rearNavigationController  animated:YES];
                        }
                    }
  
                }else{
                    MyOrderWaitPayViewController *all=[[MyOrderWaitPayViewController alloc]init];
                    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:all];
                    [revealController setFrontViewController:rearNavigationController  animated:YES];
                   // [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
                }
                
            } andError:^(NSError *error) {
                //加载圈圈(显示)
                [[HudHelper hudHepler] HideHUDAlert:self.view];
                NSLog(@"%@",error);
            }];
            
        }

    }
   
}
- (void)sectionClick:(UITapGestureRecognizer *)tap{
    int index = tap.view.tag % 100;
    
    NSMutableArray *indexArray = [[NSMutableArray alloc]init];
    NSArray *arr = _sectionArray[index];
    for (int i = 0; i < arr.count; i ++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:index];
        [indexArray addObject:path];
    }
    //展开
    if ([_flagArray[index] isEqualToString:@"0"]) {
        _flagArray[index] = @"1";
        [_rearTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationBottom];  //使用下面注释的方法就 注释掉这一句
        [_rearTableView reloadData];
     
    } else { //收起
        _flagArray[index] = @"0";
        [_rearTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationTop]; //使用下面注释的方法就 注释掉这一句
        [_rearTableView reloadData];
    }
    //	NSRange range = NSMakeRange(index, 1);
    //	NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
    //	[_tableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationAutomatic];
}





- (IBAction)loginOutBtn:(UIButton *)sender {
    //发通知侧边栏可以点击展开测试结果界面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOut" object:nil];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"user_name"];
    [defaults removeObjectForKey:@"user_mobile"];
    [defaults removeObjectForKey:@"user_sex"];
    [defaults removeObjectForKey:@"usertoken"];
    [defaults removeObjectForKey:@"avator"];
    [defaults removeObjectForKey:@"color_sentence"];
    [defaults removeObjectForKey:@"fg_sentence"];
    [defaults removeObjectForKey:@"result_imgs"];
    [defaults removeObjectForKey:@"name"];
    
    [defaults synchronize];
    [[RootHttpHelper httpHelper] setUserToken:@""];
    
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UserInfoViewController *user=[[UserInfoViewController alloc]init];
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:user];
    [revealController setFrontViewController:rearNavigationController  animated:YES];

}
- (IBAction)avatorClick:(UIButton *)sender {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *token=[userDefaultes stringForKey:@"usertoken"];
    if ([self isBlankString:token]) {
        UserInfoViewController *user=[[UserInfoViewController alloc]init];
        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:user];
        SWRevealViewController *revealController = [self revealViewController];
        [revealController panGestureRecognizer];
        [revealController tapGestureRecognizer];

        [revealController setFrontViewController:rearNavigationController  animated:YES];
    }else{
    AvatorInfoViewController *avator=[[AvatorInfoViewController alloc]init];
    avator.user_name=_name.text;
    avator.avator=avatorimg;
    [self.navigationController pushViewController:avator animated:YES];
    }
    
}
@end
