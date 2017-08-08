//
//  LoadingAnimationView.m
//  InterestTest
//
//  Created by 商佳敏 on 17/3/30.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "LoadingAnimationView.h"
#import "SDWebImage.h"
#import "Constants.h"

@implementation LoadingAnimationView

-(instancetype)initWithFrame:(CGRect)frame andGif:(NSString *)gifName
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *bg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        bg.backgroundColor=[UIColor whiteColor];
        [self addSubview:bg];
        UIImageView *gifView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-200, SCREEN_HEIGHT/2-150, 400, 300)];
         gifView.image = [UIImage sd_animatedGIFNamed:gifName];
        [bg addSubview:gifView];
      }
       return self;
}

@end
