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

@interface UserLIstViewController ()<UISearchResultsUpdating,UITableViewDataSource,UITableViewDelegate>

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
    
}
#pragma mark - Init
- (void)initData {
     NSDictionary *dic=[[NSDictionary alloc]init];
    if(_userlistdate.count>0)
    {
    dic=_userlistdate[0];
    }
//    _dataSource = @[@"小雅",@"小明",@"张三",@"李四",@"王五",@"小刘",@"小商",@"小李",@"aa",@"bb",@"coffee",@"The Grand Canyon",@"4567.com",@"长江",@"长江1号",@"&*>?",@"弯弯月亮",@"that is it ?",@"山水之间",@"倩女幽魂",@"疆土无边",@"荡秋千"];
    _searchDataSource = [NSMutableArray new];
    
    _allDataSource = [HCSortString sortAndGroupForArray:_dataSource PropertyName:@"name"];
    _indexDataSource = [HCSortString sortForStringAry:[_allDataSource allKeys]];
    
    
    _headimg.layer.cornerRadius=30;
    _headimg.layer.masksToBounds=YES;
    if (![self isBlankString:[dic objectForKey:@"avatar"]]) {
    _name.text=[dic objectForKey:@"username"];
//      [_headimg setTitle: [[dic objectForKey:@"name"] substringFromIndex:2]forState:UIControlStateNormal];
    [_headimg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] forState:UIControlStateNormal];
    }else if(_userlistdate.count>0){
      [_headimg setTitle: [[dic objectForKey:@"username"] substringFromIndex:2]forState:UIControlStateNormal];
        _name.text=[dic objectForKey:@"username"];
    }else{
      [_headimg setTitle:@"A" forState:UIControlStateNormal];
    }
   
    UIView *oneview=[[UIView alloc]initWithFrame:CGRectMake(0.38*SCREEN_WIDTH, 238, 0.62*SCREEN_WIDTH, 100)];
//    oneview.backgroundColor=[UIColor yellowColor];
    [self.view addSubview:oneview];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 100, 0.62*SCREEN_WIDTH, 1)];
    line.backgroundColor=UIColorFromRGB(0xdfdfdf);
    [oneview addSubview:line];
    
    UILabel *lplab=[[UILabel alloc]initWithFrame:CGRectMake(0, 25, 0.62*SCREEN_WIDTH/4, 20)];
    lplab.textAlignment=NSTextAlignmentCenter;
    lplab.text=@"楼盘";
    lplab.textColor=UIColorFromRGB(0x666666);
    lplab.font=[UIFont systemFontOfSize:16.f];
    [oneview addSubview:lplab];
    
    UILabel *lplab1=[[UILabel alloc]initWithFrame:CGRectMake(0, 25+25, 0.62*SCREEN_WIDTH/4, 20)];
    lplab1.textAlignment=NSTextAlignmentCenter;
//    if (_userlistdate.count>0) {
//        lplab1.text=[dic objectForKey:@"building_name"];
//    }else{
//    lplab1.text=@"湘湖一号";
//    }
    lplab1.textColor=UIColorFromRGB(0x333333);
    lplab1.font=[UIFont systemFontOfSize:16.f];
    [oneview addSubview:lplab1];
    
    UILabel *hxlab=[[UILabel alloc]initWithFrame:CGRectMake(0.62*SCREEN_WIDTH/4, 25, 0.62*SCREEN_WIDTH/4, 20)];
    hxlab.textAlignment=NSTextAlignmentCenter;
    hxlab.text=@"户型号";
    hxlab.textColor=UIColorFromRGB(0x666666);
    hxlab.font=[UIFont systemFontOfSize:16.f];
    [oneview addSubview:hxlab];
    
    UILabel *hxlab1=[[UILabel alloc]initWithFrame:CGRectMake(0.62*SCREEN_WIDTH/4, 25+25, 0.62*SCREEN_WIDTH/4, 20)];
    hxlab1.textAlignment=NSTextAlignmentCenter;
//    if (_userlistdate.count>0) {
//        lplab1.text=[dic objectForKey:@"house_type"];
//    }else{
//        hxlab1.text=@"103-12-1920";
//    }
//    hxlab1.text=@"103-12-1920";
    hxlab1.textColor=UIColorFromRGB(0x333333);
    hxlab1.font=[UIFont systemFontOfSize:16.f];
    [oneview addSubview:hxlab1];
    
    UILabel *hxlab2=[[UILabel alloc]initWithFrame:CGRectMake(0.62*SCREEN_WIDTH/4*2, 25, 0.62*SCREEN_WIDTH/4, 20)];
    hxlab2.textAlignment=NSTextAlignmentCenter;
    hxlab2.text=@"户型";
    hxlab2.textColor=UIColorFromRGB(0x666666);
    hxlab2.font=[UIFont systemFontOfSize:16.f];
    [oneview addSubview:hxlab2];
    
    UILabel *hxlab3=[[UILabel alloc]initWithFrame:CGRectMake(0.62*SCREEN_WIDTH/4*2, 25+25, 0.62*SCREEN_WIDTH/4, 20)];
    hxlab3.textAlignment=NSTextAlignmentCenter;
    hxlab3.text=@"三室两厅";
    hxlab3.textColor=UIColorFromRGB(0x333333);
    hxlab3.font=[UIFont systemFontOfSize:16.f];
    [oneview addSubview:hxlab3];
    
    UILabel *arealab=[[UILabel alloc]initWithFrame:CGRectMake(0.62*SCREEN_WIDTH/4*3, 25, 0.62*SCREEN_WIDTH/4, 20)];
    arealab.textAlignment=NSTextAlignmentCenter;
    arealab.text=@"面积";
    arealab.textColor=UIColorFromRGB(0x666666);
    arealab.font=[UIFont systemFontOfSize:16.f];
    [oneview addSubview:arealab];
    
    UILabel *arealab1=[[UILabel alloc]initWithFrame:CGRectMake(0.62*SCREEN_WIDTH/4*3, 25+25, 0.62*SCREEN_WIDTH/4, 20)];
    arealab1.textAlignment=NSTextAlignmentCenter;
    arealab1.text=@"54平米";
    arealab1.textColor=UIColorFromRGB(0x333333);
    arealab1.font=[UIFont systemFontOfSize:16.f];
    [oneview addSubview:arealab1];
    
    
    
    UIView *twoview=[[UIView alloc]initWithFrame:CGRectMake(0.38*SCREEN_WIDTH, 238+100, 0.62*SCREEN_WIDTH, 100)];
    [self.view addSubview:twoview];
    
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 100, 0.62*SCREEN_WIDTH, 1)];
    line1.backgroundColor=UIColorFromRGB(0xdfdfdf);
    [twoview addSubview:line1];
    
    
    UILabel *stylelab=[[UILabel alloc]initWithFrame:CGRectMake(0, 25, 0.62*SCREEN_WIDTH/3, 20)];
    stylelab.textAlignment=NSTextAlignmentCenter;
    stylelab.text=@"喜欢的软装风格";
    stylelab.textColor=UIColorFromRGB(0x666666);
    stylelab.font=[UIFont systemFontOfSize:16.f];
    [twoview addSubview:stylelab];
    
    UILabel *stylelab1=[[UILabel alloc]initWithFrame:CGRectMake(0, 25+25, 0.62*SCREEN_WIDTH/3, 20)];
    stylelab1.textAlignment=NSTextAlignmentCenter;
    stylelab1.text=@"北欧现代";
    stylelab1.textColor=UIColorFromRGB(0x333333);
    stylelab1.font=[UIFont systemFontOfSize:16.f];
    [twoview addSubview:stylelab1];
    
    UILabel *stylelab2=[[UILabel alloc]initWithFrame:CGRectMake(0.62*SCREEN_WIDTH/3, 25, 0.62*SCREEN_WIDTH/3, 20)];
    stylelab2.textAlignment=NSTextAlignmentCenter;
    stylelab2.text=@"拟装修风格";
    stylelab2.textColor=UIColorFromRGB(0x666666);
    stylelab2.font=[UIFont systemFontOfSize:16.f];
    [twoview addSubview:stylelab2];
    
    UILabel *stylelab3=[[UILabel alloc]initWithFrame:CGRectMake(0.62*SCREEN_WIDTH/3, 25+25, 0.62*SCREEN_WIDTH/3, 20)];
    stylelab3.textAlignment=NSTextAlignmentCenter;
    stylelab3.text=@"北欧现代";
    stylelab3.textColor=UIColorFromRGB(0x333333);
    stylelab3.font=[UIFont systemFontOfSize:16.f];
    [twoview addSubview:stylelab3];
    
    UILabel *stylelab4=[[UILabel alloc]initWithFrame:CGRectMake(0.62*SCREEN_WIDTH/3*2, 25, 0.62*SCREEN_WIDTH/3, 20)];
    stylelab4.textAlignment=NSTextAlignmentCenter;
    stylelab4.text=@"是否信风水";
    stylelab4.textColor=UIColorFromRGB(0x666666);
    stylelab4.font=[UIFont systemFontOfSize:16.f];
    [twoview addSubview:stylelab4];
    
    UILabel *stylelab5=[[UILabel alloc]initWithFrame:CGRectMake(0.62*SCREEN_WIDTH/3*2, 25+25, 0.62*SCREEN_WIDTH/3, 20)];
    stylelab5.textAlignment=NSTextAlignmentCenter;
    stylelab5.text=@"是";
    stylelab5.textColor=UIColorFromRGB(0x333333);
    stylelab5.font=[UIFont systemFontOfSize:16.f];
    [twoview addSubview:stylelab5];
    
    UIView *threeview=[[UIView alloc]initWithFrame:CGRectMake(0.38*SCREEN_WIDTH, 238+200, 0.62*SCREEN_WIDTH, 100)];
    [self.view addSubview:threeview];
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, 100, 0.62*SCREEN_WIDTH, 1)];
    line2.backgroundColor=UIColorFromRGB(0xdfdfdf);
    [threeview addSubview:line2];
    
    
    UILabel *familylab=[[UILabel alloc]initWithFrame:CGRectMake(0, 25, 0.62*SCREEN_WIDTH/3, 20)];
    familylab.textAlignment=NSTextAlignmentCenter;
    familylab.text=@"家庭成员";
    familylab.textColor=UIColorFromRGB(0x666666);
    familylab.font=[UIFont systemFontOfSize:16.f];
    [threeview addSubview:familylab];
    
    UILabel *familylab1=[[UILabel alloc]initWithFrame:CGRectMake(0, 25+25, 0.62*SCREEN_WIDTH/3, 40)];
    familylab1.textAlignment=NSTextAlignmentCenter;
    familylab1.text=@"父母2人，儿子8、10岁，女儿9、10岁";
    familylab1.textColor=UIColorFromRGB(0x333333);
    familylab1.font=[UIFont systemFontOfSize:16.f];
    familylab1.numberOfLines=0;
    [threeview addSubview:familylab1];
    
    UILabel *kflab=[[UILabel alloc]initWithFrame:CGRectMake(0.62*SCREEN_WIDTH/3, 25, 0.62*SCREEN_WIDTH/3, 20)];
    kflab.textAlignment=NSTextAlignmentCenter;
    kflab.text=@"客户来源";
    kflab.textColor=UIColorFromRGB(0x666666);
    kflab.font=[UIFont systemFontOfSize:16.f];
    [threeview addSubview:kflab];
    
    
    UILabel *kflab1=[[UILabel alloc]initWithFrame:CGRectMake(0.62*SCREEN_WIDTH/3, 25+25, 0.62*SCREEN_WIDTH/3, 20)];
    kflab1.textAlignment=NSTextAlignmentCenter;
    kflab1.text=@"朋友介绍";
    kflab1.textColor=UIColorFromRGB(0x333333);
    kflab1.font=[UIFont systemFontOfSize:16.f];
    [threeview addSubview:kflab1];
    
    UILabel *orderlab=[[UILabel alloc]initWithFrame:CGRectMake(0.62*SCREEN_WIDTH/3*2, 25, 0.62*SCREEN_WIDTH/3, 20)];
    orderlab.textAlignment=NSTextAlignmentCenter;
    orderlab.text=@"订单来源";
    orderlab.textColor=UIColorFromRGB(0x666666);
    orderlab.font=[UIFont systemFontOfSize:16.f];
    [threeview addSubview:orderlab];
    
    UILabel *orderlab1=[[UILabel alloc]initWithFrame:CGRectMake(0.62*SCREEN_WIDTH/3*2, 25+25, 0.62*SCREEN_WIDTH/3, 20)];
    orderlab1.textAlignment=NSTextAlignmentCenter;
    orderlab1.text=@"未成交";
    orderlab1.textColor=UIColorFromRGB(0x333333);
    orderlab1.font=[UIFont systemFontOfSize:16.f];
    [threeview addSubview:orderlab1];
    
    
    
    
    UIView *fourview=[[UIView alloc]initWithFrame:CGRectMake(0.38*SCREEN_WIDTH, 238+300, 0.62*SCREEN_WIDTH, 100)];
    [self.view addSubview:fourview];
    
//    UIView *line3=[[UIView alloc]initWithFrame:CGRectMake(0.38*SCREEN_WIDTH, 100, 0.62*SCREEN_WIDTH, 1)];
//    line3.backgroundColor=UIColorFromRGB(0xdfdfdf);
//    [fourview addSubview:line3];
    
    
    UILabel *remarklab=[[UILabel alloc]initWithFrame:CGRectMake(0, 25, 0.62*SCREEN_WIDTH/3, 20)];
    remarklab.textAlignment=NSTextAlignmentCenter;
    remarklab.text=@"备注";
    remarklab.textColor=UIColorFromRGB(0x666666);
    remarklab.font=[UIFont systemFontOfSize:16.f];
    [fourview addSubview:remarklab];
    
    UILabel *remarklab1=[[UILabel alloc]initWithFrame:CGRectMake(0, 25+25, 0.62*SCREEN_WIDTH, 40)];
    remarklab1.textAlignment=NSTextAlignmentCenter;
    remarklab1.text=@"男主刚毕业，设计出身，对于有设计感的产品高度需求，看中进口品牌沙发，考虑餐厅大件进口...";
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
    [lookbtn setBackgroundColor:UIColorFromRGB(0xaaaaaa)];
    [lookbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    self.tableView.backgroundColor = kColor;
    
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
                [_dataSource addObject:[dic objectForKey:@"username"]];
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
//    if (!self.searchController.active) {
//        NSArray *value = [_allDataSource objectForKey:_indexDataSource[indexPath.section]];
//        self.block(value[indexPath.row]);
//    }else{
//        self.block(_searchDataSource[indexPath.row]);
//    }
//    self.searchController.active = NO;
//    [self.navigationController popViewControllerAnimated:YES];
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

    UITextField *nametifd=[[UITextField alloc]initWithFrame:CGRectMake(90, 30+64, (0.68*SCREEN_WIDTH-90)/2-90, 48)];
    nametifd.textColor=UIColorFromRGB(0x333333);
    nametifd.font=[UIFont systemFontOfSize:18.f];
    nametifd.placeholder=@"请输入姓名";
    nametifd.textAlignment=NSTextAlignmentRight;
    [_editview addSubview:nametifd];
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48, (0.68*SCREEN_WIDTH-90)/2-30, 1)];
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
    
    UITextField *phonelab3=[[UITextField alloc]initWithFrame:CGRectMake(120, 30+64+48, (0.68*SCREEN_WIDTH-90)/2-120, 48)];
    phonelab3.textColor=UIColorFromRGB(0x333333);
    phonelab3.font=[UIFont systemFontOfSize:18.f];
    phonelab3.placeholder=@"请输入手机号码";
    phonelab3.textAlignment=NSTextAlignmentRight;
    [_editview addSubview:phonelab3];
    
    UILabel *line1=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48, (0.68*SCREEN_WIDTH-90)/2-30, 1)];
    line1.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line1];
    
    UILabel *lplab1=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48, 10, 48)];
    lplab1.text=@"*";
    lplab1.textColor=colorHead;
    [_editview addSubview:lplab1];
    
    UILabel *lplab2=[[UILabel alloc]initWithFrame:CGRectMake(40, 30+64+48+48, 50, 48)];
    lplab2.text=@"楼盘:";
    lplab2.font=[UIFont systemFontOfSize:18.f];
    lplab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:lplab2];
    
    UIButton *lp3=[[UIButton alloc]initWithFrame:CGRectMake(90, 30+64+48+48, (0.68*SCREEN_WIDTH-90)/2-90, 48)];
    lp3.titleLabel.textColor=UIColorFromRGB(0xcccccc);
    lp3.titleLabel.font=[UIFont systemFontOfSize:18.f];
    lp3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [lp3 setTitle:@"(选)" forState:UIControlStateNormal];
    [lp3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_editview addSubview:lp3];
    
    UILabel *line2=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48, (0.68*SCREEN_WIDTH-90)/2-30, 1)];
    line2.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line2];
    
    UILabel *hxlab1=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48, 10, 48)];
    hxlab1.text=@"*";
    hxlab1.textColor=colorHead;
    [_editview addSubview:hxlab1];
    
    UILabel *hxlab2=[[UILabel alloc]initWithFrame:CGRectMake(40, 30+64+48+48+48, 50, 48)];
    hxlab2.text=@"户型:";
    hxlab2.font=[UIFont systemFontOfSize:18.f];
    hxlab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:hxlab2];
    
    UIButton *hx3=[[UIButton alloc]initWithFrame:CGRectMake(90, 30+64+48+48+48, (0.68*SCREEN_WIDTH-90)/2-90, 48)];
    hx3.titleLabel.textColor=UIColorFromRGB(0xcccccc);
    hx3.titleLabel.font=[UIFont systemFontOfSize:18.f];
    hx3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [hx3 setTitle:@"(选)" forState:UIControlStateNormal];
    [hx3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_editview addSubview:hx3];
    
    UILabel *line3=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48+48, (0.68*SCREEN_WIDTH-90)/2-30, 1)];
    line3.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line3];
    
    UILabel *likestyle=[[UILabel alloc]initWithFrame:CGRectMake(40, 30+64+48+48+48+48, 160, 48)];
    likestyle.text=@"喜欢的装修风格:";
    likestyle.font=[UIFont systemFontOfSize:18.f];
    likestyle.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:likestyle];
    
    UIButton *likestylebtn=[[UIButton alloc]initWithFrame:CGRectMake(200,  30+64+48+48+48+48, (0.68*SCREEN_WIDTH-90)-200, 48)];
    likestylebtn.titleLabel.textColor=UIColorFromRGB(0xcccccc);
    likestylebtn.titleLabel.font=[UIFont systemFontOfSize:18.f];
    likestylebtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [likestylebtn setTitle:@"(选)" forState:UIControlStateNormal];
    [likestylebtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_editview addSubview:likestylebtn];
    
    UILabel *line4=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-30, 1)];
    line4.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line4];
//    UITextField *likestyletifd=[[UITextField alloc]initWithFrame:CGRectMake(160, 30+64+48+48+48+48, (0.68*SCREEN_WIDTH-90)/2-110, 48)];
//    likestyletifd.textColor=UIColorFromRGB(0x333333);
//    likestyletifd.font=[UIFont systemFontOfSize:18.f];
//    likestyletifd.placeholder=@"请输入喜欢的风格";
//    likestyletifd.textAlignment=NSTextAlignmentCenter;
//    [_editview addSubview:likestyletifd];
    
    UILabel *fslab2=[[UILabel alloc]initWithFrame:CGRectMake(40, 30+64+48+48+48+48+48, 100, 48)];
    fslab2.text=@"是否信风水:";
    fslab2.font=[UIFont systemFontOfSize:18.f];
    fslab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:fslab2];
    
    UIButton *fs3=[[UIButton alloc]initWithFrame:CGRectMake(140, 30+64+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-140, 48)];
    fs3.titleLabel.textColor=UIColorFromRGB(0xcccccc);
    fs3.titleLabel.font=[UIFont systemFontOfSize:18.f];
    fs3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [fs3 setTitle:@"(选)" forState:UIControlStateNormal];
    [fs3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_editview addSubview:fs3];
    
    UILabel *line5=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-30, 1)];
    line5.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line5];
    
    UILabel *family=[[UILabel alloc]initWithFrame:CGRectMake(40, 30+64+48+48+48+48+48+48, 100, 48)];
    family.text=@"家庭成员:";
    family.font=[UIFont systemFontOfSize:18.f];
    family.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:family];
    
    UITextField *familytifd=[[UITextField alloc]initWithFrame:CGRectMake(140, 30+64+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-140, 48)];
    familytifd.textColor=UIColorFromRGB(0x333333);
    familytifd.font=[UIFont systemFontOfSize:18.f];
    familytifd.placeholder=@"请输入家庭成员";
    familytifd.textAlignment=NSTextAlignmentRight;
    [_editview addSubview:familytifd];
    
    UILabel *line6=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-30, 1)];
    line6.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line6];
    
    
    UILabel *khlab2=[[UILabel alloc]initWithFrame:CGRectMake(40, 30+64+48+48+48+48+48+48+48, 80, 48)];
    khlab2.text=@"客户来源:";
    khlab2.font=[UIFont systemFontOfSize:18.f];
    khlab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:khlab2];
    
    UIButton *kh3=[[UIButton alloc]initWithFrame:CGRectMake(120, 30+64+48+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-120, 48)];
    kh3.titleLabel.textColor=UIColorFromRGB(0xcccccc);
    kh3.titleLabel.font=[UIFont systemFontOfSize:18.f];
    kh3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [kh3 setTitle:@"(选)" forState:UIControlStateNormal];
    [kh3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_editview addSubview:kh3];
    
    UILabel *line7=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-30, 1)];
    line7.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line7];
    
    
    UILabel *remark=[[UILabel alloc]initWithFrame:CGRectMake(40, 30+64+48+48+48+48+48+48+48+48, 100, 48)];
    remark.text=@"备注:";
    remark.font=[UIFont systemFontOfSize:18.f];
    remark.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:remark];
    
    UITextField *remarktifd=[[UITextField alloc]initWithFrame:CGRectMake(140, 30+64+48+48+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-140, 48)];
    remarktifd.textColor=UIColorFromRGB(0x333333);
    remarktifd.font=[UIFont systemFontOfSize:18.f];
    remarktifd.placeholder=@"请输入备注";
    remarktifd.textAlignment=NSTextAlignmentRight;
    [_editview addSubview:remarktifd];
    
    UILabel *line8=[[UILabel alloc]initWithFrame:CGRectMake(30, 30+64+48+48+48+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-30, 1)];
    line8.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line8];
    
    UIButton *add=[[UIButton alloc]initWithFrame:CGRectMake(40, 30+64+48+48+48+48+48+48+48+48+48+48, (0.68*SCREEN_WIDTH-90)-120, 48)];
    add.titleLabel.textColor=UIColorFromRGB(0xcccccc);
    add.titleLabel.font=[UIFont systemFontOfSize:18.f];
    [add setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [add setTitle:@"新增户型" forState:UIControlStateNormal];
    [add setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_editview addSubview:add];
    
    
    
    

    
//    UITextField *lplab3=[[UITextField alloc]initWithFrame:CGRectMake(90, 30+64+48, (0.68*SCREEN_WIDTH-90)/2-90, 48)];
//    lplab3.textColor=UIColorFromRGB(0x333333);
//    lplab3.font=[UIFont systemFontOfSize:18.f];
//    lplab3.placeholder=@"请输入手机号码（必填）";
//    lplab3.textAlignment=NSTextAlignmentCenter;
//    [_editview addSubview:lplab3];
    
//    UILabel *sexlab1=[[UILabel alloc]initWithFrame:CGRectMake(30+(0.68*SCREEN_WIDTH-90)/2, 30+64, 10, 48)];
//    sexlab1.text=@"*";
//    sexlab1.textColor=colorHead;
//    [_editview addSubview:sexlab1];
    
    UILabel *sexlab2=[[UILabel alloc]initWithFrame:CGRectMake(40+(0.68*SCREEN_WIDTH-90)/2, 30+64, 50, 48)];
    sexlab2.text=@"性别:";
    sexlab2.font=[UIFont systemFontOfSize:18.f];
    sexlab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:sexlab2];
    
    UIButton *sexlab3=[[UIButton alloc]initWithFrame:CGRectMake(80+(0.68*SCREEN_WIDTH-90)/2, 30+64, (0.68*SCREEN_WIDTH-90)/2-90, 48)];
    sexlab3.titleLabel.textColor=UIColorFromRGB(0xcccccc);
    sexlab3.titleLabel.font=[UIFont systemFontOfSize:18.f];
    sexlab3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [sexlab3 setTitle:@"(选)" forState:UIControlStateNormal];
    [sexlab3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_editview addSubview:sexlab3];
    
    UILabel *line9=[[UILabel alloc]initWithFrame:CGRectMake(30+(0.68*SCREEN_WIDTH-90)/2, 30+64+48, (0.68*SCREEN_WIDTH-90)/2-30, 1)];
    line9.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line9];
    
    
    UILabel *arealab1=[[UILabel alloc]initWithFrame:CGRectMake(30+(0.68*SCREEN_WIDTH-90)/2, 30+64+48, 10, 48)];
    arealab1.text=@"*";
    arealab1.textColor=colorHead;
    [_editview addSubview:arealab1];
    
    UILabel *arealab2=[[UILabel alloc]initWithFrame:CGRectMake(40+(0.68*SCREEN_WIDTH-90)/2,30+64+48, 50, 48)];
    arealab2.text=@"面积:";
    arealab2.font=[UIFont systemFontOfSize:18.f];
    arealab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:arealab2];
    
    UITextField *areatifd=[[UITextField alloc]initWithFrame:CGRectMake(90+(0.68*SCREEN_WIDTH-90)/2, 30+64+48, (0.68*SCREEN_WIDTH-90)/2-90-30, 48)];
    areatifd.textColor=UIColorFromRGB(0x333333);
    areatifd.font=[UIFont systemFontOfSize:18.f];
    areatifd.placeholder=@"请输入面积";
    areatifd.textAlignment=NSTextAlignmentRight;
    [_editview addSubview:areatifd];
    
    UILabel *pflab1=[[UILabel alloc]initWithFrame:CGRectMake(90+(0.68*SCREEN_WIDTH-90)/2+(0.68*SCREEN_WIDTH-90)/2-90-30, 30+64+48, 30, 48)];
    pflab1.text=@"㎡";
    pflab1.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:pflab1];
    
    UILabel *line10=[[UILabel alloc]initWithFrame:CGRectMake(30+(0.68*SCREEN_WIDTH-90)/2, 30+64+48+48, (0.68*SCREEN_WIDTH-90)/2-30, 1)];
    line10.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line10];
    
    
    UILabel *hxhlab1=[[UILabel alloc]initWithFrame:CGRectMake(30+(0.68*SCREEN_WIDTH-90)/2, 30+64+48+48, 10, 48)];
    hxhlab1.text=@"*";
    hxhlab1.textColor=colorHead;
    [_editview addSubview:hxhlab1];
    
    UILabel *hxhlab2=[[UILabel alloc]initWithFrame:CGRectMake(40+(0.68*SCREEN_WIDTH-90)/2,30+64+48+48, 60, 48)];
    hxhlab2.text=@"户型号:";
    hxhlab2.font=[UIFont systemFontOfSize:18.f];
    hxhlab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:hxhlab2];
    
    UITextField *hxhtifd=[[UITextField alloc]initWithFrame:CGRectMake(120+(0.68*SCREEN_WIDTH-90)/2, 30+64+48+48, (0.68*SCREEN_WIDTH-90)/2-120, 48)];
    hxhtifd.textColor=UIColorFromRGB(0x333333);
    hxhtifd.font=[UIFont systemFontOfSize:18.f];
    hxhtifd.placeholder=@"(选)";
    hxhtifd.textAlignment=NSTextAlignmentRight;
    [_editview addSubview:hxhtifd];
    
    UILabel *line11=[[UILabel alloc]initWithFrame:CGRectMake(30+(0.68*SCREEN_WIDTH-90)/2, 30+64+48+48+48, (0.68*SCREEN_WIDTH-90)/2-30, 1)];
    line11.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line11];
    
    UILabel *stylehlab2=[[UILabel alloc]initWithFrame:CGRectMake(40+(0.68*SCREEN_WIDTH-90)/2,30+64+48+48+48, 120, 48)];
    stylehlab2.text=@"拟装修风格:";
    stylehlab2.font=[UIFont systemFontOfSize:18.f];
    stylehlab2.textColor=UIColorFromRGB(0x333333);
    [_editview addSubview:stylehlab2];
    
    UIButton *stylelab3=[[UIButton alloc]initWithFrame:CGRectMake(160+(0.68*SCREEN_WIDTH-90)/2, 30+64+48+48+48, (0.68*SCREEN_WIDTH-90)/2-160, 48)];
    stylelab3.titleLabel.textColor=UIColorFromRGB(0xcccccc);
    stylelab3.titleLabel.font=[UIFont systemFontOfSize:18.f];
    stylelab3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [stylelab3 setTitle:@"(选)" forState:UIControlStateNormal];
    [stylelab3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_editview addSubview:stylelab3];
    
    UILabel *line12=[[UILabel alloc]initWithFrame:CGRectMake(30+(0.68*SCREEN_WIDTH-90)/2, 30+64+48+48+48+48, (0.68*SCREEN_WIDTH-90)/2-30, 1)];
    line12.backgroundColor=UIColorFromRGB(0x666666);
    [_editview addSubview:line12];
    
    
    
    
    
    
    
}
- (void)ok
{
    
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
    
}
@end
