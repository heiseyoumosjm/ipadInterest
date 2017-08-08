//
//  ChangeRoomViewController.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/8.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "BaseViewController.h"
#import "RoomLayoutModel.h"
#import "RoomProductModel.h"

@interface ChangeRoomViewController : BaseViewController


//代理
@property (strong, nonatomic) id <ChangeLayoutDelegate> delegate;

@property(nonatomic,strong)RoomLayoutModel *roomLayoutModel;
@property(nonatomic,strong)RoomProductModel *roomProductModel;
@property (strong, nonatomic) NSMutableArray *roomDataArr;
@property (strong, nonatomic) NSString *index;
@property (strong, nonatomic) NSString *picindex;
@end
