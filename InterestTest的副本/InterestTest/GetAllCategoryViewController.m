//
//  GetAllCategoryViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/3/29.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "GetAllCategoryViewController.h"
#import "SWRevealViewController.h"
#import "CategoryTableViewCell.h"
#import "RootHttpHelper.h"
#import "CategorysGoodsViewController.h"
#import "NewLoginViewController.h"

@interface GetAllCategoryViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    SWRevealViewController *revealController;
//    UITableView *table;
}
@property(nonatomic,strong)NSMutableArray *dataInfoArr;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property (strong, nonatomic) UICollectionView *collection;
@end
//好友
static NSString *ReverseCellName = @"ILikeCollectionViewCell";

@implementation GetAllCategoryViewController
-(void)initView
{
    
    _goodDetailView.backgroundColor=UIColorFromRGB(0xffffff);
    //初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置滚动方向
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collection.showsVerticalScrollIndicator = FALSE;
    _collection.showsHorizontalScrollIndicator = FALSE;
    
    //初始化collectionView
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0,48, SCREEN_WIDTH/5*3,  SCREEN_HEIGHT) collectionViewLayout:layout];
    //代理指向自己
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.showsVerticalScrollIndicator = NO;
    _collection.backgroundColor = [UIColor clearColor];
    //注册cell
    [_collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ReverseCellName];
    
    //下拉刷新
//    [_collection addHeaderWithTarget:self action:@selector(fetchData) dateKey:@"SailorTable"];
//    [_collection addFooterWithTarget:self action:@selector(fetchMoreData) ];
//    [_collection headerBeginRefreshing];
//    _collection.headerPullToRefreshText = headerPullToRefreshText;
//    _collection.headerReleaseToRefreshText = headerReleaseToRefreshText;
//    _collection.headerRefreshingText = headerRefreshingText;
    
    
    
    [_goodDetailView addSubview:_collection];
    [_collection reloadData];
    
}
-(void)fetchData
{
    
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
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBarHidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLab.text=@"添加商品";
    self.view.backgroundColor=UIColorFromRGB(0xf8f8f8);
    
    revealController = [self revealViewController];
    
    //设置按钮
    UIButton *_setBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _setBut.frame = CGRectMake(20, 30, 11, 20);
    [_setBut addTarget: self action: @selector(back) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:_setBut];
//    UIBarButtonItem *setItem = [[UIBarButtonItem alloc]initWithCustomView:_setBut];
//    [_setBut setTitle:@"返回" forState:UIControlStateNormal];
    [_setBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_setBut setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    NSMutableArray *buttonItems = [NSMutableArray array];
//    [buttonItems addObject:setItem];
//    self.navigationItem.leftBarButtonItems = buttonItems;
    
//    //设置按钮
//    UIButton *next = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    next.frame = CGRectMake(SCREEN_WIDTH-60, 28, 60, 30);
//    [next addTarget: self action: @selector(nextstep) forControlEvents: UIControlEventTouchUpInside];
//    [self.view addSubview:next];
//    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc]initWithCustomView:next];
//    [next setTitle:@"下一步" forState:UIControlStateNormal];
//    [next setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    NSMutableArray *buttonItems1 = [NSMutableArray array];
    //    [buttonItems1 addObject:nextItem];
    //    self.navigationItem.rightBarButtonItems = buttonItems1;
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
    
     _table.delegate=self;
     _table.dataSource=self;
     _table.rowHeight=117.0;
     _table.showsVerticalScrollIndicator = NO;
//     UIView *footView=[[UIView alloc]init];
     _table.backgroundColor=UIColorFromRGB(0xf8f8f8);
//     _table.tableFooterView=footView;
    
    [self getCategoryDate];
    
    [self initView];
    

    // Do any additional setup after loading the view from its nib.
}
-(void)getdate:(NSString *)strid{
    _dataArr=[[NSMutableArray alloc]init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:strid forKey:@"category_id"];
    
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"categories" andParams:params andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
            _dataArr=[successData objectForKey:@"data"];
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
- (void)getCategoryDate{
    _dataInfoArr=[[NSMutableArray alloc]init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_cateGoryid forKey:@"category_id"];
 
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"categories" andParams:params andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
            _dataInfoArr=[successData objectForKey:@"data"];
            [_table reloadData];
            [self getdate:[_dataInfoArr[0] objectForKey:@"id"]];

            
        }else{
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
//设置每个分组下tableview的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSMutableArray *data=[[NSMutableArray alloc]init];
//    data=_dataInfoArr[section];
    return _dataInfoArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SearchHistoryCellName = @"CategoryTableViewCell";
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchHistoryCellName];
    if (!cell) {
         cell= [[[NSBundle mainBundle] loadNibNamed:SearchHistoryCellName owner:nil options:nil] lastObject];
    }
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic=_dataInfoArr[indexPath.row];
    cell.name.text = [dic objectForKey:@"name"];
    [cell.bgImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://injia-dev.image.alimmdn.com",[dic objectForKey:@"banner"]]] placeholderImage:[UIImage imageNamed:@"默认"]];

       return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic=_dataInfoArr[indexPath.row];
    [self getdate:[dic objectForKey:@"id"]];
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
    
    return CGSizeMake((SCREEN_WIDTH/5*3-160)/3,(SCREEN_WIDTH/5*3-160)/3/4*5);
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

    cell.backgroundColor=[UIColor whiteColor];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    img=[[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width/2-144/2, 0, 144, 234/2)];
    [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://injia-dev.image.alimmdn.com",[dic objectForKey:@"banner"]]] placeholderImage:[UIImage imageNamed:@"默认"]];
    img.contentMode = UIViewContentModeScaleAspectFit;
    img.tag=indexPath.row;
    img.userInteractionEnabled = YES;

    UILabel *styleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-60, cell.frame.size.width, 60)];
    styleLab.font=[UIFont systemFontOfSize:17.f];
    styleLab.textAlignment=NSTextAlignmentCenter;
//    styleLab.backgroundColor=UIColorFromRGB(0xf0f0f0);
    styleLab.text=[NSString stringWithFormat:@"%ld %@",(long)indexPath.row+1,[dic objectForKey:@"name"]];
//
    styleLab.textColor=UIColorFromRGB(0x808080);
    [cell.contentView addSubview:img];
//    //    [cell.contentView addSubview:imgBtn];
//    //    [cell.contentView addSubview:titleLab];
    [cell.contentView addSubview:styleLab];
    //    cell.backgroundColor = [UIColor lightGrayColor];
    
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic=_dataArr[indexPath.row];
    CategorysGoodsViewController *good=[[CategorysGoodsViewController alloc]init];
    good.cateId=[dic objectForKey:@"id"];
    good.name=[dic objectForKey:@"name"];
    good.type=_type;
    [self.navigationController pushViewController:good animated:YES];
}

@end
