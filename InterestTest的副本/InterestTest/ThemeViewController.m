//
//  ThemeViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/2/28.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#define PAGE_OFFSET 100
// 屏幕宽高
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//普通的颜色值
#define UIColorRGB(R, G, B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]
// 随机色
#define RandomColor UIColorRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#import "ThemeViewController.h"
#import "LeftViewController.h"
#import "SWRevealViewController.h"
#import "UIView+Extension.h"
#import "iCarousel.h"
#import "RootHttpHelper.h"
#import "PicModel.h"
#import "MickeyAlbum.h"
#import "ResultViewController.h"
#import "LineLayout.h"
#import "Cell.h"
#import "NewLoginViewController.h"

@interface ThemeViewController ()<iCarouselDelegate,iCarouselDataSource,UICollectionViewDataSource,UICollectionViewDelegate>
{
    MickeyAlbum * album;
    NSMutableArray *imgArr;
    UIView *background;
    UIView *footView;
    SWRevealViewController *revealController;
}
@property (nonatomic,strong) iCarousel *iCarousel;
@property (nonatomic,strong) PicModel *picModel;

@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,strong) NSMutableArray *likedataList;
@property (nonatomic,strong) NSMutableArray *disLikedataList;
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation ThemeViewController

- (void)viewWillAppear:(BOOL)animated{
    [self getPicDate];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=UIColorFromRGB(0xeeeeee);
    revealController = [self revealViewController];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = true;
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
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
    [self setUpViews];
//    [self getPicDate];
    [self createfootView];
}
-(void)createfootView
{
    footView=[[UIView alloc]initWithFrame:CGRectMake(0,ScreenHeight-64,ScreenWidth,64)];
    footView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:footView];
    
    UIImageView *logo=[[UIImageView alloc]initWithFrame:CGRectMake(20,14,36,36)];
    logo.image=[UIImage imageNamed:@"icon_log_logo"];
    [footView addSubview:logo];
    
    UILabel *logolab=[[UILabel alloc]initWithFrame:CGRectMake(110,0,300,64)];
    logolab.text=@"测一测你适合什么风格的家？";
    [footView addSubview:logolab];
    
    
}
-(void)getPicDate{
    
    _likedataList=[[NSMutableArray alloc]init];
    _disLikedataList=[[NSMutableArray alloc]init];
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"pic/get" andParams:nil andSuccess:^(NSDictionary *successData) {
        //加载圈圈(显示)
        [[HudHelper hudHepler] HideHUDAlert:self.view];
        _dataList=[[NSMutableArray alloc]init];
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
            NSError *err = nil;
            NSMutableArray *arr=[[NSMutableArray alloc]init];
            arr=[successData objectForKey:@"data"] ;
            for (NSDictionary *dic in arr) {
                _picModel = [[PicModel alloc] initWithDictionary:dic error:&err];
                _picModel.is_like=@"0";
                [_dataList addObject:_picModel];
                [_disLikedataList addObject:_picModel.id];
            }
            [_collectionView reloadData];
            
        }else if ([[successData objectForKey:@"api_code"] integerValue]==401){
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的账号已在别处登陆了，请重新登录！" preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSLog(@"+++++++++++++++退出");
                NewLoginViewController *theme=[[NewLoginViewController alloc]init];
                [self.navigationController pushViewController:theme animated:YES];
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
        
    } andError:^(NSError *error) {
        //加载圈圈(显示)
        [[HudHelper hudHepler] HideHUDAlert:self.view];
        NSLog(@"%@",error);
    }];
    

    
}
#pragma mark - 初始化视图View
- (void)setUpViews {
    
    //初始化layout
     LineLayout *layout = [[LineLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal]; //控制滑动分页用
    
    //初始化collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:layout];
    _collectionView.showsVerticalScrollIndicator = FALSE;
    _collectionView.showsHorizontalScrollIndicator = FALSE;
    //代理指向自己
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = UIColorFromRGB(0xeeeeee);
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
//    [layout setScrollDirection:UICollectionViewScrollDirectionVertical]; //控制滑动分页用
    //注册cell
    [self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:@"MY_CELL"];

    
   [self.view addSubview:_collectionView];
}

-(iCarousel *)iCarousel{
    CGFloat height = ScreenHeight-128 - 2 *PAGE_OFFSET;
    if (_iCarousel == nil) {
        _iCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, (ScreenHeight-height)*0.5, ScreenWidth, height)];
        _iCarousel.delegate = self;
        _iCarousel.dataSource = self;
        _iCarousel.bounces = NO;
        _iCarousel.pagingEnabled = YES;
        _iCarousel.type = iCarouselTypeCustom;
    }
    return _iCarousel;
}

#pragma mark - 填充数据
- (NSMutableArray *)dataList{
    if (_dataList == nil) {
        _dataList = [[NSMutableArray alloc] init];

    }
    return _dataList;
}

#pragma mark - iCarousel代理

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    
    return _dataList.count+1;
}
-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (index>_dataList.count-1) {
//        if (view) {
//            [view removeFromSuperview];
//        }

        
            CGFloat viewWidth = (ScreenWidth - 100)/3;
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth/3*4+70)];
            UIImageView *imagev=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth/3*4+80)];
            view.backgroundColor=[UIColor whiteColor];
            imagev.image=[UIImage imageNamed:@"last"];
            UIButton *likeimagev=[[UIButton alloc]initWithFrame:CGRectMake(50, viewWidth/3*4+80-230, viewWidth-100, 48)];
           [likeimagev addTarget: self action:@selector(goresult) forControlEvents:UIControlEventTouchUpInside];
        
            [likeimagev setBackgroundImage:[UIImage imageNamed:@"lastBtn"] forState:UIControlStateNormal];
            [likeimagev setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
             likeimagev.titleLabel.font=[UIFont systemFontOfSize:20.f];
            [view addSubview:imagev];
            [view addSubview:likeimagev];
        
//
//
    }else{
    
//    UIButton *likeBtn;
//    if (view == nil) {
        _picModel=[[PicModel alloc]init];
        _picModel=_dataList[index];
        CGFloat viewWidth = (ScreenWidth - 100)/3;
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth/3*4+70)];
        view.backgroundColor=[UIColor whiteColor];
         UIImageView *imagev=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth/3*4)];
         UIButton *likeimagev=[[UIButton alloc]initWithFrame:CGRectMake(viewWidth-50, viewWidth/3*4+22.5, 29, 24.5)];
        [likeimagev setBackgroundImage:[UIImage imageNamed:@"icon_home_like"] forState:UIControlStateNormal];
         likeimagev.tag=index;
        [likeimagev addTarget:self action:@selector(likePic:) forControlEvents:UIControlEventTouchUpInside];
        if ([_picModel.is_like integerValue]==1) {
           [likeimagev setBackgroundImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
        }else {
        [likeimagev setBackgroundImage:[UIImage imageNamed:@"icon_home_like"] forState:UIControlStateNormal];
        }
        [view addSubview:imagev];
        [view addSubview:likeimagev];
//        [view addSubview:likeBtn];
//    }
//    _picModel=[[PicModel alloc]init];
//    _picModel=_dataList[index];
    [imagev sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",_picModel.image]] placeholderImage:[UIImage imageNamed:@"默认"]];
     imagev.contentMode = UIViewContentModeScaleToFill;
    imgArr=[[NSMutableArray alloc]init];

    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    imagev.tag=index;
    imagev.userInteractionEnabled = YES;
    [imagev addGestureRecognizer:tap];
    }

    //加阴影
//    view.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
//    view.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//    view.layer.shadowOpacity = 0.2;//阴影透明度，默认0
//    view.layer.shadowRadius = 2;//阴影半径，默认3
        view.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        view.layer.shadowOffset = CGSizeMake(0,30);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        view.layer.shadowOpacity = 0.2;//阴影透明度，默认0
        view.layer.shadowRadius = 30;//阴影半径，默认3
    
    
    
    return view;
}
-(void)goresult{
        if (_likedataList.count>=3) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:_likedataList forKey:@"like_pics"];
            [params setValue:_disLikedataList forKey:@"unlike_pics"];
            [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"user/result" andParams:params andSuccess:^(NSDictionary *successData) {
                //加载圈圈(显示)
                [[HudHelper hudHepler] HideHUDAlert:self.view];
                if ([[successData objectForKey:@"api_code"] integerValue]==200) {
                    
                    //发通知侧边栏可以点击展开测试结果界面
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLeft" object:@"1"];
                    
                    NSMutableDictionary *colorDic=[[NSMutableDictionary alloc]init];
                    colorDic=[successData objectForKey:@"colorAttr"];
                    NSMutableDictionary *styleAttr=[[NSMutableDictionary alloc]init];
                    styleAttr=[successData objectForKey:@"styleAttr"];
                    
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
                    
                    ResultViewController *result1=[[ResultViewController alloc]init];
                    [self.navigationController pushViewController:result1 animated:YES];
                    
                }else if([[successData objectForKey:@"api_code"] integerValue]==500){
                   [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
                }
                
            } andError:^(NSError *error) {
                
                //加载圈圈(显示)
                [[HudHelper hudHepler] HideHUDAlert:self.view];
                NSLog(@"%@",error);
            }];
            
            
            
        }else{
            [[HudHelper hudHepler] showTips:self.view tips:@"至少选择3个,才能看到结果！"];
        }
        //        ResultViewController *result1=[[ResultViewController alloc]init];
        //        [self.navigationController pushViewController:result1 animated:YES];

}
//点击图片后的方法(即图片的放大全屏效果)
- (void) tapAction:(UIGestureRecognizer *)gesture{
    
    
    self.navigationController.navigationBarHidden=YES;
    footView.hidden=YES;
    
    //创建一个黑色背景
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScreenHeight)];
    background = bgView;
    background.backgroundColor=UIColorFromRGB(0x808080);
    [self.view addSubview:bgView];
    
    //创建显示图像的视图
    //初始化要显示的图片内容的imageView
        UIImageView *imageView = (UIImageView *)gesture.view;
        imgArr=[[NSMutableArray alloc]init];
        _picModel=[[PicModel alloc]init];
        _picModel=_dataList[imageView.tag];
        [imgArr addObject:_picModel.image];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-SCREEN_HEIGHT/3*2/2, 0, SCREEN_HEIGHT/3*2, SCREEN_HEIGHT)];
    //要显示的图片，即要放大的图片
//    [imgView sd_setImageWithURL:[NSURL URLWithString:_picModel.image] placeholderImage:[UIImage imageNamed:@"默认"]];
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",_picModel.image]] placeholderImage:[UIImage imageNamed:@"默认"]];
     imgView.contentMode = UIViewContentModeScaleToFill;
    [bgView addSubview:imgView];
    
    imgView.userInteractionEnabled = YES;
    //添加点击手势（即点击图片后退出全屏）
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    [imgView addGestureRecognizer:tapGesture];
    
    imgView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    imgView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    imgView.layer.shadowOpacity = 0.35;//阴影透明度，默认0
    imgView.layer.shadowRadius = 54;//阴影半径，默认3
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    [background addGestureRecognizer:tapGesture1];
    
    
//    [self shakeToShow:imgView];//放大过程中的动画
}
-(void)closeView{
     self.navigationController.navigationBarHidden=NO;
     footView.hidden=NO;
    [background removeFromSuperview];
}
//放大过程中出现的缓慢动画
- (void) shakeToShow:(UIImageView *)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}
-(void)likePic:(UIButton *)sender
{
    _picModel=[[PicModel alloc]init];
    _picModel=_dataList[sender.tag];
    if ([_picModel.is_like integerValue]==1) {
        _picModel.is_like=@"0";
        [sender setBackgroundImage:[UIImage imageNamed:@"icon_home_like"] forState:UIControlStateNormal];
        [_likedataList removeObject:_picModel.id];
        [_disLikedataList addObject:_picModel.id];
        
        
    }else{
        _picModel.is_like=@"1";
         [sender setBackgroundImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
        [_likedataList addObject:_picModel.id];
        [_disLikedataList removeObject:_picModel.id];
    }
    
  
    
}

-(CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
//    static CGFloat max_sacle = 1.0f;
//    static CGFloat min_scale = 0.8f;
//    if (offset <=1 && offset >= -1) {
//        float tempScale = offset < 0 ? 1+offset : 1-offset;
//        float slope = (max_sacle - min_scale) / 1;
//        
//        CGFloat scale = min_scale + slope*tempScale;
//        transform = CATransform3DScale(transform, scale, scale, 1);
//    }else{
//        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
//    }

    return CATransform3DTranslate(transform, offset * self.iCarousel.itemWidth * 1.25, 0.0, 0.0);
}
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if (index<_dataList.count-1) {
        _picModel=[[PicModel alloc]init];
        _picModel=_dataList[index];
        if ([_picModel.is_like integerValue]==1) {
            _picModel.is_like=@"0";
            _dataList[index]=_picModel;
            [_iCarousel reloadItemAtIndex:index animated:YES];
            [_likedataList removeObject:_picModel.id];
            [_disLikedataList addObject:_picModel.id];
            
            
        }else{
            _picModel.is_like=@"1";
            _dataList[index]=_picModel;
            [_iCarousel reloadItemAtIndex:index animated:YES];
            [_likedataList addObject:_picModel.id];
            [_disLikedataList removeObject:_picModel.id];
        }
    }else if (index>_dataList.count-1&&index!=0){
        if (_likedataList.count>=3) {
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:_likedataList forKey:@"like_pics"];
            [params setValue:_disLikedataList forKey:@"unlike_pics"];
            [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"user/result" andParams:params andSuccess:^(NSDictionary *successData) {
                //加载圈圈(显示)
                [[HudHelper hudHepler] HideHUDAlert:self.view];
                if ([[successData objectForKey:@"api_code"] integerValue]==200) {
                    NSMutableDictionary *colorDic=[[NSMutableDictionary alloc]init];
                    colorDic=[successData objectForKey:@"colorAttr"];
                    NSMutableDictionary *styleAttr=[[NSMutableDictionary alloc]init];
                    styleAttr=[successData objectForKey:@"styleAttr"];
                    
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
                    if ([styleAttr objectForKey:@"name"]) {
                        [defaults setObject:[styleAttr objectForKey:@"name"] forKey:@"name"];
                    }
                    
                    //                    [defaults setObject:[styleAttr objectForKey:@"fg_sentence"] forKey:@"fg_sentence"];
                    //                    [defaults setObject:[styleAttr objectForKey:@"result_imgs"] forKey:@"result_imgs"];
                    [defaults synchronize];
                    
                    ResultViewController *result1=[[ResultViewController alloc]init];
                    //                    result1.color_sentence=[colorDic objectForKey:@"color_sentence"];
                    //                    result1.fg_sentence=[styleAttr objectForKey:@"fg_sentence"];
                    //                    result1.result_imgs=[styleAttr objectForKey:@"result_imgs"];
                    [self.navigationController pushViewController:result1 animated:YES];
                    
                }
                
            } andError:^(NSError *error) {
                //加载圈圈(显示)
                [[HudHelper hudHepler] HideHUDAlert:self.view];
                NSLog(@"%@",error);
            }];
            
            
            
        }else{
            [[HudHelper hudHepler] showTips:self.view tips:@"至少选择3个,才能看到结果！"];
        }

        
    }
}
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return _dataList.count+2;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
     Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
//    UIView *view;
    if (indexPath.row==_dataList.count) {
        //        if (view) {
        //            [view removeFromSuperview];
        //        }
        
        
        CGFloat viewWidth = (ScreenWidth - 100)/3;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth/3*4+70)];
        UIImageView *imagev=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth/3*4+70)];
        view.backgroundColor=[UIColor whiteColor];
        imagev.image=[UIImage imageNamed:@"last"];
        UIButton *likeimagev=[[UIButton alloc]initWithFrame:CGRectMake(50, 465/2, viewWidth-100, 107/2)];
        [likeimagev addTarget: self action:@selector(goresult) forControlEvents:UIControlEventTouchUpInside];
        
//        [likeimagev setBackgroundImage:[UIImage imageNamed:@"lastBtn"] forState:UIControlStateNormal];
        [likeimagev setTitle:@"开启理想家之门" forState:UIControlStateNormal];
        [likeimagev setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        likeimagev.titleLabel.font=[UIFont systemFontOfSize:20.f];
        likeimagev.layer.borderColor=[[UIColor whiteColor] CGColor];;
        likeimagev.layer.borderWidth=1.0;
        likeimagev.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.24];
        [view addSubview:imagev];
        [view addSubview:likeimagev];
        
//        view.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
//        view.layer.shadowOffset = CGSizeMake(0,30);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//        view.layer.shadowOpacity = 0.2;//阴影透明度，默认0
//        view.layer.shadowRadius = 30;//阴影半径，默认3
        [cell.contentView addSubview:view];
        cell.contentView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        cell.contentView.layer.shadowOffset = CGSizeMake(0,30);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        cell.contentView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
        cell.contentView.layer.shadowRadius = 30;//阴影半径，默认3

        
        //
        //
    }else if(indexPath.row<=_dataList.count-1){
        cell.contentView.hidden=NO;
        //    UIButton *likeBtn;
        //    if (view == nil) {
        _picModel=[[PicModel alloc]init];
        _picModel=_dataList[indexPath.row];
        CGFloat viewWidth = (ScreenWidth - 100)/3;
       UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth/3*4+70)];
        view.backgroundColor=[UIColor whiteColor];
        UIImageView *imagev=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth/3*4)];
        UIButton *likeimagev=[[UIButton alloc]initWithFrame:CGRectMake(viewWidth-50, viewWidth/3*4+22.5, 29, 24.5)];
        [likeimagev setBackgroundImage:[UIImage imageNamed:@"icon_home_like"] forState:UIControlStateNormal];
        likeimagev.tag=indexPath.row;
        [likeimagev addTarget:self action:@selector(likePic:) forControlEvents:UIControlEventTouchUpInside];
        if ([_picModel.is_like integerValue]==1) {
            [likeimagev setBackgroundImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
        }else {
            [likeimagev setBackgroundImage:[UIImage imageNamed:@"icon_home_like"] forState:UIControlStateNormal];
        }
        [view addSubview:imagev];
        [view addSubview:likeimagev];
        //        [view addSubview:likeBtn];
        //    }
        //    _picModel=[[PicModel alloc]init];
        //    _picModel=_dataList[index];
//        [imagev sd_setImageWithURL:[NSURL URLWithString:_picModel.image] placeholderImage:[UIImage imageNamed:@"默认"]];
        [imagev sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",_picModel.image]] placeholderImage:[UIImage imageNamed:@"默认"]];
        imagev.contentMode = UIViewContentModeScaleToFill;
        imgArr=[[NSMutableArray alloc]init];
        
        UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        imagev.tag=indexPath.row;
        imagev.userInteractionEnabled = YES;
        [imagev addGestureRecognizer:tap];
        
        cell.contentView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        cell.contentView.layer.shadowOffset = CGSizeMake(0,30);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        cell.contentView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
        cell.contentView.layer.shadowRadius = 30;//阴影半径，默认3
        
//        view.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
//        view.layer.shadowOffset = CGSizeMake(0,30);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//        view.layer.shadowOpacity = 0.2;//阴影透明度，默认0
//        view.layer.shadowRadius = 30;//阴影半径，默认3
        [cell.contentView addSubview:view];
    }else if(indexPath.row==_dataList.count+1){
        cell.contentView.hidden=YES;
//        CGFloat viewWidth = (ScreenWidth - 100)/3;
//        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth/3*4+70)];
//        view.image=[UIImage imageNamed:@"默认"];
//        [cell.contentView addSubview:view];
//        cell.contentView.backgroundColor=[UIColor clearColor];
    }
    
    //加阴影
    //    view.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    //    view.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    //    view.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    //    view.layer.shadowRadius = 2;//阴影半径，默认3
    cell.contentView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    cell.contentView.layer.shadowOffset = CGSizeMake(0,30);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    cell.contentView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    cell.contentView.layer.shadowRadius = 30;//阴影半径，默认3
//    [cell.contentView addSubview:view];
    return cell;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
