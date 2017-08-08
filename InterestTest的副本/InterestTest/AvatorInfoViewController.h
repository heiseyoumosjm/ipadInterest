//
//  AvatorInfoViewController.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/15.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "BaseViewController.h"

@interface AvatorInfoViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *avayor;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *loginout;
- (IBAction)loginOutClick:(UIButton *)sender;
@property (strong,nonatomic)NSString *user_name;
@property (strong,nonatomic)NSString *avator;
- (IBAction)myPicClick:(UIButton *)sender;


@end
