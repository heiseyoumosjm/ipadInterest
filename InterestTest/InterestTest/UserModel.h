//
//  UserModel.h
//  zhenpin
//
//  Created by mickey on 16/5/23.
//  Copyright © 2016年 mickey. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol UserModel
@end

@interface UserModel : JSONModel

//@property (strong, nonatomic) NSString *openid;
@property (strong, nonatomic) NSString<Optional> *token;
@property (strong, nonatomic) NSString<Optional> *nickname;
@property (strong, nonatomic) NSString<Optional> *username;
@property (strong, nonatomic) NSString<Optional> *head_portrait;

@property (strong, nonatomic) NSString<Optional> *error;
@property (strong, nonatomic) NSString<Optional> *id;

//@property (strong, nonatomic) NSString<Optional> *id;
//@property (strong, nonatomic) NSString<Optional> *email;
//@property (strong, nonatomic) NSString<Optional> *username;
@property (strong, nonatomic) NSString<Optional> *code;
@property (strong, nonatomic) NSString<Optional> *message;


@property (strong, nonatomic) NSString<Optional> *active;
@property (strong, nonatomic) NSString<Optional> *avatar;
@property (strong, nonatomic) NSString<Optional> *birthdate;
@property (strong, nonatomic) NSString<Optional> *blood_type;
@property (strong, nonatomic) NSString<Optional> *city;

@property (strong, nonatomic) NSString<Optional> *client_id;
//@property (strong, nonatomic) NSString<Optional> *id;
//
//@property (strong, nonatomic) NSString<Optional> *code;
@property (strong, nonatomic) NSString<Optional> *cover;

@property (strong, nonatomic) NSString<Optional> *created_at;
@property (strong, nonatomic) NSString<Optional> *credit;
@property (strong, nonatomic) NSString<Optional> *deleted_at;
@property (strong, nonatomic) NSString<Optional> *descriptions;

@property (strong, nonatomic) NSString<Optional> *domain;
@property (strong, nonatomic) NSString<Optional> *email;

@property (strong, nonatomic) NSString<Optional> *emotional_state;
@property (strong, nonatomic) NSString<Optional> *experience;
@property (strong, nonatomic) NSString<Optional> *favourites_count;
@property (strong, nonatomic) NSString<Optional> *followers_count;
@property (strong, nonatomic) NSString<Optional> *friends_count;
@property (strong, nonatomic) NSString<Optional> *gender;

@property (strong, nonatomic) NSString<Optional> *invitation_code;
@property (strong, nonatomic) NSString<Optional> *group;
@property (strong, nonatomic) NSString<Optional> *is_home;
@property (strong, nonatomic) NSString<Optional> *is_recommend;
@property (strong, nonatomic) NSString<Optional> *last_login_ip;
@property (strong, nonatomic) NSString<Optional> *last_login_time;

@property (strong, nonatomic) NSString<Optional> *likes_count;
@property (strong, nonatomic) NSString<Optional> *location;
@property (strong, nonatomic) NSString<Optional> *mobile;
@property (strong, nonatomic) NSString<Optional> *money;
//@property (strong, nonatomic) NSString<Optional> *nickname;
@property (strong, nonatomic) NSString<Optional> *online_status;

@property (strong, nonatomic) NSString<Optional> *phone;
@property (strong, nonatomic) NSString<Optional> *posts_count;
@property (strong, nonatomic) NSString<Optional> *province;
@property (strong, nonatomic) NSString<Optional> *realname;
@property (strong, nonatomic) NSString<Optional> *referee;
@property (strong, nonatomic) NSString<Optional> *score;
@property (strong, nonatomic) NSString<Optional> *start;
//@property (strong, nonatomic) NSString<Optional> *token;
@property (strong, nonatomic) NSString<Optional> *updated_at;
//@property (strong, nonatomic) NSString<Optional> *username;
@property (strong, nonatomic) NSString<Optional> *website;
@property (strong, nonatomic) NSString<Optional> *login_times;
@property (strong, nonatomic) NSString<Optional> *push_on;
@property (strong, nonatomic) NSString<Optional> *hidden_on;
//active = 1;login_times
//avatar = "<null>";
//birthdate = "<null>";
//"blood_type" = "<null>";
//city = 0;
//"client_id" = "<null>";
//code = 200;
//cover = "<null>";
//"created_at" = "2016-06-20 11:49:14";
//credit = 0;
//"deleted_at" = "<null>";
//description = "<null>";
//domain = "<null>";
//email = "<null>";
//"emotional_state" = "<null>";
//experience = 0;
//"favourites_count" = 0;
//"followers_count" = 0;
//"friends_count" = 0;
//gender = "<null>";
//group = 0;
//id = 8;
//"invitation_code" = "<null>";
//"is_home" = 0;
//"is_recommend" = 0;
//"last_login_ip" = "125.120.213.235";
//"last_login_time" = "2016-06-20 11:55:03";
//"likes_count" = 0;
//location = "<null>";
//mobile = 15726818141;
//money = 0;
//nickname = 15726818141;
//"online_status" = 0;
//phone = "<null>";
//"posts_count" = 0;
//province = 0;
//realname = "<null>";
//referee = 0;
//score = 0;
//start = 0;
//token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vMTIwLjI2LjU1LjI4OjUwNTYvYXV0aC9sb2dpbiIsImlhdCI6MTQ2NjM5NDkwMywiZXhwIjoxNDY2NDE2NTAzLCJuYmYiOjE0NjYzOTQ5MDMsImp0aSI6ImNiMDcxMDU5YmM1YTkwZmI4MGM0YjE0M2Q4YTY4OGNjIiwic3ViIjo4fQ.05e9EejexwxfnYOEF6aSn0bkJPMBP9URE77ymbd8MEU";
//"updated_at" = "2016-06-20 11:55:03";
//username = 15726818141;
//website = "<null>";push_on

//loginParm.identifier = _beginLiveModel.anchor.im_uid;
//loginParm.userSig = _beginLiveModel.anchor.im_sig;
//loginParm.appidAt3rd = _beginLiveModel.anchor.im_uid;
@property (strong, nonatomic) NSString<Optional> *im_uid;
@property (strong, nonatomic) NSString<Optional> *im_sig;
//@property (strong, nonatomic) NSString<Optional> *im_gid;
@end
