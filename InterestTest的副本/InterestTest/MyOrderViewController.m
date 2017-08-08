//
//  MyOrderViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/4/7.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "MyOrderViewController.h"
#import "SWRevealViewController.h"
#import "RootHttpHelper.h"
#import "GoodsTitleTableViewCell.h"
#import "GoodsTableViewCell.h"
#import "GetAllCategoryViewController.h"
#import "GoodAttributesView.h"
#import "GoodAttrModel.h"
#import "MickeyAlbum1.h"
#import "PaySuccessViewController.h"
#import "NewLoginViewController.h"
#import "HttpHelper.h"
@interface MyOrderViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
{
    SWRevealViewController *revealController;
    UITableView *table;
    UIView *editView;
    NSIndexPath *newindepath;
    UIButton *choosebtn;
    UIView  *editView1;
    MickeyAlbum1 * album;
    UIView *goodsView;
    UITextField  *name;
    UITextField  *phone;
    UITextField  *detail;
    UIButton *chooseBtn;
    
    NSMutableArray *_province;
    NSMutableArray *_city;
    NSMutableArray *_regionArea;
    
    NSString *provinceId;
    NSString *cityId;
    NSString *regionId;
    
    NSInteger row1;//pick
    NSInteger row2;//pick
    NSInteger row3;//pick
    UILabel *lab;
    UIButton *btn;
    
    UILabel *user_mobile;
    UILabel *user_name;
}
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
@property (nonatomic, strong) NSString *allnum;
@property (nonatomic, strong) NSString *allnum1;
@property (nonatomic, strong) NSString *allprice1;
@property (nonatomic, strong) NSString *allprice2;
@property (nonatomic, strong) NSString *shipinprice;
@property (nonatomic, strong) NSString *goods_id;
@property (nonatomic, strong) NSString *old_goods_id;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) BOOL isContainOpen;
@property (nonatomic,strong)NSString *is_need_accessories;
@property(nonatomic,strong)GoodAttributesView *attributesView;
@property (nonatomic,strong)NSMutableDictionary *attrAdress;
@property (strong, nonatomic) UIPickerView *pickerView;

@end


@implementation MyOrderViewController
@synthesize
pickerView;

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
    self.title=@"我的订单";
    //控制风格测试
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddGoods:) name:@"addGoods" object:nil];
    _isOpen=NO;
    
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
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    [self initTableView];
    
    [self getDate];
    
    row1 = row2 = row3 = 0;
    [self getProvinceList];
    [self addNoticeForKeyboard];
    // Do any additional setup after loading the view from its nib.
}
-(void)initTableView{
    table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-80)];
    table.backgroundColor=UIColorFromRGB(0xf0f0f0);
    table.separatorInset = UIEdgeInsetsMake(0,0, 0, 0);
    table.separatorColor=UIColorFromRGB(0xf0f0f0);
    [self.view addSubview:table];
    table.delegate=self;
    table.dataSource=self;
    table.bounces=NO;
    table.showsVerticalScrollIndicator = NO;//不显示右侧滑块
    table.separatorStyle=UITableViewCellSeparatorStyleNone;//分割线
    
   
    _allNum.textColor=UIColorFromRGB(0x222222);
    _allmoneyLab.textColor=UIColorFromRGB(0x666666);
    _paymoneyLab.textColor=UIColorFromRGB(0x666666);
    _discountNum.textColor=UIColorFromRGB(0x666666);
    
}
-(void)createHeadView{
    UIView *head=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 185/2)];
    head.backgroundColor=[UIColor whiteColor];
    table.tableHeaderView=head;
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(25, 185/4-35/4, 35/2, 35/2)];
    img.image=[UIImage imageNamed:@"location"];
    [head addSubview:img];
    
    user_name=[[UILabel alloc]initWithFrame:CGRectMake(25+25, 15, 60, 30)];
    user_name.font=[UIFont systemFontOfSize:15.f];
    user_name.textColor=UIColorFromRGB(0x333333);
    user_name.text=[_attrAdress objectForKey:@"name"];
    [head addSubview:user_name];
    
    user_mobile=[[UILabel alloc]initWithFrame:CGRectMake(25+25+60, 15, 160, 30)];
    user_mobile.font=[UIFont systemFontOfSize:15.f];
    user_mobile.textColor=UIColorFromRGB(0x666666);
    user_mobile.text=[_attrAdress objectForKey:@"mobile"];
    [head addSubview:user_mobile];
    
    UILabel *address=[[UILabel alloc]initWithFrame:CGRectMake(25+25, 45, SCREEN_WIDTH-50, 30)];
    address.font=[UIFont systemFontOfSize:14.f];
    address.textColor=UIColorFromRGB(0x666666);
    address.text=[NSString stringWithFormat:@"%@%@%@%@",[_attrAdress objectForKey:@"province"],[_attrAdress objectForKey:@"city"],[_attrAdress objectForKey:@"region"],[_attrAdress objectForKey:@"address"]];
   [head addSubview:address];
    
    UIImageView *lineImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 185/2-4, SCREEN_WIDTH, 4)];
    lineImg.image=[UIImage imageNamed:@"lineImg"];
    [head addSubview:lineImg];
    
    UIButton *chooseAddress=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 185/2)];
    [chooseAddress addTarget:self action:@selector(chooseArea) forControlEvents:UIControlEventTouchUpInside];
    [head addSubview:chooseAddress];
    
}
-(void)cancal{
    
    editView.hidden=YES;
}
-(void)chooseArea
{
    editView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    editView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6];
    //    editView.backgroundColor=[UIColor blackColor];
    [[AppDelegate appDelegate].window addSubview:editView];
    
    goodsView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-390/2, SCREEN_HEIGHT/2-445/2, 390, 445 )];
    goodsView.backgroundColor=[UIColor whiteColor];
    goodsView.layer.masksToBounds=YES;
    goodsView.layer.cornerRadius=5;
    [editView addSubview:goodsView];
    
    UIButton *canlbtn=[[UIButton alloc]initWithFrame:CGRectMake(390-20-25 , 19, 18, 18)];
    [canlbtn setImage:[UIImage imageNamed:@"cha"] forState:UIControlStateNormal];
    [canlbtn addTarget:self action:@selector(cancal) forControlEvents:UIControlEventTouchUpInside];
    [goodsView addSubview:canlbtn];
    
    UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(390/2-30, 60, 60, 60)];
    icon.image=[UIImage imageNamed:@"icon_log_logo"];
    [goodsView addSubview:icon];
    
    
    name = [[UITextField alloc]initWithFrame:CGRectMake(97/2, 60+60+40, 390-97, 40)];
    name.backgroundColor = [UIColor whiteColor];
    name.text = [_attrAdress objectForKey:@"name"];
    name.textColor = UIColorFromRGB(0x333333);
    name.font=[UIFont systemFontOfSize:16.f];
    name.delegate=self;
    [goodsView addSubview:name];
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(97/2, 60+60+40+40, 390-97, 1)];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [goodsView addSubview:line];
    
    
    phone = [[UITextField alloc]initWithFrame:CGRectMake(97/2, 60+60+40+40+5, 390-97, 40)];
    phone.backgroundColor = [UIColor whiteColor];
    phone.text = [_attrAdress objectForKey:@"mobile"];
    phone.textColor = UIColorFromRGB(0x333333);
    phone.font=[UIFont systemFontOfSize:16.f];
    phone.delegate=self;
    [goodsView addSubview:phone];
    
    UILabel *line1=[[UILabel alloc]initWithFrame:CGRectMake(97/2, 60+60+40+40+5+40, 390-97, 1)];
    line1.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [goodsView addSubview:line1];
    
     chooseBtn=[[UIButton alloc]initWithFrame:CGRectMake(97/2, 60+60+40+40+10+40, 390-97, 40)];
    [chooseBtn setTitle:[NSString stringWithFormat:@"%@%@%@",[_attrAdress objectForKey:@"province"],[_attrAdress objectForKey:@"city"],[_attrAdress objectForKey:@"region"]] forState:UIControlStateNormal];
    [chooseBtn setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateNormal];
    chooseBtn.titleLabel.font=[UIFont systemFontOfSize:16.f];
    chooseBtn.titleLabel.textAlignment=NSTextAlignmentLeft;
    [chooseBtn addTarget:self action:@selector(chooseCity) forControlEvents:UIControlEventTouchUpInside];
    chooseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [goodsView addSubview:chooseBtn];
    
    UILabel *line2=[[UILabel alloc]initWithFrame:CGRectMake(97/2, 60+60+40+40+10+40+40, 390-97, 1)];
    line2.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [goodsView addSubview:line2];
    
    
    detail = [[UITextField alloc]initWithFrame:CGRectMake(97/2, 60+60+40+40+5+80+10, 390-97, 40)];
    detail.backgroundColor = [UIColor whiteColor];
    detail.text = [_attrAdress objectForKey:@"address"];
    detail.textColor = UIColorFromRGB(0x333333);
    detail.font=[UIFont systemFontOfSize:16.f];
    detail.delegate=self;
    [goodsView addSubview:detail];
    
    UILabel *line3=[[UILabel alloc]initWithFrame:CGRectMake(97/2, 60+60+40+40+5+80+40+10, 390-97, 1)];
    line3.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [goodsView addSubview:line3];
    
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.layer.cornerRadius = 5;
    sureBtn.layer.masksToBounds=YES;
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"icon_log"] forState:UIControlStateNormal];
    [sureBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.frame = CGRectMake(97/2, 740/2, 390-97, 44);
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [goodsView addSubview:sureBtn];

}

-(void)sureBtnClick{
    if ([self isBlankString:name.text]) {
        [[HudHelper hudHepler] showTips:goodsView tips:@"请输入收货人姓名！"];
    }else if([self isBlankString:phone.text])
    {
        [[HudHelper hudHepler] showTips:goodsView tips:@"请输入收货人号码！"];
    }else if([self isBlankString:[NSString stringWithFormat:@"%@", [_province[row1] objectForKey:@"id"]]])
    {
        [[HudHelper hudHepler] showTips:goodsView tips:@"请选择省市区"];
    }else{
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:_order_id forKey:@"order_id"];
        [params setValue:name.text forKey:@"name"];
        [params setValue:phone.text forKey:@"mobile"];
        [params setValue:[_province[row1] objectForKey:@"id"] forKey:@"province"];
        [params setValue:[_city[row2] objectForKey:@"id"] forKey:@"city"];
        [params setValue:[_regionArea[row3] objectForKey:@"id"] forKey:@"region"];
        [params setValue:detail.text forKey:@"address"];
        [params setValue:@"" forKey:@"zipcode"];
        
        [[RootHttpHelper httpHelper]postAchieveListParamsURL1:@"order/set-address" andParams:params andSuccess:^(NSDictionary *successData) {
            if ([[successData objectForKey:@"api_code"] integerValue]==200) {
                editView.hidden=YES;
                [self getDate];
//                MyOrderViewController *order=[[MyOrderViewController alloc]init];
//                [self.navigationController pushViewController:order animated:YES];
                
            } else if ([[successData objectForKey:@"api_code"] integerValue]==401){
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的账号已在别处登陆了，请重新登录！" preferredStyle:UIAlertControllerStyleAlert];
                [alertView addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    NSLog(@"+++++++++++++++退出");
                    NewLoginViewController *theme=[[NewLoginViewController alloc]init];
                    [self.navigationController pushViewController:theme animated:YES];
                    
                }]];
                [self presentViewController:alertView animated:YES completion:nil];
            }
        } andError:^(NSError *error) {
            
        }];
    }

}
-(void)getDate{
    
    _dataInfoArr=[[NSMutableArray alloc]init];
    _attrAdress=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *pad_user_room_function_id=[userDefaultes stringForKey:@"pad_user_room_function_id"];
    [params setValue:pad_user_room_function_id forKey:@"pad_user_room_id"];
    
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"order/get-order" andParams:params andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
             _order_id=[successData objectForKey:@"order_id"];
             _attrAdress=[successData objectForKey:@"addr"];
            [_dataInfoArr addObjectsFromArray:[successData objectForKey:@"data"]];
            [_dataInfoArr addObject:[successData objectForKey:@"online_goods"]];
            [self createHeadView];
            [table reloadData];
            
      
                _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"num"]];
                _allmoneyNum.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"price"] floatValue]];
                _paymoney.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"paid_price"] floatValue]];
            if ([[successData objectForKey:@"discount_price"] integerValue]==[[successData objectForKey:@"price"] integerValue]) {
                
            }else{
                //中划线
                NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",[successData objectForKey:@"price"]] attributes:attribtDic];
                _discountNum.attributedText = attribtStr;
                _allmoneyNum.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"discount_price"] floatValue]];
                
            }
                

            
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
        return data.count+1;
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
    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:data.count inSection:_dataInfoArr.count-1]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];//这里一定要设置为NO，动画可能会影响到scrollerView，导致增加数据源之后，tableView到处乱跳
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
-(void)addGood1:(UIButton *)btn{
    NSMutableArray *data=[[NSMutableArray alloc]init];
    data=_dataInfoArr[btn.tag];
    NSMutableDictionary *dic=data[0];
    GetAllCategoryViewController *all=[[GetAllCategoryViewController alloc]init];
    all.cateGoryid=[[dic objectForKey:@"category"] objectForKey:@"id"];
    [self.navigationController pushViewController:all animated:YES];
}
-(void)addGood:(UIButton *)btn{
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"GoodsTableViewCell";
    //Cell的Identifier
    static NSString *SearchHistoryCellName = @"GoodsTitleTableViewCell";
  
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
       else{
        
        NSMutableArray *data=[[NSMutableArray alloc]init];
        NSMutableDictionary *dic;
        data=_dataInfoArr[indexPath.section];
        if (data != nil && ![data isKindOfClass:[NSNull class]] && data.count != 0) {
            dic=data[indexPath.row-1];
        }else{
            dic=nil;
        }
        
        GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
          
        if (!cell) {
            cell= [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
//        [cell.jiabtn addTarget: self action:@selector(jia:) forControlEvents:UIControlEventTouchUpInside];
        cell.jianbtn.tag=indexPath.row-1;
        cell.jianbtn.imageView.tag=indexPath.section;
//        [cell.jianbtn addTarget: self action:@selector(jian:) forControlEvents:UIControlEventTouchUpInside];
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
  
}
//实现表格单元格选中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
-(void)createView{
    [self createAttributesView];
}
- (void)createAttributesView{
    __weak typeof(self) _weakSelf = self;
    _weakSelf.attributesView = [[GoodAttributesView alloc] initWithFrame:(CGRect){0, 0, SCREEN_WIDTH, SCREEN_HEIGHT}];
    _weakSelf.attributesView.colorDic=_colorArr;
    _weakSelf.attributesView.goodAttrsArr = self.goodAttrsArr;
    _weakSelf.attributesView.goodModelArr=_modlesArr;
    _weakSelf.attributesView.attrArr=_attrArr;
    // _weakSelf.attributesView.colorDic=_colorArr;
    _weakSelf.attributesView.good_img = [_modlesArr[0] objectForKey:@"imgs"][0];
    //    attributesView.good_name = self.goodDetailModel.goods_name;
    _weakSelf.attributesView.good_price = [_modlesArr[0] objectForKey:@"price"];
    _weakSelf.attributesView.good_name=[_modlesArr[0] objectForKey:@"name"];
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
                    [table reloadData];
                    _is_need_accessories=[successData objectForKey:@"is_need_accessories"];
                    if ([[successData objectForKey:@"is_need_accessories"] integerValue]==0) {
                        _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"offline_num"]];
                        _allmoneyNum.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"offline_price"] floatValue]];
                        
                    }else{
                        _allNum.text=[NSString stringWithFormat:@"总共：%@ 件商品",[successData objectForKey:@"num"]];
                        _allmoneyNum.text=[NSString stringWithFormat:@"¥%.2f ",[[successData objectForKey:@"price"] floatValue]];
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
    };
    [_attributesView showInView:self.navigationController.view];
}


-(void)jia:(UIButton *)btn{
    NSLog(@"jiajiajai");
}
-(void)jian:(UIButton *)btn{
    NSLog(@"jianjianjai");
}

- (void)deselect
{
    [table deselectRowAtIndexPath:[table indexPathForSelectedRow] animated:YES];
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
#pragma mark - 请求省份数据
-(void)getProvinceList
{
    [[HttpHelper httpHelper]getAchieveListParamsURL:@"region/province" andParams:nil andSuccess:^(NSDictionary *successData) {
        _province = [successData objectForKey:@"data"];
        [self getCityList:[_province[row1] objectForKey:@"id"]];
    } andError:^(NSError *error) {
        
    }];
}

#pragma mark - 请求城市数据
-(void)getCityList:(NSString *)province
{
    
    [[HttpHelper httpHelper]getAchieveListParamsURL:[NSString stringWithFormat:@"region/city/%@",province] andParams:nil andSuccess:^(NSDictionary *successData) {
        _city = [successData objectForKey:@"data"];
        if (pickerView) {
            [pickerView reloadComponent:1];
        }
        if (_city.count < row2 + 1) {
            row2 = _city.count - 1;
            [self getRegionArea:[[_city lastObject] objectForKey:@"id"]];
        }
        else{
            [self getRegionArea:[_city[row2] objectForKey:@"id"]];
        }
        
        
    } andError:^(NSError *error) {
        
        
    }];
}

#pragma mark - 请求区县数据
-(void)getRegionArea:(NSString *)city
{
    [[HttpHelper httpHelper]getAchieveListParamsURL:[NSString stringWithFormat:@"region/region/%@",city] andParams:nil andSuccess:^(NSDictionary *successData) {
        _regionArea = [successData objectForKey:@"data"];
        if (row3 > _regionArea.count - 1) {
            row3 = _regionArea.count - 1;
        }
        if (pickerView) {
            [pickerView reloadComponent:2];
        }
        
    } andError:^(NSError *error) {
        
    }];
}
#pragma mark - 收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:self.view];  //返回触摸点在视图中的当前坐标
    float y = point.y;
    if (pickerView && y < pickerView.frame.origin.y) {
        [pickerView removeFromSuperview];
        [lab removeFromSuperview];
        [btn removeFromSuperview];
        pickerView = nil;
        if (_regionArea.count > 0) {
            [chooseBtn setTitle:[NSString stringWithFormat:@"%@%@%@",[_province[row1] objectForKey:@"region_name"],[_city[row2] objectForKey:@"region_name"],[_regionArea[row3] objectForKey:@"region_name"]] forState:UIControlStateNormal];
            [chooseBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        }
        else{
            [chooseBtn setTitle:[NSString stringWithFormat:@"%@%@",[_province[row1] objectForKey:@"region_name"],[_city[row2] objectForKey:@"region_name"]] forState:UIControlStateNormal];
            [chooseBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
            
        }
    }
}

-(void)chooseCity{
    NSLog(@"+++++++++++修改城市按钮点击事件");
    [self.view endEditing:YES];
    

    [name endEditing:YES];
    [phone endEditing:YES];
    [detail endEditing:YES];
    
    if (pickerView) {
        [pickerView removeFromSuperview];
        pickerView = nil;
    }
    pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-150 , SCREEN_WIDTH, 150)];
    if (lab) {
        [lab removeFromSuperview];
        lab = nil;
    }
    if (btn) {
        [btn removeFromSuperview];
        btn = nil;
    }
    lab=[[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-150-48, SCREEN_WIDTH, 48)];
    lab.backgroundColor=[UIColor whiteColor];
    lab.text=@"请选择地址";
    lab.textAlignment=NSTextAlignmentCenter;
    lab.font=[UIFont systemFontOfSize:15.f];
    [editView addSubview:lab];
    
    btn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60,SCREEN_HEIGHT-150-48, 50, 48)];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(ok) forControlEvents: UIControlEventTouchUpInside];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [editView addSubview:btn];
    
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = self;
    pickerView.dataSource =self;
    [pickerView selectRow:row1 inComponent:0 animated:NO];
    [pickerView selectRow:row2 inComponent:1 animated:NO];
    [pickerView selectRow:row3 inComponent:2 animated:NO];
    [editView addSubview:pickerView];
}
-(void)ok
{
    [pickerView removeFromSuperview];
    [lab removeFromSuperview];
    [btn removeFromSuperview];
    pickerView = nil;
    if (_regionArea.count > 0) {
        [chooseBtn setTitle:[NSString stringWithFormat:@"%@%@%@",[_province[row1] objectForKey:@"region_name"],[_city[row2] objectForKey:@"region_name"],[_regionArea[row3] objectForKey:@"region_name"]] forState:UIControlStateNormal];
        [chooseBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
    }
    else{
        [chooseBtn setTitle:[NSString stringWithFormat:@"%@%@",[_province[row1] objectForKey:@"region_name"],[_city[row2] objectForKey:@"region_name"]] forState:UIControlStateNormal];
        [chooseBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
    }
    
}
#pragma mark --------------- PickerView相关代理 ------------------
#pragma mark - pickerView列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

#pragma mark - 每列行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {//省
        return _province.count;
    }
    if (component == 1) {//市
        return _city.count;
    }
    if (component == 2) {//区
        return _regionArea.count;
    }
    return 0;
}

#pragma mark - 每列,行title
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {//省
        return [_province[row] objectForKey:@"region_name"];
    }
    if (component == 1) {//市
        return [_city[row] objectForKey:@"region_name"];
    }
    if (component == 2) {//区
        return [_regionArea[row] objectForKey:@"region_name"];
    }
    return nil;
}

#pragma mark - 选择代理方法
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        if (row != row1) {
            row1 = row;
            [self getCityList:[_province[row] objectForKey:@"id"]];
            provinceId = nil;
            provinceId = [NSString stringWithFormat:@"%@",[_province[row] objectForKey:@"id"]];
        }
    }
    if (component == 1) {
        
        if (row != row2) {
            row2 = row;
            [self getRegionArea:[_city[row] objectForKey:@"id"]];
            cityId = nil;
            cityId = [NSString stringWithFormat:@"%@",[_city[row] objectForKey:@"id"]];
        }
    }
    if (component == 2) {
        if (row != row3) {
            row3 = row;
            regionId = nil;
            regionId = [NSString stringWithFormat:@"%@",[_regionArea[row] objectForKey:@"id"]];
        }
    }
}
#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    //        CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    if (name.isEditing) {
        goodsView.frame=CGRectMake(SCREEN_WIDTH/2-390/2, SCREEN_HEIGHT/2-445/2-50, 390, 445 );
    }else if (phone.isEnabled){
        
        goodsView.frame=CGRectMake(SCREEN_WIDTH/2-390/2, SCREEN_HEIGHT/2-445/2-100, 390, 445 );
        
    }else{
        goodsView.frame=CGRectMake(SCREEN_WIDTH/2-390/2, SCREEN_HEIGHT/2-445/2-150, 390, 445 );
        
    }
    
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        goodsView.frame=CGRectMake(SCREEN_WIDTH/2-390/2, SCREEN_HEIGHT/2-445/2, 390, 445 );
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [pickerView removeFromSuperview];
    [lab removeFromSuperview];
    [btn removeFromSuperview];
    pickerView = nil;
    
}
@end
