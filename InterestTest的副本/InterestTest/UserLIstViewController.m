//
//  UserLIstViewController.m
//  InterestTest
//
//  Created by Mickey on 2017/8/8.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "UserLIstViewController.h"
#import "RootHttpHelper.h"
#import "MickeyTools.h"
#import "ZYPinYinSearch.h"
#import "HCSortString.h"


#define kColor          [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];

@interface UserLIstViewController ()<UISearchResultsUpdating,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UILabel *lplab1;
    UILabel *hxlab1;
    UILabel *hxlab3;
    UILabel *arealab1;
    UILabel *stylelab1;
    UILabel *stylelab3;
    UILabel *stylelab5;
    UILabel *familylab1;
    UILabel *kflab1;
    UILabel *orderlab1;
    UILabel *remarklab1;
    NSString *sex;
    NSString *mobile;
    
    //更改字段
    NSString *nickname;
    NSString *areas;
    NSString *gender;
    NSString *newmobile;
    NSString *room_name;
    NSString *basic_room_id;
    NSString *house_type;
    NSString *like_move_style;
    NSString *like_fixed;
    NSString *is_belief_fs;
    NSString *home_member;
    NSString *client_source;
    NSString *order_status;
    NSString *remark;
    
    UITextField *nametifd;
    UITextField *areatifd;
    UITextField *phonelab3;
    UITextField *lp3;
    UITextField *hxhtifd;
    UITextField *likestyletifd;
    UITextField *stylelabtifd;
    UITextField *familytifd;
    UITextField *remarktifd;
    //

    
    UILabel *sexlab2;
    UIButton *sexlab3;
    NSString *nowuser_id;
    UIButton *fs3;
    UIButton *kh3;
    NSString *basec_id;
    NSString *basec_name;
    
    //
    UITextField *addname;
    UITextField *addphone;
    UITextField *addlp;
    UIButton    *addhx;
    UITextField *addlikestyle;
    UIButton *fs;
    UITextField *addfamily;
    UITextField *addremark;
    UIButton *addsex;
    UITextField *addarea;
    UITextField *addhxh;
    UITextField *addstyle;
    UIButton *addkh;
    NSMutableArray *hxArr;
    NSMutableArray *btnArr1;
    
    UIButton *hx3;
    
}
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *dataSource;/**<排序前的整个数据源*/
@property (strong, nonatomic) NSMutableArray *userlistdate;/**<排序前的整个数据源*/
@property (strong, nonatomic) NSDictionary *allDataSource;/**<排序后的整个数据源*/
@property (strong, nonatomic) NSMutableArray *searchDataSource;/**<搜索结果数据源*/
@property (strong, nonatomic) NSArray *indexDataSource;/**<索引数据源*/
@property (strong, nonatomic) UIView *editview;/**<索引数据源*/


@end

@implementation UserLIstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initData];
    [self createtableview];
    [self getuserlist];
    [self getbasicdate];
    _backview.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.3f];
    
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
    basec_name=[btn titleForState:UIControlStateNormal];
    basec_id=[NSString stringWithFormat:@"%ld",btn.tag];
    basic_room_id=[NSString stringWithFormat:@"%ld",btn.tag];
//    hxlab3.text=[btn titleForState:UIControlStateNormal];
    
    
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
         _hxviewheight.constant=backView.frame.size.height;
        [_lpview addSubview:backView];
        
    }
    
    
}

- (void)getbasicdate
{

    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"sale-staff/basic-type" andParams:nil andSuccess:^(NSDictionary *successData) {
        //加载圈圈(显示)
            hxArr=[[NSMutableArray alloc]init];
            if ([[successData objectForKey:@"api_code"] integerValue]==200) {
                hxArr=[successData objectForKey:@"data"];
                [self creatHeadView1];
//                _hxview.hidden=NO;
//                [self.view bringSubviewToFront:_hxview];
                _hxview.layer.shadowColor = [UIColor blackColor].CGColor;
                _hxview.layer.shadowOpacity = 0.8f;
                _hxview.layer.shadowRadius = 10.f;
                _hxview.layer.shadowOffset = CGSizeMake(4,4);

        }
        else if([[successData objectForKey:@"status"] integerValue]==0){
            [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
        }
        else{
            [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"error"]];
        }

        
    } andError:^(NSError *error) {
        //加载圈圈(显示)
        [[HudHelper hudHepler] HideHUDAlert:self.view];
        NSLog(@"%@",error);
        if ([[MickeyTools getErrorStringWithError:error] isEqualToString:@"登陆信息过期,需要重新登陆"]) {
            
        }else{
            [[HudHelper hudHepler] showTips:self.view tips:[MickeyTools getErrorStringWithError:error] ] ;
            
        }
    }];

}
#pragma mark - Init
- (void)initData {
     NSDictionary *dic=[[NSDictionary alloc]init];
    if(_userlistdate.count>0)
    {
        dic=_userlistdate[0];
        nowuser_id=[dic objectForKey:@"id"];
        gender=[dic objectForKey:@"gender"];
        basic_room_id=[dic objectForKey:@"basic_room_id"];
        is_belief_fs=[dic objectForKey:@"is_belief_fs"];
        client_source=[dic objectForKey:@"client_source"];
        if ([[dic objectForKey:@"gender"] integerValue]==0) {
            sex=@"女";
        }else{
            sex=@"男";
        }
        mobile=[dic objectForKey:@"mobile"];
    }

    _searchDataSource = [NSMutableArray new];
    
    _allDataSource = [HCSortString sortAndGroupForArray:_dataSource PropertyName:@"name"];
    _indexDataSource = [HCSortString sortForStringAry:[_allDataSource allKeys]];
    
    
    _headimg.layer.cornerRadius=30;
    _headimg.layer.masksToBounds=YES;
    if (![self isBlankString:[dic objectForKey:@"avatar"]]) {
     [_headimg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] forState:UIControlStateNormal];
      _name.text=[dic objectForKey:@"nickname"];
    }else if(_userlistdate.count>0){
      [_headimg setTitle: [[dic objectForKey:@"nickname"] substringToIndex:1]forState:UIControlStateNormal];
         _name.text=[dic objectForKey:@"nickname"];
    }else{
      [_headimg setTitle:@"A" forState:UIControlStateNormal];
    }
   
    UIView *oneview=[[UIView alloc]initWithFrame:CGRectMake(0.38*SCREEN_WIDTH, 238, 0.62*SCREEN_WIDTH, 100)];
//    oneview.backgroundColor=[UIColor yellowColor];
    [self.view addSubview:oneview];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 100, 0.62*SCREEN_WIDTH, 1)];
    line.backgroundColor=UIColorFromRGB(0xdfdfdf);
    [oneview addSubview:line];
    
    UILabel *lplab=[[UILabel alloc]initWithFrame:CGRectMake(10, 25, (0.62*SCREEN_WIDTH-50)/4, 20)];
    lplab.textAlignment=NSTextAlignmentLeft;
    lplab.text=@"楼盘";
    lplab.textColor=UIColorFromRGB(0x666666);
    lplab.font=[UIFont systemFontOfSize:16.f];
    [oneview addSubview:lplab];
    
    lplab1=[[UILabel alloc]initWithFrame:CGRectMake(10, 25+25, (0.62*SCREEN_WIDTH-50)/4, 20)];
    lplab1.textAlignment=NSTextAlignmentLeft;
    if (_userlistdate.count>0) {
        lplab1.text=[dic objectForKey:@"room_name"];
    }else{
    lplab1.text=@"湘湖一号";
    }
    lplab1.textColor=UIColorFromRGB(0x333333);
    lplab1.font=[UIFont systemFontOfSize:16.f];
    [oneview addSubview:lplab1];
    
    UILabel *hxlab=[[UILabel alloc]initWithFrame:CGRectMake((0.62*SCREEN_WIDTH-50)/4+10, 25, (0.62*SCREEN_WIDTH-50)/4, 20)];
    hxlab.textAlignment=NSTextAlignmentLeft;
    hxlab.text=@"户型号";
    hxlab.textColor=UIColorFromRGB(0x666666);
    hxlab.font=[UIFont systemFontOfSize:16.f];
    [oneview addSubview:hxlab];
    
    hxlab1=[[UILabel alloc]initWithFrame:CGRectMake((0.62*SCREEN_WIDTH-50)/4+10, 25+25, (0.62*SCREEN_WIDTH-50)/4, 20)];
    hxlab1.textAlignment=NSTextAlignmentLeft;
    if (_userlistdate.count>0&&![self isBlankString:[dic objectForKey:@"house_type"]]) {
        hxlab1.text=[dic objectForKey:@"house_type"];
    }else{
        hxlab1.text=@"103-12-1920";
    }
//    hxlab1.text=@"103-12-1920";
    hxlab1.textColor=UIColorFromRGB(0x333333);
    hxlab1.font=[UIFont systemFontOfSize:16.f];
    [oneview addSubview:hxlab1];
    
    UILabel *hxlab2=[[UILabel alloc]initWithFrame:CGRectMake((0.62*SCREEN_WIDTH-50)/4*2+20, 25, (0.62*SCREEN_WIDTH-50)/4, 20)];
    hxlab2.textAlignment=NSTextAlignmentLeft;
    hxlab2.text=@"户型";
    hxlab2.textColor=UIColorFromRGB(0x666666);
    hxlab2.font=[UIFont systemFontOfSize:16.f];
    [oneview addSubview:hxlab2];
    
    hxlab3=[[UILabel alloc]initWithFrame:CGRectMake((0.62*SCREEN_WIDTH-50)/4*2+20, 25+25, (0.62*SCREEN_WIDTH-50)/4, 20)];
    hxlab3.textAlignment=NSTextAlignmentLeft;
    if (_userlistdate.count>0) {
        hxlab3.text=[dic objectForKey:@"basic_room_name"];
    }else{
        hxlab3.text=@"三室两厅";
    }
    hxlab3.textColor=UIColorFromRGB(0x333333);
    hxlab3.font=[UIFont systemFontOfSize:16.f];
    [oneview addSubview:hxlab3];
    
    UILabel *arealab=[[UILabel alloc]initWithFrame:CGRectMake((0.62*SCREEN_WIDTH-50)/4*3+30, 25, (0.62*SCREEN_WIDTH-50)/4, 20)];
    arealab.textAlignment=NSTextAlignmentLeft;
    arealab.text=@"面积";
    arealab.textColor=UIColorFromRGB(0x666666);
    arealab.font=[UIFont systemFontOfSize:16.f];
    [oneview addSubview:arealab];
    
    arealab1=[[UILabel alloc]initWithFrame:CGRectMake((0.62*SCREEN_WIDTH-50)/4*3+30, 25+25, (0.62*SCREEN_WIDTH-50)/4, 20)];
    arealab1.textAlignment=NSTextAlignmentLeft;
    if (_userlistdate.count>0) {
        arealab1.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"areas"]];
    }else{
        arealab1.text=@"三室两厅";
    }
    arealab1.textColor=UIColorFromRGB(0x333333);
    arealab1.font=[UIFont systemFontOfSize:16.f];
    [oneview addSubview:arealab1];
    
    
    
    UIView *twoview=[[UIView alloc]initWithFrame:CGRectMake(0.38*SCREEN_WIDTH, 238+100, 0.62*SCREEN_WIDTH, 100)];
    [self.view addSubview:twoview];
    
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 100, 0.62*SCREEN_WIDTH, 1)];
    line1.backgroundColor=UIColorFromRGB(0xdfdfdf);
    [twoview addSubview:line1];
    
    
    UILabel *stylelab=[[UILabel alloc]initWithFrame:CGRectMake(10, 25, (0.62*SCREEN_WIDTH-40)/3, 20)];
    stylelab.textAlignment=NSTextAlignmentLeft;
    stylelab.text=@"喜欢的软装风格";
    stylelab.textColor=UIColorFromRGB(0x666666);
    stylelab.font=[UIFont systemFontOfSize:16.f];
    [twoview addSubview:stylelab];
    
    stylelab1=[[UILabel alloc]initWithFrame:CGRectMake(10, 25+25,(0.62*SCREEN_WIDTH-40)/3, 20)];
    stylelab1.textAlignment=NSTextAlignmentLeft;
    if (_userlistdate.count>0) {
        stylelab1.text=[dic objectForKey:@"like_move_style"];
    }else{
        stylelab1.text=@"三室两厅";
    }
    stylelab1.textColor=UIColorFromRGB(0x333333);
    stylelab1.font=[UIFont systemFontOfSize:16.f];
    [twoview addSubview:stylelab1];
    
    UILabel *stylelab2=[[UILabel alloc]initWithFrame:CGRectMake((0.62*SCREEN_WIDTH-40)/3+20, 25, (0.62*SCREEN_WIDTH-40)/3, 20)];
    stylelab2.textAlignment=NSTextAlignmentLeft;
    stylelab2.text=@"拟装修风格";
    stylelab2.textColor=UIColorFromRGB(0x666666);
    stylelab2.font=[UIFont systemFontOfSize:16.f];
    [twoview addSubview:stylelab2];
    
    stylelab3=[[UILabel alloc]initWithFrame:CGRectMake((0.62*SCREEN_WIDTH-40)/3+20, 25+25, (0.62*SCREEN_WIDTH-40)/3, 20)];
    stylelab3.textAlignment=NSTextAlignmentLeft;
    if (_userlistdate.count>0) {
        stylelab3.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"like_fixed"]];
    }else{
        stylelab3.text=@"三室两厅";
    }
    stylelab3.textColor=UIColorFromRGB(0x333333);
    stylelab3.font=[UIFont systemFontOfSize:16.f];
    [twoview addSubview:stylelab3];
    
    UILabel *stylelab4=[[UILabel alloc]initWithFrame:CGRectMake((0.62*SCREEN_WIDTH-40)/3*2+30, 25, 0.62*SCREEN_WIDTH/3, 20)];
    stylelab4.textAlignment=NSTextAlignmentLeft;
    stylelab4.text=@"是否信风水";
    stylelab4.textColor=UIColorFromRGB(0x666666);
    stylelab4.font=[UIFont systemFontOfSize:16.f];
    [twoview addSubview:stylelab4];
    
    stylelab5=[[UILabel alloc]initWithFrame:CGRectMake((0.62*SCREEN_WIDTH-40)/3*2+30, 25+25, 0.62*SCREEN_WIDTH/3, 20)];
    stylelab5.textAlignment=NSTextAlignmentLeft;
    if (_userlistdate.count>0) {
        if([[NSString stringWithFormat:@"%@",[dic objectForKey:@"is_belief_fs"]] integerValue]==1)
        {
        stylelab5.text=@"是";
        }else{
        stylelab5.text=@"否";
        }
    }
    else{
        stylelab5.text=@"";
    }
    stylelab5.textColor=UIColorFromRGB(0x333333);
    stylelab5.font=[UIFont systemFontOfSize:16.f];
    [twoview addSubview:stylelab5];
    
    UIView *threeview=[[UIView alloc]initWithFrame:CGRectMake(0.38*SCREEN_WIDTH, 238+200, 0.62*SCREEN_WIDTH, 100)];
    [self.view addSubview:threeview];
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, 100, 0.62*SCREEN_WIDTH, 1)];
    line2.backgroundColor=UIColorFromRGB(0xdfdfdf);
    [threeview addSubview:line2];
    
    
    UILabel *familylab=[[UILabel alloc]initWithFrame:CGRectMake(10, 25, (0.62*SCREEN_WIDTH-40)/3, 20)];
    familylab.textAlignment=NSTextAlignmentLeft;
    familylab.text=@"家庭成员";
    familylab.textColor=UIColorFromRGB(0x666666);
    familylab.font=[UIFont systemFontOfSize:16.f];
    [threeview addSubview:familylab];
    
    familylab1=[[UILabel alloc]initWithFrame:CGRectMake(10, 25+25, (0.62*SCREEN_WIDTH-40)/3, 20)];
    familylab1.textAlignment=NSTextAlignmentLeft;
    if (_userlistdate.count>0) {
        familylab1.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"home_member"]];
    }else{
        familylab1.text=@"";
    }
    familylab1.textColor=UIColorFromRGB(0x333333);
    familylab1.font=[UIFont systemFontOfSize:16.f];
    familylab1.numberOfLines=0;
    [threeview addSubview:familylab1];
    
    UILabel *kflab=[[UILabel alloc]initWithFrame:CGRectMake((0.62*SCREEN_WIDTH-40)/3+20, 25, (0.62*SCREEN_WIDTH-40)/3, 20)];
    kflab.textAlignment=NSTextAlignmentLeft;
    kflab.text=@"客户来源";
    kflab.textColor=UIColorFromRGB(0x666666);
    kflab.font=[UIFont systemFontOfSize:16.f];
    [threeview addSubview:kflab];
    
    
    kflab1=[[UILabel alloc]initWithFrame:CGRectMake((0.62*SCREEN_WIDTH-40)/3+20, 25+25, (0.62*SCREEN_WIDTH-40)/3, 20)];
    kflab1.textAlignment=NSTextAlignmentLeft;
    if (_userlistdate.count>0) {
        kflab1.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"client_source"]];
    }else{
        kflab1.text=@"";
    }
    kflab1.textColor=UIColorFromRGB(0x333333);
    kflab1.font=[UIFont systemFontOfSize:16.f];
    [threeview addSubview:kflab1];
    
    UILabel *orderlab=[[UILabel alloc]initWithFrame:CGRectMake((0.62*SCREEN_WIDTH-40)/3*2+30, 25, (0.62*SCREEN_WIDTH-40)/3, 20)];
    orderlab.textAlignment=NSTextAlignmentLeft;
    orderlab.text=@"订单状态";
    orderlab.textColor=UIColorFromRGB(0x666666);
    orderlab.font=[UIFont systemFontOfSize:16.f];
    [threeview addSubview:orderlab];
    
    orderlab1=[[UILabel alloc]initWithFrame:CGRectMake((0.62*SCREEN_WIDTH-40)/3*2+30, 25+25, (0.62*SCREEN_WIDTH-40)/3, 20)];
    orderlab1.textAlignment=NSTextAlignmentLeft;
    if (_userlistdate.count>0) {
        if([[dic objectForKey:@"order_statues"] integerValue]==0)
        {
          orderlab1.text=@"未成交";
        }else if([[dic objectForKey:@"order_statues"] integerValue]==1){
          orderlab1.text=@"方案阶段";
        }else{
          orderlab1.text=@"已成交";
        }
//        kflab1.text=[dic objectForKey:@"order_statues"];
    }else{
        kflab1.text=@"";
    }
//    orderlab1.text=@"未成交";
    orderlab1.textColor=UIColorFromRGB(0x333333);
    orderlab1.font=[UIFont systemFontOfSize:16.f];
    [threeview addSubview:orderlab1];
    
    
    
    
    UIView *fourview=[[UIView alloc]initWithFrame:CGRectMake(0.38*SCREEN_WIDTH, 238+300, 0.62*SCREEN_WIDTH, 100)];
    [self.view addSubview:fourview];
    
//    UIView *line3=[[UIView alloc]initWithFrame:CGRectMake(0.38*SCREEN_WIDTH, 100, 0.62*SCREEN_WIDTH, 1)];
//    line3.backgroundColor=UIColorFromRGB(0xdfdfdf);
//    [fourview addSubview:line3];
    
    
    UILabel *remarklab=[[UILabel alloc]initWithFrame:CGRectMake(10, 25, (0.62*SCREEN_WIDTH-20)/3, 20)];
    remarklab.textAlignment=NSTextAlignmentLeft;
    remarklab.text=@"备注";
    remarklab.textColor=UIColorFromRGB(0x666666);
    remarklab.font=[UIFont systemFontOfSize:16.f];
    [fourview addSubview:remarklab];
    
    remarklab1=[[UILabel alloc]initWithFrame:CGRectMake(10, 25+25, 0.62*SCREEN_WIDTH-20, 20)];
    remarklab1.textAlignment=NSTextAlignmentLeft;
    if (_userlistdate.count>0) {
        remarklab1.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"remark"]];
     }else{
        remarklab1.text=@"";
     }
//    remarklab1.text=@"男主刚毕业，设计出身，对于有设计感的产品高度需求，看中进口品牌沙发，考虑餐厅大件进口...";
    remarklab1.textColor=UIColorFromRGB(0x333333);
    remarklab1.numberOfLines=0;
    remarklab1.font=[UIFont systemFontOfSize:16.f];
    [fourview addSubview:remarklab1];
    
    
    UIButton *testbtn=[[UIButton alloc]initWithFrame:CGRectMake(0.38*SCREEN_WIDTH+0.62*SCREEN_WIDTH/2-147-20, SCREEN_HEIGHT-29-47, 147, 47)];
    [testbtn setTitle:@"风格测试" forState:UIControlStateNormal];
    testbtn.layer.masksToBounds=YES;
    testbtn.layer.cornerRadius=3.f;
    [testbtn setBackgroundColor:UIColorFromRGB(0xc90920)];
    [testbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:testbtn];
    
    
    UIButton *lookbtn=[[UIButton alloc]initWithFrame:CGRectMake(0.38*SCREEN_WIDTH+0.62*SCREEN_WIDTH/2+20, SCREEN_HEIGHT-29-47, 147, 47)];
    [lookbtn setTitle:@"查看清单" forState:UIControlStateNormal];
    lookbtn.layer.masksToBounds=YES;
    lookbtn.layer.cornerRadius=3.f;
    lookbtn.layer.borderWidth=1;
    lookbtn.layer.borderColor=UIColorFromRGB(0xaaaaaa).CGColor;
//    [lookbtn setBackgroundColor:UIColorFromRGB(0xaaaaaa)];
    [lookbtn setTitleColor:UIColorFromRGB(0xaaaaaa) forState:UIControlStateNormal];
    [self.view addSubview:lookbtn];
    
    

    
    
    
}

- (void)createtableview
{
    _tableView = [[UITableView alloc]initWithFrame: CGRectMake(0 , 64, SCREEN_WIDTH*0.38, SCREEN_HEIGHT-64-40)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
//    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] init];   //隐藏tableview多余分割线
//    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    _tableView.indicatorStyle=UIScrollViewIndicatorStyleWhite;     //设置滚动条为白色
    _tableView.scrollsToTop=YES;
    self.tableView.backgroundColor = UIColorFromRGB(0xf9f9f9);
    
    [_tablebackview addSubview:_tableView];
    
    [self.tableView setTableHeaderView:self.searchController.searchBar];
    
    //下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(loadData) dateKey:@"SailorTable"];
    [self.tableView headerBeginRefreshing];
    self.tableView.headerPullToRefreshText = headerPullToRefreshText;
    self.tableView.headerReleaseToRefreshText = headerReleaseToRefreshText;
    self.tableView.headerRefreshingText = headerRefreshingText;
    
    //上拉加载
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    self.tableView.footerPullToRefreshText = footerPullToRefreshText;
    self.tableView.footerReleaseToRefreshText = footerReleaseToRefreshText;
    self.tableView.footerRefreshingText = footerRefreshingText;
}
- (void)getuserlist
{
    _dataSource=[[NSMutableArray alloc]init];
    //退回到LoginHome页面
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_user_id forKey:@"user_id"];
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"sale-staff/list" andParams:params andSuccess:^(NSDictionary *successData) {
        //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200&&[[successData objectForKey:@"status"] integerValue]==1) {
            _userlistdate=[[NSMutableArray alloc]initWithArray:[successData objectForKey:@"user_info"]];
            for (NSDictionary *dic in _userlistdate) {
                [_dataSource addObject:[dic objectForKey:@"nickname"]];
            }
            [self initData];
            [self.tableView reloadData];
            
//            UserLIstViewController *list=[[UserLIstViewController alloc]init];
//            [self.navigationController pushViewController:list animated:YES];
        }
        else if([[successData objectForKey:@"status"] integerValue]==0){
            [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
        }
        else{
             [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"error"]];
        }
        //
        //            NSError *err = nil;
        //            _userModel = [[UserModel alloc] initWithDictionary:successData error:&err];
        //
        //            if([_userModel.code isEqualToString:@"200"])
        //            {
        //                [[RootHttpHelper httpHelper] setUserToken:_userModel.token];
        //                [[HttpHelper httpHelper] setUserToken:_userModel.token];
        //                NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        //                [defaults setObject:_userModel.token forKey:@"usertoken"];
        //                [defaults setObject:_userModel.avatar forKey:@"avator"];
        //                [defaults synchronize];
        //                //发通知侧边栏可以点击展开测试结果界面
        //                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginin" object:nil];
        //                [self setUserInfo];
        //                [self getUserTestResult];
        //                //                ThemeViewController *theme=[[ThemeViewController alloc]init];
        //                //                LeftViewController  *left=[[LeftViewController alloc]init];
        //                //                UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:theme];
        //                //                UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:left];
        //                //
        //                //                SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
        //                //                revealController.delegate = self;
        //                //                [self.navigationController pushViewController:revealController animated:YES];
        //            }
        //            else
        //            {
        //                [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"message"]];
        //            }
        
    } andError:^(NSError *error) {
        //加载圈圈(显示)
        [[HudHelper hudHepler] HideHUDAlert:self.view];
        NSLog(@"%@",error);
        if ([[MickeyTools getErrorStringWithError:error] isEqualToString:@"登陆信息过期,需要重新登陆"]) {
            
        }else{
            [[HudHelper hudHepler] showTips:self.view tips:[MickeyTools getErrorStringWithError:error] ] ;
            
        }
    }];

}
- (void)getuserlist1
{
    _dataSource=[[NSMutableArray alloc]init];
    //退回到LoginHome页面
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_user_id forKey:@"user_id"];
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"sale-staff/list" andParams:params andSuccess:^(NSDictionary *successData) {
        //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200&&[[successData objectForKey:@"status"] integerValue]==1) {
            _userlistdate=[[NSMutableArray alloc]initWithArray:[successData objectForKey:@"user_info"]];
            for (NSDictionary *dic in _userlistdate) {
                [_dataSource addObject:[dic objectForKey:@"nickname"]];
            }
            _searchDataSource = [NSMutableArray new];
            
            _allDataSource = [HCSortString sortAndGroupForArray:_dataSource PropertyName:@"name"];
            _indexDataSource = [HCSortString sortForStringAry:[_allDataSource allKeys]];
            [self.tableView reloadData];
            
            //            UserLIstViewController *list=[[UserLIstViewController alloc]init];
            //            [self.navigationController pushViewController:list animated:YES];
        }
        else if([[successData objectForKey:@"status"] integerValue]==0){
            [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
        }
        else{
            [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"error"]];
        }
     
        
    } andError:^(NSError *error) {
        //加载圈圈(显示)
        [[HudHelper hudHepler] HideHUDAlert:self.view];
        NSLog(@"%@",error);
        if ([[MickeyTools getErrorStringWithError:error] isEqualToString:@"登陆信息过期,需要重新登陆"]) {
            
        }else{
            [[HudHelper hudHepler] showTips:self.view tips:[MickeyTools getErrorStringWithError:error] ] ;
            
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 请求数据方法
/**
 *  发送请求并获取数据方法
 */
- (void)loadData{
    //    _page=1;
    //    _start=@"";
    //    [self getNetwork];
    __weak typeof(self) weakSelf = self;
    [weakSelf.tableView headerEndRefreshing];
}
/**
 *  加载更多数据
 */
- (void)loadMoreData{
    //  _page=_page+1;
    //    [self getMoreDate];
    __weak typeof(self) weakSelf = self;
    //
    [weakSelf.tableView footerEndRefreshing];
    //    _page=_page+1;
    
}
- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = YES;
        _searchController.searchBar.placeholder = @"搜索";
        [_searchController.searchBar sizeToFit];
    }
    return _searchController;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.searchController.active) {
        self.tableView.frame=CGRectMake(0, 64, SCREEN_WIDTH*0.38, SCREEN_HEIGHT);
        return _indexDataSource.count;
    }else {
        self.tableView.frame=CGRectMake(0, 20, SCREEN_WIDTH*0.38, SCREEN_HEIGHT);

        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.searchController.active) {
        NSArray *value = [_allDataSource objectForKey:_indexDataSource[section]];
        return value.count;
    }else {
        return _searchDataSource.count;
    }
}
//头部索引标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!self.searchController.active) {
        return _indexDataSource[section];
    }else {
        return nil;
    }
}
//右侧索引列表
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (!self.searchController.active) {
        return _indexDataSource;
    }else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if (!self.searchController.active) {
        NSArray *value = [_allDataSource objectForKey:_indexDataSource[indexPath.section]];
        cell.textLabel.text = value[indexPath.row];
    }else{
        cell.textLabel.text = _searchDataSource[indexPath.row];
    }
    return cell;
}
//索引点击事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.searchController.active) {
        NSArray *value = [_allDataSource objectForKey:_indexDataSource[indexPath.section]];
//        self.block(value[indexPath.row]);
        for (NSDictionary *dic in _userlistdate) {
            if ([[dic objectForKey:@"nickname"]isEqualToString:value[indexPath.row]]) {
                [_headimg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] forState:UIControlStateNormal];
                if (![self isBlankString:[dic objectForKey:@"avatar"]]) {
                    [_headimg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] forState:UIControlStateNormal];
                    _name.text=[dic objectForKey:@"nickname"];
                }else if(_userlistdate.count>0){
                    [_headimg setTitle: [[dic objectForKey:@"nickname"] substringToIndex:1]forState:UIControlStateNormal];
                    _name.text=[dic objectForKey:@"nickname"];
                }else{
                    [_headimg setTitle:@"A" forState:UIControlStateNormal];
                }
                

                nowuser_id=[dic objectForKey:@"id"];
                _name.text=[dic objectForKey:@"nickname"];
                gender=[dic objectForKey:@"gender"];
                basic_room_id=[dic objectForKey:@"basic_room_id"];
                is_belief_fs=[dic objectForKey:@"is_belief_fs"];
                client_source=[dic objectForKey:@"client_source"];
                if ([[dic objectForKey:@"gender"] integerValue]==0) {
                    sex=@"女";
                }else{
                    sex=@"男";
                }
                mobile=[dic objectForKey:@"mobile"];
                
                lplab1.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"room_name"]];
                hxlab1.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"house_type"]];
                hxlab3.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"basic_room_name"]];
                arealab1.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"areas"]];
                stylelab1.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"like_move_style"]];
                stylelab3.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"like_fixed"]];

                if([[NSString stringWithFormat:@"%@",[dic objectForKey:@"is_belief_fs"]] integerValue]==1)
                {
                    stylelab5.text=[dic objectForKey:@"是"];
                }else{
                    stylelab5.text=[dic objectForKey:@"否"];
                }
                familylab1.text=[dic objectForKey:@"home_member"];
                kflab1.text=[dic objectForKey:@"client_source"];
                if ([[dic objectForKey:@"order_statues"] integerValue]==0) {
                    orderlab1.text=@"未成交";
                }else if([[dic objectForKey:@"order_statues"] integerValue]==1)
                {
                    orderlab1.text=@"方案阶段";
                }else{
                    orderlab1.text=@"以成交";
                }
                remarklab1.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"remark"]];
            }
        }
//        NSDictionary *dic=[[NSDictionary alloc]init];
//        dic=_userlistdate[indexPath.row];
//        [_headimg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] forState:UIControlStateNormal];
//        _name.text=[dic objectForKey:@"nickname"];;
        
    }else{
        for (NSDictionary *dic in _userlistdate) {
            if ([[dic objectForKey:@"nickname"]isEqualToString:_searchDataSource[indexPath.row]]) {
                        [_headimg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] forState:UIControlStateNormal];
                if (![self isBlankString:[dic objectForKey:@"avatar"]]) {
                    [_headimg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] forState:UIControlStateNormal];
                    _name.text=[dic objectForKey:@"nickname"];
                }else if(_userlistdate.count>0){
                    [_headimg setTitle: [[dic objectForKey:@"nickname"] substringToIndex:1]forState:UIControlStateNormal];
                    _name.text=[dic objectForKey:@"nickname"];
                }else{
                    [_headimg setTitle:@"A" forState:UIControlStateNormal];
                }
                        _name.text=[dic objectForKey:@"nickname"];
                         gender=[dic objectForKey:@"gender"];
                         basic_room_id=[dic objectForKey:@"basic_room_id"];
                         is_belief_fs=[dic objectForKey:@"is_belief_fs"];
                         client_source=[dic objectForKey:@"client_source"];
                nowuser_id=[dic objectForKey:@"id"];
                if ([[dic objectForKey:@"gender"] integerValue]==0) {
                    sex=@"女";
                }else{
                    sex=@"男";
                }
                mobile=[dic objectForKey:@"mobile"];
                
                lplab1.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"room_name"]];
                hxlab1.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"house_type"]];
                hxlab3.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"basic_room_name"]];
                arealab1.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"areas"]];
                stylelab1.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"like_move_style"]];
                stylelab3.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"like_fixed"]];
                
                if([[NSString stringWithFormat:@"%@",[dic objectForKey:@"is_belief_fs"]] integerValue]==1)
                {
                    stylelab5.text=[dic objectForKey:@"是"];
                }else{
                    stylelab5.text=[dic objectForKey:@"否"];
                }
                familylab1.text=[dic objectForKey:@"home_member"];
                kflab1.text=[dic objectForKey:@"client_source"];
                if ([[dic objectForKey:@"order_statues"] integerValue]==0) {
                    orderlab1.text=@"未成交";
                }else if([[dic objectForKey:@"order_statues"] integerValue]==1)
                {
                    orderlab1.text=@"方案阶段";
                }else{
                    orderlab1.text=@"以成交";
                }
                remarklab1.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"remark"]];
            }
        }

    }
    self.searchController.active = NO;

}

#pragma mark - UISearchDelegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [_searchDataSource removeAllObjects];
    searchController.searchBar.showsCancelButton = YES;
    NSArray *ary = [HCSortString getAllValuesFromDict:_allDataSource];
    
    if (searchController.searchBar.text.length == 0) {
        [_searchDataSource addObjectsFromArray:ary];
    }else {
        ary = [ZYPinYinSearch searchWithOriginalArray:ary andSearchText:searchController.searchBar.text andSearchByPropertyName:@"name"];
        [_searchDataSource addObjectsFromArray:ary];
    }
    for(id sousuo in [searchController.searchBar subviews])
    {
        
        for (id zz in [sousuo subviews])
        {
            
            if([zz isKindOfClass:[UIButton class]]){
                UIButton *btn = (UIButton *)zz;
                [btn setTitle:@"取消" forState:UIControlStateNormal];
                [btn setTitleColor:colorHead forState:UIControlStateNormal];
            }
            
            
        }
    }

    [self.tableView reloadData];
}

#pragma mark - block
- (void)didSelectedItem:(SelectedItem)block {
    self.block = block;
}

- (IBAction)addbtnclick:(UIButton *)sender {
    if (_editview) {
        [_editview removeFromSuperview];
    }
    _editview=[[UIView alloc]initWithFrame:CGRectMake(0.38*SCREEN_WIDTH, 0, 0.62*SCREEN_WIDTH, SCREEN_HEIGHT)];
    _editview.backgroundColor=UIColorFromRGB(0xFAFAFF);
    [self.view addSubview:_editview];
    
    UIButton *cancalbtn=[[UIButton alloc]initWithFrame:CGRectMake(30, 30, 60, 20)];
    [cancalbtn setTitleColor:UIColorFromRGB(0xc90920) forState:UIControlStateNormal];
    [cancalbtn setTitle:@"取消" forState:UIControlStateNormal];
    cancalbtn.titleLabel.font=[UIFont systemFontOfSize:18.f];
    [cancalbtn addTarget:self action:@selector(cancal) forControlEvents:UIControlEventTouchUpInside];
    [_editview addSubview:cancalbtn];
    
    UIButton *okbtn=[[UIButton alloc]initWithFrame:CGRectMake(0.62*SCREEN_WIDTH-30-60, 30, 60, 20)];
    [okbtn setTitleColor:UIColorFromRGB(0xc90920) forState:UIControlStateNormal];
    [okbtn setTitle:@"完成" forState:UIControlStateNormal];
    okbtn.titleLabel.font=[UIFont systemFontOfSize:18.f];
    [okbtn addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [_editview addSubview:okbtn];
    
    UILabel *nanelab1=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64, 10, 48)];
    nanelab1.text=@"*";
    nanelab1.textColor=colorHead;
    [_editview addSubview:nanelab1];
    
    UILabel *nanelab2=[[UILabel alloc]initWithFrame:CGRectMake(40, 30+64, 50, 48)];
    nanelab2.text=@"姓名:";
    nanelab2.font=[UIFont systemFontOfSize:18.f];
    nanelab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:nanelab2];
    
    addname=[[UITextField alloc]initWithFrame:CGRectMake(90, 30+64, (0.68*SCREEN_WIDTH-90)/2-90, 48)];
    addname.textColor=UIColorFromRGB(0x333333);
    addname.font=[UIFont systemFontOfSize:18.f];
    addname.placeholder=@"请输入姓名";
    addname.textAlignment=NSTextAlignmentRight;
    [_editview addSubview:addname];
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48, (0.68*SCREEN_WIDTH-90)/2-30, 0.5)];
    line.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line];
    
    
    
    UILabel *phonelab1=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48, 10, 48)];
    phonelab1.text=@"*";
    phonelab1.textColor=colorHead;
    [_editview addSubview:phonelab1];
    
    UILabel *phonelab2=[[UILabel alloc]initWithFrame:CGRectMake(40, 30+64+48, 80, 48)];
    phonelab2.text=@"电话号码:";
    phonelab2.font=[UIFont systemFontOfSize:18.f];
    phonelab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:phonelab2];
    
    addphone=[[UITextField alloc]initWithFrame:CGRectMake(120, 30+64+48, (0.68*SCREEN_WIDTH-90)-120, 48)];
    addphone.textColor=UIColorFromRGB(0x333333);
    addphone.font=[UIFont systemFontOfSize:18.f];
    addphone.placeholder=@"请输入手机号码";
    addphone.textAlignment=NSTextAlignmentRight;
    [_editview addSubview:addphone];
    
    UILabel *line1=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48, (0.68*SCREEN_WIDTH-90)-30, 0.5)];
    line1.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line1];
    
    UILabel *lplab11=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48, 10, 48)];
    lplab11.text=@"*";
    lplab11.textColor=colorHead;
    [_editview addSubview:lplab11];
    
    UILabel *lplab2=[[UILabel alloc]initWithFrame:CGRectMake(40, 30+64+48+48, 50, 48)];
    lplab2.text=@"楼盘:";
    lplab2.font=[UIFont systemFontOfSize:18.f];
    lplab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:lplab2];
    
    addlp=[[UITextField alloc]initWithFrame:CGRectMake(90, 30+64+48+48, (0.68*SCREEN_WIDTH-90)/2-90, 48)];
    addlp.textColor=UIColorFromRGB(0x333333);
    addlp.font=[UIFont systemFontOfSize:18.f];
    addlp.placeholder=@"请输入楼盘";
    addlp.textAlignment=NSTextAlignmentRight;
    [_editview addSubview:addlp];
    
//    addlp=[[UIButton alloc]initWithFrame:CGRectMake(90, 30+64+48+48, (0.68*SCREEN_WIDTH-90)/2-90, 48)];
//    addlp.titleLabel.textColor=UIColorFromRGB(0xcccccc);
//    addlp.titleLabel.font=[UIFont systemFontOfSize:18.f];
//    addlp.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [addlp setTitle:@"请选择" forState:UIControlStateNormal];
//    [addlp setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [_editview addSubview:addlp];
    
    UILabel *line2=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48, (0.68*SCREEN_WIDTH-90)/2-30, 0.5)];
    line2.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line2];
    
    UILabel *hxlab11=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48, 10, 48)];
    hxlab11.text=@"*";
    hxlab11.textColor=colorHead;
    [_editview addSubview:hxlab11];
    
    UILabel *hxlab2=[[UILabel alloc]initWithFrame:CGRectMake(40, 30+64+48+48+48, 50, 48)];
    hxlab2.text=@"户型:";
    hxlab2.font=[UIFont systemFontOfSize:18.f];
    hxlab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:hxlab2];
    
//    addhx=[[UITextField alloc]initWithFrame:CGRectMake(90, 30+64+48+48+48, (0.68*SCREEN_WIDTH-90)/2-90, 48)];
//    addhx.textColor=UIColorFromRGB(0x333333);
//    addhx.font=[UIFont systemFontOfSize:18.f];
//    addhx.placeholder=@"请输入户型";
//    addhx.textAlignment=NSTextAlignmentRight;
//    [_editview addSubview:addhx];
    
    addhx=[[UIButton alloc]initWithFrame:CGRectMake(90, 30+64+48+48+48, (0.68*SCREEN_WIDTH-90)/2-90, 48)];
    addhx.titleLabel.textColor=UIColorFromRGB(0xcccccc);
    addhx.titleLabel.font=[UIFont systemFontOfSize:18.f];
    addhx.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [addhx setTitle:@"请选择" forState:UIControlStateNormal];
     addhx.tag=1;
    [addhx addTarget:self action:@selector(addhx1:) forControlEvents:UIControlEventTouchUpInside];
    [addhx setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [_editview addSubview:addhx];
    
    UILabel *line3=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48+48, (0.68*SCREEN_WIDTH-90)/2-30, 0.5)];
    line3.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line3];
    
    UILabel *likestyle=[[UILabel alloc]initWithFrame:CGRectMake(40, 30+64+48+48+48+48, 160, 48)];
    likestyle.text=@"喜欢的装修风格:";
    likestyle.font=[UIFont systemFontOfSize:18.f];
    likestyle.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:likestyle];
    
  
    
    UILabel *line4=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-30, 0.5)];
    line4.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line4];
    
    addlikestyle=[[UITextField alloc]initWithFrame:CGRectMake(200,  30+64+48+48+48+48, (0.68*SCREEN_WIDTH-90)-200, 48)];
    addlikestyle.textColor=UIColorFromRGB(0x333333);
    addlikestyle.font=[UIFont systemFontOfSize:18.f];
    addlikestyle.placeholder=@"请输入喜欢的风格";
    addlikestyle.textAlignment=NSTextAlignmentRight;
    [_editview addSubview:addlikestyle];
    
    UILabel *fslab2=[[UILabel alloc]initWithFrame:CGRectMake(40, 30+64+48+48+48+48+48+48, 100, 48)];
    fslab2.text=@"是否信风水:";
    fslab2.font=[UIFont systemFontOfSize:18.f];
    fslab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:fslab2];
    
    fs=[[UIButton alloc]initWithFrame:CGRectMake(140, 30+64+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-140, 48)];
    fs.titleLabel.textColor=UIColorFromRGB(0xcccccc);
    fs.titleLabel.font=[UIFont systemFontOfSize:18.f];
    fs.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [fs setTitle:@"请选择" forState:UIControlStateNormal];
    [fs addTarget:self action:@selector(choosefs:) forControlEvents:UIControlEventTouchUpInside];
    [fs setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [_editview addSubview:fs];
    
    UILabel *line5=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-30, 0.5)];
    line5.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line5];
    
    UILabel *family=[[UILabel alloc]initWithFrame:CGRectMake(40, 30+64+48+48+48+48+48+48+48, 100, 48)];
    family.text=@"家庭成员:";
    family.font=[UIFont systemFontOfSize:18.f];
    family.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:family];
    
    addfamily=[[UITextField alloc]initWithFrame:CGRectMake(140, 30+64+48+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-140, 48)];
    addfamily.textColor=UIColorFromRGB(0x333333);
    addfamily.font=[UIFont systemFontOfSize:18.f];
    addfamily.placeholder=@"请输入家庭成员";
    addfamily.textAlignment=NSTextAlignmentRight;
    [_editview addSubview:addfamily];
    
    UILabel *line6=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-30, 0.5)];
    line6.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line6];
    
    
    UILabel *khlab2=[[UILabel alloc]initWithFrame:CGRectMake(40, 30+64+48+48+48+48+48+48+48+48, 80, 48)];
    khlab2.text=@"客户来源:";
    khlab2.font=[UIFont systemFontOfSize:18.f];
    khlab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:khlab2];
    
    addkh=[[UIButton alloc]initWithFrame:CGRectMake(120, 30+64+48+48+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-120, 48)];
    addkh.titleLabel.textColor=UIColorFromRGB(0xcccccc);
    addkh.titleLabel.font=[UIFont systemFontOfSize:18.f];
    addkh.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [addkh setTitle:@"请选择" forState:UIControlStateNormal];
    [addkh addTarget:self action:@selector(addkfly:) forControlEvents:UIControlEventTouchUpInside];
    [addkh setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [_editview addSubview:addkh];
    
    UILabel *line7=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-30, 0.5)];
    line7.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line7];
    
    
    UILabel *remark1=[[UILabel alloc]initWithFrame:CGRectMake(40, 30+64+48+48+48+48+48+48+48+48+48, 100, 48)];
    remark1.text=@"备注:";
    remark1.font=[UIFont systemFontOfSize:18.f];
    remark1.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:remark1];
    
    addremark=[[UITextField alloc]initWithFrame:CGRectMake(140, 30+64+48+48+48+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-140, 48)];
    addremark.textColor=UIColorFromRGB(0x333333);
    addremark.font=[UIFont systemFontOfSize:18.f];
    addremark.placeholder=@"请输入备注";
    addremark.textAlignment=NSTextAlignmentRight;
    [_editview addSubview:addremark];
    
    UILabel *line8=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48+48+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-30, 0.5)];
    line8.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line8];
    
    UIButton *add=[[UIButton alloc]initWithFrame:CGRectMake(40, 30+64+48+48+48+48+48+48+48+48+48+20+48, (0.68*SCREEN_WIDTH-90)-120, 48)];
    add.titleLabel.textColor=UIColorFromRGB(0xcccccc);
    add.titleLabel.font=[UIFont systemFontOfSize:18.f];
    [add setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [add setTitle:@"  新增户型" forState:UIControlStateNormal];
    add.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [add addTarget:self action:@selector(addnewhx) forControlEvents:UIControlEventTouchUpInside];
    [add setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [_editview addSubview:add];
    
    
    
    
    
    UILabel *sexlab21=[[UILabel alloc]initWithFrame:CGRectMake(40+(0.68*SCREEN_WIDTH-90)/2, 30+64, 50, 48)];
    sexlab21.text=@"性别:";
    sexlab21.font=[UIFont systemFontOfSize:18.f];
    sexlab21.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:sexlab21];
    
    addsex=[[UIButton alloc]initWithFrame:CGRectMake(80+(0.68*SCREEN_WIDTH-90)/2, 30+64, (0.68*SCREEN_WIDTH-90)/2-90, 48)];
    addsex.titleLabel.textColor=UIColorFromRGB(0xcccccc);
    addsex.titleLabel.font=[UIFont systemFontOfSize:18.f];
    addsex.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [addsex setTitle:@"请选择" forState:UIControlStateNormal];
    [addsex addTarget:self action:@selector(addsex:) forControlEvents:UIControlEventTouchUpInside];
    [addsex setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [_editview addSubview:addsex];
    
    UILabel *line9=[[UILabel alloc]initWithFrame:CGRectMake(30+(0.68*SCREEN_WIDTH-90)/2, 30+64+48, (0.68*SCREEN_WIDTH-90)/2-30, 0.5)];
    line9.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line9];
    
    
    UILabel *arealab11=[[UILabel alloc]initWithFrame:CGRectMake(30+(0.68*SCREEN_WIDTH-90)/2, 30+64+48+48, 10, 48)];
    arealab11.text=@"*";
    arealab11.textColor=colorHead;
    [_editview addSubview:arealab11];
    
    UILabel *arealab2=[[UILabel alloc]initWithFrame:CGRectMake(40+(0.68*SCREEN_WIDTH-90)/2,30+64+48+48, 50, 48)];
    arealab2.text=@"面积:";
    arealab2.font=[UIFont systemFontOfSize:18.f];
    arealab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:arealab2];
    
    addarea=[[UITextField alloc]initWithFrame:CGRectMake(90+(0.68*SCREEN_WIDTH-90)/2, 30+64+48+48, (0.68*SCREEN_WIDTH-90)/2-90-40, 48)];
    addarea.textColor=UIColorFromRGB(0x333333);
    addarea.font=[UIFont systemFontOfSize:18.f];
    addarea.placeholder=@"请输入面积";
    addarea.textAlignment=NSTextAlignmentRight;
    [_editview addSubview:addarea];
    
    UILabel *pflab1=[[UILabel alloc]initWithFrame:CGRectMake(90+(0.68*SCREEN_WIDTH-90)/2+(0.68*SCREEN_WIDTH-90)/2-90-30, 30+64+48+48, 30, 48)];
    pflab1.text=@"㎡";
    pflab1.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:pflab1];
    
    UILabel *line10=[[UILabel alloc]initWithFrame:CGRectMake(30+(0.68*SCREEN_WIDTH-90)/2, 30+64+48+48+48, (0.68*SCREEN_WIDTH-90)/2-30, 0.5)];
    line10.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line10];
    
    
    UILabel *hxhlab1=[[UILabel alloc]initWithFrame:CGRectMake(30+(0.68*SCREEN_WIDTH-90)/2, 30+64+48+48+48, 10, 48)];
    hxhlab1.text=@"*";
    hxhlab1.textColor=colorHead;
    [_editview addSubview:hxhlab1];
    
    UILabel *hxhlab2=[[UILabel alloc]initWithFrame:CGRectMake(40+(0.68*SCREEN_WIDTH-90)/2,30+64+48+48+48, 60+48, 48)];
    hxhlab2.text=@"户型号:";
    hxhlab2.font=[UIFont systemFontOfSize:18.f];
    hxhlab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:hxhlab2];
    
    addhxh=[[UITextField alloc]initWithFrame:CGRectMake(120+(0.68*SCREEN_WIDTH-90)/2, 30+64+48+48+48, (0.68*SCREEN_WIDTH-90)/2-120, 48)];
    addhxh.textColor=UIColorFromRGB(0x333333);
    addhxh.font=[UIFont systemFontOfSize:18.f];
    addhxh.placeholder=@"请输入户型号";
    addhxh.textAlignment=NSTextAlignmentRight;
    [_editview addSubview:addhxh];
    
    UILabel *line11=[[UILabel alloc]initWithFrame:CGRectMake(30+(0.68*SCREEN_WIDTH-90)/2, 30+64+48+48+48+48, (0.68*SCREEN_WIDTH-90)/2-30, 0.5)];
    line11.backgroundColor=UIColorFromRGB(0x333333);
    [_editview addSubview:line11];
    
    UILabel *stylehlab2=[[UILabel alloc]initWithFrame:CGRectMake(40,30+64+48+48+48+48+48, 120, 48)];
    stylehlab2.text=@"拟装修风格:";
    stylehlab2.font=[UIFont systemFontOfSize:18.f];
    stylehlab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:stylehlab2];
    
    
    
    addstyle=[[UITextField alloc]initWithFrame:CGRectMake(160, 30+64+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-160, 48)];
    addstyle.textColor=UIColorFromRGB(0x333333);
    addstyle.font=[UIFont systemFontOfSize:18.f];
    addstyle.placeholder=@"请输入喜欢的风格";
    addstyle.textAlignment=NSTextAlignmentRight;
    [_editview addSubview:addstyle];
    
    
    UILabel *line12=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-30, 0.5)];
    line12.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line12];
    
    
    
    
    
    
    
}
- (void)add
{

    if([self isBlankString:addname.text])
    {
        [[HudHelper hudHepler] showTips:self.view tips:@"姓名不能为空"];
    }else if([self isBlankString:addarea.text])
    {
        [[HudHelper hudHepler] showTips:self.view tips:@"面积不能为空"];
    }else if([self isBlankString:addphone.text])
    {
        [[HudHelper hudHepler] showTips:self.view tips:@"手机号码不能为空"];
    }else if([self isBlankString:addlp.text])
    {
        [[HudHelper hudHepler] showTips:self.view tips:@"楼盘不能为空"];
    }else if([self isBlankString:basic_room_id])
    {
        [[HudHelper hudHepler] showTips:self.view tips:@"户型不能为空"];
    }else if([self isBlankString:addhxh.text])
    {
        [[HudHelper hudHepler] showTips:self.view tips:@"户型号不能为空"];
    }else{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_user_id forKey:@"user_id"];
    [params setValue:addname.text forKey:@"nickname"];
    [params setValue:addphone.text forKey:@"mobile"];
    [params setValue:addarea.text forKey:@"areas"];
    [params setValue:gender forKey:@"gender"];
    [params setValue:addlp.text forKey:@"room_name"];
    [params setValue:addhxh.text forKey:@"house_type"];
    [params setValue:basic_room_id forKey:@"basic_room_id"];
    [params setValue:addlikestyle.text forKey:@"like_move_style"];
    [params setValue:addstyle.text forKey:@"like_fixed"];
    [params setValue:is_belief_fs forKey:@"is_belief_fs"];
    [params setValue:addfamily.text forKey:@"home_member"];
    [params setValue:client_source forKey:@"client_source"];
    [params setValue:addremark.text forKey:@"remark"];
    [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"sale-staff/create" andParams:params andSuccess:^(NSDictionary *successData) {
        //加载圈圈(显示)
//        [self getuserlist1];
        if ([[successData objectForKey:@"api_code"] integerValue]==200&&[[successData objectForKey:@"status"] integerValue]==1) {
            [self getuserlist1];
            if(_editview)
            {
                [_editview removeFromSuperview];
            }
            NSDictionary *dic=[[NSDictionary alloc]init];
            dic=[successData objectForKey:@"user_info"];
            [_headimg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] forState:UIControlStateNormal];
            if (![self isBlankString:[dic objectForKey:@"avatar"]]) {
                [_headimg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] forState:UIControlStateNormal];
                _name.text=[dic objectForKey:@"nickname"];
            }else if(_userlistdate.count>0){
                [_headimg setTitle: [[dic objectForKey:@"nickname"] substringToIndex:1]forState:UIControlStateNormal];
                _name.text=[dic objectForKey:@"nickname"];
            }else{
                [_headimg setTitle:@"A" forState:UIControlStateNormal];
            }
            

            nowuser_id=[dic objectForKey:@"id"];
            _name.text=[dic objectForKey:@"nickname"];
            gender=[dic objectForKey:@"gender"];
            basic_room_id=[dic objectForKey:@"basic_room_id"];
            is_belief_fs=[dic objectForKey:@"is_belief_fs"];
            client_source=[dic objectForKey:@"client_source"];
            if ([[dic objectForKey:@"gender"] integerValue]==0) {
                sex=@"女";
            }else{
                sex=@"男";
            }
            mobile=[dic objectForKey:@"mobile"];
            
            lplab1.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"room_name"]];
            hxlab1.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"house_type"]];
            hxlab3.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"basic_room_name"]];
            arealab1.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"areas"]];
            stylelab1.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"like_move_style"]];
            stylelab3.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"like_fixed"]];
            
            if([is_belief_fs integerValue]==1)
            {
                stylelab5.text=@"是";
            }else{
                stylelab5.text=@"否";
            }
            familylab1.text=[dic objectForKey:@"home_member"];
            kflab1.text=[dic objectForKey:@"client_source"];
            if ([[dic objectForKey:@"order_statues"] integerValue]==0) {
                orderlab1.text=@"未成交";
            }else if([[dic objectForKey:@"order_statues"] integerValue]==1)
            {
                orderlab1.text=@"方案阶段";
            }else{
                orderlab1.text=@"以成交";
            }
            remarklab1.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"remark"]];
            
        }
        else if([[successData objectForKey:@"status"] integerValue]==0){
            [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
        }
        else{
            [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"error"]];
        }
    } andError:^(NSError *error) {
        //加载圈圈(显示)
        [[HudHelper hudHepler] HideHUDAlert:self.view];
        NSLog(@"%@",error);
        if ([[MickeyTools getErrorStringWithError:error] isEqualToString:@"登陆信息过期,需要重新登陆"]) {
            
        }else{
            [[HudHelper hudHepler] showTips:self.view tips:[MickeyTools getErrorStringWithError:error] ] ;
            
        }
    }];
    
    }
}
- (void)updateuser
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:nowuser_id forKey:@"user_id"];
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"sale-staff/users" andParams:params andSuccess:^(NSDictionary *successData) {
        //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200&&[[successData objectForKey:@"status"] integerValue]==1) {
            NSDictionary *dic=[[NSDictionary alloc]init];
            dic=[successData objectForKey:@"user_info"];
            [_headimg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] forState:UIControlStateNormal];
            nowuser_id=[dic objectForKey:@"id"];
            _name.text=[dic objectForKey:@"nickname"];
            gender=[dic objectForKey:@"gender"];
            basic_room_id=[dic objectForKey:@"basic_room_id"];
            
            is_belief_fs=[dic objectForKey:@"is_belief_fs"];
            client_source=[dic objectForKey:@"client_source"];
            if ([[dic objectForKey:@"gender"] integerValue]==0) {
                sex=@"女";
            }else{
                sex=@"男";
            }
            mobile=[dic objectForKey:@"mobile"];
            
            lplab1.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"room_name"]];
            hxlab1.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"house_type"]];
            hxlab3.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"basic_room_name"]];
            arealab1.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"areas"]];
            stylelab1.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"like_move_style"]];
            stylelab3.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"like_fixed"]];
            
            if([is_belief_fs integerValue]==1)
            {
                stylelab5.text=@"是";
            }else{
                stylelab5.text=@"否";
            }
            familylab1.text=[dic objectForKey:@"home_member"];
            kflab1.text=[dic objectForKey:@"client_source"];
            if ([[dic objectForKey:@"order_statues"] integerValue]==0) {
                orderlab1.text=@"未成交";
            }else if([[dic objectForKey:@"order_statues"] integerValue]==1)
            {
                orderlab1.text=@"方案阶段";
            }else{
                orderlab1.text=@"以成交";
            }
            remarklab1.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"remark"]];

        }
        else if([[successData objectForKey:@"status"] integerValue]==0){
            [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
        }
        else{
            [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"error"]];
        }
    } andError:^(NSError *error) {
        //加载圈圈(显示)
        [[HudHelper hudHepler] HideHUDAlert:self.view];
        NSLog(@"%@",error);
        if ([[MickeyTools getErrorStringWithError:error] isEqualToString:@"登陆信息过期,需要重新登陆"]) {
            
        }else{
            [[HudHelper hudHepler] showTips:self.view tips:[MickeyTools getErrorStringWithError:error] ] ;
            
        }
    }];
    

}
- (void)ok
{
    
//    UITextField *nametifd;
//    UITextField *areatifd;
//    UITextField *phonelab3;
//    UITextField *lp3;
//    UITextField *hxhtifd;
//    UITextField *likestyletifd;
//    UITextField *stylelabtifd;
//    UITextField *familytifd;
//    UITextField *remarktifd;
    if([self isBlankString:nametifd.text])
    {
        [[HudHelper hudHepler] showTips:self.view tips:@"姓名不能为空"];
    }else if([self isBlankString:areatifd.text])
    {
         [[HudHelper hudHepler] showTips:self.view tips:@"面积不能为空"];
    }else if([self isBlankString:phonelab3.text])
    {
        [[HudHelper hudHepler] showTips:self.view tips:@"手机号码不能为空"];
    }else if([self isBlankString:lp3.text])
    {
        [[HudHelper hudHepler] showTips:self.view tips:@"楼盘不能为空"];
    }else if([self isBlankString:basic_room_id])
    {
        [[HudHelper hudHepler] showTips:self.view tips:@"户型不能为空"];
    }else if([self isBlankString:hxhtifd.text])
    {
        [[HudHelper hudHepler] showTips:self.view tips:@"户型号不能为空"];
    }else{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:nowuser_id forKey:@"user_id"];
    [params setValue:nametifd.text forKey:@"nickname"];
    [params setValue:areatifd.text forKey:@"areas"];
    [params setValue:gender forKey:@"gender"];
    [params setValue:phonelab3.text forKey:@"mobile"];
    [params setValue:lp3.text forKey:@"room_name"];
    [params setValue:basic_room_id forKey:@"basic_room_id"];
    [params setValue:hxhtifd.text forKey:@"house_type"];
    [params setValue:likestyletifd.text forKey:@"like_move_style"];
    [params setValue:stylelabtifd.text forKey:@"like_fixed"];
    [params setValue:is_belief_fs forKey:@"is_belief_fs"];
    [params setValue:familytifd.text forKey:@"home_member"];
    [params setValue:remarktifd.text forKey:@"remark"];
    [params setValue:client_source forKey:@"client_source"];
    [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"sale-staff/update" andParams:params andSuccess:^(NSDictionary *successData) {
        //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200&&[[successData objectForKey:@"status"] integerValue]==1) {
            if(_editview)
            {
                [_editview removeFromSuperview];
            }
            [self updateuser];
        }
        else if([[successData objectForKey:@"status"] integerValue]==0){
            [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
        }
        else{
            [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"error"]];
        }
     } andError:^(NSError *error) {
        //加载圈圈(显示)
        [[HudHelper hudHepler] HideHUDAlert:self.view];
        NSLog(@"%@",error);
        if ([[MickeyTools getErrorStringWithError:error] isEqualToString:@"登陆信息过期,需要重新登陆"]) {
            
        }else{
            [[HudHelper hudHepler] showTips:self.view tips:[MickeyTools getErrorStringWithError:error] ] ;
            
        }
    }];
    }
    
    
}
- (void)cancal
{
    if(_editview)
    {
        [_editview removeFromSuperview];
    }
}
- (void)searchResult: (UISearchController *)searchController {
    NSPredicate *precidate = [NSPredicate predicateWithFormat:@"displayName CONTAINS[cd] %@", searchController.searchBar.text];
    
}

- (IBAction)editclick:(UIButton *)sender {
    if (_editview) {
        [_editview removeFromSuperview];
    }
    _editview=[[UIView alloc]initWithFrame:CGRectMake(0.38*SCREEN_WIDTH, 0, 0.62*SCREEN_WIDTH, SCREEN_HEIGHT)];
    _editview.backgroundColor=UIColorFromRGB(0xFAFAFF);
    [self.view addSubview:_editview];
    
    UIButton *cancalbtn=[[UIButton alloc]initWithFrame:CGRectMake(30, 30, 60, 20)];
    [cancalbtn setTitleColor:UIColorFromRGB(0xc90920) forState:UIControlStateNormal];
    [cancalbtn setTitle:@"取消" forState:UIControlStateNormal];
    cancalbtn.titleLabel.font=[UIFont systemFontOfSize:18.f];
    [cancalbtn addTarget:self action:@selector(cancal) forControlEvents:UIControlEventTouchUpInside];
    [_editview addSubview:cancalbtn];
    
    UIButton *okbtn=[[UIButton alloc]initWithFrame:CGRectMake(0.62*SCREEN_WIDTH-30-60, 30, 60, 20)];
    [okbtn setTitleColor:UIColorFromRGB(0xc90920) forState:UIControlStateNormal];
    [okbtn setTitle:@"完成" forState:UIControlStateNormal];
    okbtn.titleLabel.font=[UIFont systemFontOfSize:18.f];
    [okbtn addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
    [_editview addSubview:okbtn];
    
    UILabel *nanelab1=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64, 10, 48)];
    nanelab1.text=@"*";
    nanelab1.textColor=colorHead;
    [_editview addSubview:nanelab1];
    
    UILabel *nanelab2=[[UILabel alloc]initWithFrame:CGRectMake(40, 30+64, 50, 48)];
    nanelab2.text=@"姓名:";
    nanelab2.font=[UIFont systemFontOfSize:18.f];
    nanelab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:nanelab2];
    
    nametifd=[[UITextField alloc]initWithFrame:CGRectMake(90, 30+64, (0.68*SCREEN_WIDTH-90)/2-90, 48)];
    nametifd.textColor=UIColorFromRGB(0x333333);
    nametifd.font=[UIFont systemFontOfSize:18.f];
    nametifd.placeholder=@"请输入姓名";
    nametifd.text=_name.text;
    nametifd.textAlignment=NSTextAlignmentRight;
    [_editview addSubview:nametifd];
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48, (0.68*SCREEN_WIDTH-90)/2-30, 0.5)];
    line.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line];
    
    
    
    UILabel *phonelab1=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48, 10, 48)];
    phonelab1.text=@"*";
    phonelab1.textColor=colorHead;
    [_editview addSubview:phonelab1];
    
    UILabel *phonelab2=[[UILabel alloc]initWithFrame:CGRectMake(40, 30+64+48, 80, 48)];
    phonelab2.text=@"电话号码:";
    phonelab2.font=[UIFont systemFontOfSize:18.f];
    phonelab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:phonelab2];
    
    phonelab3=[[UITextField alloc]initWithFrame:CGRectMake(120, 30+64+48, (0.68*SCREEN_WIDTH-90)-120, 48)];
    phonelab3.textColor=UIColorFromRGB(0x333333);
    phonelab3.font=[UIFont systemFontOfSize:18.f];
    phonelab3.placeholder=@"请输入电话号码";
    phonelab3.text=mobile;
    phonelab3.textAlignment=NSTextAlignmentRight;
    [_editview addSubview:phonelab3];
    
    UILabel *line1=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48, (0.68*SCREEN_WIDTH-90)-30, 0.5)];
    line1.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line1];
    
    UILabel *lplab11=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48, 10, 48)];
    lplab11.text=@"*";
    lplab11.textColor=colorHead;
    [_editview addSubview:lplab11];
    
    UILabel *lplab2=[[UILabel alloc]initWithFrame:CGRectMake(40, 30+64+48+48, 50, 48)];
    lplab2.text=@"楼盘:";
    lplab2.font=[UIFont systemFontOfSize:18.f];
    lplab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:lplab2];
    
    
    lp3=[[UITextField alloc]initWithFrame:CGRectMake(90, 30+64+48+48, (0.68*SCREEN_WIDTH-90)/2-90, 48)];
    lp3.textColor=UIColorFromRGB(0x333333);
    lp3.font=[UIFont systemFontOfSize:18.f];
    lp3.placeholder=@"请输入楼盘";
    lp3.text=lplab1.text;
    lp3.textAlignment=NSTextAlignmentRight;
    [_editview addSubview:lp3];

    
    UILabel *line2=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48, (0.68*SCREEN_WIDTH-90)/2-30, 0.5)];
    line2.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line2];
    
    UILabel *hxlab11=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48, 10, 48)];
    hxlab11.text=@"*";
    hxlab11.textColor=colorHead;
    [_editview addSubview:hxlab11];
    
    UILabel *hxlab2=[[UILabel alloc]initWithFrame:CGRectMake(40, 30+64+48+48+48, 50, 48)];
    hxlab2.text=@"户型:";
    hxlab2.font=[UIFont systemFontOfSize:18.f];
    hxlab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:hxlab2];
    
    
    hx3=[[UIButton alloc]initWithFrame:CGRectMake(90, 30+64+48+48+48, (0.68*SCREEN_WIDTH-90)/2-90, 48)];
    hx3.titleLabel.textColor=UIColorFromRGB(0x333333);
    hx3.titleLabel.font=[UIFont systemFontOfSize:18.f];
    hx3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [hx3 setTitle:hxlab3.text forState:UIControlStateNormal];
    [hx3 setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
     hx3.tag=2;
    [hx3 addTarget:self action:@selector(addhx1:) forControlEvents:UIControlEventTouchUpInside];
    [_editview addSubview:hx3];
    
    UILabel *line3=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48+48, (0.68*SCREEN_WIDTH-90)/2-30, 0.5)];
    line3.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line3];
    
    UILabel *likestyle=[[UILabel alloc]initWithFrame:CGRectMake(40, 30+64+48+48+48+48, 160, 48)];
    likestyle.text=@"喜欢的装修风格:";
    likestyle.font=[UIFont systemFontOfSize:18.f];
    likestyle.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:likestyle];
    

    
    UILabel *line4=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-30, 0.5)];
    line4.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line4];
        likestyletifd=[[UITextField alloc]initWithFrame:CGRectMake(200,  30+64+48+48+48+48, (0.68*SCREEN_WIDTH-90)-200, 48)];
        likestyletifd.textColor=UIColorFromRGB(0x333333);
        likestyletifd.font=[UIFont systemFontOfSize:18.f];
        likestyletifd.placeholder=stylelab1.text;
    
    likestyletifd.text=stylelab1.text;
        likestyletifd.textAlignment=NSTextAlignmentRight;
        [_editview addSubview:likestyletifd];
    
    UILabel *fslab2=[[UILabel alloc]initWithFrame:CGRectMake(40, 30+64+48+48+48+48+48+48, 100, 48)];
    fslab2.text=@"是否信风水:";
    fslab2.font=[UIFont systemFontOfSize:18.f];
    fslab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:fslab2];
    
    fs3=[[UIButton alloc]initWithFrame:CGRectMake(140, 30+64+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-140, 48)];
    fs3.titleLabel.textColor=UIColorFromRGB(0xcccccc);
    fs3.titleLabel.font=[UIFont systemFontOfSize:18.f];
    [fs3 addTarget:self action:@selector(chooselikefs:) forControlEvents:UIControlEventTouchUpInside];
    fs3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [fs3 setTitle:stylelab5.text forState:UIControlStateNormal];
    
    [fs3 setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [_editview addSubview:fs3];
    
    UILabel *line5=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-30, 0.5)];
    line5.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line5];
    
    UILabel *family=[[UILabel alloc]initWithFrame:CGRectMake(40, 30+64+48+48+48+48+48+48+48, 100, 48)];
    family.text=@"家庭成员:";
    family.font=[UIFont systemFontOfSize:18.f];
    family.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:family];
    
    familytifd=[[UITextField alloc]initWithFrame:CGRectMake(140, 30+64+48+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-140, 48)];
    familytifd.textColor=UIColorFromRGB(0x333333);
    familytifd.font=[UIFont systemFontOfSize:18.f];
    familytifd.placeholder=@"请输入家庭成员";
    familytifd.text=familylab1.text;
    familytifd.textAlignment=NSTextAlignmentRight;
    [_editview addSubview:familytifd];
    
    UILabel *line6=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-30, 0.5)];
    line6.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line6];
    
    
    UILabel *khlab2=[[UILabel alloc]initWithFrame:CGRectMake(40, 30+64+48+48+48+48+48+48+48+48, 80, 48)];
    khlab2.text=@"客户来源:";
    khlab2.font=[UIFont systemFontOfSize:18.f];
    khlab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:khlab2];
    
    kh3=[[UIButton alloc]initWithFrame:CGRectMake(120, 30+64+48+48+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-120, 48)];
    kh3.titleLabel.textColor=UIColorFromRGB(0xcccccc);
    kh3.titleLabel.font=[UIFont systemFontOfSize:18.f];
    kh3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [kh3 setTitle:kflab1.text forState:UIControlStateNormal];
    [kh3 addTarget:self action:@selector(khly:) forControlEvents:UIControlEventTouchUpInside];
    [kh3 setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [_editview addSubview:kh3];
    
    UILabel *line7=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-30, 0.5)];
    line7.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line7];
    
    
    UILabel *remark1=[[UILabel alloc]initWithFrame:CGRectMake(40, 30+64+48+48+48+48+48+48+48+48+48, 100, 48)];
    remark1.text=@"备注:";
    remark1.font=[UIFont systemFontOfSize:18.f];
    remark1.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:remark1];
    
    remarktifd=[[UITextField alloc]initWithFrame:CGRectMake(140, 30+64+48+48+48+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-140, 48)];
    remarktifd.textColor=UIColorFromRGB(0x333333);
    remarktifd.font=[UIFont systemFontOfSize:18.f];
    remarktifd.placeholder=@"请输入备注";
    remarktifd.text=remarklab1.text;
    remarktifd.textAlignment=NSTextAlignmentRight;
    [_editview addSubview:remarktifd];
    
    UILabel *line8=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48+48+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-30, 0.5)];
    line8.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line8];
    
    UIButton *add=[[UIButton alloc]initWithFrame:CGRectMake(40, 30+64+48+48+48+48+48+48+48+48+48+20+48, (0.68*SCREEN_WIDTH-90)-120, 48)];
    add.titleLabel.textColor=UIColorFromRGB(0xcccccc);
    add.titleLabel.font=[UIFont systemFontOfSize:18.f];
    [add setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [add setTitle:@"  新增户型" forState:UIControlStateNormal];
    add.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [add addTarget:self action:@selector(addnewhx) forControlEvents:UIControlEventTouchUpInside];
    [add setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [_editview addSubview:add];
    
    
    
    

    sexlab2=[[UILabel alloc]initWithFrame:CGRectMake(40+(0.68*SCREEN_WIDTH-90)/2, 30+64, 50, 48)];
    sexlab2.text=@"性别:";
    sexlab2.font=[UIFont systemFontOfSize:18.f];
    sexlab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:sexlab2];
    
    sexlab3=[[UIButton alloc]initWithFrame:CGRectMake(80+(0.68*SCREEN_WIDTH-90)/2, 30+64, (0.68*SCREEN_WIDTH-90)/2-90, 48)];
    sexlab3.titleLabel.textColor=UIColorFromRGB(0xcccccc);
    sexlab3.titleLabel.font=[UIFont systemFontOfSize:18.f];
    sexlab3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [sexlab3 setTitle:sex forState:UIControlStateNormal];
    [sexlab3 setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [sexlab3 addTarget:self action:@selector(choosesex:) forControlEvents:UIControlEventTouchUpInside];
    [_editview addSubview:sexlab3];
    
    UILabel *line9=[[UILabel alloc]initWithFrame:CGRectMake(30+(0.68*SCREEN_WIDTH-90)/2, 30+64+48, (0.68*SCREEN_WIDTH-90)/2-30, 0.5)];
    line9.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line9];
    
    
    UILabel *arealab11=[[UILabel alloc]initWithFrame:CGRectMake(30+(0.68*SCREEN_WIDTH-90)/2, 30+64+48+48, 10, 48)];
    arealab11.text=@"*";
    arealab11.textColor=colorHead;
    [_editview addSubview:arealab11];
    
    UILabel *arealab2=[[UILabel alloc]initWithFrame:CGRectMake(40+(0.68*SCREEN_WIDTH-90)/2,30+64+48+48, 50, 48)];
    arealab2.text=@"面积:";
    arealab2.font=[UIFont systemFontOfSize:18.f];
    arealab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:arealab2];
    
    areatifd=[[UITextField alloc]initWithFrame:CGRectMake(90+(0.68*SCREEN_WIDTH-90)/2, 30+64+48+48, (0.68*SCREEN_WIDTH-90)/2-90-40, 48)];
    areatifd.textColor=UIColorFromRGB(0x333333);
    areatifd.font=[UIFont systemFontOfSize:18.f];
    areatifd.placeholder=@"请输入面积";
    areatifd.text=arealab1.text;
    areatifd.textAlignment=NSTextAlignmentRight;
    [_editview addSubview:areatifd];
    
    UILabel *pflab1=[[UILabel alloc]initWithFrame:CGRectMake(90+(0.68*SCREEN_WIDTH-90)/2+(0.68*SCREEN_WIDTH-90)/2-90-30, 30+64+48+48, 30, 48)];
    pflab1.text=@"㎡";
    pflab1.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:pflab1];
    
    UILabel *line10=[[UILabel alloc]initWithFrame:CGRectMake(30+(0.68*SCREEN_WIDTH-90)/2, 30+64+48+48+48, (0.68*SCREEN_WIDTH-90)/2-30, 0.5)];
    line10.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line10];
    
    
    UILabel *hxhlab1=[[UILabel alloc]initWithFrame:CGRectMake(30+(0.68*SCREEN_WIDTH-90)/2, 30+64+48+48+48, 10, 48)];
    hxhlab1.text=@"*";
    hxhlab1.textColor=colorHead;
    [_editview addSubview:hxhlab1];
    
    UILabel *hxhlab2=[[UILabel alloc]initWithFrame:CGRectMake(40+(0.68*SCREEN_WIDTH-90)/2,30+64+48+48+48, 60+48, 48)];
    hxhlab2.text=@"户型号:";
    hxhlab2.font=[UIFont systemFontOfSize:18.f];
    hxhlab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:hxhlab2];
    
    hxhtifd=[[UITextField alloc]initWithFrame:CGRectMake(120+(0.68*SCREEN_WIDTH-90)/2, 30+64+48+48+48, (0.68*SCREEN_WIDTH-90)/2-120, 48)];
    hxhtifd.textColor=UIColorFromRGB(0x333333);
    hxhtifd.font=[UIFont systemFontOfSize:18.f];
    hxhtifd.placeholder=@"请选择";
    hxhtifd.text=hxlab1.text;
    hxhtifd.textAlignment=NSTextAlignmentRight;
    [_editview addSubview:hxhtifd];
    
    UILabel *line11=[[UILabel alloc]initWithFrame:CGRectMake(30+(0.68*SCREEN_WIDTH-90)/2, 30+64+48+48+48+48, (0.68*SCREEN_WIDTH-90)/2-30, 0.5)];
    line11.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line11];
    
    UILabel *stylehlab2=[[UILabel alloc]initWithFrame:CGRectMake(40,30+64+48+48+48+48+48, 120, 48)];
    stylehlab2.text=@"拟装修风格:";
    stylehlab2.font=[UIFont systemFontOfSize:18.f];
    stylehlab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:stylehlab2];
    
    
    
    stylelabtifd=[[UITextField alloc]initWithFrame:CGRectMake(160, 30+64+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-160, 48)];
    stylelabtifd.textColor=UIColorFromRGB(0x333333);
    stylelabtifd.font=[UIFont systemFontOfSize:18.f];
    stylelabtifd.placeholder=@"请输入喜欢的风格";
    stylelabtifd.text=stylelab3.text;
    stylelabtifd.textAlignment=NSTextAlignmentRight;
    [_editview addSubview:stylelabtifd];
    
    UILabel *line12=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-30, 0.5)];
    line12.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line12];

}
- (void)addnewhx
{
    _addnewhxview.hidden=NO;
    _backview.hidden=NO;
    _inputhx.text=@"";
    [self.view bringSubviewToFront:_backview];
    [self.view bringSubviewToFront:_addnewhxview];
}
- (void)addsex:(UIButton *)btn
{
    [self.view endEditing:YES];
    //实现和UIActionSheet相同的效果
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"请选择性别" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        nil;
    }];
    UIAlertAction* firstAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        gender=@"0";
        [addsex setTitle:@"女" forState:UIControlStateNormal];
       
        
    }];
    UIAlertAction* secondAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        gender=@"1";
        [addsex setTitle:@"男" forState:UIControlStateNormal];
       
        
    }];
    [alert addAction:cancelAction];
    [alert addAction:firstAction];
    [alert addAction:secondAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    UIPopoverPresentationController *popover = alert.popoverPresentationController;
    
    if (popover) {
        
        
          popover.sourceView = btn;
          popover.sourceRect = btn.bounds;
          popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }

}
- (void)choosesex:(UIButton *)btn
{
    [self.view endEditing:YES];
    //实现和UIActionSheet相同的效果
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"请选择性别" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        nil;
    }];
    UIAlertAction* firstAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        gender=@"0";
        [sexlab3 setTitle:@"女" forState:UIControlStateNormal];
      
    }];
    UIAlertAction* secondAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        gender=@"1";
        [sexlab3 setTitle:@"男" forState:UIControlStateNormal];
       
    }];
    [alert addAction:cancelAction];
    [alert addAction:firstAction];
    [alert addAction:secondAction];
    [self presentViewController:alert animated:YES completion:^{
    
    }];
    UIPopoverPresentationController *popover = alert.popoverPresentationController;
    
    if (popover) {
        
        
        popover.sourceView = btn;
        popover.sourceRect = btn.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }


}
- (void)addkfly:(UIButton *)btn
{
    [self.view endEditing:YES];
    //实现和UIActionSheet相同的效果
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"客户来源" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        nil;
    }];
    UIAlertAction* firstAction = [UIAlertAction actionWithTitle:@"网络查找" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [addkh setTitle:@"网络查找" forState:UIControlStateNormal];
        client_source=@"网络查找";
    }];
    UIAlertAction* secondAction = [UIAlertAction actionWithTitle:@"朋友介绍" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [addkh setTitle:@"朋友介绍" forState:UIControlStateNormal];
        client_source=@"朋友介绍";
    }];
    [alert addAction:cancelAction];
    [alert addAction:firstAction];
    [alert addAction:secondAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    UIPopoverPresentationController *popover = alert.popoverPresentationController;
    
    if (popover) {
        
        
        popover.sourceView = btn;
        popover.sourceRect = btn.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }

}
- (void)khly:(UIButton *)btn
{
    [self.view endEditing:YES];
    //实现和UIActionSheet相同的效果
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"客户来源" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        nil;
    }];
    UIAlertAction* firstAction = [UIAlertAction actionWithTitle:@"网络查找" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [kh3 setTitle:@"网络查找" forState:UIControlStateNormal];
        client_source=@"网络查找";
    }];
    UIAlertAction* secondAction = [UIAlertAction actionWithTitle:@"朋友介绍" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [kh3 setTitle:@"朋友介绍" forState:UIControlStateNormal];
        client_source=@"朋友介绍";
    }];
    [alert addAction:cancelAction];
    [alert addAction:firstAction];
    [alert addAction:secondAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    UIPopoverPresentationController *popover = alert.popoverPresentationController;
    
    if (popover) {
        
        
        popover.sourceView = btn;
        popover.sourceRect = btn.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }

}
- (void)choosefs:(UIButton *)btn
{
    [self.view endEditing:YES];
    //实现和UIActionSheet相同的效果
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"是否喜欢风水" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        nil;
    }];
    UIAlertAction* firstAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [fs setTitle:@"是" forState:UIControlStateNormal];
         is_belief_fs=@"1";
    }];
    UIAlertAction* secondAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [fs setTitle:@"否" forState:UIControlStateNormal];
         is_belief_fs=@"0";
    }];
    [alert addAction:cancelAction];
    [alert addAction:firstAction];
    [alert addAction:secondAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    UIPopoverPresentationController *popover = alert.popoverPresentationController;
    
    if (popover) {
        
        
        popover.sourceView = btn;
        popover.sourceRect = btn.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }

}
- (void)chooselikefs:(UIButton *)btn
{
    [self.view endEditing:YES];
    //实现和UIActionSheet相同的效果
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"是否喜欢风水" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        nil;
    }];
    UIAlertAction* firstAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     [fs3 setTitle:@"是" forState:UIControlStateNormal];
      is_belief_fs=@"1";
    }];
    UIAlertAction* secondAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     [fs3 setTitle:@"否" forState:UIControlStateNormal];
      is_belief_fs=@"0";
    }];
    [alert addAction:cancelAction];
    [alert addAction:firstAction];
    [alert addAction:secondAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    UIPopoverPresentationController *popover = alert.popoverPresentationController;
    
    if (popover) {
        
        
        popover.sourceView = btn;
        popover.sourceRect = btn.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
}
- (IBAction)cancal:(UIButton *)sender {
    _hxview.hidden=YES;
    _backview.hidden=YES;
}
- (IBAction)makeok:(UIButton *)sender {
    _hxview.hidden=YES;
    _backview.hidden=YES;
    hxlab3.text=basec_name;
    [addhx setTitle:basec_name forState:UIControlStateNormal];
    [hx3 setTitle:basec_name forState:UIControlStateNormal];
     _inputhx.text=basec_name;

    
}
-(void)addhx1:(UIButton *)btn
{
    _hxview.hidden=NO;
    _backview.hidden=NO;
    [self.view bringSubviewToFront:_backview];
    [self.view bringSubviewToFront:_hxview];
//    if (btn.tag==1) {
//        [addhx setTitle:basec_name forState:UIControlStateNormal];
//    }else{
//        [hx3 setTitle:basec_name forState:UIControlStateNormal];
//    }

}
- (IBAction)choosenewhx:(id)sender {
    _hxview.hidden=NO;
    _backview.hidden=NO;
    [self.view bringSubviewToFront:_backview];
    [self.view bringSubviewToFront:_hxview];
//    _inputhx.text=basec_name;
}


- (IBAction)addnewhxclick:(UIButton *)sender {
   
    _backview.hidden=NO;
    if([self isBlankString:_inputlp.text])
    {
        [[HudHelper hudHepler] showTips:self.view tips:@"楼盘不能为空"];
    }else if([self isBlankString:basic_room_id])
    {
        [[HudHelper hudHepler] showTips:self.view tips:@"户型不能为空"];
    }else if([self isBlankString:_inputhxh.text])
    {
        [[HudHelper hudHepler] showTips:self.view tips:@"户型号不能为空"];
    }else if([self isBlankString:_inputarea.text])
    {
        [[HudHelper hudHepler] showTips:self.view tips:@"面积不能为空"];
    }
    else{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:nowuser_id forKey:@"user_id"];
    [params setValue:_inputlp forKey:@"room_name"];
    [params setValue:_inputhxh forKey:@"house_type"];
    [params setValue:_inputarea forKey:@"areas"];
    [params setValue:basic_room_id forKey:@"basic_room_id"];
    [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"sale-staff/new-add" andParams:nil andSuccess:^(NSDictionary *successData) {
       
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
           
            _addnewhxview.hidden=YES;
            _backview.hidden=YES;
        }
        else if([[successData objectForKey:@"status"] integerValue]==0){
            [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
        }
        else{
            [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"error"]];
        }
        
        
    } andError:^(NSError *error) {
        //加载圈圈(显示)
        [[HudHelper hudHepler] HideHUDAlert:self.view];
        NSLog(@"%@",error);
        if ([[MickeyTools getErrorStringWithError:error] isEqualToString:@"登陆信息过期,需要重新登陆"]) {
            
        }else{
            [[HudHelper hudHepler] showTips:self.view tips:[MickeyTools getErrorStringWithError:error] ] ;
            
        }
    }];
    }
}

- (IBAction)hxcancal:(UIButton *)sender {
    _addnewhxview.hidden=YES;
    _backview.hidden=YES;
}
@end
