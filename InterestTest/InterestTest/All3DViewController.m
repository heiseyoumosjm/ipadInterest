//
//  All3DViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/3/27.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "All3DViewController.h"
#import "SWRevealViewController.h"
#import "RootHttpHelper.h"
#import "GenerateReportViewController.h"
#import "AllPictureModel.h"
#import "ScenePicture.h"
#import "NewLoginViewController.h"
@interface All3DViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

{
    SWRevealViewController *revealController;
}
@property (strong, nonatomic) UICollectionView *collection;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSMutableArray *btndataArr;
@property (strong, nonatomic) NSMutableArray *choosebtndataArr;
@property (strong, nonatomic) AllPictureModel *allPictureModel;
@end

//好友
static NSString *ReverseCellName = @"ILikeCollectionViewCell";

@implementation All3DViewController
-(void)initView
{
    
    //初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置滚动方向
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collection.showsVerticalScrollIndicator = FALSE;
    _collection.showsHorizontalScrollIndicator = FALSE;
    
    //初始化collectionView
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  SCREEN_HEIGHT-64) collectionViewLayout:layout];
    //代理指向自己
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.showsVerticalScrollIndicator = NO;
    _collection.backgroundColor = [UIColor whiteColor];
    //注册cell
    [_collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ReverseCellName];
    
    //下拉刷新
//    [_collection addHeaderWithTarget:self action:@selector(fetchData) dateKey:@"SailorTable"];
//    [_collection addFooterWithTarget:self action:@selector(fetchMoreData) ];
//    [_collection headerBeginRefreshing];
    _collection.headerPullToRefreshText = headerPullToRefreshText;
    _collection.headerReleaseToRefreshText = headerReleaseToRefreshText;
    _collection.headerRefreshingText = headerRefreshingText;
    
    
    
    [self.view addSubview:_collection];
    [self fetchData];
//    [_collection reloadData];
    
}
-(void)fetchData
{
    _dataArr=[[NSMutableArray alloc]init];
    _btndataArr=[[NSMutableArray alloc]init];
    _choosebtndataArr=[[NSMutableArray alloc]init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *pad_user_room_function_id=[userDefaultes stringForKey:@"pad_user_room_function_id"];
    [params setValue:pad_user_room_function_id forKey:@"pad_user_room_id"];
    
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"product-goods/user-scene-picture" andParams:params andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
//            _dataArr=[successData objectForKey:@"data"];
            for (NSDictionary *dic in [successData objectForKey:@"data"]) {
                _allPictureModel=[[AllPictureModel alloc]initWithDictionary:dic error:nil];
                _allPictureModel.is_like=@"1";
                [_dataArr addObject:_allPictureModel];
            }
            
            [UIView performWithoutAnimation:^{
                [self.collection reloadData];
            }];
        }else if ([[successData objectForKey:@"api_code"] integerValue]==401){
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
    
        [UIView performWithoutAnimation:^{
            [self.collection reloadData];
        }];
    
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
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"最终确认";
    
    //发通知侧边栏可以点击展开测试结果界面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLeft3" object:nil];
    
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
    
    
    //设置按钮
    UIButton *next = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    next.frame = CGRectMake(20, 0, 60, 30);
    [next addTarget: self action: @selector(nextStep) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc]initWithCustomView:next];
    [next setTitle:@"下一步" forState:UIControlStateNormal];
    [next setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSMutableArray *buttonItems1 = [NSMutableArray array];
    [buttonItems1 addObject:nextItem];
    self.navigationItem.rightBarButtonItems = buttonItems1;
    //
    
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    [self initView];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)nextStep{
    for (AllPictureModel *model in _dataArr) {
        if ([model.is_like integerValue]==1) {
           [_choosebtndataArr addObject:model.id];
        }
    }
    if(_choosebtndataArr.count>0){
    GenerateReportViewController *next=[[GenerateReportViewController alloc]init];
    next.dataArr=_choosebtndataArr;
    [self.navigationController pushViewController:next animated:YES];
    }else{
    [[HudHelper hudHepler] showTips:self.view tips:@"请至少选择一个您满意的效果图！"];
    }
    
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
    return UIEdgeInsetsMake(28, 75, 28, 75);
    
    
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
    return 28;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   // _allPictureModel=[[AllPictureModel alloc]initWithDictionary:_dataArr[indexPath.row] error:nil];
    UIImageView *img;
//    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
////    dic=[_dataArr[indexPath.row]objectForKey:@"scenePicture" ];
    _allPictureModel=_dataArr[indexPath.row];
    
    //    UILabel *titleLab;
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ReverseCellName forIndexPath:indexPath];
    
    //    cell.contentView.layer.masksToBounds=YES;
    //    cell.contentView.layer.cornerRadius=5;
//    cell.contentView.backgroundColor=colorHead;
//
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
     UIButton *likeBtn=[[UIButton alloc]initWithFrame:CGRectMake(cell.frame.size.width-56, 15, 36, 36)];
     likeBtn.tag=indexPath.row;
//    likeBtn.selected=YES;
//    [likeBtn setBackgroundImage:[UIImage imageNamed:@"choosed1"] forState:UIControlStateSelected];
    if ([_allPictureModel.is_like integerValue]==1) {
        [likeBtn setBackgroundImage:[UIImage imageNamed:@"choosed1"] forState:UIControlStateNormal];
    }else{
        [likeBtn setBackgroundImage:[UIImage imageNamed:@"choose1"] forState:UIControlStateNormal];
    }
//    likeBtn.selected=YES;
//    [likeBtn setBackgroundImage:[UIImage imageNamed:@"choosed1"] forState:UIControlStateSelected];
//    [likeBtn setBackgroundImage:[UIImage imageNamed:@"gouxuan"] forState:UIControlStateSelected];
   // [_btndataArr addObject:likeBtn];
//     likeBtn.selected=YES;
    [likeBtn addTarget:self action:@selector(likeChange:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.contentView addSubview:likeBtn];
//    [_choosebtndataArr addObject:[_dataArr[indexPath.row]objectForKey:@"id" ]];
//    if ([_allPictureModel.is_like integerValue]==1) {
//         [likeBtn setBackgroundImage:[UIImage imageNamed:@"choosed1"] forState:UIControlStateNormal];
//    }else{
//         [likeBtn setBackgroundImage:[UIImage imageNamed:@"choose1"] forState:UIControlStateNormal];
//    }
    //    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, cell.frame.size.width-60, cell.frame.size.width, 60)];
    //    titleView.backgroundColor=[UIColor whiteColor];
    //    [cell.contentView addSubview:titleView];
    
    ScenePicture *scenePicture=_allPictureModel.scenePicture;
    img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",scenePicture.flat_img]] placeholderImage:[UIImage imageNamed:@"默认"]];
    img.contentMode=UIViewContentModeScaleAspectFill;
    img.clipsToBounds=YES;
//     img.contentMode = UIViewContentModeScaleAspectFit;
//     img.clipsToBounds = YES; // 裁剪边缘
    
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
    for (int i=0; i<_dataArr.count; i++) {
        if (i==btn1.tag) {
             _allPictureModel=_dataArr[i];
            if ([_allPictureModel.is_like integerValue]==0) {
               _allPictureModel.is_like=@"1";
            }else{
               _allPictureModel.is_like=@"0";
            }
            _dataArr[i]=_allPictureModel;
        }
    }
    [_collection reloadData];
//    btn1.selected=!btn1.selected;
//    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//    dic=[_dataArr[btn1.tag]objectForKey:@"scenePicture" ];
//    if (btn1.selected) {
//        [btn1 setBackgroundImage:[UIImage imageNamed:@"choosed1"] forState:UIControlStateNormal];
//        _allPictureModel=[[AllPictureModel alloc]initWithDictionary:_dataArr[btn1.tag] error:nil];
//        _allPictureModel.is_like=@"0";
//        [_collection reloadData];
//        
//        [_choosebtndataArr addObject:[_dataArr[btn1.tag]objectForKey:@"id" ]];
//    }else{
//        _allPictureModel=[[AllPictureModel alloc]initWithDictionary:_dataArr[btn1.tag] error:nil];
//        _allPictureModel.is_like=@"1";
//        [_collection reloadData];
//        [btn1 setBackgroundImage:[UIImage imageNamed:@"choose1"] forState:UIControlStateNormal];
//                            if ([_choosebtndataArr containsObject:[_dataArr[btn1.tag]objectForKey:@"id" ]]) {
//                              [_choosebtndataArr removeObject:[_dataArr[btn1.tag]objectForKey:@"id" ]];
//                            }
//
//        
//    }
    
//        UIButton *btn=_btndataArr[btn.tag];
//        btn.selected=!btn.selected;
//        if (btn.selected) {
//            btn.backgroundColor=[UIColor blueColor];
//           [btn setBackgroundImage:[UIImage imageNamed:@"gouxuan"] forState:UIControlStateNormal];
//        }
//        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//        dic=[_dataArr[indexPath.row]objectForKey:@"scenePicture" ];
//        for (UIButton *btn in _btndataArr) {
//            if (btn.tag==indexPath.row) {
//                btn.selected=!btn.selected;
//                if (btn.selected) {
//                    [btn setBackgroundImage:[UIImage imageNamed:@"choosed1"] forState:UIControlStateNormal];
//                    [_choosebtndataArr addObject:[_dataArr[indexPath.row]objectForKey:@"id" ]];
//    
//                }else{
//                    [btn setBackgroundImage:[UIImage imageNamed:@"choose1"] forState:UIControlStateNormal];
//                    if ([_choosebtndataArr containsObject:[_dataArr[indexPath.row]objectForKey:@"id" ]]) {
//                      [_choosebtndataArr removeObject:[_dataArr[indexPath.row]objectForKey:@"id" ]];
//                    }
//                    
//                }
//            }else{
//    
//            }
//        }
//
    
}
-(void)chooseImg:(UIButton *)btn{
    
    
    
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UIButton *btn=_btndataArr[indexPath.row];
//    btn.selected=!btn.selected;
//    if (btn.selected) {
//        btn.backgroundColor=[UIColor blueColor];
//       [btn setBackgroundImage:[UIImage imageNamed:@"gouxuan"] forState:UIControlStateNormal];
//    }
//    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//    dic=[_dataArr[indexPath.row]objectForKey:@"scenePicture" ];
//    for (UIButton *btn in _btndataArr) {
//        if (btn.tag==indexPath.row) {
//            btn.selected=!btn.selected;
//            if (btn.selected) {
//                [btn setBackgroundImage:[UIImage imageNamed:@"choosed1"] forState:UIControlStateNormal];
//                [_choosebtndataArr addObject:[_dataArr[indexPath.row]objectForKey:@"id" ]];
//                
//            }else{
//                [btn setBackgroundImage:[UIImage imageNamed:@"choose1"] forState:UIControlStateNormal];
//                if ([_choosebtndataArr containsObject:[_dataArr[indexPath.row]objectForKey:@"id" ]]) {
//                  [_choosebtndataArr removeObject:[_dataArr[indexPath.row]objectForKey:@"id" ]];
//                }
//                
//            }
//        }else{
//
//        }
//    }
//    [_collection reloadData];
    
}

@end
