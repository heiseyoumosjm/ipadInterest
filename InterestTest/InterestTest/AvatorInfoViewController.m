//
//  AvatorInfoViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/3/15.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "AvatorInfoViewController.h"
#import "RootHttpHelper.h"
#import "SWRevealViewController.h"
#import "UserInfoViewController.h"
#import "RootHttpHelper.H"
#import "BasicModel.h"
#import "UnitLoginViewController.h"
#import "NewLoginViewController.h"
#import "MyCollectPicViewController.h"
#import "CollectPicViewController.h"

@interface AvatorInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *title;
}
@property(strong,nonatomic)NSMutableArray *dataArr;
@property(assign,nonatomic)BOOL isclick;
@end

@implementation AvatorInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationBarHidden=YES;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = NO;
    
    
    [_loginout.layer setMasksToBounds:YES];
    [_loginout.layer setCornerRadius:5.0]; //设置矩圆角半径
    [_loginout.layer setBorderWidth:1.0];   //边框宽度
    CGColorRef colorref = [UIColor lightGrayColor].CGColor;
    [_loginout.layer setBorderColor:colorref];//边框颜色
    
    //设置按钮
    UIButton *_setBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _setBut.frame = CGRectMake(20, 30, 12.5, 20);
    [_setBut addTarget: self action: @selector(back) forControlEvents: UIControlEventTouchUpInside];
//    UIBarButtonItem *setItem = [[UIBarButtonItem alloc]initWithCustomView:_setBut];
    [_setBut addTarget:self action:@selector(toback) forControlEvents:UIControlEventTouchUpInside];
    [_setBut setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.view addSubview:_setBut];
//    NSMutableArray *buttonItems = [NSMutableArray array];
//    [buttonItems addObject:setItem];
//    self.navigationItem.leftBarButtonItems = buttonItems;
    
    [_avayor sd_setImageWithURL:[NSURL URLWithString:_avator] placeholderImage:[UIImage imageNamed:@"icon_log_logo"]];
    
     title=[[UILabel alloc]initWithFrame:CGRectMake(60, 22, 100, 40)];
     title.text=_user_name;
    title.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:title];
//     self.title.text=_user_name;
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 64 , SCREEN_WIDTH, 1)];
    line.backgroundColor=UIColorFromRGB(0xcccccc);
    [self.view addSubview:line];
    
    self.navigationController.title=_user_name;
    
    //[self getUserLP];
    
    //控制自动化测试最终三维效果图
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginin:) name:@"loginin" object:nil];
    
    //控制风格测试
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back:) name:@"toback" object:nil];
     _isclick=NO;
    

    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
     [self getUserLP];
}
-(void)back:(NSNotification *)notification
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loginin:(NSNotification *)notification
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *name=[userDefaultes stringForKey:@"user_name"];
    title.text=name;
}
-(void)toback{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getUserLP
{
    _dataArr=[[NSMutableArray alloc]init];
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"user/get-bind-rooms" andParams:nil andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
            _dataArr=[successData objectForKey:@"data"];
            [_tableView reloadData];
            
            
            if (_dataArr.count==0&&_isclick) {
                UnitLoginViewController *login=[[UnitLoginViewController alloc]init];
                SWRevealViewController *revealController = [self revealViewController];
                [revealController panGestureRecognizer];
                [revealController tapGestureRecognizer];
                
                
                UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:login];
                [revealController setFrontViewController:rearNavigationController  animated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                //
            }

//            if (_dataArr.count==0) {
//                UnitLoginViewController *login=[[UnitLoginViewController alloc]init];
//                SWRevealViewController *revealController = [self revealViewController];
//                [revealController panGestureRecognizer];
//                [revealController tapGestureRecognizer];
//
//
//                UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:login];
//                [revealController setFrontViewController:rearNavigationController  animated:YES];
//                [self.navigationController popViewControllerAnimated:YES];
//            }else{
////           [_tableView reloadData];
//            }
        
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
                ////                LeftViewController  *left=[[LeftViewController alloc]init];
                //                UIViewController *target = nil;
                //                for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
                //                    if ([controller isKindOfClass:[theme class]]) { //这里判断是否为你想要跳转的页面
                //                        target = controller;
                ////                        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:theme];
                ////                        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:target];
                ////
                ////                        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
                ////                        revealController.delegate = self;
                //                        [self.navigationController popViewControllerAnimated:YES];
                //                    }else{
                ////                        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:theme];
                ////                        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:left];
                ////
                ////                        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
                ////                        revealController.delegate = self;
                ////                        [self.navigationController pushViewController:revealController animated:YES];
                //                    }
                //                }
                
                
                
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
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
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
//设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    footView.backgroundColor=[UIColor whiteColor];
    
    UIButton *addBtn=[[UIButton alloc]init];
        [addBtn setTitle:@" 添加户型" forState:UIControlStateNormal];
        addBtn.frame=CGRectMake(50, 1, 120, 49);
        [addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [addBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        addBtn.titleLabel.font=[UIFont systemFontOfSize:14.f];
        addBtn.tag=section;
        [addBtn addTarget:self action:@selector(addGood1) forControlEvents:UIControlEventTouchUpInside];
        [addBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0,-20, 0.0, 0.0)];
        [footView addSubview:addBtn];
  
    [footView addSubview:addBtn];
    return footView;

}
-(void)addGood1{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toback" object:nil];
    
     NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey: @"type"];
    [defaults removeObjectForKey: @"hxname"];
    [defaults removeObjectForKey:@"hxnameid"];
    [defaults removeObjectForKey:@"lpnameid"];
    [defaults removeObjectForKey:@"lpname"];
    [defaults removeObjectForKey:@"unitLab"];
    
    [defaults synchronize];

    
    UnitLoginViewController *login=[[UnitLoginViewController alloc]init];
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
  
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:login];
    [revealController setFrontViewController:rearNavigationController  animated:YES];

}
//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic=_dataArr[indexPath.row];
//    if ([self isBlankString:[dic objectForKey:@"basicRoom"]]) {
//        
//    }else{
//        
//    }
    BasicModel *model=[[BasicModel alloc]initWithDictionary:[dic objectForKey:@"basicRoom"] error:nil];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    if (!model)
    {
    cell.textLabel.text = [NSString stringWithFormat:@"           %@-%@",[[dic objectForKey:@"padRoom"] objectForKey:@"building"],[[dic objectForKey:@"padRoom"] objectForKey:@"room_name"]];
         NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        [defaults setObject: @"1" forKey:@"type"];
        [defaults setObject:[[dic objectForKey:@"padRoom"] objectForKey:@"id"] forKey:@"lpnameid"];
        [defaults setObject:[[dic objectForKey:@"padRoom"] objectForKey:@"building"] forKey:@"lpname"];
        [defaults setObject:[[dic objectForKey:@"padRoom"] objectForKey:@"room_name"] forKey:@"unitLab"];
        [defaults synchronize];
    }
    else {
        cell.textLabel.text = [NSString stringWithFormat:@"           其它楼盘-%@", [[dic objectForKey:@"basicRoom"] objectForKey:@"room_name"]];
         NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        [defaults setObject: @"0" forKey:@"type"];
        [defaults setObject:model.room_name forKey:@"hxname"];
        [defaults setObject:model.id forKey:@"hxnameid"];
        [defaults synchronize];
    }
    

    cell.textLabel.textColor=UIColorFromRGB(0x333333);
    cell.textLabel.font=[UIFont systemFontOfSize:14.f];
   // cell.textLabel.text = [NSString stringWithFormat:@"首页测试数据----%ld", (long)indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //消除cell选择痕迹
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.2f];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic=_dataArr[indexPath.row];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[dic objectForKey:@"id"] forKey:@"pad_user_room_id"];
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"pad-user/progress" andParams:params andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
            
            NSMutableArray *arr=[[NSMutableArray alloc]init];
            [arr addObject:[dic objectForKey:@"id"]];
            [arr addObject:[successData objectForKey:@"progress"]];
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            [defaults setObject:[dic objectForKey:@"id"] forKey:@"pad_user_room_function_id"];
            [defaults synchronize];

            
            //发通知侧边栏可以点击展开测试结果界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getUserProgress" object:arr];
            [self.navigationController popViewControllerAnimated:YES];
            
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
- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}
- (IBAction)loginOutClick:(UIButton *)sender {
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
     _avayor.image=[UIImage imageNamed:@"icon_log_logo"];
     title.text=@"请登录";
     _dataArr=[[NSMutableArray alloc]init];
    [_tableView reloadData];
    [defaults removeObjectForKey: @"type"];
    [defaults removeObjectForKey: @"hxname"];
    [defaults removeObjectForKey:@"hxnameid"];
    [defaults removeObjectForKey:@"lpnameid"];
    [defaults removeObjectForKey:@"lpname"];
    [defaults removeObjectForKey:@"unitLab"];
    [defaults removeObjectForKey:@"colorid"];
    [defaults removeObjectForKey:@"pad_user_room_function_id"];
    
    [defaults synchronize];
    [[RootHttpHelper httpHelper] setUserToken:@""];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toback" object:nil];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UserInfoViewController *user=[[UserInfoViewController alloc]init];
    user.type=@"3";
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:user];
    [revealController setFrontViewController:rearNavigationController  animated:YES];
    

    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
// 自定义左滑显示编辑按钮
-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title:@"x" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                             NSLog(@"jianjianjai");
                                                                             UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定要删除该户型吗？" preferredStyle:UIAlertControllerStyleAlert];
                                                                             [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                                 NSLog(@"+++++++++++++++退出");
                                                                                 
                                                                                 
                                                                                 
                                                                                 
                                                                             }]];
                                                                             [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                                                 NSLog(@"+++++++++++++++确定");
                                                                                 _isclick=YES;
                                                                        
                                                                                 NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                                                                                 [defaults removeObjectForKey: @"type"];
                                                                                 [defaults removeObjectForKey: @"hxname"];
                                                                                 [defaults removeObjectForKey:@"hxnameid"];
                                                                                 [defaults removeObjectForKey:@"lpnameid"];
                                                                                 [defaults removeObjectForKey:@"lpname"];
                                                                                 [defaults removeObjectForKey:@"unitLab"];
                                                                                 
                                                                                 [defaults synchronize];

                                                                                 NSMutableDictionary *params = [NSMutableDictionary dictionary];
                                                                        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                                                                        dic=_dataArr[indexPath.row];
                                                                            
                                                                        [params setValue:[dic objectForKey:@"id"] forKey:@"pad_user_room_id"];
                                                                       
                                                                       [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"pad-user/delete-user-room" andParams:params andSuccess:^(NSDictionary *successData) {
                                                                                     //            //加载圈圈(显示)
                                                                                     if ([[successData objectForKey:@"api_code"] integerValue]==200) {
                                                                          
                                                                        [self getUserLP];
//                                                                                         if (_dataArr.count==0) {
//                                                                                             UnitLoginViewController *login=[[UnitLoginViewController alloc]init];
//                                                                                             SWRevealViewController *revealController = [self revealViewController];
//                                                                                             [revealController panGestureRecognizer];
//                                                                                             [revealController tapGestureRecognizer];
//                                                                                             
//                                                                                             
//                                                                                             UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:login];
//                                                                                             [revealController setFrontViewController:rearNavigationController  animated:YES];
//                                                                                             [self.navigationController popViewControllerAnimated:YES];
//                                                                                         }else{
//                                                                                             //           
//                                                                                         }

                                                                                         
                                                                                     }else{
                                                                                         [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
                                                                                     }
                                                                                     
                                                                                 } andError:^(NSError *error) {
                                                                                     //加载圈圈(显示)
                                                                                     [[HudHelper hudHepler] HideHUDAlert:self.view];
                                                                                     NSLog(@"%@",error);
                                                                                 }];
                                                                             }]];
                                                                             [self presentViewController:alertView animated:YES completion:nil];
                                                                             
                                                                             
                                                                             
                                                                             
                                                                         }];
    
    //    UITableViewRowAction *rowActionSec = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
    //                                                                            title:@"快速备忘"    handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    //                                                                                NSLog(@"快速备忘");
    //
    //                                                                            }];
    //    rowActionSec.backgroundColor = [UIColor colorWithHexString:@"f38202"];
    rowAction.backgroundColor = colorHead;
    
    NSArray *arr = @[rowAction];
    return arr;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //        [dataArray removeObjectAtIndex:indexPath.row];
        //        // Delete the row from the data source.
        //        [testTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
//// 自定义左滑显示编辑按钮
//-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
//                                                                         title:@"  x  " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//                                                                             NSLog(@"jianjianjai");
//                                                                             UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定要删除该商品吗？" preferredStyle:UIAlertControllerStyleAlert];
//                                                                             [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                                                                                 NSLog(@"+++++++++++++++退出");
//                                                                                 
//                                                                                 
//                                                                                 
//                                                                                 
//                                                                             }]];
//                                                                             [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
//                                                                                 NSLog(@"+++++++++++++++确定");
//                                                                                 
////                                                                                 NSMutableArray *data=[[NSMutableArray alloc]init];
////                                                                                 data=_dataInfoArr[indexPath.section];
////                                                                                 NSMutableDictionary *dic=data[indexPath.row-1];
////                                                                                 
////                                                                                 NSMutableDictionary *params = [NSMutableDictionary dictionary];
////                                                                                 [params setValue:[dic objectForKey:@"id"] forKey:@"pad_user_room_goods_model_id"];
////                                                                                 [params setValue:@"0"forKey:@"num"];
////                                                                                 _dataInfoArr=[[NSMutableArray alloc]init];
////                                                                                 [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"product-goods/goods-num" andParams:params andSuccess:^(NSDictionary *successData) {
////                                                                                     //            //加载圈圈(显示)
////                                                                                     if ([[successData objectForKey:@"api_code"] integerValue]==200) {
////                                                                                         _is_need_accessories=[successData objectForKey:@"is_need_accessories"];
////                                                                                         [_dataInfoArr addObjectsFromArray:[successData objectForKey:@"data"]];
////                                                                                         [_dataInfoArr addObject:[successData objectForKey:@"online_goods"]];
////                                                                                         [table reloadData];
////                                                                                         if ([[successData objectForKey:@"is_need_accessories"] integerValue]==0) {
////                                                                                             _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"offline_num"]];
////                                                                                             _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"offline_price"] floatValue]];
////                                                                                             _allmoney=[successData objectForKey:@"offline_price"] ;
////                                                                                             [self calculateDiscount];
////                                                                                         }else{
////                                                                                             _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"num"]];
////                                                                                             _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"price"] floatValue]];
////                                                                                             float finprice=[[successData objectForKey:@"price"] floatValue]-[[successData objectForKey:@"offline_price"] floatValue];
////                                                                                             _shipinLab.text=[NSString stringWithFormat:@"(包含饰品 %.2f)",finprice];
////                                                                                             _allmoney=[successData objectForKey:@"price"] ;
////                                                                                             [self calculateDiscount];
////                                                                                         }
////                                                                                         
////                                                                                     }else{
////                                                                                         [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
////                                                                                     }
////                                                                                     
////                                                                                 } andError:^(NSError *error) {
////                                                                                     //加载圈圈(显示)
////                                                                                     [[HudHelper hudHepler] HideHUDAlert:self.view];
////                                                                                     NSLog(@"%@",error);
////                                                                                 }];
//                                                                             }]];
//                                                                             [self presentViewController:alertView animated:YES completion:nil];
//                                                                             
//                                                                             
//                                                                             
//                                                                             
//                                                                         }];
//    
//    //    UITableViewRowAction *rowActionSec = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
//    //                                                                            title:@"快速备忘"    handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//    //                                                                                NSLog(@"快速备忘");
//    //
//    //                                                                            }];
//    //    rowActionSec.backgroundColor = [UIColor colorWithHexString:@"f38202"];
//    rowAction.backgroundColor = colorHead;
//    
//    NSArray *arr = @[rowAction];
//    return arr;
//}

- (IBAction)myPicClick:(UIButton *)sender {
    CollectPicViewController *login=[[CollectPicViewController alloc]init];
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:login];
    [revealController setFrontViewController:rearNavigationController  animated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
}
@end
