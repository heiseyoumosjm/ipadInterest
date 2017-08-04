//
//  AnLiViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/5/10.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "AnLiViewController.h"
#import "SWRevealViewController.h"
#import "RootHttpHelper.h"
#import "NewLoginViewController.h"
#import "CategoryTableViewCell.h"
#import "AllAnLiViewController.h"
@interface AnLiViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    SWRevealViewController *revealController;
    //    UITableView *table;
    
}
@property(nonatomic,strong)NSMutableArray *dataInfoArr;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property (strong, nonatomic) UICollectionView *collection;
@property(nonatomic,strong)NSMutableArray *dataIdArr;
//@property (assign, nonatomic) NSInteger page;
@end

//好友
static NSString *ReverseCellName = @"ILikeCollectionViewCell";

@implementation AnLiViewController

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
    _titleLab.text=@"案例";
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
    _dataIdArr=[[NSMutableArray alloc]init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:strid forKey:@"building_id"];
    
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"building/building-folder" andParams:params andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
            _dataArr=[successData objectForKey:@"data"];
            for (NSDictionary *dic in _dataArr) {
//                if ([[dic objectForKey:@"folder_name"]isEqualToString:@"全部"]) {
//                    
//                }else{
                   [_dataIdArr addObject:[dic objectForKey:@"id"]];
//                }
                
            }
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
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:@"42" forKey:@"category_id"];
    
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"building/index" andParams:nil andSuccess:^(NSDictionary *successData) {
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
    cell.name.text = [dic objectForKey:@"building_name"];
    [cell.bgImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",[dic objectForKey:@"pic"]]] placeholderImage:[UIImage imageNamed:@"默认"]];
    
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
    
    return CGSizeMake((SCREEN_WIDTH/5*3-160)/3,(SCREEN_WIDTH/5*3-160)/3/4*6.5);
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
    UIImageView *img1;
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ReverseCellName forIndexPath:indexPath];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic=_dataArr[indexPath.row];
    
    cell.backgroundColor=[UIColor whiteColor];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    img=[[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width/2-342/2/2, 0, 342/2, 409/2)];
    img.image=[UIImage imageNamed:@"ty"];
//    [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",[dic objectForKey:@"folder_pic"]]] placeholderImage:[UIImage imageNamed:@"默认"]];
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.tag=indexPath.row;
    img.layer.masksToBounds=YES;
    img.userInteractionEnabled = YES;
    
    img1=[[UIImageView alloc]initWithFrame:CGRectMake(1, 1, 342/2-2, 409/2-2)];
//    img1.image=[UIImage imageNamed:@"ty"];
    [img1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",[dic objectForKey:@"folder_pic"]]] placeholderImage:[UIImage imageNamed:@"默认"]];
    img1.contentMode = UIViewContentModeScaleAspectFill;
    img1.tag=indexPath.row;
    img1.layer.masksToBounds=YES;
    img1.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(album:)];
    [img addGestureRecognizer:tap];
  //       img.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
//         img.layer.shadowOffset = CGSizeMake(0,30);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//         img.layer.shadowOpacity = 0.2;//阴影透明度，默认0
//         img.layer.shadowRadius = 100;//阴影半径，默认3
    
    UILabel *styleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-30, cell.frame.size.width, 30)];
    styleLab.font=[UIFont systemFontOfSize:17.f];
    styleLab.textAlignment=NSTextAlignmentCenter;
    //    styleLab.backgroundColor=UIColorFromRGB(0xf0f0f0);
    styleLab.text=[NSString stringWithFormat:@"%ld %@",(long)indexPath.row+1,[dic objectForKey:@"folder_name"]];
    //
    styleLab.textColor=UIColorFromRGB(0x333333  );
    [cell.contentView addSubview:img];
    [img addSubview:img1];
    //    //    [cell.contentView addSubview:imgBtn];
    //    //    [cell.contentView addSubview:titleLab];
    [cell.contentView addSubview:styleLab];
    //    cell.backgroundColor = [UIColor lightGrayColor];
    
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic=_dataArr[indexPath.row];
        AllAnLiViewController *good=[[AllAnLiViewController alloc]init];
        good.cateId=[dic objectForKey:@"id"];
        good.name=[dic objectForKey:@"name"];
        good.type=_type;
        good.IdDateArr=_dataIdArr;
        good.postion=indexPath.row;
        [self.navigationController pushViewController:good animated:YES];
}
-(void)album:(UIGestureRecognizer *)gesture
{
    UIImageView *imageView = (UIImageView *)gesture.view;
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic=_dataArr[imageView.tag];
    AllAnLiViewController *good=[[AllAnLiViewController alloc]init];
    good.cateId=[dic objectForKey:@"id"];
    good.name=[dic objectForKey:@"name"];
    good.type=_type;
    good.IdDateArr=_dataIdArr;
    good.postion=imageView.tag;
    [self.navigationController pushViewController:good animated:YES];
    
}

@end
