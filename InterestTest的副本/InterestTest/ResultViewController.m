//
//  ResultViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/3/4.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "ResultViewController.h"
#import "SWRevealViewController.h"
#import "MickeyAlbum.h"
#import "UnitLoginViewController.h"

@interface ResultViewController ()
{
    UIView *bgView;
    MickeyAlbum * album;
}
@property(nonatomic,strong)NSMutableArray *imgArr;

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _imgArr=[[NSMutableArray alloc]init];
     self.view.backgroundColor=UIColorFromRGB(0xffffff);
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
     self.navigationController.navigationBar.translucent = true;
     self.navigationController.navigationBarHidden=NO;
    //去掉透明后导航栏下边的黑边
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
    
    
    //设置按钮
    UIButton *next = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    next.frame = CGRectMake(20, 0, 60, 30);
    [next addTarget: self action: @selector(next) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc]initWithCustomView:next];
    [next setTitle:@"下一步" forState:UIControlStateNormal];
    [next setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSMutableArray *buttonItems1 = [NSMutableArray array];
    [buttonItems1 addObject:nextItem];
    self.navigationItem.rightBarButtonItems = buttonItems1;
    //

    
    
    
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    _color_sentence=[userDefaultes stringForKey:@"color_sentence"];
    _fg_sentence=[userDefaultes stringForKey:@"fg_sentence"];
    _result_imgs=[userDefaultes objectForKey:@"result_imgs"];
    NSString *name=[userDefaultes objectForKey:@"name"];
    
    
    _likeTitle.text=[NSString stringWithFormat:@"%@ — %@",@"偏好家居风格",name];
    
    if (_result_imgs.count>2) {
        
        [_leftImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",_result_imgs[0]]] placeholderImage:[UIImage imageNamed:@"默认"]];
         _leftImg.contentMode = UIViewContentModeScaleToFill;
        [_imgArr addObject:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",_result_imgs[0]]];
        
        
        [_topImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",_result_imgs[1]]] placeholderImage:[UIImage imageNamed:@"默认"]];
        _topImg.contentMode = UIViewContentModeScaleToFill;
        [_imgArr addObject:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",_result_imgs[1]]];
        
        [_bottomImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",_result_imgs[2]]] placeholderImage:[UIImage imageNamed:@"默认"]];
        _bottomImg.contentMode = UIViewContentModeScaleToFill;
        [_imgArr addObject:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",_result_imgs[2]]];
    }
    
    
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    _leftImg.userInteractionEnabled = YES;
    [_leftImg addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap1  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    _topImg.userInteractionEnabled = YES;
    [_topImg addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    _bottomImg.userInteractionEnabled = YES;
    [_bottomImg addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(album:)];
    _leftImg.userInteractionEnabled = YES;
    [_leftImg addGestureRecognizer:tap3];
    
    _detail1.textColor=UIColorFromRGB(0x808080);
    _detail2.textColor=UIColorFromRGB(0x808080);
    if ([self isBlankString:_color_sentence]) {
        
    }else{
        _detail1.text=_color_sentence;
    }
    if ([self isBlankString:_fg_sentence]) {
        
    }else{
        _detail2.text=_fg_sentence;
    }
//    _detail2.textColor=UIColorFromRGB(0x808080);
    
    
    

    // Do any additional setup after loading the view from its nib.
}
-(void)next{
    UnitLoginViewController *login=[[UnitLoginViewController alloc]init];
    [self.navigationController pushViewController:login animated:YES];
}
-(void)album:(UIGestureRecognizer *)gesture
{
    NSLog(@"局部放大");
    UIImageView *imageView = (UIImageView *)gesture.view;
    album = [[MickeyAlbum alloc]initWithImgUrlArr:_imgArr CurPage:0];
    album.photoFrame = imageView.frame;
    [self.navigationController presentViewController:album animated:YES completion:nil];
}

//点击图片后的方法(即图片的放大全屏效果)
- (void) tapAction:(UIGestureRecognizer *)gesture{
    self.navigationController.navigationBarHidden=YES;
    //创建一个黑色背景
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.backgroundColor=UIColorFromRGB(0x808080);
    [self.view addSubview:bgView];
    
    //创建显示图像的视图
    //初始化要显示的图片内容的imageView
    UIImageView *imageView = (UIImageView *)gesture.view;
   
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-SCREEN_HEIGHT/3*2/2, 0, SCREEN_HEIGHT/3*2, SCREEN_HEIGHT)];
    imgView.image=imageView.image;
    //要显示的图片，即要放大的图片
//    [imgView sd_setImageWithURL:[NSURL URLWithString:_picModel.image] placeholderImage:[UIImage imageNamed:@"默认"]];
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
    [bgView addGestureRecognizer:tapGesture1];
    
    
    [self shakeToShow:imgView];//放大过程中的动画
}
-(void)closeView{
    self.navigationController.navigationBarHidden=NO;
    [bgView removeFromSuperview];
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

@end
