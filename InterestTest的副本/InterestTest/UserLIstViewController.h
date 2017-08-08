//
//  UserLIstViewController.h
//  InterestTest
//
//  Created by Mickey on 2017/8/8.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SelectedItem)(NSString *item);
@interface UserLIstViewController : BaseViewController

@property(nonatomic,strong)NSString *user_id;
@property (strong, nonatomic) IBOutlet UIView *tablebackview;
@property (strong, nonatomic)UITableView *tableView;

@property (strong, nonatomic) SelectedItem block;

- (void)didSelectedItem:(SelectedItem)block;
- (IBAction)addbtnclick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *headimg;
- (IBAction)editclick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end
