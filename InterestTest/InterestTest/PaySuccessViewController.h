//
//  PaySuccessViewController.h
//  InterestTest
//
//  Created by 商佳敏 on 17/4/12.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "BaseViewController.h"

@interface PaySuccessViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;
- (IBAction)toLook:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *payMoney;

@property (weak, nonatomic) IBOutlet UILabel *successLab;
@property (strong,nonatomic)NSString *sn;
@property (strong,nonatomic)NSString *money;
@property (strong,nonatomic)NSString *order_id;
@end
