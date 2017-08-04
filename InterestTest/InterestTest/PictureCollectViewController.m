//
//  PictureCollectViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/5/9.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "PictureCollectViewController.h"
#import "SWRevealViewController.h"
#import "AllFurnitureViewController.H"
#import "AnLiViewController.h"

@interface PictureCollectViewController ()

@end

@implementation PictureCollectViewController

- (void)viewWillAppear:(BOOL)animated
{
    
     self.navigationController.navigationBarHidden=NO;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=UIColorFromRGB(0xffffff);
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = true;
    //去掉透明后导航栏下边的黑边
    self.title=@"最In图库";
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    SWRevealViewController *revealController = [self revealViewController];
    
    //设置按钮
    UIButton *_setBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _setBut.frame = CGRectMake(20, 0, 14, 11);
    [_setBut addTarget: revealController action: @selector(revealToggle:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *setItem = [[UIBarButtonItem alloc]initWithCustomView:_setBut];
    [_setBut setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    NSMutableArray *buttonItems = [NSMutableArray array];
    [buttonItems addObject:setItem];
    self.navigationItem.leftBarButtonItems = buttonItems;
    
    
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];

    // Do any additional setup after loading the view from its nib.
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

- (IBAction)jiajuBtn:(UIButton *)sender {
    AllFurnitureViewController *ALL=[[AllFurnitureViewController alloc]init];
    [self.navigationController pushViewController:ALL animated:YES];
}

- (IBAction)anliBtn:(UIButton *)sender {
    AnLiViewController *all=[[AnLiViewController alloc]init];
    [self.navigationController pushViewController:all animated:YES];
}
@end
