//
//  PaySuccessViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/4/12.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "SWRevealViewController.h"
#import <CoreText/CoreText.h>
#import "MyOrderViewController.h"
#import "RootHttpHelper.h"
#import "HttpHelper.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "NewLoginViewController.h"

@interface PaySuccessViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
{
    SWRevealViewController *revealController;
    UIView  *editView;
    
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
    UIButton *chooseBtn;
    UIView *goodsView;
    UITextField  *name;
    UITextField  *phone;
    UITextField  *detail;
}
@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;
@property (strong, nonatomic) UIPickerView *pickerView;
@end

@implementation PaySuccessViewController

@synthesize
pickerView;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=UIColorFromRGB(0xffffff);
    self.title=@"订单支付成功";
    
    [self addNoticeForKeyboard];
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    self.returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    
    
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
    
    //
    
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    
    _successLab.textColor=UIColorFromRGB(0x333333);
    _payMoney.textColor=UIColorFromRGB(0x333333);
    _payMoney.text=[NSString stringWithFormat:@"支付金额:¥%@",_money];
//    _payMoney.textColor=colorHead;
    _orderNum.textColor=UIColorFromRGB(0x333333);
    _orderNum.text=[NSString stringWithFormat:@"订单编号:%@",_sn];
    
    _lookBtn.layer.masksToBounds=YES;
    _lookBtn.layer.cornerRadius=5;
    [_lookBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [_lookBtn.layer setBorderWidth:1.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 102/255,102/255, 102/255, 1 });
    [_lookBtn.layer setBorderColor:colorref];//边框颜色
    
    //实例化NSMutableAttributedString模型
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:_payMoney.text];
    //设置字间距
    long number = 2.f;
    
    //CFNumberRef添加字间距
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);    [attributedString1 addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString1 length])];
    
    //清除CFNumberRef
    CFRelease(num);
    
    //给lab赋值改变好的文字
    [_payMoney setAttributedText:attributedString1];
    
    //实例化NSMutableAttributedString模型
    NSMutableAttributedString * attributedString2 = [[NSMutableAttributedString alloc] initWithString:_orderNum.text];

    
    //CFNumberRef添加字间距
    CFNumberRef num1 = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);    [attributedString2 addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString2 length])];
    
    //清除CFNumberRef
    CFRelease(num1);
    
    //给lab赋值改变好的文字
    [_orderNum setAttributedText:attributedString2];
    

    
    row1 = row2 = row3 = 0;
    [self getProvinceList];
    
    
    
    // Do any additional setup after loading the view from its nib.
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
-(void)cancal{
    
    editView.hidden=YES;
}
- (IBAction)toLook:(id)sender {
    
    if (editView) {
        [editView removeFromSuperview];
    }
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
    name.placeholder = @"收货人姓名";
    name.delegate=self;
    name.textColor = UIColorFromRGB(0x333333);
    name.font=[UIFont systemFontOfSize:16.f];
    [goodsView addSubview:name];
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(97/2, 60+60+40+40, 390-97, 1)];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [goodsView addSubview:line];
    

    phone = [[UITextField alloc]initWithFrame:CGRectMake(97/2, 60+60+40+40+5, 390-97, 40)];
    phone.backgroundColor = [UIColor whiteColor];
    phone.placeholder = @"联系电话";
    phone.textColor = UIColorFromRGB(0x333333);
    phone.font=[UIFont systemFontOfSize:16.f];
    phone.delegate=self;
    [goodsView addSubview:phone];
    
    UILabel *line1=[[UILabel alloc]initWithFrame:CGRectMake(97/2, 60+60+40+40+5+40, 390-97, 1)];
    line1.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [goodsView addSubview:line1];
    
     chooseBtn=[[UIButton alloc]initWithFrame:CGRectMake(97/2, 60+60+40+40+10+40, 390-97, 40)];
    [chooseBtn setTitle:@"请选择省市区" forState:UIControlStateNormal];
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
    detail.placeholder = @"详细地址";
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
//    MyOrderViewController *order=[[MyOrderViewController alloc]init];
//    [self.navigationController pushViewController:order animated:YES];
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
            MyOrderViewController *order=[[MyOrderViewController alloc]init];
            [self.navigationController pushViewController:order animated:YES];
            
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
