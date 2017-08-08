//
//  goodsModel.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/16.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "goodsAtrrsModel.h"
@protocol goodsModel
@end
@interface goodsModel : JSONModel
//{
//    "after_sales_content" = "\U62b1\U6795\U8d2d\U4e70\U8bf4\U660e
//    \n\U5173\U4e8e\U54c1\U724c
//    \n\U3010In\U5bb6\U3011\U4e3a\U539f\U521b\U8f6f\U9970\U54c1\U724c\Uff0c\U6240\U6709\U4ea7\U54c1\U5747\U7531\U539f\U521b\U56e2\U961f\U8bbe\U8ba1\U7814\U53d1\Uff0c\U5176\U81f4\U529b\U4e8e\U53d1\U6325\U4ea7\U54c1\U5f00\U53d1\U3001\U98ce\U683c\U8bbe\U8ba1\U3001\U4e13\U4e1a\U914d\U5957\U3001\U5bfc\U8d2d\U4f53\U9a8c\U7b49\U4e13\U4e1a\U4f18\U52bf\Uff0c\U4ee5\U8bbe\U8ba1\U3001\U670d\U52a1\U7684\U4e13\U5c5e\U4f53\U9a8c\U6ee1\U8db3\U6d88\U8d39\U8005\U7684\U4e2a\U4f53\U9700\U6c42\Uff0c\U5efa\U7acb\U6574\U4f53\U5bb6\U5c45\U8f6f\U9970\U54c1\U724c\U4ef7\U503c\Uff0c\U5f15\U9886\U539f\U521b\Uff0c\U54c1\U5473\U751f\U6d3b\U3002
//    \n
//    \n\U5173\U4e8e\U5e93\U5b58
//    \n\U672c\U5e97\U51fa\U552e\U4ea7\U54c1\U5927\U591a\U4e3a\U7eaf\U624b\U5de5\U521b\U610f\U62b1\U6795\Uff0c\U5e93\U5b58\U6709\U9650\Uff0c\U6545\U62cd\U4e0b\U8ba2\U5355\U7684\U4e70\U5bb6\U4eec\U8bf7\U5c3d\U5feb\U652f\U4ed8\U4ee5\U4fbf\U4e8e\U6211\U4eec\U5c3d\U5feb\U53d1\U8d27\U3002\U751f\U4ea7\U8d27\U671f\U4e00\U822c\U4e3a5-7\U5929\Uff0c\U5982\U679c\U51fa\U73b0\U62cd\U4e0b\U7f3a\U8d27\U7684\U60c5\U51b5\U6211\U4eec\U7684\U5ba2\U670d\U4f1a\U7b2c\U4e00\U65f6\U95f4\U901a\U77e5\U60a8\Uff0c\U656c\U8bf7\U8c05\U89e3\U3002
//    \n
//    \n\U5173\U4e8e\U53d1\U8d27
//    \n\U9ed8\U8ba4\U62cd\U4e0b\U8ba2\U5355\U4ed8\U6b3e\U540e72\U5c0f\U65f6\U53d1\U8d27\Uff0c\U5982\U9047\U8282\U5047\U65e5\U3001\U5e97\U94fa\U4f11\U606f\U7b49\U7279\U6b8a\U60c5\U51b5\U4ee5\U5177\U4f53\U901a\U77e5\U4e3a\U51c6\U3002
//    \n
//    \n\U5173\U4e8e\U9000\U6362\U8d27
//    \n\U6536\U5230\U4ea7\U54c1\U540e\Uff0c\U4e70\U5bb6\U7531\U4e8e\U81ea\U8eab\U539f\U56e0\U9020\U6210\U7684\U9000\U8d27\Uff0c\U9700\U81ea\U884c\U627f\U62c5\U8fd0\U8d39\U3002\U8fd0\U8f93\U9014\U4e2d\U53d1\U751f\U7834\U635f\U9020\U6210\U7684\U9000\U8d27\Uff0c\U8fd0\U8d39\U7531\U5356\U5bb6\U627f\U62c5\U3002\U672c\U5e97\U6240\U6709\U5546\U54c1\U5747\U53ef\U652f\U6301\U9000\U6362\U8d27\U670d\U52a1\U3002\U4ea7\U54c1\U4f7f\U7528\U540e\U906d\U5230\U4eba\U4e3a\U635f\U574f\Uff0c\U5f71\U54cd\U4e8c\U6b21\U9500\U552e\U7684\Uff0c\U6211\U5e97\U6709\U6743\U62d2\U7edd\U63d0\U4f9b\U9000\U6362\U8d27\U670d\U52a1\U3002\U7531\U4e8e\U672c\U5e97\U5927\U591a\U4e3a\U7eaf\U624b\U5de5\U521b\U610f\U62b1\U6795\Uff0c\U8272\U5dee\U548c2CM\U5185\U504f\U5dee\U4e0d\U5c5e\U4e8e\U8d28\U91cf\U95ee\U9898\Uff0c\U4ecb\U610f\U8005\U614e\U62cd\U3002
//    \n
//    \n\U4fdd\U517b\U8bf4\U660e
//    \n1\U3001\U8981\U6b63\U786e\U7684\U6e05\U6d17\U62b1\U6795\U3002\U4f7f\U7528\U6027\U8d28\U6e29\U548c\U7684\U6d17\U8863\U7c89\U8fdb\U884c\U6d17\U6da4\Uff1b
//    \n2\U3001\U6e05\U6d17\U62b1\U6795\U65f6\U9700\U591a\U52a0\U6ce8\U610f\U3002\U4f7f\U7528\U6e29\U548c\U7684\U6d17\U6da4\U5242\U8fdb\U884c\U6d17\U6da4;\U4f7f\U7528\U5927\U578b\U7684\U6d17\U8863\U673a\Uff0c\U53ef\U540c\U65f6\U6d17\U4e24\U4e2a\U62b1\U6795\U3002
//    \n3\U3001\U4e0d\U540c\U6750\U8d28\U8981\U9009\U7528\U4e0d\U540c\U7684\U6e05\U6d17\U65b9\U6cd5\U3002\U4e0d\U540c\U6750\U8d28\U7684\U62b1\U6795\U5e94\U8be5\U8981\U7528\U4e0d\U540c\U7684\U6e05\U6d01\U65b9\U6cd5\U6765\U8fdb\U884c\U6e05\U6d17\Uff0c\U4e73\U80f6\U6795\U5e94\U7528\U51b7\U6d17\U7cbe\U6d78\U6ce1\Uff0c\U7528\U624b\U8f7b\U538b\U540e\U518d\U4ee5\U6e05\U6c34\U53cd\U590d\U51b2\U6d17\U5e72\U51c0\Uff0c\U4e4b\U540e\U518d\U4ee5\U5e72\U5e03\U5305\U88f9\Uff0c\U5c06\U5927\U90e8\U5206\U7684\U6c34\U5206\U5438\U6536\U540e\Uff0c\U653e\U7f6e\U9634\U51c9\U5904\U98ce\U5e72\U5373\U53ef\Uff0c\U5207\U52ff\U5728\U592a\U9633\U4e0b\U66dd\U6652\Uff0c\U4ee5\U514d\U6750\U6599\U53d8\U8d28\U6c27\U5316\U3002
//    \n";
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
//    content = "<p align=\"center\" style=\"text-align:center\"><span style=\"font-size:18px;\"><span style=\"font-family:\U5b8b\U4f53\"><span style=\"font-weight:normal\"><font face=\"\U5b8b\U4f53\">\U62bd\U8c61\U7684\U51e0\U4f55\U56fe\U6848</font></span></span></span></p>
//    \n
//    \n<p align=\"center\" style=\"text-align:center\"><span style=\"font-size:18px;\"><span style=\"font-family:\U5b8b\U4f53\"><span style=\"font-weight:normal\"><font face=\"\U5b8b\U4f53\">\U914d\U4ee5\U771f\U4e1d\U6750\U8d28</font></span></span></span></p>
//    \n
//    \n<p align=\"center\" style=\"text-align:center\"><span style=\"font-size:18px;\"><span style=\"font-family:\U5b8b\U4f53\"><span style=\"font-weight:normal\"><font face=\"\U5b8b\U4f53\">\U5149\U6cfd\U5e7d\U96c5\U7ec6\U817b\Uff0c\U5982\U73cd\U73e0\U4e00\U822c\U8000\U773c</font></span></span></span></p>
//    \n
//    \n<p align=\"center\" style=\"text-align:center\"><span style=\"font-size:18px;\"><span style=\"font-family:\U5b8b\U4f53\"><span style=\"font-weight:normal\"><font face=\"\U5b8b\U4f53\">\U624b\U611f\U67d4\U548c\U98d8\U9038</font></span></span></span></p>
//    \n
//    \n<p align=\"center\" style=\"text-align:center\"><span style=\"font-size:18px;\"><span style=\"font-family:\U5b8b\U4f53\"><span style=\"font-weight:normal\"><font face=\"\U5b8b\U4f53\">\U4ee4\U4eba\U65e0\U6cd5\U5fd8\U6000</font></span></span></span></p>
//    \n";
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
//}

@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *name;
@property (strong, nonatomic) NSString<Optional> *position;
@property (strong, nonatomic) NSMutableDictionary<Optional> *category;
@property (strong, nonatomic) NSMutableDictionary<Optional> *brand;
@property (strong, nonatomic) NSString<Optional> *price;
@property (strong, nonatomic) NSMutableArray<Optional> *imgs;
//
//@property (strong, nonatomic) NSString<Optional> *price;
//@property (strong, nonatomic) NSString<Optional> *promote_price;
//@property (strong, nonatomic) NSString<Optional> *award_coin;
@end
