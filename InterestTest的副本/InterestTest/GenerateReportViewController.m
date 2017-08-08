//
//  GenerateReportViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/3/27.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "GenerateReportViewController.h"
#import "SWRevealViewController.h"
#import "RootHttpHelper.h"
#import "GoodsTitleTableViewCell.h"
#import "GoodsTableViewCell.h"
#import "GetAllCategoryViewController.h"
#import "GoodAttributesView.h"
#import "GoodAttrModel.h"
#import "MickeyAlbum1.h"
#import "IQKeyboardReturnKeyHandler.h"
#import <CoreText/CoreText.h>
#import "UIImage+MDQRCode.h"
#import "PaySuccessViewController.h"
#import "NewLoginViewController.h"

@interface GenerateReportViewController ()<UITableViewDataSource,UITableViewDelegate,AddGoodsDelegate>
{
    SWRevealViewController *revealController;
    UITableView *table;
    UIView *editView;
    NSIndexPath *newindepath;
    UIButton *choosebtn;
    UIView  *editView1;
    MickeyAlbum1 * album;
    UITextField *text;
}
@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;
@property(nonatomic,strong)NSMutableArray *imageArr;
@property(nonatomic,strong)NSMutableArray *dataInfoArr;
@property(nonatomic,strong)NSMutableArray *attrArr;//属性的数组
@property(nonatomic,strong)NSMutableArray *modlesArr;//属性的数组
@property(nonatomic,strong)NSMutableArray *attrvalueArr;//属性的数值的数组
@property(nonatomic,strong)NSMutableArray *attrAllArr;//属性的数值的数组
@property(nonatomic,strong)NSMutableDictionary *colorArr;//颜色图片属性的数值的数组
@property(nonatomic,strong)NSMutableArray *colorAllArr;//颜色图片属性的数值的数组
@property (nonatomic, strong) NSMutableArray *goodAttrsArr;
@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic, strong) NSString *staffNumId;
@property (nonatomic, strong) NSString *allnum;
@property (nonatomic, strong) NSString *allnum1;
@property (nonatomic, strong) NSString *allprice1;
@property (nonatomic, strong) NSString *allprice2;
@property (nonatomic, strong) NSString *allmoney;
@property (nonatomic, strong) NSString *shipinprice;
@property (nonatomic, strong) NSString *goods_id;
@property (nonatomic, strong) NSString *old_goods_id;
@property (nonatomic, strong) NSString *final_Ooder_id;
@property (nonatomic, strong) NSString *final_sn;
@property (nonatomic, strong) NSString *final_pay_money;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) BOOL isContainOpen;
@property (nonatomic, assign) float discountNum;
@property (nonatomic,strong)NSString *is_need_accessories;
@property(nonatomic,strong)GoodAttributesView *attributesView;
@end

@implementation GenerateReportViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.translucent = NO;
}
-(void)viewDidAppear:(BOOL)animated
{

    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.translucent = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor=UIColorFromRGB(0xf0f0f0);
     self.title=@"报价列表";
    //发通知侧边栏可以点击展开测试结果界面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLeft4" object:nil];
    //控制风格测试
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddGoods:) name:@"addGoods" object:nil];
     _isOpen=NO;
    
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
    
    
//    //设置按钮
//    UIButton *next = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    next.frame = CGRectMake(20, 0, 60, 30);
//    [next addTarget: self action: @selector(nextStep) forControlEvents: UIControlEventTouchUpInside];
//    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc]initWithCustomView:next];
//    [next setTitle:@"下一步" forState:UIControlStateNormal];
//    [next setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    NSMutableArray *buttonItems1 = [NSMutableArray array];
//    [buttonItems1 addObject:nextItem];
//    self.navigationItem.rightBarButtonItems = buttonItems1;
    //
    
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    [self initTableView];
    
    [self getDate];
    
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    self.returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    
    // Do any additional setup after loading the view from its nib.
}
-(void)initTableView{
    table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-78)];
    table.backgroundColor=UIColorFromRGB(0xf0f0f0);
    table.separatorInset = UIEdgeInsetsMake(0,0, 0, 0);
    table.separatorColor=UIColorFromRGB(0xf0f0f0);
    [self.view addSubview:table];
    table.delegate=self;
    table.dataSource=self;
    table.bounces=NO;
    table.showsVerticalScrollIndicator = NO;//不显示右侧滑块
    table.separatorStyle=UITableViewCellSeparatorStyleNone;//分割线
//    UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(16, (i+1) * 40 /* i乘以高度*/, 380, 1)];
//    
//    
//    
//    separator.backgroundColor = [UIColor colorWithRed:0.03 * i green:0.05*i blue:0.1*i alpha:1];
//    
//    
//    
//    [tableView addSubview:separator];
//    table.separatorColor = [UIColor groupTableViewBackgroundColor];
    if ([table respondsToSelector:@selector(setSeparatorInset:)]) {
        // 如果tableView响应了setSeparatorInset: 这个方法,我们就将tableView分割线的内边距设为0.
        [table setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([table respondsToSelector:@selector(setLayoutMargins:)]) {
        // 如果tableView响应了setLayoutMargins: 这个方法,我们就将tableView分割线的间距距设为0.
        [table setLayoutMargins:UIEdgeInsetsZero];
    }
    _allNum.textColor=UIColorFromRGB(0x222222);
    _all.textColor=UIColorFromRGB(0x808080);
    _allprice.textColor=UIColorFromRGB(0xc90920);
    
}
-(void)getDate{

    _dataInfoArr=[[NSMutableArray alloc]init];
//    _btnArr=[[NSMutableArray alloc]init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *pad_user_room_function_id=[userDefaultes stringForKey:@"pad_user_room_function_id"];
    [params setValue:pad_user_room_function_id forKey:@"pad_user_room_id"];
    [params setValue:_dataArr forKey:@"pad_user_scene_pictures"];
    
    [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"product-goods/user-goods" andParams:params andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
//           _dataInfoArr=[successData objectForKey:@"data"];
            [_dataInfoArr addObjectsFromArray:[successData objectForKey:@"data"]];
            [_dataInfoArr addObject:[successData objectForKey:@"online_goods"]];
           
           //[_dataInfoArr addObject:[successData objectForKey:@"online_goods"]];
            if (_dataInfoArr.count>0) {
                [table reloadData];
            }
            _is_need_accessories=[successData objectForKey:@"is_need_accessories"];
            if ([[successData objectForKey:@"is_need_accessories"] integerValue]==0) {
                _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"offline_num"]];
                _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"offline_price"] floatValue]];
                _allmoney=[successData objectForKey:@"offline_price"];
                [self calculateDiscount];
                
            }else{
                  _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"num"]];
                 _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"price"] floatValue]];
                float finprice=[[successData objectForKey:@"price"] floatValue]-[[successData objectForKey:@"offline_price"] floatValue];
                 _shipinLab.text=[NSString stringWithFormat:@"(包含饰品 %.2f)",finprice];
                 _allmoney=[successData objectForKey:@"price"];
                [self calculateDiscount];
            }
////            _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"offline_num"]];
//            _allnum=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"num"]];
//            _allnum1=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"offline_num"]];
////            _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"offline_price"] floatValue]];
//            _allprice1=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"price"] floatValue]];
//            _allprice2=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"offline_price"] floatValue]];
    
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

    
}
-(void)nextStep{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //分组数 也就是section数
     _btnArr=[[NSMutableArray alloc]init];
    return _dataInfoArr.count;
}

//设置每个分组下tableview的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *data=[[NSMutableArray alloc]init];
    data=_dataInfoArr[section];
    if (data != nil && ![data isKindOfClass:[NSNull class]] && data.count != 0)
    {
    return data.count+2;
    }else{
     return 1;   
    }
}
//每个分组上边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 50;
}
//每个分组下边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
//    if (section==_dataInfoArr.count-1) {
//        if (_isOpen) {
//            return 50;
//        }else{
//        return 0;
//        }
//    }else{
//        return 50;
//    }
}
//每一个分组下对应的tableview 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *data=[[NSMutableArray alloc]init];
    data=_dataInfoArr[indexPath.section];
     if (indexPath.row==0) {
        if (indexPath.section==_dataInfoArr.count-1) {
            if (_isOpen) {
             return 60;
            }else{
            return 0;
            }
        }else{
        return 60;
        }
    }else if (data.count+1==indexPath.row){
        if (indexPath.section<_dataInfoArr.count-1) {
            return 50;
        }else{
        if (_isOpen) {
           return 50;
        }else{
            return 0;
        }
        }

        //return 50;
    }
    

    else{
        if (indexPath.section==_dataInfoArr.count-1) {
            if (_isOpen) {
                return 114;
            }else{
            return 0;
            }
            
        }else{
        return 114;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    headView.backgroundColor=UIColorFromRGB(0xf0f0f0);
    
//    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 0, 40)];
//    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
//    [headView addSubview:line];
    
//    UILabel *left=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 10, 40)];
//    left.backgroundColor=colorHead;
//    [headView addSubview:left];
    
    NSMutableArray *data=[[NSMutableArray alloc]init];
    data=_dataInfoArr[section];
    if (data != nil && ![data isKindOfClass:[NSNull class]] && data.count != 0){
    UILabel *left=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 10, 40)];
    left.backgroundColor=colorHead;
    [headView addSubview:left];
        
    NSMutableDictionary *dic=data[0];

    UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH, 39)];
        if ([[[dic objectForKey:@"category"] objectForKey:@"name"] isEqualToString:@"布艺"]||[[[dic objectForKey:@"category"] objectForKey:@"name"] isEqualToString:@"艺术画"]||[[[dic objectForKey:@"category"] objectForKey:@"name"] isEqualToString:@"风水"]) {
           name.text=[NSString stringWithFormat:@"     %@",@"饰品"];
        }else{
    name.text=[NSString stringWithFormat:@"     %@",[[dic objectForKey:@"category"] objectForKey:@"name"]];
        }
    name.backgroundColor=[UIColor whiteColor];
    name.font=[UIFont systemFontOfSize:16.f];
    name.textColor=colorHead;
    [headView addSubview:name];
    
    if (section==_dataInfoArr.count-1) {
     choosebtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50,25,20,15)];
//    btn.backgroundColor=colorHead;
     choosebtn.tag=section;
    [choosebtn setImage:[UIImage imageNamed:@"todown"] forState:UIControlStateNormal];
    [choosebtn setImage:[UIImage imageNamed:@"toup"] forState:UIControlStateSelected];
    [choosebtn addTarget:self action:@selector(up:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:choosebtn];
    }
    }
    
    return headView;
}
- (void)scrollsToBottomAnimated:(BOOL)animated
{
    NSMutableArray *data=[[NSMutableArray alloc]init];
    data=_dataInfoArr[_dataInfoArr.count-1];
    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:data.count+1 inSection:_dataInfoArr.count-1]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];//这里一定要设置为NO，动画可能会影响到scrollerView，导致增加数据源之后，tableView到处乱跳
}
-(void)up:(UIButton *)btn{
    _isOpen=!_isOpen;
    btn.selected=!btn.selected;
    if (btn.selected) {
//        _isOpen=true;
        btn.selected=true;
        
    }else{
//        _isOpen=false;
         btn.selected=false;
    }
    [table reloadData];
    [self scrollsToBottomAnimated:YES];
    
}
-(float)getallprice:(NSInteger )num andPrice:(float)price
{
    float apricr=price;
    return apricr;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    footView.backgroundColor=[UIColor whiteColor];
    
    UIButton *addBtn=[[UIButton alloc]init];
    if (section==_dataInfoArr.count-1) {
        if ([_is_need_accessories integerValue]==1) {
            _shipinLab.hidden=NO;
            _shipinLab.textColor=UIColorFromRGB(0x888888);
            addBtn.selected=YES;
            addBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];

        }else{
            addBtn.selected=NO;
            _shipinLab.hidden=YES;
            addBtn.layer.borderColor = [colorHead CGColor];
        }
    [addBtn setTitle:@"加入结算" forState:UIControlStateNormal];
//     addBtn.layer.borderColor = [colorHead CGColor];
    [addBtn setTitle:@"取消加入" forState:UIControlStateSelected];
     addBtn.frame=CGRectMake(0, 1+10, 100, 29);
     addBtn.tag=section;
    [addBtn setTitleColor:colorHead forState:UIControlStateNormal];
    [addBtn setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateSelected];
     addBtn.titleLabel.font=[UIFont systemFontOfSize:16.f];
     addBtn.layer.borderWidth=1.0;
     addBtn.layer.masksToBounds=YES;
     addBtn.layer.cornerRadius=5.0f;
    [addBtn addTarget:self action:@selector(addGood:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
     addBtn.frame=CGRectMake(0, 1, 50, 49);
     addBtn.backgroundColor=[UIColor redColor];
    [addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     addBtn.titleLabel.font=[UIFont systemFontOfSize:16.f];
     addBtn.tag=section;
    [addBtn addTarget:self action:@selector(addGood1:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0,0, 0.0, 0.0)];
        [_btnArr addObject:addBtn];
        [footView addSubview:addBtn];
    }
    [_btnArr addObject:addBtn];
    [footView addSubview:addBtn];
    
    
    NSMutableArray *data=[[NSMutableArray alloc]init];
    
    data=_dataInfoArr[section];
    
    float allprice1=0;
    for (NSMutableDictionary *dic in data) {
//     [self getallprice:[[dic objectForKey:@"num"] integerValue] andPrice:[[dic objectForKey:@"price"] floatValue]];
     allprice1=allprice1+[self getallprice:[[dic objectForKey:@"num"] integerValue] andPrice:[[dic objectForKey:@"price"] floatValue]];
    }
    
    UILabel *all=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-140, 1, 60, 49)];
    all.text=@"总价：";
    all.textAlignment=NSTextAlignmentRight;
    all.textColor=UIColorFromRGB(0x808080);
    [footView addSubview:all];
    
    UILabel *allprice=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, 1, 80, 49)];
    allprice.text=[NSString stringWithFormat:@"¥%2.f",allprice1];
    _shipinprice=allprice.text;
    allprice.textAlignment=NSTextAlignmentLeft;
    allprice.textColor=colorHead;
    [footView addSubview:allprice];
    
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line.backgroundColor=UIColorFromRGB(0xf0f0f0);
    [footView addSubview:line];
    return footView;
    
}
-(void)addGood1:(UIButton *)btn{
    NSMutableArray *data=[[NSMutableArray alloc]init];
    data=_dataInfoArr[btn.tag];
    NSMutableDictionary *dic=data[0];
    GetAllCategoryViewController *all=[[GetAllCategoryViewController alloc]init];
    all.type=@"1";
    all.cateGoryid=[[dic objectForKey:@"category"] objectForKey:@"id"];
    [self.navigationController pushViewController:all animated:YES];
}
-(void)addGood:(UIButton *)btn{
    if ([_is_need_accessories integerValue]==0) {
        
                    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
                    NSString *pad_user_room_function_id=[userDefaultes stringForKey:@"pad_user_room_function_id"];
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    [params setValue:@"1" forKey:@"is_need_accessories"];
                    [params setValue:pad_user_room_function_id forKey:@"pad_user_room_id"];
                    _dataInfoArr=[[NSMutableArray alloc]init];
                    [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"pad-user/change-accessories" andParams:params andSuccess:^(NSDictionary *successData) {
                        //            //加载圈圈(显示)
                        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
                            _is_need_accessories=[successData objectForKey:@"is_need_accessories"];
                            [_dataInfoArr addObjectsFromArray:[successData objectForKey:@"data"]];
                            [_dataInfoArr addObject:[successData objectForKey:@"online_goods"]];
                            if (_dataInfoArr.count>0) {
                               [table reloadData];
                            }
                            //[table reloadData];
                            if ([[successData objectForKey:@"is_need_accessories"] integerValue]==0) {
                                _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"offline_num"]];
                                _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"offline_price"] floatValue]];
                                _allmoney=[successData objectForKey:@"offline_price"];
                                [self calculateDiscount];
                            }else{
                                _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"num"]];
                                _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"price"] floatValue]];
                                _shipinLab.hidden=NO;
                                float finprice=[[successData objectForKey:@"price"] floatValue]-[[successData objectForKey:@"offline_price"] floatValue];
                                _shipinLab.text=[NSString stringWithFormat:@"(包含饰品 %.2f)",finprice];
                                _allmoney=[successData objectForKey:@"price"];
                                [self calculateDiscount];
                            }
        
                        }else{
                            [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
                        }
                        
                    } andError:^(NSError *error) {
                        //加载圈圈(显示)
                        [[HudHelper hudHepler] HideHUDAlert:self.view];
                        NSLog(@"%@",error);
                    }];

        
    }else{
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *pad_user_room_function_id=[userDefaultes stringForKey:@"pad_user_room_function_id"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:@"0" forKey:@"is_need_accessories"];
        [params setValue:pad_user_room_function_id forKey:@"pad_user_room_id"];
        _dataInfoArr=[[NSMutableArray alloc]init];
        [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"pad-user/change-accessories" andParams:params andSuccess:^(NSDictionary *successData) {
            //            //加载圈圈(显示)
            if ([[successData objectForKey:@"api_code"] integerValue]==200) {
                _is_need_accessories=[successData objectForKey:@"is_need_accessories"];
                [_dataInfoArr addObjectsFromArray:[successData objectForKey:@"data"]];
                [_dataInfoArr addObject:[successData objectForKey:@"online_goods"]];
                if (_dataInfoArr.count>0) {
                    [table reloadData];
                }
                if ([[successData objectForKey:@"is_need_accessories"] integerValue]==0) {
                    _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"offline_num"]];
                    _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"offline_price"] floatValue]];
                    _allmoney=[successData objectForKey:@"offline_price"];
                    [self calculateDiscount];
                }else{
                    _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"num"]];
                    _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"price"] floatValue]];
                    _shipinLab.hidden=NO;
                    float finprice=[[successData objectForKey:@"price"] floatValue]-[[successData objectForKey:@"offline_price"] floatValue];
                    _shipinLab.text=[NSString stringWithFormat:@"(包含饰品 %.2f)",finprice];
                    _allmoney=[successData objectForKey:@"price"];
                    [self calculateDiscount];
                }
                
            }else{
                [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
            }
            
        } andError:^(NSError *error) {
            //加载圈圈(显示)
            [[HudHelper hudHepler] HideHUDAlert:self.view];
            NSLog(@"%@",error);
        }];
        
        
    }
//    UIButton *btn1=_btnArr[btn.tag];
//    btn1.selected=!btn1.selected;

//    if (btn1.selected) {
//        if (btn.tag==_dataInfoArr.count-1) {
//            _dataInfoArr=[[NSMutableArray alloc]init];
//            btn1.selected=true;
//            [btn1  setTitle:@"取消加入" forState:UIControlStateNormal];
//            [btn1 setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateNormal];
//            btn1.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//            NSString *pad_user_room_function_id=[userDefaultes stringForKey:@"pad_user_room_function_id"];
//            NSMutableDictionary *params = [NSMutableDictionary dictionary];
//            [params setValue:@"1" forKey:@"is_need_accessories"];
//            [params setValue:pad_user_room_function_id forKey:@"pad_user_room_id"];
//            //        _dataInfoArr=[[NSMutableArray alloc]init];
//            [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"pad-user/change-accessories" andParams:params andSuccess:^(NSDictionary *successData) {
//                //            //加载圈圈(显示)
//                if ([[successData objectForKey:@"api_code"] integerValue]==200) {
//                    _is_need_accessories=[successData objectForKey:@"is_need_accessories"];
//                    [_dataInfoArr addObjectsFromArray:[successData objectForKey:@"data"]];
//                    [_dataInfoArr addObject:[successData objectForKey:@"online_goods"]];
//                    [table reloadData];
//                    if ([[successData objectForKey:@"is_need_accessories"] integerValue]==0) {
//                        _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"offline_num"]];
//                        _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"offline_price"] floatValue]];
//                    }else{
//                        _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"num"]];
//                        _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"price"] floatValue]];
//                        _shipinLab.hidden=NO;
//                        float finprice=[[successData objectForKey:@"price"] floatValue]-[[successData objectForKey:@"offline_price"] floatValue];
//                        _shipinLab.text=[NSString stringWithFormat:@"(包含饰品 %.2f)",finprice];
//                    }
//                    //                    if (btn.tag==_dataInfoArr.count-1) {
//                    //
//                    //                    }else{
//                    //                    NSMutableArray *data=[[NSMutableArray alloc]init];
//                    //                    data=_dataInfoArr[btn.tag];
//                    //                    NSMutableDictionary *dic=data[0];
//                    //                    GetAllCategoryViewController *all=[[GetAllCategoryViewController alloc]init];
//                    //                    all.cateGoryid=[[dic objectForKey:@"category"] objectForKey:@"id"];
//                    //                    [self.navigationController pushViewController:all animated:YES];
//                    //                    }
//                    
//                    
//                }else{
//                    [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
//                }
//                
//            } andError:^(NSError *error) {
//                //加载圈圈(显示)
//                [[HudHelper hudHepler] HideHUDAlert:self.view];
//                NSLog(@"%@",error);
//            }];
//
//        }else{
//            NSMutableArray *data=[[NSMutableArray alloc]init];
//            data=_dataInfoArr[btn.tag];
//            NSMutableDictionary *dic=data[0];
//            GetAllCategoryViewController *all=[[GetAllCategoryViewController alloc]init];
//            all.cateGoryid=[[dic objectForKey:@"category"] objectForKey:@"id"];
//            [self.navigationController pushViewController:all animated:YES];
//        }
////        _dataInfoArr=[[NSMutableArray alloc]init];
////        btn1.selected=true;
////        [btn1  setTitle:@"取消加入" forState:UIControlStateNormal];
////        [btn1 setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateNormal];
////        btn1.layer.borderColor = [[UIColor lightGrayColor] CGColor];
////        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
////        NSString *pad_user_room_function_id=[userDefaultes stringForKey:@"pad_user_room_function_id"];
////        NSMutableDictionary *params = [NSMutableDictionary dictionary];
////        [params setValue:@"1" forKey:@"is_need_accessories"];
////        [params setValue:pad_user_room_function_id forKey:@"pad_user_room_id"];
//////        _dataInfoArr=[[NSMutableArray alloc]init];
////        [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"pad-user/change-accessories" andParams:params andSuccess:^(NSDictionary *successData) {
////            //            //加载圈圈(显示)
////            if ([[successData objectForKey:@"api_code"] integerValue]==200) {
////                _is_need_accessories=[successData objectForKey:@"is_need_accessories"];
////                [_dataInfoArr addObjectsFromArray:[successData objectForKey:@"data"]];
////                [_dataInfoArr addObject:[successData objectForKey:@"online_goods"]];
////                [table reloadData];
////                if ([[successData objectForKey:@"is_need_accessories"] integerValue]==0) {
////                    _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"offline_num"]];
////                    _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"offline_price"] floatValue]];
////                }else{
////                    _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"num"]];
////                    _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"price"] floatValue]];
////                    _shipinLab.hidden=NO;
////                    float finprice=[[successData objectForKey:@"price"] floatValue]-[[successData objectForKey:@"offline_price"] floatValue];
////                    _shipinLab.text=[NSString stringWithFormat:@"(包含饰品 %.2f)",finprice];
////                }
//////                    if (btn.tag==_dataInfoArr.count-1) {
//////                
//////                    }else{
//////                    NSMutableArray *data=[[NSMutableArray alloc]init];
//////                    data=_dataInfoArr[btn.tag];
//////                    NSMutableDictionary *dic=data[0];
//////                    GetAllCategoryViewController *all=[[GetAllCategoryViewController alloc]init];
//////                    all.cateGoryid=[[dic objectForKey:@"category"] objectForKey:@"id"];
//////                    [self.navigationController pushViewController:all animated:YES];
//////                    }
////
////                
////            }else{
////                [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
////            }
////            
////        } andError:^(NSError *error) {
////            //加载圈圈(显示)
////            [[HudHelper hudHepler] HideHUDAlert:self.view];
////            NSLog(@"%@",error);
////        }];
//        
//
////        _isOpen=YES;
////        _allNum.text=_allnum;
////        _allprice.text=_allprice1;
////        _shipinLab.hidden=NO;
////        _shipinLab.text=[NSString stringWithFormat:@"(包含饰品 %@)",_shipinprice];
////        _shipinLab.textColor=UIColorFromRGB(0x888888);
//
//        
//    }else{
//        btn1.selected=false;
//       [btn1 setTitleColor:colorHead forState:UIControlStateNormal];
//       [btn1 setTitle:@"加入结算" forState:UIControlStateNormal];
//        btn1.layer.borderColor = [colorHead CGColor];
//        
//        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//        NSString *pad_user_room_function_id=[userDefaultes stringForKey:@"pad_user_room_function_id"];
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        [params setValue:@"0" forKey:@"is_need_accessories"];
//        [params setValue:pad_user_room_function_id forKey:@"pad_user_room_id"];
//        _dataInfoArr=[[NSMutableArray alloc]init];
//        [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"pad-user/change-accessories" andParams:params andSuccess:^(NSDictionary *successData) {
//            //            //加载圈圈(显示)
//            if ([[successData objectForKey:@"api_code"] integerValue]==200) {
//                _is_need_accessories=[successData objectForKey:@"is_need_accessories"];
//                [_dataInfoArr addObjectsFromArray:[successData objectForKey:@"data"]];
//                [_dataInfoArr addObject:[successData objectForKey:@"online_goods"]];
//                [table reloadData];
//                if ([[successData objectForKey:@"is_need_accessories"] integerValue]==0) {
//                    _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"offline_num"]];
//                    _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"offline_price"] floatValue]];
//                    _shipinLab.hidden=YES;
//                }else{
//                    _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"num"]];
//                    _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"price"] floatValue]];
//                    float finprice=[[successData objectForKey:@"price"] floatValue]-[[successData objectForKey:@"offline_price"] floatValue];
//                    _shipinLab.text=[NSString stringWithFormat:@"(包含饰品 %.2f)",finprice];
//                    
//                }
//                    if (btn.tag==_dataInfoArr.count-1) {
//                
//                    }else{
//                    NSMutableArray *data=[[NSMutableArray alloc]init];
//                    data=_dataInfoArr[btn.tag];
//                    NSMutableDictionary *dic=data[0];
//                    GetAllCategoryViewController *all=[[GetAllCategoryViewController alloc]init];
//                    all.cateGoryid=[[dic objectForKey:@"category"] objectForKey:@"id"];
//                    [self.navigationController pushViewController:all animated:YES];
//                    }
//
//                
//            }else{
//                [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
//            }
//            
//        } andError:^(NSError *error) {
//            //加载圈圈(显示)
//            [[HudHelper hudHepler] HideHUDAlert:self.view];
//            NSLog(@"%@",error);
//        }];
//        
//
////        _isOpen=NO;
////        _allNum.text=_allnum1;
////        _allprice.text=_allprice2;
//        _shipinLab.hidden=YES;
////        _shipinLab.text=[NSString stringWithFormat:@"(包含饰品 %lf)",[_allprice2 floatValue]-[_allprice1 floatValue]];
////        [table reloadData];
//    }
//    if (btn.tag==_dataInfoArr.count-1) {
//        
//    }else{
//    NSMutableArray *data=[[NSMutableArray alloc]init];
//    data=_dataInfoArr[btn.tag];
//    NSMutableDictionary *dic=data[0];
//    GetAllCategoryViewController *all=[[GetAllCategoryViewController alloc]init];
//    all.cateGoryid=[[dic objectForKey:@"category"] objectForKey:@"id"];
//    [self.navigationController pushViewController:all animated:YES];
//    }
}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *identifer=@"cell";
//    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
//    if (cell==nil) {
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
//    }
//    
//    return cell;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"GoodsTableViewCell";
    //Cell的Identifier
    static NSString *SearchHistoryCellName = @"GoodsTitleTableViewCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//    }
//    NSMutableArray *data=[[NSMutableArray alloc]init];
//    data=_dataInfoArr[indexPath.section];
//    NSMutableDictionary *dic=data[indexPath.row];
//    UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(32, (indexPath.row+2) * 60 /* i乘以高度*/, SCREEN_WIDTH-32, 1)];
//    separator.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    [tableView addSubview:separator];
    NSMutableArray *data=[[NSMutableArray alloc]init];
    data=_dataInfoArr[indexPath.section];
       if (indexPath.row==0) {
        GoodsTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell= [[[NSBundle mainBundle] loadNibNamed:SearchHistoryCellName owner:nil options:nil] lastObject];
        }
        UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(39, 59, SCREEN_WIDTH-78, 1)];
        line.backgroundColor=UIColorFromRGB(0xf0f0f0);
        [cell.contentView addSubview:line];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        NSMutableArray *data=[[NSMutableArray alloc]init];
//        data=_dataInfoArr[indexPath.section];
//        
           if (_isOpen) {
               cell.hidden=NO;
           }else{
               if (indexPath.section==_dataInfoArr.count-1) {
                   cell.hidden=YES;
               }else{
               cell.hidden=NO;
               }
           }
        return cell;
    }
    else if (indexPath.row==data.count+1)
    {
        static NSString *ID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        footView.backgroundColor=[UIColor whiteColor];
        
        UIButton *addBtn=[[UIButton alloc]init];
        if (indexPath.section==_dataInfoArr.count-1) {
            if ([_is_need_accessories integerValue]==1) {
                _shipinLab.hidden=NO;
                _shipinLab.textColor=UIColorFromRGB(0x888888);
                addBtn.selected=YES;
                addBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                
            }else{
                addBtn.selected=NO;
                _shipinLab.hidden=YES;
                addBtn.layer.borderColor = [colorHead CGColor];
            }
            [addBtn setTitle:@"加入结算" forState:UIControlStateNormal];
            //     addBtn.layer.borderColor = [colorHead CGColor];
            [addBtn setTitle:@"取消加入" forState:UIControlStateSelected];
            addBtn.frame=CGRectMake(30, 1+10, 100, 29);
            addBtn.tag=indexPath.section;
            [addBtn setTitleColor:colorHead forState:UIControlStateNormal];
            [addBtn setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateSelected];
            addBtn.titleLabel.font=[UIFont systemFontOfSize:16.f];
            addBtn.layer.borderWidth=1.0;
            [addBtn addTarget:self action:@selector(addGood:) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            [addBtn setTitle:@"添加" forState:UIControlStateNormal];
            addBtn.frame=CGRectMake(30, 1, 80, 49);
            [addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
            [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            addBtn.titleLabel.font=[UIFont systemFontOfSize:16.f];
            addBtn.tag=indexPath.section;
            [addBtn addTarget:self action:@selector(addGood1:) forControlEvents:UIControlEventTouchUpInside];
            [addBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -20, 0.0, 0.0)];
            [_btnArr addObject:addBtn];
            [footView addSubview:addBtn];
        }
        [_btnArr addObject:addBtn];
        [footView addSubview:addBtn];
        
        
        NSMutableArray *data=[[NSMutableArray alloc]init];
        
        data=_dataInfoArr[indexPath.section];
        
        float allprice1=0;
        for (NSMutableDictionary *dic in data) {
            //     [self getallprice:[[dic objectForKey:@"num"] integerValue] andPrice:[[dic objectForKey:@"price"] floatValue]];
            allprice1=allprice1+[self getallprice:[[dic objectForKey:@"num"] integerValue] andPrice:[[dic objectForKey:@"price"] floatValue]];
        }
        
        UILabel *all=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-140, 1, 60, 49)];
        all.text=@"总价：";
        all.textAlignment=NSTextAlignmentRight;
        all.textColor=UIColorFromRGB(0x808080);
        [footView addSubview:all];
        
        UILabel *allprice=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, 1, 80, 49)];
        allprice.text=[NSString stringWithFormat:@"¥%2.f",allprice1];
        _shipinprice=allprice.text;
        allprice.textAlignment=NSTextAlignmentLeft;
        allprice.textColor=colorHead;
        [footView addSubview:allprice];
        
        
        UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        line.backgroundColor=UIColorFromRGB(0xf0f0f0);
        [footView addSubview:line];
        [cell.contentView addSubview:footView];
        return cell;
    }
    else{
//        UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(32, (indexPath.row+1) * 50 /* i乘以高度*/, SCREEN_WIDTH-32, 1)];
//        separator.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        [tableView addSubview:separator];
        
        NSMutableArray *data=[[NSMutableArray alloc]init];
        NSMutableDictionary *dic;
        data=_dataInfoArr[indexPath.section];
        if (data != nil && ![data isKindOfClass:[NSNull class]] && data.count != 0) {
            //data=_dataInfoArr[indexPath.section];
            dic=data[indexPath.row-1];
        }else{
            dic=nil;
        }
//        data=_dataInfoArr[indexPath.section];
//        NSMutableDictionary *dic=data[indexPath.row-1];
        
         GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell= [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
//            UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(32, 111, SCREEN_WIDTH, 1)];
//            line.backgroundColor=UIColorFromRGB(0xf0f0f0);
//            if (indexPath.row<data.count-1) {
//                [cell.contentView addSubview:line];
//            }
//            [cell.contentView addSubview:line];
        }
//        if (indexPath.row==data.count+1) {
//             cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(39, 111, SCREEN_WIDTH-39, 1)];
//        line.backgroundColor=UIColorFromRGB(0xf0f0f0);
//        if (indexPath.row-1<data.count-1) {
//            [cell.contentView addSubview:line];
//        }
//        UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(32, 111, SCREEN_WIDTH, 1)];
//        line.backgroundColor=UIColorFromRGB(0xf0f0f0);
//        [cell.contentView addSubview:line];
        
        [cell.goodsImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://injia-dev.image.alimmdn.com",[[dic objectForKey:@"goodsModel"]objectForKey:@"imgs"][0]]] placeholderImage:[UIImage imageNamed:@"默认"]];
        cell.goodsImg.contentMode = UIViewContentModeScaleAspectFit;
        
        if (![[dic objectForKey:@"location"] isKindOfClass:[NSString class]]) {
           cell.position.text=[[dic objectForKey:@"location"] objectForKey:@"room_name"];
        }else{
           cell.position.text=@"";
        }
        if ([[[dic objectForKey:@"goodsModel"] objectForKey:@"name"] isEqualToString:@"地毯"]) {
           cell.name.text=@"地毯";
        }else if ([[[dic objectForKey:@"goodsModel"] objectForKey:@"name"]isEqualToString:@"窗帘"])
        {
           cell.name.text=@"窗帘";
        }else if ([[[dic objectForKey:@"goodsModel"] objectForKey:@"name"]isEqualToString:@"布艺"])
        {
            cell.name.text=@"饰品";
        }
        else{
        cell.name.text=[[dic objectForKey:@"goodsModel"] objectForKey:@"category"];
        }
        
      
        [cell.lookGoodBtn addTarget: self action:@selector(look:) forControlEvents:UIControlEventTouchUpInside];
         cell.lookGoodBtn.imageView.tag=indexPath.section;
         cell.lookGoodBtn.tag=indexPath.row;
        NSMutableArray *attr=[[NSMutableArray alloc]init];
        attr=[[dic objectForKey:@"goodsModel"] objectForKey:@"attrs"];
        for (NSMutableDictionary *dic in attr) {
            if ([[dic objectForKey:@"name"]isEqualToString:@"尺寸"]) {
                 cell.chicun.text=[dic objectForKey:@"val"];
                
            }else if ([[dic objectForKey:@"name"]isEqualToString:@"颜色"]){
                [cell.buliao sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://injia-dev.image.alimmdn.com",[dic objectForKey:@"img"]]] placeholderImage:[UIImage imageNamed:@"默认"]];

            }else if ([[dic objectForKey:@"name"]isEqualToString:@"材质"]){
                cell.master.text=[dic objectForKey:@"val"];
            }
        }
//        cell.chicun.text=[[dic objectForKey:@"goodsModel"] objectForKey:@"attr_str"];
        if (indexPath.section==_dataInfoArr.count-1&&[[[dic objectForKey:@"goodsModel"] objectForKey:@"promote_price"]integerValue]!=0) {
        cell.price.text=[NSString stringWithFormat:@"%@%@",@"¥",[[dic objectForKey:@"goodsModel"] objectForKey:@"promote_price"]];
        }else{
        cell.price.text=[NSString stringWithFormat:@"%@%@",@"¥",[[dic objectForKey:@"goodsModel"] objectForKey:@"price"]];
        }
        cell.price.textColor=colorHead;
        cell.num.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"num"]];
        cell.num.textColor=colorHead;
        cell.allprice.text=[NSString stringWithFormat:@"¥%ld",[[dic objectForKey:@"price"] integerValue]];
        cell.allprice.textColor=colorHead;
        cell.jiabtn.tag=indexPath.row-1;
        cell.jiabtn.imageView.tag=indexPath.section;
        [cell.jiabtn addTarget: self action:@selector(jia:) forControlEvents:UIControlEventTouchUpInside];
        cell.jianbtn.tag=indexPath.row-1;
        cell.jianbtn.imageView.tag=indexPath.section;
        [cell.jianbtn addTarget: self action:@selector(jian:) forControlEvents:UIControlEventTouchUpInside];
        
//        cell.buliao.text=[[dic objectForKey:@"goodsModel"] objectForKey:@"attr_str"];
        
//         cell.textLabel.text = [NSString stringWithFormat:@"首页测试数据----%ld", (long)indexPath.row];
        if (_isOpen) {
            cell.hidden=NO;
        }else{
            if (indexPath.section==_dataInfoArr.count-1) {
                cell.hidden=YES;
            }else{
                cell.hidden=NO;
            }
        }
        return cell;
    }
    
//    cell.textLabel.text = [NSString stringWithFormat:@"首页测试数据----%ld", (long)indexPath.row];
//    return cell;
}
//实现表格单元格选中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSMutableArray *data=[[NSMutableArray alloc]init];
    data=_dataInfoArr[indexPath.section];
    if (indexPath.row==data.count+1) {
        
    }else{
    if (indexPath.row>0&&indexPath.row!=data.count+1) {
  
    _attrArr=[[NSMutableArray alloc]init];
    _modlesArr=[[NSMutableArray alloc]init];
    _attrvalueArr=[[NSMutableArray alloc]init];
    _attrAllArr=[[NSMutableArray alloc]init];
    _goodAttrsArr=[[NSMutableArray alloc]init];
    _colorArr=[[NSMutableDictionary alloc]init];
    _colorAllArr=[[NSMutableArray alloc]init];
    NSMutableArray *data=[[NSMutableArray alloc]init];
    data=_dataInfoArr[indexPath.section];
    NSMutableDictionary *dic=data[indexPath.row-1];
    
    _old_goods_id=[dic objectForKey:@"id"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[[dic objectForKey:@"goodsModel"] objectForKey:@"goods_id"] forKey:@"goods_id"];
    
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"product-goods/get-goods-detail" andParams:params andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {

            _attrArr=[successData objectForKey:@"attrs"];
            _modlesArr=[successData objectForKey:@"models"];
            for (int i=0; i<_modlesArr.count; i++) {
                NSMutableArray *arr=[_modlesArr[i] objectForKey:@"attrs"];
                for (NSDictionary *dic in arr) {
                    [_attrvalueArr addObject:dic];
//                    GoodAttrModel *model0 = [GoodAttrModel new];
//                    model0.attr_id = @"10";
//                    model0.attr_name = @"尺寸";
                }
            }
            for (NSMutableDictionary *dic in _attrArr) {
                NSMutableArray *arr=[[NSMutableArray alloc]init];
                for (NSMutableDictionary *dic1 in _attrvalueArr) {
                    if ([[dic objectForKey:@"name"]isEqualToString:[dic1 objectForKey:@"name"]]) {
                        [arr addObject:[dic1 objectForKey:@"val"]];
                        if ([[dic1 objectForKey:@"name"]isEqualToString:@"颜色"]) {
                            [_colorArr setObject:[dic1 objectForKey:@"img"] forKey:[dic1 objectForKey:@"val"]];
//                             [_colorAllArr addObject:_colorArr];
                        }
//                        [_colorArr addObject:[dic1 objectForKey:@"img"]];
                    }
                }
                [_attrAllArr addObject:arr];
            }
            for (int i=0;i<_attrArr.count;i++) {
                NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                NSMutableArray *newArr=[[NSMutableArray alloc]init];
                dic=_attrArr[i];
                GoodAttrModel *model0 = [GoodAttrModel new];
                model0.attr_id = [dic objectForKey:@"id"];
                model0.attr_name = [dic objectForKey:@"name"];
                model0.attr_value=[[NSMutableArray alloc]init];
                NSMutableArray *arr=_attrAllArr[i];
                for (NSString *str in arr) {
                    if ([newArr containsObject:str]) {
                        
                    }else{
                        [newArr addObject:str];
                    }
                }
                for (NSString *str in newArr) {
//                  GoodAttrValueModel *value1 = [GoodAttrValueModel new];
//                  value1.attr_value=str;
                    if ([model0.attr_value containsObject:str]) {
                        
                    }else{
                        GoodAttrValueModel *value1 = [GoodAttrValueModel new];
                        value1.attr_value=str;
                        [model0.attr_value  addObject:value1];
                    }
//                 [self.goodAttrsArr addObject:model0];
                }
                
                [self.goodAttrsArr addObject:model0];
                
            }
            
          

            [self createView:[[dic objectForKey:@"goodsModel"] objectForKey:@"attr_str"]];
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
    
    
   
}
-(void)createView:(NSString *)attr_str{
    [self createAttributesView:attr_str];
}
- (void)createAttributesView:(NSString *)attr_str{
    __weak typeof(self) _weakSelf = self;
    _weakSelf.attributesView = [[GoodAttributesView alloc] initWithFrame:(CGRect){0, 0, SCREEN_WIDTH, SCREEN_HEIGHT}];
    _weakSelf.attributesView.old_attr_str=attr_str;
    _weakSelf.attributesView.colorDic=_colorArr;
    _weakSelf.attributesView.goodAttrsArr = self.goodAttrsArr;
    _weakSelf.attributesView.goodModelArr=_modlesArr;
    _weakSelf.attributesView.attrArr=_attrArr;
   // _weakSelf.attributesView.colorDic=_colorArr;
    for (NSDictionary *dic in _modlesArr) {
        if ([[dic objectForKey:@"attr_str"]isEqualToString:attr_str]) {
         _weakSelf.attributesView.good_img = [dic objectForKey:@"imgs"][0];
            if ([[dic objectForKey:@"category"]isEqualToString:@"抱枕"]) {
                if ([[dic objectForKey:@"promote_price"] integerValue]>0) {
                    _weakSelf.attributesView.good_price = [dic objectForKey:@"promote_price"];
                }else{
                    _weakSelf.attributesView.good_price = [dic objectForKey:@"price"];
                }
            }else{
                _weakSelf.attributesView.good_price = [dic objectForKey:@"price"];
            }
            _weakSelf.attributesView.good_name=[dic objectForKey:@"name"];
        }
    }

    _weakSelf.attributesView.sureBtnsClick = ^( NSString *goodsid) {
        if ([self isBlankString:goodsid]) {
            
            [[HudHelper hudHepler] showTips:_weakSelf.attributesView tips:@"暂无该组合的商品"];
            
        }else{
            _dataInfoArr=[[NSMutableArray alloc]init];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            
            [params setValue:goodsid forKey:@"goods_model_id"];
            [params setValue:_old_goods_id forKey:@"pad_user_room_goods_id"];
            
            [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"product-goods/alter-goods" andParams:params andSuccess:^(NSDictionary *successData) {
                //            //加载圈圈(显示)
                if ([[successData objectForKey:@"api_code"] integerValue]==200) {
                    //           _dataInfoArr=[successData objectForKey:@"data"];
                     _goods_id=@"";
                    [_dataInfoArr addObjectsFromArray:[successData objectForKey:@"data"]];
                    [_dataInfoArr addObject:[successData objectForKey:@"online_goods"]];
                    if (_dataInfoArr.count>0) {
                        [table reloadData];
                    }
                    _is_need_accessories=[successData objectForKey:@"is_need_accessories"];
                    if ([[successData objectForKey:@"is_need_accessories"] integerValue]==0) {
                        _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"offline_num"]];
                        _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"offline_price"] floatValue]];
                        _allmoney=[successData objectForKey:@"offline_price"];
                        [self calculateDiscount];
                        
                    }else{
                        _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"num"]];
                        _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"price"] floatValue]];
                        float finprice=[[successData objectForKey:@"price"] floatValue]-[[successData objectForKey:@"offline_price"] floatValue];
                        _shipinLab.text=[NSString stringWithFormat:@"(包含饰品 %.2f)",finprice];
                        _allmoney=[successData objectForKey:@"price"];
                        [self calculateDiscount];
                    }
                    ////            _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"offline_num"]];
                    //            _allnum=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"num"]];
                    //            _allnum1=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"offline_num"]];
                    ////            _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"offline_price"] floatValue]];
                    //            _allprice1=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"price"] floatValue]];
                    //            _allprice2=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"offline_price"] floatValue]];
                    
                }else{
                    [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
                }
                
            } andError:^(NSError *error) {
                //加载圈圈(显示)
                [[HudHelper hudHepler] HideHUDAlert:self.view];
                NSLog(@"%@",error);
            }];

            
        }
    };
    [_attributesView showInView:self.navigationController.view];
}

-(void)cancal{
   
    editView.hidden=YES;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
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
// 自定义左滑显示编辑按钮
-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title:@"  x  " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                             NSLog(@"jianjianjai");
                                                                                 UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定要删除该商品吗？" preferredStyle:UIAlertControllerStyleAlert];
                                                                                 [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                                     NSLog(@"+++++++++++++++退出");
                                                                             
                                                    
                                                                                     
                                                                                
                                                                                 }]];
                                                                                 [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                                                     NSLog(@"+++++++++++++++确定");

                                                                             NSMutableArray *data=[[NSMutableArray alloc]init];
                                                                             data=_dataInfoArr[indexPath.section];
                                                                             NSMutableDictionary *dic=data[indexPath.row-1];
                                                                            
                                                                                 NSMutableDictionary *params = [NSMutableDictionary dictionary];
                                                                                 [params setValue:[dic objectForKey:@"id"] forKey:@"pad_user_room_goods_model_id"];
                                                                                 [params setValue:@"0"forKey:@"num"];
                                                                         _dataInfoArr=[[NSMutableArray alloc]init];         
                                                                                 [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"product-goods/goods-num" andParams:params andSuccess:^(NSDictionary *successData) {
                                                                                     //            //加载圈圈(显示)
                                                                                     if ([[successData objectForKey:@"api_code"] integerValue]==200) {
                                                                                          _is_need_accessories=[successData objectForKey:@"is_need_accessories"];
                                                                                         [_dataInfoArr addObjectsFromArray:[successData objectForKey:@"data"]];
                                                                                         [_dataInfoArr addObject:[successData objectForKey:@"online_goods"]];
                                                                                         if (_dataInfoArr.count>0) {
                                                                                             [table reloadData];
                                                                                         }
                                                                                         if ([[successData objectForKey:@"is_need_accessories"] integerValue]==0) {
                                                                                             _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"offline_num"]];
                                                                                             _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"offline_price"] floatValue]];
                                                                                             _allmoney=[successData objectForKey:@"offline_price"] ;
                                                                        [self calculateDiscount];
                                                                                         }else{
                                                                                             _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"num"]];
                                                                                             _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"price"] floatValue]];
                                                                                             float finprice=[[successData objectForKey:@"price"] floatValue]-[[successData objectForKey:@"offline_price"] floatValue];
                                                                                             _shipinLab.text=[NSString stringWithFormat:@"(包含饰品 %.2f)",finprice];
                                                                                               _allmoney=[successData objectForKey:@"price"] ;
                                                                        [self calculateDiscount];
                                                                                         }
                                                                                         
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
-(void)jia:(UIButton *)btn{
    NSLog(@"jiajiajai");
    NSMutableArray *data=[[NSMutableArray alloc]init];
    if (_dataInfoArr.count>0) {
    data=_dataInfoArr[btn.imageView.tag];
    NSMutableDictionary *dic=data[btn.tag];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    [params setValue:[dic objectForKey:@"id"] forKey:@"pad_user_room_goods_model_id"];
    [params setValue:[NSString stringWithFormat:@"%ld",[[dic objectForKey:@"num"] integerValue]+1]forKey:@"num"];
     _dataInfoArr=[[NSMutableArray alloc]init];
    [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"product-goods/goods-num" andParams:params andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
             _is_need_accessories=[successData objectForKey:@"is_need_accessories"];
            [_dataInfoArr addObjectsFromArray:[successData objectForKey:@"data"]];
            [_dataInfoArr addObject:[successData objectForKey:@"online_goods"]];
            if (_dataInfoArr.count>0) {
                [table reloadData];
            }
            if ([[successData objectForKey:@"is_need_accessories"] integerValue]==0) {
                _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"offline_num"]];
                _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"offline_price"] floatValue]];
                _allmoney=[successData objectForKey:@"offline_price"];
                [self calculateDiscount];
            }else{
                _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"num"]];
                _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"price"] floatValue]];
                float finprice=[[successData objectForKey:@"price"] floatValue]-[[successData objectForKey:@"offline_price"] floatValue];
                _shipinLab.text=[NSString stringWithFormat:@"(包含饰品 %.2f)",finprice];
                _allmoney=[successData objectForKey:@"price"];
                [self calculateDiscount];
            }
            
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
-(void)jian:(UIButton *)btn{
    NSLog(@"jianjianjai");
    NSMutableArray *data=[[NSMutableArray alloc]init];
    if (_dataInfoArr.count>0) {
    data=_dataInfoArr[btn.imageView.tag];
    NSMutableDictionary *dic=data[btn.tag];
    if ([[dic objectForKey:@"num"] integerValue]>1) {
         _dataInfoArr=[[NSMutableArray alloc]init];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:[dic objectForKey:@"id"] forKey:@"pad_user_room_goods_model_id"];
        [params setValue:[NSString stringWithFormat:@"%ld",[[dic objectForKey:@"num"] integerValue]-1]forKey:@"num"];
        
        [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"product-goods/goods-num" andParams:params andSuccess:^(NSDictionary *successData) {
            //            //加载圈圈(显示)
            if ([[successData objectForKey:@"api_code"] integerValue]==200) {
                 _is_need_accessories=[successData objectForKey:@"is_need_accessories"];
                [_dataInfoArr addObjectsFromArray:[successData objectForKey:@"data"]];
                [_dataInfoArr addObject:[successData objectForKey:@"online_goods"]];
                if (_dataInfoArr.count>0) {
                    [table reloadData];
                }
                if ([[successData objectForKey:@"is_need_accessories"] integerValue]==0) {
                    _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"offline_num"]];
                    _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"offline_price"] floatValue]];
                    _allmoney=[successData objectForKey:@"offline_price"];
                    [self calculateDiscount];
                }else{
                    _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"num"]];
                    _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"price"] floatValue]];
                    float finprice=[[successData objectForKey:@"price"] floatValue]-[[successData objectForKey:@"offline_price"] floatValue];
                    _shipinLab.text=[NSString stringWithFormat:@"(包含饰品 %.2f)",finprice];
                    _allmoney=[successData objectForKey:@"price"];
                    [self calculateDiscount];
                }
                
            }else{
                [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
            }
            
        } andError:^(NSError *error) {
            //加载圈圈(显示)
            [[HudHelper hudHepler] HideHUDAlert:self.view];
            NSLog(@"%@",error);
        }];
  
    }else{
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定要删除该商品吗？" preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSLog(@"+++++++++++++++退出");
        
            }]];
            [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                NSLog(@"+++++++++++++++确定");
                _dataInfoArr=[[NSMutableArray alloc]init];
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setValue:[dic objectForKey:@"id"] forKey:@"pad_user_room_goods_model_id"];
                [params setValue:@"0" forKey:@"num"];
                
                [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"product-goods/goods-num" andParams:params andSuccess:^(NSDictionary *successData) {
                    //            //加载圈圈(显示)
                    if ([[successData objectForKey:@"api_code"] integerValue]==200) {
                        _is_need_accessories=[successData objectForKey:@"is_need_accessories"];
                        [_dataInfoArr addObjectsFromArray:[successData objectForKey:@"data"]];
                        [_dataInfoArr addObject:[successData objectForKey:@"online_goods"]];
                        if (_dataInfoArr.count>0) {
                            [table reloadData];
                        }
                        if ([[successData objectForKey:@"is_need_accessories"] integerValue]==0) {
                            _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"offline_num"]];
                            _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"offline_price"] floatValue]];
                            _allmoney=[successData objectForKey:@"offline_price"];
                            [self calculateDiscount];
                        }else{
                            _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"num"]];
                            _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"price"] floatValue]];
                            float finprice=[[successData objectForKey:@"price"] floatValue]-[[successData objectForKey:@"offline_price"] floatValue];
                            _shipinLab.text=[NSString stringWithFormat:@"(包含饰品 %.2f)",finprice];
                            _allmoney=[successData objectForKey:@"price"];
                            [self calculateDiscount];
                        }
                        
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
    }
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:[dic objectForKey:@"id"] forKey:@"pad_user_room_goods_model_id"];
//    [params setValue:[NSString stringWithFormat:@"%ld",[[dic objectForKey:@"num"] integerValue]-1]forKey:@"num"];
//    
//    [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"product-goods/goods-num" andParams:params andSuccess:^(NSDictionary *successData) {
//        //            //加载圈圈(显示)
//        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
//            _dataInfoArr=[successData objectForKey:@"data"];
//            [table reloadData];
//            _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"num"]];
//            _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"price"] floatValue]];
//            
//        }else{
//            [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
//        }
//        
//    } andError:^(NSError *error) {
//        //加载圈圈(显示)
//        [[HudHelper hudHepler] HideHUDAlert:self.view];
//        NSLog(@"%@",error);
//    }];
    }
    
}
- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated{
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 这两句的含义跟上面两句代码相同,就不做解释了
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)deselect
{
       [table deselectRowAtIndexPath:[table indexPathForSelectedRow] animated:YES];
}
- (IBAction)iconClick:(UIButton *)sender {
    
   
        editView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        editView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6];
    //    editView.backgroundColor=[UIColor blackColor];
        [[AppDelegate appDelegate].window addSubview:editView];
    
        UIView *goodsView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-1102/4, SCREEN_HEIGHT/2-719/4-40, 1102/2, 719/2 )];
        goodsView.backgroundColor=[UIColor whiteColor];
        goodsView.layer.masksToBounds=YES;
        goodsView.layer.cornerRadius=5;
        [editView addSubview:goodsView];
    
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(1102/2-20-25 , 19, 18, 18)];
        [btn setImage:[UIImage imageNamed:@"cha"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cancal) forControlEvents:UIControlEventTouchUpInside];
        [goodsView addSubview:btn];
    
        UILabel *titlelab1=[[UILabel alloc]initWithFrame:CGRectMake(0,0,1102/2,114/2)];
        titlelab1.text=@"销售促销码";
        titlelab1.textColor=UIColorFromRGB(0x333333);
        titlelab1.textAlignment=NSTextAlignmentCenter;
        titlelab1.font=[UIFont systemFontOfSize:18.f];
       [goodsView addSubview:titlelab1];
                           
        UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0,114/2,1102/2,1)];
        line.backgroundColor=UIColorFromRGB(0xcccccc);
        [goodsView addSubview:line];
    
        UILabel *titlelab2=[[UILabel alloc]initWithFrame:CGRectMake(1102/2/2-521/2/2,114/2+140/2,512/2,40)];
        titlelab2.text=@"请输入您的促销码:";
        titlelab2.textColor=UIColorFromRGB(0x666666);
        titlelab2.font=[UIFont systemFontOfSize:18.f];
        titlelab2.textAlignment=NSTextAlignmentLeft;
       [goodsView addSubview:titlelab2];
    
       text = [[UITextField alloc]initWithFrame:CGRectMake(1102/2/2-521/2/2, 114/2+158/2+40, 521/2, 44)];
       text.borderStyle = UITextBorderStyleRoundedRect;
       text.backgroundColor = [UIColor whiteColor];
       text.placeholder = @"请输入促销码";
       text.textColor = UIColorFromRGB(0x333333);
       text.font=[UIFont systemFontOfSize:16.f];
       [goodsView addSubview:text];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    sureBtn.backgroundColor = colorHead;
    sureBtn.layer.cornerRadius = 5;
    sureBtn.layer.masksToBounds=YES;
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"icon_log"] forState:UIControlStateNormal];
    [sureBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.frame = CGRectMake(1102/2/2-521/2/2, 114/2+158/2+40+40+20, 521/2, 44);
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [goodsView addSubview:sureBtn];
    
    
    
    
    
                           
                           

}
-(void)calculateDiscount{
//    //中划线
//    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:_allprice.text attributes:attribtDic];
//    _newprice.attributedText = attribtStr;
    if (_discountNum>0) {
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:_allprice.text attributes:attribtDic];
        _newprice.attributedText = attribtStr;
        
        _allprice.text=[NSString stringWithFormat:@"¥%2.f ",[_allmoney floatValue]*_discountNum];
    }else{
        _allprice.text=[NSString stringWithFormat:@"¥%2.f ",[_allmoney floatValue]];
    }
}
-(void)sureBtnClick{
    editView.hidden=YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([self isBlankString:text.text]) {
         [[HudHelper hudHepler] showTips:self.view tips:@"请输入促销码"];
    }else{
    [params setValue:text.text forKey:@"gift_code"];
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"order/sale-staff" andParams:params andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
            _staffNumId=[successData objectForKey:@"id"];
            //中划线
            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:_allprice.text attributes:attribtDic];
            _newprice.attributedText = attribtStr;
            
            _discountNum=[[successData objectForKey:@"discount"] floatValue]/100;
            _allprice.text=[NSString stringWithFormat:@"¥%2.f ",[_allmoney floatValue]*[[successData objectForKey:@"discount"] floatValue]/100];
            
        }else{
            
            [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
        }
        
    } andError:^(NSError *error) {
        //加载圈圈(显示)
        [[HudHelper hudHepler] HideHUDAlert:self.view];
        NSLog(@"%@",error);
    }];
    }
    

    
    
  
   // _newprice.text=_allprice.text;
//    //中划线
//    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:_allprice.text attributes:attribtDic];
//    _newprice.attributedText = attribtStr;
//     _newprice.text=_allprice.text;
    
}
- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}
-(void)changeButtonStatus{
    self.payBtn.userInteractionEnabled=YES;
}
- (IBAction)toPay:(UIButton *)sender {
//     self.payBtn.userInteractionEnabled=NO;
//    [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:1.0f];//防止用户重复点击
    UIImage* image = nil;
    
    UIGraphicsBeginImageContext(table.contentSize);
    {
        CGPoint savedContentOffset = table.contentOffset;
        CGRect savedFrame = table.frame;
        
        table.contentOffset = CGPointZero;
        table.frame = CGRectMake(0, 0, table.contentSize.width, table.contentSize.height);
        
        [table.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        table.contentOffset = savedContentOffset;
        table.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        [self loadImageFinished:image];

    }
    
    self.payBtn.userInteractionEnabled=NO;
    [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:1.0f];//防止用户重复点击
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *pad_user_room_function_id=[userDefaultes stringForKey:@"pad_user_room_function_id"];
    [params setValue:pad_user_room_function_id forKey:@"pad_user_room_id"];
    if ([self isBlankString:[NSString stringWithFormat:@"%@",_staffNumId]]) {
       
    }else{
    [params setValue:[NSString stringWithFormat:@"%@",_staffNumId] forKey:@"sale_staff_id"];
    }
    
    [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"order/confirm" andParams:params andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
            
            
            _final_Ooder_id=[successData objectForKey:@"id"];
            _final_pay_money=[successData objectForKey:@"paid_amount"];
            _final_sn=[successData objectForKey:@"sn"];
            if (editView) {
                [editView removeFromSuperview];
            }
            editView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            editView1.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6];
            //    editView.backgroundColor=[UIColor blackColor];
            [[AppDelegate appDelegate].window addSubview:editView1];
            
            UIView *goodsView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-1102/2/2, SCREEN_HEIGHT/2-1169/2/2-30, 1102/2, 1169/2)];
            goodsView.backgroundColor=[UIColor whiteColor];
            goodsView.layer.masksToBounds=YES;
            goodsView.layer.cornerRadius=5;
            [editView1 addSubview:goodsView];
            
            UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1102/2, 115/2)];
            titleLab.text=@"POS机支付";
            titleLab.textColor=UIColorFromRGB(0x333333);
            titleLab.font=[UIFont systemFontOfSize:18.f];
            titleLab.textAlignment=NSTextAlignmentCenter;
            
            //实例化NSMutableAttributedString模型
            NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:titleLab.text];
            //设置字间距
            long number = 2.f;
            
            //CFNumberRef添加字间距
            CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);    [attributedString1 addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString1 length])];
            
            //清除CFNumberRef
            CFRelease(num);
            
            //给lab赋值改变好的文字
            [titleLab setAttributedText:attributedString1];
            [goodsView addSubview:titleLab];
            
            UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 115/2 , 1102/2, 1)];
            line.backgroundColor=UIColorFromRGB(0xcccccc);
            [goodsView addSubview:line];
            
            
            UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(1102/2/2-(1102/2-348)/2, 115/2+87/2, 1102/2-348, 1102/2-348 )];
            img.image = [UIImage mdQRCodeForString:[NSString stringWithFormat:@"%@",[successData objectForKey:@"sn"]] size:img.bounds.size.width fillColor:[UIColor darkGrayColor]];
            [goodsView addSubview:img];
            
            UIImageView *sysimg=[[UIImageView alloc]initWithFrame:CGRectMake(1102/2/2-(1102/2-348)/2+5, 115/2+87/2+1102/2-348 +25+5,61/2, 57/2)];
            sysimg.image=[UIImage imageNamed:@"sys"];
            [goodsView addSubview:sysimg];
            
            UILabel *detailLab=[[UILabel alloc]initWithFrame:CGRectMake(1102/2/2-(1102/2-348)/2+5+61/2, 115/2+87/2+1102/2-348 +25, 1102/2-348-20, 40)];
            detailLab.text=@"请使用POS机扫一扫             扫描二维码支付";
            detailLab.textColor=UIColorFromRGB(0x666666);
            detailLab.font=[UIFont systemFontOfSize:15.f];
            detailLab.numberOfLines=0;
            detailLab.textAlignment=NSTextAlignmentCenter;
            //实例化NSMutableAttributedString模型
            NSMutableAttributedString * attributedString2 = [[NSMutableAttributedString alloc] initWithString:detailLab.text];

            
            //CFNumberRef添加字间距
            CFNumberRef num1 = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);    [attributedString2 addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString2 length])];
            
            //清除CFNumberRef
            CFRelease(num1);
            
            //给lab赋值改变好的文字
            [detailLab setAttributedText:attributedString2];
            [goodsView addSubview:detailLab];
            
            UILabel *payNumLab=[[UILabel alloc]initWithFrame:CGRectMake(1102/2/2-(1102/2-348)/2, 115/2+87/2+1102/2-348 +12+52+45, 1102/2-348, 30)];
            payNumLab.text=[NSString stringWithFormat:@"首付%@％金额:",[successData objectForKey:@"discount"]];
            payNumLab.textColor=UIColorFromRGB(0x666666);
            payNumLab.font=[UIFont systemFontOfSize:18.f];
            payNumLab.textAlignment=NSTextAlignmentCenter;
            //实例化NSMutableAttributedString模型
            NSMutableAttributedString * attributedString3 = [[NSMutableAttributedString alloc] initWithString:payNumLab.text];
            
            
            //CFNumberRef添加字间距
            CFNumberRef num2 = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);    [attributedString3 addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString3 length])];
            
            //清除CFNumberRef
            CFRelease(num2);
            
            //给lab赋值改变好的文字
            [payNumLab setAttributedText:attributedString3];
            [goodsView addSubview:payNumLab];
            
            UILabel *paymoneyLab=[[UILabel alloc]initWithFrame:CGRectMake(1102/2/2-(1102/2-348)/2, 115/2+87/2+1102/2-348 +12+52+30+45+10, 1102/2-348, 30)];
            paymoneyLab.text=[NSString stringWithFormat:@"¥%@",[successData objectForKey:@"paid_amount"]];
            paymoneyLab.textColor=colorHead;
            paymoneyLab.font=[UIFont systemFontOfSize:30.f];
            paymoneyLab.textAlignment=NSTextAlignmentCenter;
            [goodsView addSubview:paymoneyLab];
            
            
            UILabel *numLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 115/2+87/2+1102/2-348 +12+52+30+30+30+45, 1102/2, 40)];
            numLab.text=[NSString stringWithFormat:@"订单编号:%@",[successData objectForKey:@"sn"]];
            numLab.textColor=UIColorFromRGB(0x666666);
            numLab.font=[UIFont systemFontOfSize:18.f];
            numLab.textAlignment=NSTextAlignmentCenter;
            //实例化NSMutableAttributedString模型
            NSMutableAttributedString * attributedString4 = [[NSMutableAttributedString alloc] initWithString:numLab.text];
            
            
            //CFNumberRef添加字间距
            CFNumberRef num3 = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);    [attributedString4 addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString4 length])];
            
            //清除CFNumberRef
            CFRelease(num3);
            
            //给lab赋值改变好的文字
            [numLab setAttributedText:attributedString4];
            [goodsView addSubview:numLab];
            
            
            
            
            UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(1102/2-20-25 , 19, 18, 18)];
            [btn setImage:[UIImage imageNamed:@"cha"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(cancal1) forControlEvents:UIControlEventTouchUpInside];
            [goodsView addSubview:btn];
            
            UIButton *successbtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-(1102/2)/2 ,SCREEN_HEIGHT-60-50, 1102/2, 50)];
            [successbtn setTitle:@"支付成功" forState:UIControlStateNormal];
             successbtn.layer.masksToBounds=YES;
             successbtn.layer.cornerRadius=5.0;
             successbtn.backgroundColor=colorHead;
            [successbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [successbtn addTarget:self action:@selector(paysuccess) forControlEvents:UIControlEventTouchUpInside];
            [editView1 addSubview:successbtn];
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
-(void)paysuccess{
    editView1.hidden=YES;
//    PaySuccessViewController *suc=[[PaySuccessViewController alloc]init];
//    suc.sn=_final_sn;
//    suc.money=_final_pay_money;
//    [self.navigationController pushViewController:suc animated:YES];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *pad_user_room_function_id=[userDefaultes stringForKey:@"pad_user_room_function_id"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:pad_user_room_function_id forKey:@"pad_user_room_id"];
    
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"order/get-order-status" andParams:params andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
//                            PaySuccessViewController *suc=[[PaySuccessViewController alloc]init];
//                            suc.sn=_final_sn;
//                            suc.order_id=_final_Ooder_id;
//                            suc.money=_final_pay_money;
//            
//                            [self.navigationController pushViewController:suc animated:YES];
            if ([[successData objectForKey:@"status"] integerValue]==0||[[successData objectForKey:@"status"] integerValue]==1) {
                [[HudHelper hudHepler] showTips:editView1 tips:@"抱歉支付是失败的，请重新在付一次吧！"];
            }else{
                 
                PaySuccessViewController *suc=[[PaySuccessViewController alloc]init];
                suc.sn=_final_sn;
                suc.money=_final_pay_money;
                [self.navigationController pushViewController:suc animated:YES];
            }
        
        }else{
            [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
        }
        
    } andError:^(NSError *error) {
        //加载圈圈(显示)
        [[HudHelper hudHepler] HideHUDAlert:self.view];
        NSLog(@"%@",error);
    }];
    
    
}
-(void)cancal1{
    editView1.hidden=YES;
}
- (void) AddGoods:(NSNotification *)notification{
    _dataInfoArr=[[NSMutableArray alloc]init];
    NSMutableDictionary *goodsdic=notification.object;
    _is_need_accessories=[goodsdic objectForKey:@"is_need_accessories"];
    [_dataInfoArr addObjectsFromArray:[goodsdic objectForKey:@"data"]];
    [_dataInfoArr addObject:[goodsdic objectForKey:@"online_goods"]];
    if (_dataInfoArr.count>0) {
        [table reloadData];
    }
    if ([[goodsdic objectForKey:@"is_need_accessories"] integerValue]==0) {
        _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[goodsdic objectForKey:@"offline_num"]];
        _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[goodsdic objectForKey:@"offline_price"] floatValue]];
        [self calculateDiscount];
    }else{
        _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[goodsdic objectForKey:@"num"]];
        _allprice.text=[NSString stringWithFormat:@"¥%.2f ",[[goodsdic objectForKey:@"price"] floatValue]];
        float finprice=[[goodsdic objectForKey:@"price"] floatValue]-[[goodsdic objectForKey:@"offline_price"] floatValue];
        _shipinLab.text=[NSString stringWithFormat:@"(包含饰品 %.2f)",finprice];
        [self calculateDiscount];
    }
//    [table reloadData];
    
}
-(void)look:(UIButton *)btn
{
    NSMutableArray *data=[[NSMutableArray alloc]init];
    NSMutableDictionary *dic;
    data=_dataInfoArr[btn.imageView.tag];
    if (data != nil && ![data isKindOfClass:[NSNull class]] && data.count != 0) {
        //data=_dataInfoArr[indexPath.section];
        dic=data[btn.tag-1];
    }else{
        dic=nil;
    }
    NSLog(@"局部放大");
    _imageArr=[[NSMutableArray alloc]init];
    NSMutableArray *arr=[[NSMutableArray alloc]initWithArray:[[dic objectForKey:@"goodsModel"]objectForKey:@"imgs"]];
//    _g1oodsModel=[[goodsModel alloc]initWithDictionary:arr[0] error:nil];
    // UIImageView *imageView = (UIImageView *)gesture.view;
    for (NSString *str in arr) {
        [_imageArr addObject:[NSString stringWithFormat:@"%@%@",@"http://injia-dev.image.alimmdn.com",str]];
    }
    album = [[MickeyAlbum1 alloc]initWithImgUrlArr:_imageArr CurPage:0];
    album.photoFrame = btn.imageView.frame;
    [self.navigationController presentViewController:album animated:YES completion:nil];
}
- (UIImage *)captureScrollView:(UIScrollView *)scrollView{
    UIImage* image = nil;
    UIGraphicsBeginImageContext(scrollView.contentSize);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }
    return nil;
}
@end
