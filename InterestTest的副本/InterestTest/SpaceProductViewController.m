//
//  SpaceProductViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/3/8.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "SpaceProductViewController.h"
#import "SWRevealViewController.h"
#import "ChangeRoomViewController.h"
#import "RoomColorViewController.h"
#import "ChooseSpaceProductViewController.h"
#import "RootHttpHelper.h"
#import "RoomLayoutModel.h"
#import "RoomProductModel.h"
#import "goodsModel.h"
#import "ProductionModel.h"
#import "roomModel.h"
#import "SceneModel.h"
#import "MickeyAlbum1.h"
#import "UIImageView+RotateImgV.h"
#import "NewLoginViewController.h"

@interface SpaceProductViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ChangeLayoutDelegate,ChangeGoodsDelegate>
{
    SWRevealViewController *revealController;
    MickeyAlbum1 * album;
}
@property(nonatomic,strong)RoomLayoutModel *roomLayoutModel;
@property(nonatomic,strong)RoomProductModel *roomProductModel;
@property(nonatomic,strong)goodsModel *g1oodsModel;
@property(nonatomic,strong)roomModel *roomModel1;
@property(nonatomic,strong)SceneModel *sceneModel;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSMutableArray *goodIdArr;
@property(nonatomic,strong)NSMutableArray *goodPositionArr;
@property(nonatomic,strong)NSMutableArray *imageArr;
@property(nonatomic,strong)ProductionModel *productionModel;
@property(nonatomic,strong)NSString  *changeLayoutId;
@end
//好友
static NSString *ReverseCellName = @"ILikeCollectionViewCell";

@implementation SpaceProductViewController

-(void)initView
{
    
    _goodsView.backgroundColor=UIColorFromRGB(0xf0f0f0);
    //初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置滚动方向
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collection.showsVerticalScrollIndicator = FALSE;
    _collection.showsHorizontalScrollIndicator = FALSE;
    
    //初始化collectionView
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH*73/100,  SCREEN_HEIGHT-64) collectionViewLayout:layout];
    //代理指向自己
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.showsVerticalScrollIndicator = NO;
    _collection.backgroundColor = [UIColor clearColor];
    //注册cell
    [_collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ReverseCellName];
    
    
    [self fetchData];
   
    [_goodsView addSubview:_collection];
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

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBarHidden=YES;
//   [self getRoomLayout];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor=UIColorFromRGB(0xffffff);
     revealController = [self revealViewController];
     self.title=@"空间产品";
     self.navigationController.navigationBarHidden=YES;
    
    
    //发通知侧边栏可以点击展开测试结果界面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLeft2" object:_roomDataArr];
    
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//     self.navigationController.navigationBar.translucent = true;
//    //去掉透明后导航栏下边的黑边
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    //设置按钮
    UIButton *_setBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _setBut.frame = CGRectMake(20, 28, 14, 11);
    [_setBut addTarget: revealController action: @selector(revealToggle:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:_setBut];
    UIBarButtonItem *setItem = [[UIBarButtonItem alloc]initWithCustomView:_setBut];
    [_setBut setBackgroundImage:[UIImage imageNamed:@"menu1"] forState:UIControlStateNormal];
    NSMutableArray *buttonItems = [NSMutableArray array];
//    [buttonItems addObject:setItem];
//    self.navigationItem.leftBarButtonItems = buttonItems;
    
    
    //设置按钮
    UIButton *next = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    next.frame = CGRectMake(SCREEN_WIDTH-80, 28, 60, 30);
    [next addTarget: self action: @selector(nextstep) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:next];
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc]initWithCustomView:next];
    [next setTitle:@"下一步" forState:UIControlStateNormal];
    [next setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSMutableArray *buttonItems1 = [NSMutableArray array];
//    [buttonItems1 addObject:nextItem];
//    self.navigationItem.rightBarButtonItems = buttonItems1;
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    //获取房间的布局列表
    [self getRoomLayout];
    
    [self initView];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)getProduct:(RoomProductModel *)model{
    _dataArr=[[NSMutableArray alloc]init];
    _goodIdArr=[[NSMutableArray alloc]init];
    _goodPositionArr=[[NSMutableArray alloc]init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _roomModel1=[[roomModel alloc]initWithDictionary:[_roomDataArr[[_index integerValue]] objectForKey:@"roomFunction"] error:nil];
    [params setValue:_changeLayoutId forKey:@"pad_user_room_product_id"];

    
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"product-goods/goods" andParams:params andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
            _dataArr=[successData objectForKey:@"data"];
//            NSMutableArray *goodid=[[NSMutableArray alloc]initWithArray:_dataArr[0]];
            for (NSMutableArray *ARR in _dataArr) {
             NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
             dic=ARR[0];
             [_goodIdArr addObject:[dic objectForKey:@"id"]];
             [_goodPositionArr addObject:[dic objectForKey:@"position"]];
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
        }else{
            [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
        }
        
    } andError:^(NSError *error) {
        //加载圈圈(显示)
        [[HudHelper hudHepler] HideHUDAlert:self.view];
        NSLog(@"%@",error);
    }];

}
//获取房间的布局接口
- (void)getRoomLayout{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    self.name.text=[NSString stringWithFormat:@"%@",[[_roomDataArr[[_index integerValue]] objectForKey:@"roomFunction"]objectForKey:@"room_name"]];
    [params setValue:[_roomDataArr[[_index integerValue]] objectForKey:@"id"] forKey:@"pad_user_room_function_id"];
   
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"product-goods" andParams:params andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
            _roomLayoutModel=[[RoomLayoutModel alloc]initWithDictionary:successData error:nil];

            for (int i=0; i<_roomLayoutModel.data.count; i++) {
                _roomProductModel=[[RoomProductModel alloc]init];
                _roomProductModel=_roomLayoutModel.data[i];
                
                switch (i) {
                    case 0:
                    {
                       
                        _leftHeight.constant=[_roomProductModel.img_height integerValue] *(SCREEN_WIDTH*0.27-80)/[_roomProductModel.img_width integerValue];
                        [_ImgLeft sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",_roomProductModel.recommended_layout]] placeholderImage:[UIImage imageNamed:@"默认"]];

                    }
                        break;
                    case 1:
                    {
                          _topHeight.constant=[_roomProductModel.img_width floatValue] *90/[_roomProductModel.img_height floatValue];
                        [_ImgTop sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",_roomProductModel.recommended_layout]] placeholderImage:[UIImage imageNamed:@"默认"]];
                         _ImgTop.contentMode = UIViewContentModeScaleAspectFit;
                    }
                        
                        break;
                    case 2:
                    {
                          _midHeight.constant=[_roomProductModel.img_width floatValue] *90/[_roomProductModel.img_height floatValue];
                        [_ImgMid sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",_roomProductModel.recommended_layout]] placeholderImage:[UIImage imageNamed:@"默认"]];
                         _ImgMid.contentMode = UIViewContentModeScaleAspectFit;
                        
                    }
                        
                        break;
                    case 3:
                    {
                        [_ImgBottom sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",_roomProductModel.recommended_layout]] placeholderImage:[UIImage imageNamed:@"默认"]];
                         _ImgBottom.contentMode = UIViewContentModeScaleAspectFit;
                    }
                        
                        break;
                        
                    default:
                        break;
                }
               
            }
            
            if (_roomLayoutModel.data.count>0) {
            //设置布局
            RoomProductModel *model=_roomLayoutModel.data[0];
            NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
            [params1 setValue:[_roomDataArr[[_index integerValue]] objectForKey:@"id"] forKey:@"pad_user_room_function_id"];
            [params1 setValue:model.id forKey:@"room_product_id"];
            
            [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"product-goods/set-product-goods" andParams:params1 andSuccess:^(NSDictionary *successData) {
                //            //加载圈圈(显示)
                if ([[successData objectForKey:@"api_code"] integerValue]==200) {
         
                    _changeLayoutId=[successData objectForKey:@"id"];
      
                    if (_roomLayoutModel.data.count>0) {
                        [self getProduct:_roomLayoutModel.data[0]];
                    }
                    //            
                    
                }else{
                    [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
                }
                
            } andError:^(NSError *error) {
                //加载圈圈(显示)
                [[HudHelper hudHepler] HideHUDAlert:self.view];
                NSLog(@"%@",error);
            }];
            
            
        }else{
            [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
        }
        }
        
    } andError:^(NSError *error) {
        //加载圈圈(显示)
        [[HudHelper hudHepler] HideHUDAlert:self.view];
        NSLog(@"%@",error);
    }];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)nextstep{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_changeLayoutId forKey:@"pad_user_room_product_id"];
    [params setValue:_goodIdArr  forKey:@"goods_model_ids"];
    [params setValue:_goodPositionArr  forKey:@"positions"];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *colorid=[userDefaultes stringForKey:@"colorid"];
    if ([self isBlankString:colorid]) {
        
    }else{
    [params setValue:colorid  forKey:@"scene_color_id"];
    }
    
    [[RootHttpHelper httpHelper] postAchieveListParamsURL1:@"product-goods/set-goods-model" andParams:params andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
            _sceneModel=[[SceneModel alloc]initWithDictionary:[successData objectForKey:@"scenePicture"] error:nil];
            if (_sceneModel) {
                NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                [defaults setObject:_sceneModel.scene_color_id forKey:@"colorid"];
                [defaults synchronize];
//                _sceneModel=[[SceneModel alloc]initWithDictionary:successData error:nil];
                RoomColorViewController *color=[[RoomColorViewController alloc]init];
                color.sceneModel=_sceneModel;
                color.roomDataArr=_roomDataArr;
                color.index=_index;
                color.colorId=[successData objectForKey:@"id"];
                color.picindex=_picindex;
                [self.navigationController pushViewController:color animated:YES];
            }else{
               [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"暂无场景图"]];
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


- (IBAction)ChangeUnit:(UIButton *)sender {
    ChangeRoomViewController *change=[[ChangeRoomViewController alloc]init];
    change.roomLayoutModel=_roomLayoutModel;
    change.roomDataArr=_roomDataArr;
    change.index=_index;
    change.delegate=self;
    [self.navigationController pushViewController:change animated:YES];
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
    
    return CGSizeMake((SCREEN_WIDTH*73/100-160)/3,(SCREEN_WIDTH*73/100-160)/3/3*4);
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
    NSMutableArray *arr=[[NSMutableArray alloc]initWithArray:_dataArr[indexPath.row]];
    if (arr.count>0) {
     _g1oodsModel=[[goodsModel alloc]initWithDictionary:arr[0] error:nil];
    

    cell.backgroundColor=[UIColor whiteColor];
    
    
   
    img=[[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width/2-144/2, 60, 144, 234/2)];
//   [img rotate360DegreeWithImageView];
    [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://injia-dev.image.alimmdn.com",_g1oodsModel.imgs[0]]] placeholderImage:[UIImage imageNamed:@"默认"]];
     img.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(album:)];
    img.tag=indexPath.row;
    img.userInteractionEnabled = YES;
    [img addGestureRecognizer:tap];
    }

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
    
    
    NSMutableDictionary *categorydic=_g1oodsModel.category;
//    titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 234/2+10, cell.frame.size.width, 35)];
//    titleLab.font=[UIFont systemFontOfSize:17.f];
//    titleLab.textAlignment=NSTextAlignmentLeft;
////    titleLab.backgroundColor=[UIColor lightGrayColor];
//    titleLab.text=[NSString stringWithFormat:@"      %@",[categorydic objectForKey:@"name"]];
    for (UILabel *lab in cell.contentView.subviews) {
        [lab removeFromSuperview];
    }
    if (arr.count>1) {
        _g1oodsModel=[[goodsModel alloc]initWithDictionary:arr[1] error:nil];
        UIButton *imgBtn=[[UIButton alloc]initWithFrame:CGRectMake(cell.frame.size.width-42-5, 5, 42, 50)];
//        [imgBtn setBackgroundImage:[UIImage imageNamed:@"loginBackView"] forState:UIControlStateNormal]
//        ;
//        img.backgroundColor=[UIColor redColor];
        [imgBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://injia-dev.image.alimmdn.com",_g1oodsModel.imgs[0]]] forState:UIControlStateNormal  placeholderImage:[UIImage imageNamed:@"默认"]];
        
        imgBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        imgBtn.tag=indexPath.row;
        [imgBtn addTarget:self action:@selector(chooseImg:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:imgBtn];
    }
    UILabel *styleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-35, cell.frame.size.width, 35)];
    styleLab.font=[UIFont systemFontOfSize:17.f];
    styleLab.textAlignment=NSTextAlignmentCenter;
    styleLab.backgroundColor=UIColorFromRGB(0xf0f0f0);
    if([_g1oodsModel.name isEqualToString:@"地毯"])
    {
        styleLab.text=[NSString stringWithFormat:@"%ld 地毯",(long)indexPath.row+1];
        
    }else if ([_g1oodsModel.name isEqualToString:@"窗帘"]){
        styleLab.text=[NSString stringWithFormat:@"%ld 窗帘",(long)indexPath.row+1];
    }else{
        styleLab.text=[NSString stringWithFormat:@"%ld %@",(long)indexPath.row+1,[categorydic objectForKey:@"name"]];
    }
  
    [cell.contentView addSubview:img];
//    [cell.contentView addSubview:imgBtn];
//    [cell.contentView addSubview:titleLab];
    [cell.contentView addSubview:styleLab];
    //    cell.backgroundColor = [UIColor lightGrayColor];
    
    return cell;
    
}
-(void)chooseImg:(UIButton *)btn{
    NSMutableArray *arr=[[NSMutableArray alloc]initWithArray:_dataArr[btn.tag]];
    _g1oodsModel=[[goodsModel alloc]initWithDictionary:arr[0] error:nil];
    ChooseSpaceProductViewController *choose=[[ChooseSpaceProductViewController alloc]init];
    choose.goods_id=_g1oodsModel.id;
    choose.delegate=self;
    choose.position=_g1oodsModel.position;
     _roomProductModel=_roomLayoutModel.data[0];
    choose.layout_id_unband=_roomProductModel.id;
    choose.layout_id=_changeLayoutId;
    [self.navigationController pushViewController:choose animated:YES];
    
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)ChangeGoods:(NSString *)layoutid{
    
   [self getProduct:_roomLayoutModel.data[0]];
    
}
-(void)ChangeLayout:(NSString *)layoutid{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    self.name.text=[NSString stringWithFormat:@"%@",[[_roomDataArr[[_index integerValue]] objectForKey:@"roomFunction"]objectForKey:@"room_name"]];
    [params setValue:[_roomDataArr[[_index integerValue]] objectForKey:@"id"] forKey:@"pad_user_room_function_id"];
    
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"product-goods" andParams:params andSuccess:^(NSDictionary *successData) {
        //            //加载圈圈(显示)
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
            _roomLayoutModel=[[RoomLayoutModel alloc]initWithDictionary:successData error:nil];
            
            for (int i=0; i<_roomLayoutModel.data.count; i++) {
                _roomProductModel=[[RoomProductModel alloc]init];
                _roomProductModel=_roomLayoutModel.data[i];
                
                switch (i) {
                    case 0:
                    {
                        
                        _leftHeight.constant=[_roomProductModel.img_height integerValue] *(SCREEN_WIDTH*0.27-80)/[_roomProductModel.img_width integerValue];
                        [_ImgLeft sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",_roomProductModel.recommended_layout]] placeholderImage:[UIImage imageNamed:@"默认"]];
                        
                    }
                        break;
                    case 1:
                    {
                        _topHeight.constant=[_roomProductModel.img_width floatValue] *90/[_roomProductModel.img_height floatValue];
                        [_ImgTop sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",_roomProductModel.recommended_layout]] placeholderImage:[UIImage imageNamed:@"默认"]];
                        _ImgTop.contentMode = UIViewContentModeScaleAspectFit;
                    }
                        
                        break;
                    case 2:
                    {
                        _midHeight.constant=[_roomProductModel.img_width floatValue] *90/[_roomProductModel.img_height floatValue];
                        [_ImgMid sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",_roomProductModel.recommended_layout]] placeholderImage:[UIImage imageNamed:@"默认"]];
                        _ImgMid.contentMode = UIViewContentModeScaleAspectFit;
                        
                    }
                        
                        break;
                    case 3:
                    {
                        [_ImgBottom sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",_roomProductModel.recommended_layout]] placeholderImage:[UIImage imageNamed:@"默认"]];
                        _ImgBottom.contentMode = UIViewContentModeScaleAspectFit;
                    }
                        
                        break;
                        
                    default:
                        break;
                }
    
                
            }
            
        }
        //绑定布局的id
        _changeLayoutId=layoutid;
        _dataArr=[[NSMutableArray alloc]init];
        _goodIdArr=[[NSMutableArray alloc]init];
        _goodPositionArr=[[NSMutableArray alloc]init];
        NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
        _roomModel1=[[roomModel alloc]initWithDictionary:[_roomDataArr[[_index integerValue]] objectForKey:@"roomFunction"] error:nil];
        [params1 setValue:_changeLayoutId forKey:@"pad_user_room_product_id"];
        
        
        [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"product-goods/goods" andParams:params1 andSuccess:^(NSDictionary *successData) {
            //            //加载圈圈(显示)
            if ([[successData objectForKey:@"api_code"] integerValue]==200) {
                _dataArr=[successData objectForKey:@"data"];
                for (NSMutableArray *ARR in _dataArr) {
                    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                    dic=ARR[0];
                    [_goodIdArr addObject:[dic objectForKey:@"id"]];
                    [_goodPositionArr addObject:[dic objectForKey:@"position"]];
                }
                [_collection reloadData];
            }else{
                [[HudHelper hudHepler] showTips:self.view tips:[successData objectForKey:@"api_msg"]];
            }
            
        } andError:^(NSError *error) {
            //加载圈圈(显示)
            [[HudHelper hudHepler] HideHUDAlert:self.view];
            NSLog(@"%@",error);
        }];

        
    } andError:^(NSError *error) {
        //加载圈圈(显示)
        [[HudHelper hudHepler] HideHUDAlert:self.view];
        NSLog(@"%@",error);
    }];

    
//    //绑定布局的id
//    _changeLayoutId=layoutid;
//    _dataArr=[[NSMutableArray alloc]init];
//    _goodIdArr=[[NSMutableArray alloc]init];
//    _goodPositionArr=[[NSMutableArray alloc]init];
//    NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
//    _roomModel1=[[roomModel alloc]initWithDictionary:[_roomDataArr[[_index integerValue]] objectForKey:@"roomFunction"] error:nil];
//    [params1 setValue:_changeLayoutId forKey:@"pad_user_room_product_id"];
//    
//    
//    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"product-goods/goods" andParams:params1 andSuccess:^(NSDictionary *successData) {
//        //            //加载圈圈(显示)
//        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
//            _dataArr=[successData objectForKey:@"data"];
//            for (NSMutableArray *ARR in _dataArr) {
//                NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//                dic=ARR[0];
//                [_goodIdArr addObject:[dic objectForKey:@"id"]];
//                [_goodPositionArr addObject:[dic objectForKey:@"position"]];
//            }
//            [_collection reloadData];
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

-(void)album:(UIGestureRecognizer *)gesture
{
    NSLog(@"局部放大");
    _imageArr=[[NSMutableArray alloc]init];
    UIImageView *imageView = (UIImageView *)gesture.view;
    NSMutableArray *arr=[[NSMutableArray alloc]initWithArray:_dataArr[imageView.tag]];
    _g1oodsModel=[[goodsModel alloc]initWithDictionary:arr[0] error:nil];
   // UIImageView *imageView = (UIImageView *)gesture.view;
    for (NSString *str in _g1oodsModel.imgs) {
        [_imageArr addObject:[NSString stringWithFormat:@"%@%@",@"http://injia-dev.image.alimmdn.com",str]];
    }
    album = [[MickeyAlbum1 alloc]initWithImgUrlArr:_imageArr CurPage:0];
    album.photoFrame = imageView.frame;
    [self.navigationController presentViewController:album animated:YES completion:nil];
}

@end
