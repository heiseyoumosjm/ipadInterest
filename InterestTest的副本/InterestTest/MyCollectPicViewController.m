//
//  MyCollectPicViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/5/12.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "MyCollectPicViewController.h"
#import "SWRevealViewController.h"
#import "MickeyAlbum1.h"
#import "MickeyAlbum2.h"
#import "RootHttpHelper.h"
#import "NewLoginViewController.h"

@interface MyCollectPicViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

{
    SWRevealViewController *revealController;
    MickeyAlbum1 * album;
    MickeyAlbum2 * album1;
}
@property (strong, nonatomic) UICollectionView *collection;
@property (strong,nonatomic)NSMutableArray *dataArr;
@property (strong,nonatomic)NSMutableArray *imageArr;
@property (strong,nonatomic)NSString *num;
@property (assign,nonatomic)NSInteger *page;
@end

//好友
static NSString *ReverseCellName = @"ILikeCollectionViewCell";

@implementation MyCollectPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=UIColorFromRGB(0xeeeeee);
    revealController = [self revealViewController];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = true;
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
     self.title=@"全部图库";
    
    
    // Do any additional setup after loading the view from its nib.
    //设置按钮
    UIButton *_setBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _setBut.frame = CGRectMake(20, 0, 11, 20);
    [_setBut addTarget: self action: @selector(back) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *setItem = [[UIBarButtonItem alloc]initWithCustomView:_setBut];
    [_setBut setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    NSMutableArray *buttonItems = [NSMutableArray array];
    [buttonItems addObject:setItem];
    self.navigationItem.leftBarButtonItems = buttonItems;
    
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];

    [self initView];
    // Do any additional setup after loading the view.
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initView
{
    
    self.view.backgroundColor=UIColorFromRGB(0xf0f0f0);
    //初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置滚动方向
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collection.showsVerticalScrollIndicator = FALSE;
    _collection.showsHorizontalScrollIndicator = FALSE;
    
    //初始化collectionView
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH,  SCREEN_HEIGHT-64) collectionViewLayout:layout];
    //代理指向自己
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.showsVerticalScrollIndicator = NO;
    _collection.backgroundColor = [UIColor clearColor];
    //注册cell
    [_collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ReverseCellName];
    
    //下拉刷新
    [_collection addHeaderWithTarget:self action:@selector(fetchData) dateKey:@"SailorTable"];
    [_collection addFooterWithTarget:self action:@selector(fetchMoreData) ];
    [_collection headerBeginRefreshing];
    _collection.headerPullToRefreshText = headerPullToRefreshText;
    _collection.headerReleaseToRefreshText = headerReleaseToRefreshText;
    _collection.headerRefreshingText = headerRefreshingText;
    
    
    
    [self.view addSubview:_collection];
    //    [self fetchData];
    
}
-(void)fetchData
{
    _num=@"20";
    _page=0;
    [self getDate];
    [UIView performWithoutAnimation:^{
        [self.collection reloadData];
    }];
    
    [_collection headerEndRefreshing];
    
}
-(void)fetchMoreData{
    _num=@"20";
    _page=_page+1;
    [self getMoreDate];
    [UIView performWithoutAnimation:^{
        [self.collection reloadData];
    }];
    [_collection footerEndRefreshing];
}



-(void)getMoreDate{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:[NSString stringWithFormat:@"%ld",_page] forKey:@"page"];
        [params setValue:@"20" forKey:@"num"];
        [params setValue:@"0" forKey:@"type"];
        [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"get-user-collection" andParams:params andSuccess:^(NSDictionary *successData) {
            //            //加载圈圈(显示)
            if ([[successData objectForKey:@"api_code"] integerValue]==200) {
                [_dataArr addObjectsFromArray:[successData objectForKey:@"dara"]];
                [_collection reloadData];
                
                
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
-(void)getDate
{
    _dataArr=[[NSMutableArray alloc]init];
   
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"0" forKey:@"page"];
    [params setValue:@"20" forKey:@"num"];
    [params setValue:@"0" forKey:@"type"];
    
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"get-user-collection" andParams:params andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
            
             _dataArr=[[NSMutableArray alloc]initWithArray:[successData objectForKey:@"data"]];
            [_collection reloadData];
 
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 每组Cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}

#pragma mark - 设置每个Cell的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((SCREEN_WIDTH-200)/4,(SCREEN_WIDTH-200)/4/3*4);
}

#pragma mark - 设置每个Cell的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //前两个代表距离上边距和左边距的距离
    //后两个代理距离下边距和右边距的距离
    return UIEdgeInsetsMake(40, 40, 40, 40);
    
    
}

#pragma mark - 设置每个Cell水平间距
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
    UIImageView *img;
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ReverseCellName forIndexPath:indexPath];
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        dic=_dataArr[indexPath.row];
//    _goodsFrunitureModel=[[GoodsFrunitureModel alloc]init];
//    _goodsFrunitureModel=_dataArr[indexPath.row];
    //    NSMutableArray *arr=[[NSMutableArray alloc]initWithArray:_dataArr[indexPath.row]];
    //    _g1oodsModel=[[goodsModel alloc]initWithDictionary:arr[0] error:nil];
    
    //    for (UIView *view in cell.contentView.subviews) {
    //        [view removeFromSuperview];
    //    }
    //    cell.contentView.layer.masksToBounds=YES;
    //    cell.contentView.layer.cornerRadius=5;
    cell.backgroundColor=[UIColor whiteColor];
    
    //    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, cell.frame.size.width-60, cell.frame.size.width, 60)];
    //    titleView.backgroundColor=[UIColor whiteColor];
    //    [cell.contentView addSubview:titleView];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
//    img=[[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width/2-144/2, 60, 144, 234/2)];
    //    img.image=[UIImage imageNamed:@"bg"];
    
    //    [_ImgLeft sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",_roomProductModel.recommended_layout]] placeholderImage:[UIImage imageNamed:@"默认"]];
    //    _ImgLeft.contentMode = UIViewContentModeScaleToFill;
    if([[dic objectForKey:@"type"] integerValue]==0)
    {
     img=[[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width/2-144/2, 60, 144, 234/2)];
    [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://injia-dev.image.alimmdn.com",[[dic objectForKey:@"target"] objectForKey:@"imgs"][0]]] placeholderImage:[UIImage imageNamed:@"默认"]];
     img.contentMode = UIViewContentModeScaleAspectFit;
    }else{
     img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height-40)];
    [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",[[dic objectForKey:@"target"] objectForKey:@"case_pics"]]] placeholderImage:[UIImage imageNamed:@"默认"]];
     img.contentMode = UIViewContentModeScaleAspectFill;
     img.layer.masksToBounds=YES;
    }
    //img.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(album:)];
    img.tag=indexPath.row;
    img.userInteractionEnabled = YES;
    [img addGestureRecognizer:tap];
    
    
//    UIButton *likeBtn=[[UIButton alloc]initWithFrame:CGRectMake(cell.frame.size.width-30, 10, 42/2, 35/2)];
////    if ([_goodsFrunitureModel.is_collection integerValue]==0) {
////        [likeBtn setBackgroundImage:[UIImage imageNamed:@"icon_home_like"] forState:UIControlStateNormal];
////    }else{
////        [likeBtn setBackgroundImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
////    }
//    //    [likeBtn setBackgroundImage:[UIImage imageNamed:@"liked"] forState:UIControlStateSelected];
//    likeBtn.tag=indexPath.row;
//    [likeBtn addTarget:self action:@selector(likeChange:) forControlEvents:UIControlEventTouchUpInside];
//    [_btndataArr addObject:likeBtn ];
    
    //    if (_g1oodsModel.attrs.count>0) {
    //
    //    UIButton *imgBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 5, 42, 50)];
    //    [imgBtn setBackgroundImage:[UIImage imageNamed:@"loginBackView"] forState:UIControlStateNormal]
    //     ;
    //     img.backgroundColor=[UIColor redColor];
    //     imgBtn.tag=indexPath.row;
    //    [imgBtn addTarget:self action:@selector(chooseImg:) forControlEvents:UIControlEventTouchUpInside];
    //    [cell.contentView addSubview:imgBtn];
    //    }
    
    
    //    NSMutableDictionary *categorydic=_g1oodsModel.category;
    //    //    titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 234/2+10, cell.frame.size.width, 35)];
    //    //    titleLab.font=[UIFont systemFontOfSize:17.f];
    //    //    titleLab.textAlignment=NSTextAlignmentLeft;
    //    ////    titleLab.backgroundColor=[UIColor lightGrayColor];
    //    //    titleLab.text=[NSString stringWithFormat:@"      %@",[categorydic objectForKey:@"name"]];
    //    for (UILabel *lab in cell.contentView.subviews) {
    //        [lab removeFromSuperview];
    //    }
    //    if (arr.count>1) {
    //        _g1oodsModel=[[goodsModel alloc]initWithDictionary:arr[1] error:nil];
    //        UIButton *imgBtn=[[UIButton alloc]initWithFrame:CGRectMake(cell.frame.size.width-42, 0, 42, 50)];
    //        //        [imgBtn setBackgroundImage:[UIImage imageNamed:@"loginBackView"] forState:UIControlStateNormal]
    //        //        ;
    //        //        img.backgroundColor=[UIColor redColor];
    //        [imgBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://injia-dev.image.alimmdn.com",_g1oodsModel.imgs[0]]] forState:UIControlStateNormal  placeholderImage:[UIImage imageNamed:@"默认"]];
    //
    //        imgBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //        imgBtn.tag=indexPath.row;
    //        [imgBtn addTarget:self action:@selector(chooseImg:) forControlEvents:UIControlEventTouchUpInside];
    //        [cell.contentView addSubview:imgBtn];
    //    }
    UILabel *styleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-40, cell.frame.size.width, 40)];
    styleLab.font=[UIFont systemFontOfSize:17.f];
    styleLab.textAlignment=NSTextAlignmentCenter;
    styleLab.backgroundColor=UIColorFromRGB(0xf0f0f0);
    if ([[dic objectForKey:@"type"] integerValue]==0) {
    styleLab.text=[NSString stringWithFormat:@"%ld %@",(long)indexPath.row+1,[[dic objectForKey:@"target"] objectForKey:@"name"]];
    }else{
    styleLab.text=[NSString stringWithFormat:@"%ld %@",(long)indexPath.row+1,[[dic objectForKey:@"target"] objectForKey:@"case_name"]];
    }
    //
    [cell.contentView addSubview:img];
    //    //    [cell.contentView addSubview:titleLab];
    [cell.contentView addSubview:styleLab];
    //    cell.backgroundColor = [UIColor lightGrayColor];
    
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)album:(UIGestureRecognizer *)gesture
{
//    NSLog(@"局部放大");
    _imageArr=[[NSMutableArray alloc]init];
    UIImageView *imageView = (UIImageView *)gesture.view;
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic=_dataArr[imageView.tag];
    if([[dic objectForKey:@"type"] integerValue]==0){
        for (NSString *str in [[dic objectForKey:@"target"] objectForKey:@"imgs"]) {
        [_imageArr addObject:[NSString stringWithFormat:@"%@%@",@"http://injia-dev.image.alimmdn.com",str]];
        }
        album = [[MickeyAlbum1 alloc]initWithImgUrlArr:_imageArr CurPage:0];
        album.photoFrame = imageView.frame;
        [self.navigationController presentViewController:album animated:YES completion:nil];
    }else{
        [_imageArr addObject:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",[[dic objectForKey:@"target"]objectForKey:@"case_pics"]]];
            album1 = [[MickeyAlbum2 alloc]initWithImgUrlArr:_imageArr CurPage:0];
            album1.photoFrame = imageView.frame;
            [self.navigationController presentViewController:album1 animated:YES completion:nil];
    }
    // UIImageView *imageView = (UIImageView *)gesture.view;
//    for (NSString *str in _goodsFrunitureModel.imgs) {
//        [_imageArr addObject:[NSString stringWithFormat:@"%@%@",@"http://injia-dev.image.alimmdn.com",str]];
//    }
//    album = [[MickeyAlbum1 alloc]initWithImgUrlArr:_imageArr CurPage:0];
//    album.photoFrame = imageView.frame;
//    [self.navigationController presentViewController:album animated:YES completion:nil];
}

@end
