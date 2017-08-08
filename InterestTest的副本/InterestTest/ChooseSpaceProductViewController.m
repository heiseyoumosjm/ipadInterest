//
//  ChooseSpaceProductViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/3/12.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "ChooseSpaceProductViewController.h"
#import "SWRevealViewController.h"
#import "RootHttpHelper.h"
#import "goodDetailModel.h"
#import "MickeyAlbum1.h"
#import "NewLoginViewController.h"


@interface ChooseSpaceProductViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    SWRevealViewController *revealController;
    MickeyAlbum1 * album;
}
@property (strong, nonatomic) UICollectionView *collection;
@property (strong, nonatomic) goodDetailModel *goodModel;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSMutableArray *btndataArr;
@property (strong, nonatomic) NSString *chooseid;
@property (strong, nonatomic) NSString *choosepositionid;
@property(nonatomic,strong)NSMutableArray *imageArr;
@end
//好友
static NSString *ReverseCellName = @"ILikeCollectionViewCell";

@implementation ChooseSpaceProductViewController

-(void)initView
{
    
    //初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置滚动方向
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collection.showsVerticalScrollIndicator = FALSE;
    _collection.showsHorizontalScrollIndicator = FALSE;
    
    //初始化collectionView
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH,  SCREEN_HEIGHT-64) collectionViewLayout:layout];
    //代理指向自己
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.showsVerticalScrollIndicator = NO;
    _collection.backgroundColor = [UIColor whiteColor];
    //注册cell
    [_collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ReverseCellName];
    
//    //下拉刷新
//    [_collection addHeaderWithTarget:self action:@selector(fetchData) dateKey:@"SailorTable"];
//    [_collection addFooterWithTarget:self action:@selector(fetchMoreData) ];
//    [_collection headerBeginRefreshing];
//    _collection.headerPullToRefreshText = headerPullToRefreshText;
//    _collection.headerReleaseToRefreshText = headerReleaseToRefreshText;
//    _collection.headerRefreshingText = headerRefreshingText;
    
    
    
    [self.view addSubview:_collection];
    [self fetchData];
    [_collection reloadData];
    
}
-(void)fetchData
{
    _dataArr=[[NSMutableArray alloc]init];
    _btndataArr=[[NSMutableArray alloc]init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_goods_id forKey:@"goods_model_id"];
    [params setValue:_layout_id_unband forKey:@"room_product_id"];
    
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"product-goods/goods-detail" andParams:params andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
            _dataArr=[successData objectForKey:@"data"];
            
            [UIView performWithoutAnimation:^{
                [self.collection reloadData];
            }];
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

//    [UIView performWithoutAnimation:^{
//        [self.collection reloadData];
//    }];
    
    [_collection headerEndRefreshing];
    
}
-(void)fetchMoreData{
    [UIView performWithoutAnimation:^{
        [self.collection reloadData];
    }];
    [_collection footerEndRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=UIColorFromRGB(0xffffff);
    revealController = [self revealViewController];
    self.title=@"空间产品";
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = true;
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    //设置按钮
    UIButton *_setBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _setBut.frame = CGRectMake(20, 0,  11, 20);
    [_setBut addTarget: self action: @selector(back) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *setItem = [[UIBarButtonItem alloc]initWithCustomView:_setBut];
    [_setBut setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_setBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSMutableArray *buttonItems = [NSMutableArray array];
    [buttonItems addObject:setItem];
    self.navigationItem.leftBarButtonItems = buttonItems;
    
    
//    //设置按钮
//    UIButton *next = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    next.frame = CGRectMake(20, 0, 60, 30);
//    [next addTarget: self action: @selector(nextstep) forControlEvents: UIControlEventTouchUpInside];
//    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc]initWithCustomView:next];
//    [next setTitle:@"确认" forState:UIControlStateNormal];
//    [next setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    NSMutableArray *buttonItems1 = [NSMutableArray array];
//    [buttonItems1 addObject:nextItem];
//    self.navigationItem.rightBarButtonItems = buttonItems1;
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
    
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)nextstep{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_chooseid forKey:@"goods_model_id"];
    [params setValue:_layout_id forKey:@"pad_user_room_product_id"];
    
    [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"product-goods/set-goods-single" andParams:params andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
            [self.navigationController popViewControllerAnimated:true];
          
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
#pragma mark - CollectionView的代理方法
#pragma mark - 分组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark - 每组Cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}

#pragma mark - 设置每个Cell的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((SCREEN_WIDTH-150-40)/2,(SCREEN_WIDTH-150-40)/2/4*3);
}

#pragma mark - 设置每个Cell的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //前两个代表距离上边距和左边距的距离
    //后两个代理距离下边距和右边距的距离
    return UIEdgeInsetsMake(40, 75, 40, 75);
    
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumColumnSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
#pragma mark - 设置每个Cell垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 40;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSMutableArray *arr=[[NSMutableArray alloc]init];
//    arr=_dataArr[0];
    _goodModel=[[goodDetailModel alloc]initWithDictionary:_dataArr[indexPath.row] error:nil];
  
//    UILabel *titleLab;
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ReverseCellName forIndexPath:indexPath];
    
    //    cell.contentView.layer.masksToBounds=YES;
    //    cell.contentView.layer.cornerRadius=5;
//    cell.contentView.backgroundColor=[UIColor whiteColor];
//    for (UIView *view in cell.contentView.subviews) {
//        [view removeFromSuperview];
//    }
    UIButton *likeBtn=[[UIButton alloc]initWithFrame:CGRectMake(cell.frame.size.width-60, 15, 40, 40)];
    [likeBtn setBackgroundImage:[UIImage imageNamed:@"choose1"] forState:UIControlStateNormal];
    [likeBtn setBackgroundImage:[UIImage imageNamed:@"choosed1"] forState:UIControlStateSelected];
    likeBtn.tag=indexPath.row;
    [likeBtn addTarget:self action:@selector(likeChange:) forControlEvents:UIControlEventTouchUpInside];
    [_btndataArr addObject:likeBtn ];
    
//    [cell.contentView addSubview:likeBtn];
    
    //    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, cell.frame.size.width-60, cell.frame.size.width, 60)];
    //    titleView.backgroundColor=[UIColor whiteColor];
    //    [cell.contentView addSubview:titleView];
    
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
   [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://injia-dev.image.alimmdn.com",_goodModel.imgs[0]]] placeholderImage:[UIImage imageNamed:@"默认"]];
    img.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(album:)];
    img.tag=indexPath.row;
    img.userInteractionEnabled = YES;
    [img addGestureRecognizer:tap];
//    UIButton *imgBtn=[[UIButton alloc]initWithFrame:CGRectMake(cell.frame.size.width/2+144/2, 10, cell.frame.size.width-(cell.frame.size.width/2+144/2), cell.frame.size.width-(cell.frame.size.width/2+144/2)-15)];
//    [imgBtn setBackgroundImage:[UIImage imageNamed:@"loginBackView"] forState:UIControlStateNormal]
//    ;
//    imgBtn.tag=indexPath.row;
//    [imgBtn addTarget:self action:@selector(chooseImg:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 234/2+10, cell.frame.size.width, 35)];
//    titleLab.font=[UIFont systemFontOfSize:17.f];
//    titleLab.textAlignment=NSTextAlignmentLeft;
//    titleLab.backgroundColor=[UIColor lightGrayColor];
//    titleLab.text=@"     沙发";
//    
//    UILabel *styleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 234/2+35, cell.frame.size.width, cell.frame.size.height-234/2-35)];
//    styleLab.font=[UIFont systemFontOfSize:12.f];
//    styleLab.textAlignment=NSTextAlignmentLeft;
//    styleLab.backgroundColor=[UIColor lightGrayColor];
//    styleLab.text=@"      80*80*20";
//    
    [cell.contentView addSubview:img];
    [cell.contentView addSubview:likeBtn];
//    [cell.contentView addSubview:imgBtn];
//    [cell.contentView addSubview:titleLab];
//    [cell.contentView addSubview:styleLab];
    //    cell.backgroundColor = [UIColor lightGrayColor];
    
    return cell;
    
}
-(void)likeChange:(UIButton *)btn1{
    
    for (UIButton *btn in _btndataArr) {
        btn.selected=NO;
        if (btn.tag==btn1.tag) {
          btn.selected=!btn.selected;
        }
    }
    
    _goodModel=[[goodDetailModel alloc]initWithDictionary:_dataArr[btn1.tag] error:nil];
//    btn.selected=!btn.selected;
    _chooseid=_goodModel.id;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_chooseid forKey:@"goods_model_id"];
    [params setValue:_layout_id forKey:@"pad_user_room_product_id"];
    [params setValue:_position forKey:@"position"];
    
    [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"product-goods/set-goods-single" andParams:params andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
            if(_delegate != nil && [_delegate respondsToSelector:@selector(ChangeLayout:)])
                //判断委托对象和委托方法是否存在
            {
                [_delegate ChangeGoods:nil];
            }
            
            [self.navigationController popViewControllerAnimated:true];
            
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
-(void)chooseImg:(UIButton *)btn{
    
   
    
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)album:(UIGestureRecognizer *)gesture
{
    NSLog(@"局部放大");
    _imageArr=[[NSMutableArray alloc]init];
    UIImageView *imageView = (UIImageView *)gesture.view;
//    NSMutableArray *arr=[[NSMutableArray alloc]initWithArray:_dataArr[imageView.tag]];
    _goodModel=[[goodDetailModel alloc]initWithDictionary:_dataArr[imageView.tag] error:nil];
    // UIImageView *imageView = (UIImageView *)gesture.view;
    for (NSString *str in _goodModel.imgs) {
        [_imageArr addObject:[NSString stringWithFormat:@"%@%@",@"http://injia-dev.image.alimmdn.com",str]];
    }
    album = [[MickeyAlbum1 alloc]initWithImgUrlArr:_imageArr CurPage:0];
    album.photoFrame = imageView.frame;
    [self.navigationController presentViewController:album animated:YES completion:nil];
}

@end
