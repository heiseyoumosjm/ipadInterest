//
//  BasicModel.h
//  InterestTest
//
//  Created by 商佳敏 on 17/4/5.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BasicModel : JSONModel
//"promote_price" = "136.00";
//    "selled_num" = 2;
//    sn = 020101002A;
//    "snap_up" = 0;
//    "snap_up_price" = "<null>";
@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *room_name;
@end
