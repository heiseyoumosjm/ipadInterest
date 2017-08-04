//
//  GoodsTableViewCell.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/27.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *chicun;
@property (weak, nonatomic) IBOutlet UIImageView *buliao;
@property (weak, nonatomic) IBOutlet UILabel *price;

- (IBAction)jian:(UIButton *)sender;
- (IBAction)jia:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UILabel *allprice;
@property (weak, nonatomic) IBOutlet UILabel *master;
@property (weak, nonatomic) IBOutlet UIButton *jianbtn;
@property (weak, nonatomic) IBOutlet UIButton *jiabtn;
@property (weak, nonatomic) IBOutlet UIButton *lookGoodBtn;

@end
