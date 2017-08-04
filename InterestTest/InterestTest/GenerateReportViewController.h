//
//  GenerateReportViewController.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/27.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "BaseViewController.h"

@interface GenerateReportViewController : BaseViewController
@property(strong,nonatomic)NSMutableArray *dataArr;
- (IBAction)iconClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *allNum;
@property (weak, nonatomic) IBOutlet UILabel *allprice;
@property (weak, nonatomic) IBOutlet UILabel *all;
- (IBAction)toPay:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *shipinLab;

@property (weak, nonatomic) IBOutlet UILabel *newprice;

@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@end
