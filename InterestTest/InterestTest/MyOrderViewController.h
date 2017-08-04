//
//  MyOrderViewController.h
//  InterestTest
//
//  Created by 商佳敏 on 17/4/7.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "BaseViewController.h"

@interface MyOrderViewController : BaseViewController
@property(strong,nonatomic)NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UILabel *allNum;

@property (weak, nonatomic) IBOutlet UILabel *allmoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *allmoneyNum;

@property (weak, nonatomic) IBOutlet UILabel *discountNum;
@property (weak, nonatomic) IBOutlet UILabel *paymoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *paymoney;


@end
