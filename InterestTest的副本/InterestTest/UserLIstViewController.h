//
//  UserLIstViewController.h
//  InterestTest
//
//  Created by Mickey on 2017/8/8.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SelectedItem)(NSDictionary *item);
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
- (IBAction)cancal:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *hxview;
@property (weak, nonatomic) IBOutlet UIView *lpview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hxviewheight;
- (IBAction)makeok:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *addnewhxview;
@property (weak, nonatomic) IBOutlet UITextField *inputlp;
@property (weak, nonatomic) IBOutlet UITextField *inputhxh;
@property (weak, nonatomic) IBOutlet UITextField *inputhx;
@property (weak, nonatomic) IBOutlet UITextField *inputarea;

- (IBAction)choosenewhx:(id)sender;
- (IBAction)addnewhxclick:(UIButton *)sender;
- (IBAction)hxcancal:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *backview;
@end
