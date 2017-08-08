//
//  ResultViewController.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/4.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "BaseViewController.h"

@interface ResultViewController : BaseViewController
@property (nonatomic,strong)NSString *color_sentence;
@property (nonatomic,strong)NSString *fg_sentence;
@property (nonatomic,strong)NSMutableArray *result_imgs;
@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet UIImageView *topImg;

@property (weak, nonatomic) IBOutlet UIImageView *bottomImg;
@property (weak, nonatomic) IBOutlet UILabel *detail1;
@property (weak, nonatomic) IBOutlet UILabel *detail2;
@property (weak, nonatomic) IBOutlet UILabel *likeTitle;

@end
