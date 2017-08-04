//
//  AlLiModel.h
//  InterestTest
//
//  Created by 商佳敏 on 17/5/10.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface AlLiModel : JSONModel
//"building_folder_id" = 2;
//"case_building_id" = 1;
//"case_name" = "\U5ba2\U5385";
//"case_pics" = "/res/upload/1/b5/14943959933543.jpg";
//"created_at" = 1494395998;
//id = 2;
//"is_collection" = 0;
//"like_num" = 0;
//position = "<null>";
//"updated_at" = 1494395998;
@property (strong, nonatomic) NSString<Optional> *building_folder_id;
@property (strong, nonatomic) NSString<Optional> *case_building_id;
@property (strong, nonatomic) NSString<Optional> *case_name;
@property (strong, nonatomic) NSString<Optional> *case_pics;
@property (strong, nonatomic) NSString<Optional> *created_at;
@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *is_collection;
@property (strong, nonatomic) NSString<Optional> *like_num;
@property (strong, nonatomic) NSString<Optional> *position;
@property (strong, nonatomic) NSString<Optional> *updated_at;
@end
