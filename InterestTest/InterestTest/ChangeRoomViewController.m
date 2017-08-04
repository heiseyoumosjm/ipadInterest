//
//  ChangeRoomViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/3/8.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "ChangeRoomViewController.h"
#import "SWRevealViewController.h"
#import "SDCycleScrollView.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "RootHttpHelper.h"
#import "roomModel.h"
#import "NewLoginViewController.h"

@interface ChangeRoomViewController ()<SDCycleScrollViewDelegate,NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>
{
    SWRevealViewController *revealController;
    //轮播图片
    SDCycleScrollView *bannerScrol;
    NSMutableArray *imgArr;
}
@property (strong,nonatomic)NSMutableArray *btndataArr;
@end

@implementation ChangeRoomViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor=UIColorFromRGB(0xffffff);
    self.navigationController.navigationBarHidden=NO;
    revealController = [self revealViewController];
    self.title=@"空间布局";
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = true;
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    //设置按钮
    UIButton *_setBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     _setBut.frame = CGRectMake(20, 0, 11, 20);
    [_setBut addTarget: self action: @selector(back) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *setItem = [[UIBarButtonItem alloc]initWithCustomView:_setBut];
    [_setBut setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [_setBut setTitle:@"返回" forState:UIControlStateNormal];
    [_setBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_setBut setBackgroundImage:[UIImage imageNamed:@"menu1"] forState:UIControlStateNormal];
    NSMutableArray *buttonItems = [NSMutableArray array];
    [buttonItems addObject:setItem];
    self.navigationItem.leftBarButtonItems = buttonItems;
    
    
//    //设置按钮
//    UIButton *next = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    next.frame = CGRectMake(20, 0, 60, 30);
//    [next addTarget: self action: @selector(nextstep) forControlEvents: UIControlEventTouchUpInside];
//    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc]initWithCustomView:next];
//    [next setTitle:@"确定" forState:UIControlStateNormal];
//    [next setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    NSMutableArray *buttonItems1 = [NSMutableArray array];
//    [buttonItems1 addObject:nextItem];
//    self.navigationItem.rightBarButtonItems = buttonItems1;
    

    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, (SCREEN_WIDTH - 500) * 9 / 16 + 24)];
    pageFlowView.backgroundColor = [UIColor whiteColor];
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.4;
    pageFlowView.minimumPageScale = 0.85;
    pageFlowView.orginPageCount = imgArr.count;
    pageFlowView.isOpenAutoScroll = NO;

    
    [self.view addSubview:pageFlowView];
    

    imgArr=[[NSMutableArray alloc]init];
    for (RoomProductModel *model in _roomLayoutModel.data) {
        [imgArr addObject:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",model.recommended_layout]];
    }
    [pageFlowView reloadData];
  
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];

    
    // Do any additional setup after loading the view from its nib.
}
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)nextstep{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 轮播图片的点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
//    NSLog(@"++++++++++++第%ld个轮播图片",(long)index + 1);
//    RoomProductModel *model=_roomLayoutModel.data[index];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:_roomLayoutModel.id forKey:@"pad_user_room_function_id"];
//    [params setValue:model.id forKey:@"room_product_id"];
//    
//    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"product-goods/goods" andParams:params andSuccess:^(NSDictionary *successData) {
//        //            //加载圈圈(显示)
//        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
//            //            _g1oodsModel=[[goodsModel alloc]initWithDictionary:[successData objectForKey:@"goods"] error:nil];_dataArr
//            [self.navigationController popViewControllerAnimated:YES];
//        }else{
//            [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
//        }
//        
//    } andError:^(NSError *error) {
//        //加载圈圈(显示)
//        [[HudHelper hudHepler] HideHUDAlert:self.view];
//        NSLog(@"%@",error);
//    }];
//
    
    
}
#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    _btndataArr=[[NSMutableArray alloc]init];
    return imgArr.count;
}
#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(SCREEN_WIDTH - 500, (SCREEN_WIDTH - 500) * 9 / 16);
}
- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
//    bannerView.backgroundColor=[UIColor yellowColor];
//    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 500, (SCREEN_WIDTH - 500) * 9 / 16)];
//    }
//    for (UIButton *view in bannerView.subviews) {
//        [view removeFromSuperview];
//    }

    //在这里下载网络图片
    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:imgArr[index]] placeholderImage:[UIImage imageNamed:@"默认"]];
    
    UIButton *likeBtn=[[UIButton alloc]initWithFrame:CGRectMake(bannerView.frame.size.width-60, 15, 40, 40)];
    [likeBtn setBackgroundImage:[UIImage imageNamed:@"choose1"] forState:UIControlStateNormal];
    [likeBtn setBackgroundImage:[UIImage imageNamed:@"choosed1"] forState:UIControlStateSelected];
    likeBtn.tag=index;
    [likeBtn addTarget:self action:@selector(likeChange:) forControlEvents:UIControlEventTouchUpInside];
    [bannerView addSubview:likeBtn ];
    [_btndataArr addObject:likeBtn];
//    bannerView.mainImageView.image = imgArr[index];
    
    return bannerView;
}
-(void)likeChange:(UIButton *)btn1{
    
    for (UIButton *btn in _btndataArr) {
        btn.selected=NO;
        if (btn.tag==btn1.tag) {
            btn.selected=!btn.selected;
        }
    }
    
    RoomProductModel *model=_roomLayoutModel.data[btn1.tag];
    //    roomModel  *roomModel1=[[roomModel alloc]initWithDictionary:[_roomDataArr[[_index integerValue]] objectForKey:@"id"] error:nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[_roomDataArr[[_index integerValue]] objectForKey:@"id"] forKey:@"pad_user_room_function_id"];
    [params setValue:model.id forKey:@"room_product_id"];
    
    [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"product-goods/set-product-goods" andParams:params andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
            //            _g1oodsModel=[[goodsModel alloc]initWithDictionary:[successData objectForKey:@"goods"] error:nil];_dataArr
            if(_delegate != nil && [_delegate respondsToSelector:@selector(ChangeLayout:)])
                //判断委托对象和委托方法是否存在
            {
                [_delegate ChangeLayout:[successData objectForKey:@"id"]];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
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


- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    NSLog(@"TestViewController 滚动到了第%ld页",pageNumber);
}
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex{
    
    RoomProductModel *model=_roomLayoutModel.data[subIndex];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[_roomDataArr[[_index integerValue]] objectForKey:@"id"] forKey:@"pad_user_room_function_id"];
    [params setValue:model.id forKey:@"room_product_id"];
    
    [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"product-goods/set-product-goods" andParams:params andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
           
            if(_delegate != nil && [_delegate respondsToSelector:@selector(ChangeLayout:)])
                //判断委托对象和委托方法是否存在
            {
                [_delegate ChangeLayout:[successData objectForKey:@"id"]];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
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




@end
