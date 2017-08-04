//
//  NewInterestTestViewController.m
//  InterestTest
//
//  Created by 商佳敏 on 17/5/25.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "NewInterestTestViewController.h"
#import "RootHttpHelper.h"
#import "HudHelper.h"
#import "PicModel.h"
#import "SDWebImage.h"

@interface NewInterestTestViewController ()
{
    NSMutableArray *arr;
    NSMutableArray *arr1;
    int a ;
    NSMutableArray *likedataList;
    NSMutableArray *disLikedataList;
}
@property (nonatomic, strong) NSMutableArray *img1Arr;
@property (nonatomic, strong) NSMutableArray *img2Arr;
@property (nonatomic, assign) int subtype;
@end
typedef enum : NSUInteger {
    Fade = 1,                   //淡入淡出
    Push,                       //推挤
    Reveal,                     //揭开
    MoveIn,                     //覆盖
    Cube,                       //立方体
    SuckEffect,                 //吮吸
    OglFlip,                    //翻转
    RippleEffect,               //波纹
    PageCurl,                   //翻页
    PageUnCurl,                 //反翻页
    CameraIrisHollowOpen,       //开镜头
    CameraIrisHollowClose,      //关镜头
    CurlDown,                   //下翻页
    CurlUp,                     //上翻页
    FlipFromLeft,               //左翻转
    FlipFromRight,              //右翻转
    
} AnimationType;

@implementation NewInterestTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _subtype = 0;
     a=0;
    [super viewDidLoad];
     arr=[[NSMutableArray alloc]init];
     arr1=[[NSMutableArray alloc]init];
     _img1Arr=[[NSMutableArray alloc]init];
     _img2Arr=[[NSMutableArray alloc]init];
     likedataList=[[NSMutableArray alloc]init];
     disLikedataList=[[NSMutableArray alloc]init];
    
    [[RootHttpHelper httpHelper] getAchieveListParamsURL:@"pic/get" andParams:nil andSuccess:^(NSDictionary *successData) {
        //加载圈圈(显示)
        [[HudHelper hudHepler] HideHUDAlert:self.view];
//        _dataList=[[NSMutableArray alloc]init];
        if ([[successData objectForKey:@"api_code"] integerValue]==200) {
            NSError *err = nil;
            NSMutableArray *arrlist=[[NSMutableArray alloc]init];
            arrlist=[successData objectForKey:@"data"] ;
            for(int i=0;i<arrlist.count;i++){
                if((i+1)%2==0){
                    NSDictionary *dix=arrlist[i];
                    PicModel  *picModel = [[PicModel alloc]initWithDictionary:dix error:&err];
                    [arr addObject:picModel];
                 
                }else{
                    NSDictionary *dix=arrlist[i];
                    PicModel  *picModel = [[PicModel alloc]initWithDictionary:dix error:&err];
                    [arr1 addObject:picModel];
                }
            }
            PicModel *a1=[[PicModel alloc]init];
            a1=arr[0];
            [_btn1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",a1.image]] forState:UIControlStateNormal];
            PicModel *a2=[[PicModel alloc]init];
            a2=arr1[0];
            [_btn2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",a2.image]] forState:UIControlStateNormal];

            
        }else if ([[successData objectForKey:@"api_code"] integerValue]==401){
        }
        
    } andError:^(NSError *error) {
        //加载圈圈(显示)
        [[HudHelper hudHepler] HideHUDAlert:self.view];
        NSLog(@"%@",error);
    }];
//    PicModel *a1=[[PicModel alloc]init];
//    a1=arr[0];
//    [_btn1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",a1.image]] forState:UIControlStateNormal];
//    PicModel *a2=[[PicModel alloc]init];
//    a2=arr1[0];
//    [_btn2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",a2.image]] forState:UIControlStateNormal];
   


    
    
   

    
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

- (IBAction)btnclick:(UIButton *)sender {
    if(sender.tag==0)
    {
        _subtype=3;
    }else{
        _subtype=0;
    }
    if (a<25) {
        
        AnimationType animationType = 1;
        
        NSString *subtypeString;
        
        switch (_subtype) {
            case 0:
                subtypeString = kCATransitionFromLeft;
                break;
            case 1:
                subtypeString = kCATransitionFromBottom;
                break;
            case 2:
                subtypeString = kCATransitionFromRight;
                break;
            case 3:
                subtypeString = kCATransitionFromTop;
                break;
            default:
                break;
        }
//        _subtype += 1;
//        if (_subtype > 3) {
//            _subtype = 0;
//        }
        
        
        switch (animationType) {
            case Fade:
                [self transitionWithType:kCATransitionFade WithSubtype:subtypeString ForView:_btn1 andView:_btn2];
                
                break;
                
            case Push:
                [self transitionWithType:kCATransitionPush WithSubtype:subtypeString ForView:_btn1 andView:_btn2];
                
                break;
                
            case Reveal:
                [self transitionWithType:kCATransitionReveal WithSubtype:subtypeString ForView:_btn1 andView:_btn2];
                break;
                
            case MoveIn:
                [self transitionWithType:kCATransitionMoveIn WithSubtype:subtypeString ForView:_btn1 andView:_btn2];
                [self transitionWithType1:kCATransitionPush WithSubtype:subtypeString ForView:_btn1 andView:_btn2];
                break;
                
            case Cube:
            {
                [self transitionWithType:@"cube" WithSubtype:subtypeString ForView:_btn1 andView:_btn2];
                [self transitionWithType1:@"cube" WithSubtype:subtypeString ForView:_btn2 andView:_btn2];
            }
                break;
                
            case CurlUp:
                [self animationWithView:_btn1 WithAnimationTransition:UIViewAnimationTransitionCurlUp];
                break;
                
            case FlipFromLeft:
                [self animationWithView:_btn1 WithAnimationTransition:UIViewAnimationTransitionFlipFromLeft];
                break;
                
            case FlipFromRight:
                [self animationWithView:_btn1 WithAnimationTransition:UIViewAnimationTransitionFlipFromRight];
                break;
                
            default:
                break;
        }
        //    for (int i=0; i<10; i++) {
        //        if ((i+1)%2==1) {
        //           [self addBgImageWithImageName:IMAGE1];
        //        }
        //        else{
        //            [self addBgImageWithImaq                       qq3geName:IMAGE2];
        //        }
        //    }
        
        //    if (i == 0) {
//        [self addBgImageWithImageName:arr[a]];
//        ////        i = 1;
//        ////    }
//        ////    else
//        ////    {
//        [self addBgImageWithImageName1:arr1[a]];
        //
        //        i = 0;
        //    }
        a++;
    }

}
#pragma CATransition动画实现
- (void) transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view andView:(UIView *)view2
{
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    
    //设置运动时间
    animation.duration = 1;
    
    //设置运动type
    animation.type = type;
    if (subtype != nil) {
        
        //设置子类
        animation.subtype = subtype;
    }
    
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [view.layer addAnimation:animation forKey:@"animation"];
    
    // [view2.layer addAnimation:animation forKey:@"animation"];
}
- (void) transitionWithType1:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view andView:(UIView *)view2
{
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    
    //设置运动时间
    animation.duration = 10;
    
    //设置运动type
    animation.type = type;
    if (subtype != nil) {
        
        //设置子类
        animation.subtype = kCATransitionFromBottom;
    }
    
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [view.layer addAnimation:animation forKey:@"animation"];
    // [view2.layer addAnimation:animation forKey:@"animation"];
}



#pragma UIView实现动画
- (void) animationWithView : (UIView *)view WithAnimationTransition : (UIViewAnimationTransition) transition
{
    [UIView animateWithDuration:10 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:transition forView:view cache:YES];
    }];
}



#pragma 给View添加背景图
-(void)addBgImageWithImageName:(NSString *) imageName
{
    PicModel *a1=[[PicModel alloc]init];
    a1=arr[a];
    [_btn1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",a1.image]] forState:UIControlStateNormal];
//    [_btn1 setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //[img1 setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imageName]];
}
#pragma 给View添加背景图
-(void)addBgImageWithImageName1:(NSString *) imageName
{
    // [img setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    PicModel *a1=[[PicModel alloc]init];
    a1=arr1[a];
    [_btn2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://weixin.inhomehz.com",a1.image]] forState:UIControlStateNormal];
    // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imageName]];
}

@end
