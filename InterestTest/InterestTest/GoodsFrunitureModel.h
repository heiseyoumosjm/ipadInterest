//
//  GoodsFrunitureModel.h
//  InterestTest
//
//  Created by 商佳敏 on 17/5/10.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GoodsFrunitureModel : JSONModel
//{
//    "begin_at" = 0;
//    brand = "<null>";
//    "can_use_coupon" = 0;
//    category =             {
//        banner = "/1/14913752413192.png";
//        coin = 0;
//        icon = "<null>";
//        id = 47;
//        "is_online" = 0;
//        name = "\U4e09\U4eba\U6c99\U53d1";
//        "parent_id" = 43;
//        position = 1;
//        "serial_no" = "<null>";
//        "show_type" = 3;
//    };
//    coin = 0;
//    "expiration_at" = 0;
//    id = 252;
//    imgs =             (
//                        "/2/14913592258981.png"
//                        );
//    "is_collection" = 0;
//    "limit_buy" = 999;
//    name = "\U4e09\U4eba\U6c99\U53d1";
//    position = "<null>";
//    price = "32400.00";
//    "promote_price" = "<null>";
//    "selled_num" = 0;
//    sn = "M-1737";
//    "snap_up" = 0;
//    "snap_up_price" = "<null>";
//    "space_imgs" =             (
//                                ""
//                                );
//    status = 0;
//    stock = 20002;
//    time = 1493017614;
//}
@property (strong, nonatomic) NSDictionary<Optional> *category;
@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSMutableArray<Optional> *imgs;
@property (strong, nonatomic) NSString<Optional> *is_collection;
@property (strong, nonatomic) NSString<Optional> *name;
@end
