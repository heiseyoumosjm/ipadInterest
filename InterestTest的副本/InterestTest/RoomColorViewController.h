//
//  RoomColorViewController.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/9.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "BaseViewController.h"
#import "SceneModel.h"
@interface RoomColorViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property(strong,nonatomic)SceneModel *sceneModel;
@property (strong, nonatomic) NSMutableArray *roomDataArr;
@property (strong, nonatomic) NSString *index;
@property (strong, nonatomic) NSString *colorId;
@property (strong, nonatomic) NSString *picindex;
@property (weak, nonatomic) IBOutlet UIButton *colorbtn;
- (IBAction)colorChangeBtn:(UIButton *)sender;
@end
