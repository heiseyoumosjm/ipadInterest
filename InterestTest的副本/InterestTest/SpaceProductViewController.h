//
//  SpaceProductViewController.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/8.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "BaseViewController.h"

@interface SpaceProductViewController : BaseViewController
- (IBAction)ChangeUnit:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *ImgLeft;
@property (weak, nonatomic) IBOutlet UIImageView *ImgTop;
@property (weak, nonatomic) IBOutlet UIImageView *ImgMid;
@property (weak, nonatomic) IBOutlet UIImageView *ImgBottom;
@property (weak, nonatomic) IBOutlet UIView *goodsView;
@property (strong, nonatomic) UICollectionView *collection;
@property (strong, nonatomic) NSString *room_function_id;
@property (strong, nonatomic) NSMutableArray *roomDataArr;
@property (strong, nonatomic) NSString *index;
@property (strong, nonatomic) NSString *picindex;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistance;

@end
