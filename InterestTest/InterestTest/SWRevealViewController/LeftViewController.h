//
//  LeftViewController.h
//  InterestTest
//
//  Created by 商佳敏 on 17/2/28.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "BaseViewController.h"

@interface LeftViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) IBOutlet UITableView *rearTableView;
@property (weak, nonatomic) IBOutlet UIButton *loginOut;

- (IBAction)loginOutBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *avator;
@property (weak, nonatomic) IBOutlet UIButton *avatorBtn;
- (IBAction)avatorClick:(UIButton *)sender;

@end
