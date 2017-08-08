//
//  PicModel.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/1.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@interface PicModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *created_at;
@property (strong, nonatomic) NSString<Optional> *image;
@property (strong, nonatomic) NSString<Optional> *like_count;
@property (strong, nonatomic) NSString<Optional> *not_like_count;

@property (strong, nonatomic) NSString<Optional> *position;
@property (strong, nonatomic) NSString<Optional> *tags;
@property (strong, nonatomic) NSString<Optional> *topic_id;
@property (strong, nonatomic) NSString<Optional> *updated_at;
@property (strong, nonatomic) NSString<Optional> *is_like;
@property (strong, nonatomic) NSString<Optional> *id;
//"created_at" = 1483780864;
//id = 51;
//image = "http://weixin.inhomehz.com/res/upload/1/19/14837808488175.jpg";
//"like_count" = 49;
//"not_like_count" = 89;
//position = 48;
//tags = "\U6e2f\U5f0f,\U9ec4\U8272,\U9910\U5385";
//"topic_id" = 1;
//"updated_at" = 1488353583;


@end
