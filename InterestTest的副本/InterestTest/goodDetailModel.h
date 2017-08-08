//
//  goodDetailModel.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/26.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import <JSONModel/JSONModel.h>
//{
//    "begin_at" = 1488339900;
//    brand = "<null>";
//    "can_use_coupon" = 1;
//    category =     {
//        banner = "";
//        coin = 0;
//        id = 20;
//        "is_online" = 1;
//        name = "\U62b1\U6795";
//        "parent_id" = 3;
//        "serial_no" = 1;
//        "show_type" = 0;
//    };
//    coin = 0;
//    "expiration_at" = 0;
//    id = 2;
//    imgs =     (
//                "/2/14881843243913.jpg"
//                );
//    "limit_buy" = 999;
//    name = "\U65b0\U53e4\U5178\U51e0\U4f55\U62bd\U8c61\U62b1\U6795\U7ea2 020101002A";
//    price = "256.00";
//    "promote_price" = "136.00";
//    "selled_num" = 2;
//    sn = 020101002A;
//    "snap_up" = 0;
//    "snap_up_price" = "<null>";
//    status = 1;
//    stock = 1;
//    time = 1490667411;
//},

@interface goodDetailModel : JSONModel
@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *name;
@property (strong, nonatomic) NSString<Optional> *position;
@property (strong, nonatomic) NSMutableDictionary<Optional> *category;
@property (strong, nonatomic) NSMutableArray<Optional> *imgs;
@property (strong, nonatomic) NSString<Optional> *price;


@end
