//
//  HttpHelper.m
//  InterestTest
//
//  Created by 商佳敏 on 17/4/26.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "HttpHelper.h"

@implementation HttpHelper
@synthesize manager,appDelegate;
/*
 * 初始化方法
 */
+ (HttpHelper *)httpHelper
{
    static HttpHelper *httpHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //初始化自己
        httpHelper = [[HttpHelper alloc] init];
        //实例化请求对象
        httpHelper.manager = [AFHTTPSessionManager manager];
        //设置请求和接收数据类型(JSON)
        httpHelper.manager.requestSerializer = [AFJSONRequestSerializer serializer];   //请求
        httpHelper.manager.responseSerializer = [AFJSONResponseSerializer serializer];   //响应
        
        httpHelper.manager.requestSerializer= [AFHTTPRequestSerializer serializer];
        
        
        
        httpHelper.appDelegate = [AppDelegate appDelegate];
        [httpHelper.manager.requestSerializer setValue:@"1an7uma11langjumall!" forHTTPHeaderField:@"JOKE"];
        
        //        [httpHelper.manager.requestSerializer setValue:[NSString stringWithFormat:@"%@%@%@",AcceptValue,APIVersion,TransferType] forHTTPHeaderField:Accept];
        [httpHelper.manager.requestSerializer setValue:AcceptValue forHTTPHeaderField:Accept];
        
        [httpHelper.manager.requestSerializer setValue:Origin forHTTPHeaderField:@"Origin"];
        
        
        
        //设置请求超时的时间(8s)
        httpHelper.manager.requestSerializer.timeoutInterval = 6.0f;
        NSLog(@"++++++++++++++requestSerializer%@",httpHelper.manager.requestSerializer.HTTPRequestHeaders);
        
    });
    return httpHelper;
}

/*
 * 传入userToken
 */
- (void)setUserToken:(NSString *)userToken
{
    [manager.requestSerializer setValue:userToken forHTTPHeaderField:Authorization];
}

/*
 * GET方法
 */
- (void)basicGetURL:(NSString *)requestURL andParams:(NSMutableDictionary *)requestParams andSuccess:(void (^) (NSDictionary * successData))successBlock andError:(void (^) (NSError *error))errorBlock
{
    //   http://api.weixin.inhomehz.com/v1/product-goods/get-goods-detail?goods_id=1
    //构造URL
    NSString *URL = [[NSString stringWithFormat:@"%@%@",@"http://api.mall.inhomehz.com/v1/",requestURL]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"++++++++++++++++请求的URL为:%@",URL);
    
    [manager GET:URL parameters:requestParams progress:^(NSProgress * downloadProgress) {
        
        NSLog(@"++++++++++++++++请求的数据进度为:%@",downloadProgress);
    } success:^(NSURLSessionDataTask * task, id responseObject) {
        
        if(successBlock)
        {
            //JSON解析
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject];
            //利用块返回数据
            successBlock(dic);
        }
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        
        if(errorBlock)
        {
            errorBlock(error);
        }
    }];
}

/*
 * POST方法
 */
- (void)basicPostURL:(NSString *)requestURL andParams:(NSMutableDictionary *)requestParams andSuccess:(void (^) (NSDictionary * successData))successBlock andError:(void (^) (NSError *error))errorBlock
{
    //构造URL
    NSString *URL = [[NSString stringWithFormat:@"%@%@",DATAAPI,requestURL]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"++++++++++++++++请求的URL为:%@",URL);
    
    [manager POST:URL parameters:requestParams progress:^(NSProgress * uploadProgress) {
        
        NSLog(@"++++++++++++++++请求的数据进度为:%@",uploadProgress);
    } success:^(NSURLSessionDataTask * task, id responseObject) {
        
        if(successBlock)
        {
            //JSON解析
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject];
            //利用块返回数据
            successBlock(dic);
        }
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        
        if(errorBlock)
        {
            errorBlock(error);
        }
    }];
}
/*
 * POST方法1
 */
- (void)basicPostURL1:(NSString *)requestURL andParams:(NSMutableDictionary *)requestParams andSuccess:(void (^) (NSDictionary * successData))successBlock andError:(void (^) (NSError *error))errorBlock
{
    //构造URL
    NSString *URL = [[NSString stringWithFormat:@"%@%@",@"http://api.mall.inhomehz.com/v1/",requestURL]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"++++++++++++++++请求的URL为:%@",URL);
    
    [manager POST:URL parameters:requestParams progress:^(NSProgress * uploadProgress) {
        
        NSLog(@"++++++++++++++++请求的数据进度为:%@",uploadProgress);
    } success:^(NSURLSessionDataTask * task, id responseObject) {
        
        if(successBlock)
        {
            //JSON解析
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject];
            //利用块返回数据
            successBlock(dic);
        }
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        
        if(errorBlock)
        {
            errorBlock(error);
        }
    }];
}

/*
 * items 的POST方法
 */
- (void)postAchieveListParamsURL:(NSString *)requestURL andParams:(NSMutableDictionary *)params andSuccess:(void (^) (NSDictionary * successData))successBlock andError:(void (^) (NSError *error))errorBlock
{
    [self basicPostURL:requestURL andParams:params andSuccess:^(NSDictionary *successData) {
        
        if(successBlock)
        {
            successBlock(successData);
        }
    } andError:^(NSError *error) {
        
        if(errorBlock)
        {
            errorBlock(error);
            //            NSMutableDictionary *userInfo=[[NSMutableDictionary alloc]init];
            //            userInfo=[error ob]
            
            NSLog(@"+++++++++++++Error:%ld",error.code);
        }
    }];
}

/*
 * items 的POST方法
 */
- (void)postAchieveListParamsURL1:(NSString *)requestURL andParams:(NSMutableDictionary *)params andSuccess:(void (^) (NSDictionary * successData))successBlock andError:(void (^) (NSError *error))errorBlock
{
    [self basicPostURL1:requestURL andParams:params andSuccess:^(NSDictionary *successData) {
        
        if(successBlock)
        {
            successBlock(successData);
        }
    } andError:^(NSError *error) {
        
        if(errorBlock)
        {
            errorBlock(error);
            //            NSMutableDictionary *userInfo=[[NSMutableDictionary alloc]init];
            //            userInfo=[error ob]
            
            NSLog(@"+++++++++++++Error:%ld",error.code);
        }
    }];
}


/*
 * items 的GET方法
 */
- (void)getAchieveListParamsURL:(NSString *)requestURL andParams:(NSMutableDictionary *)params andSuccess:(void (^) (NSDictionary * successData))successBlock andError:(void (^) (NSError *error))errorBlock
{
    [self basicGetURL:requestURL andParams:params andSuccess:^(NSDictionary *successData) {
        
        if(successBlock)
        {
            successBlock(successData);
        }
    } andError:^(NSError *error) {
        
        if(errorBlock)
        {
            errorBlock(error);
            NSLog(@"+++++++++++++Error:%ld",error.code);
        }
    }];
}

/*
 * 图片
 */
- (void)uploadImg:(NSString *)requestURL andParameter:(NSDictionary *)parameter addImgDate:(UIImage *)avatar andSuccess:(void (^) (NSDictionary * successData))successBlock andError:(void (^) (NSError *error))errorBlock
{
    //构造URL
    NSString *URL = [[NSString stringWithFormat:@"%@%@",DATAAPI,requestURL]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:URL parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFormData:UIImageJPEGRepresentation(avatar, 0.1) name:@"avatar/png"];
        
        [formData appendPartWithFileData:UIImageJPEGRepresentation(avatar, 0.1) name:@"avatar" fileName:@"avatar.png" mimeType:@"avatar/png"];
        
    }progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //进度条
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //上传成功,返回响应
        NSLog(@"%@",responseObject);
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * task, NSError *  error) {
        //失败
        NSLog(@"%@",error);
        if(errorBlock)
        {
            errorBlock(error);
            NSLog(@"+++++++++++++Error:%@",error);
        }
    }];
}

///*
// * 微信授权后请求Token
// */
//- (void)fetchWXAccessToken:(NSString *)code andSuccess:(void (^) (WxLoginModel * wxLoginModel))successBlock andError:(void (^) (NSError *error))errorBlock
//{
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:kwxAppId forKey:@"appid"];
//    [params setValue:kwxSecret forKey:@"secret"];
//    [params setValue:code forKey:@"code"];
//    [params setValue:@"authorization_code" forKey:@"grant_type"];
//
//    //构造URL
//    NSString *URLStr = [[NSString stringWithFormat:@"%@?appid=%@&secret=%@&code=%@&grant_type=authorization_code",wxTokenApi,kwxAppId,kwxSecret,code]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    //初始化URL
//    NSURL * URL = [NSURL URLWithString:URLStr];
//    //初始化请求
//    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:URL];
//    //设置请求方法
//    [request setHTTPMethod:@"GET"];
//    //发请求并处理数据
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]  completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//
//        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//
//        WxLoginModel *wxLoginModel = [[WxLoginModel alloc] init];
//        wxLoginModel.token = [dic objectForKey:@"access_token"];
//        wxLoginModel.openid = [dic objectForKey:@"openid"];
//        wxLoginModel.refresh_token = [dic objectForKey:@"refresh_token"];
//        wxLoginModel.unionid = [dic objectForKey:@"unionid"];
//
//        successBlock(wxLoginModel);
//    }];
//}
//
///*
// * 微信请求Token后请求用户信息
// */
//- (void)fetchWXUserInfo:(WxLoginModel *)wxLoginModel
//{
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:wxLoginModel.token forKey:@"access_token"];
//    [params setValue:wxLoginModel.openid forKey:@"openid"];
//
//    //构造URL
//    NSString *URLStr = [[NSString stringWithFormat:@"%@?access_token=%@&openid=%@",userInfoApi,wxLoginModel.token,wxLoginModel.openid]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    //初始化URL
//    NSURL * URL = [NSURL URLWithString:URLStr];
//    //初始化请求
//    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:URL];
//    //设置请求方法
//    [request setHTTPMethod:@"GET"];
//    //发请求并处理数据
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]  completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//
//        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//
//        wxLoginModel.external_name = [dic objectForKey:@"nickname"];
//        wxLoginModel.avatar = [dic objectForKey:@"headimgurl"];
//
//        NSLog(@"+++++++++++微信授权返回的用户信息：%@",wxLoginModel);
//
//        //发通知
//        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
//        [center postNotificationName:@"WXUserLoginSucceed" object:wxLoginModel];
//    }];
//}
//
//
/*
 * 发布作品
 */
- (void)postWorksURL:(NSString *)requestURL andImage:(NSMutableArray *)images andParams:(NSMutableDictionary *)params andSuccess:(void (^) (NSDictionary * successData))successBlock andError:(void (^) (NSError *error))errorBlock
{
    //构造URL
    NSString *URL = [[NSString stringWithFormat:@"%@%@",DATAAPI,requestURL]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"++++++++++++++++请求的URL为:%@",URL);
    
    [manager POST:URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for(int i=1;i<images.count;i++)
        {
            [formData appendPartWithFormData:UIImageJPEGRepresentation(images[i-1], 0.1) name:[NSString stringWithFormat:@"images[%d]/png",i-1]];
            
            [formData appendPartWithFileData:UIImageJPEGRepresentation(images[i], 0.1) name:[NSString stringWithFormat:@"images[%d]",i-1] fileName:[NSString stringWithFormat:@"images[%d].png",i-1] mimeType:[NSString stringWithFormat:@"images[%d]/png",i-1]];
        }
    } progress:^(NSProgress *uploadProgress) {
        
        NSLog(@"++++++++++++++++请求的数据进度为:%@",uploadProgress);
    } success:^(NSURLSessionDataTask * task, id responseObject) {
        
        if (successBlock)
        {
            //JSON解析
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject];
            //利用块返回数据
            successBlock(dic);
        }
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        
        if(errorBlock)
        {
            errorBlock(error);
            NSLog(@"+++++++++++++Error:%@",error);
        }
    }];
}

///*
// * 检验APP线上版本
// */
//- (void)updateApp
//{
//    //构造URL
//    NSString *URL = [[NSString stringWithFormat:@"%@%@", APPRENEWURL, APPID]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//    NSLog(@"++++++++++++++++请求的URL为:%@",URL);
//
//    [manager GET:URL parameters:nil progress:^(NSProgress * downloadProgress) {
//
//        NSLog(@"++++++++++++++++请求的数据进度为:%@",downloadProgress);
//    } success:^(NSURLSessionDataTask * task, id responseObject) {
//
//        //JSON解析
//        NSDictionary *appInfoDict = [NSDictionary dictionaryWithDictionary:responseObject];
//
//        AppVersionModels *appModels = [[AppVersionModels alloc] initWithDictionary:appInfoDict error:nil];
//        NSLog(@"========APP线上版本信息：%@",[appModels toDictionary]);
//        //获取当前设备中应用的版本号
//        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
//        NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
//
//        AppVersionModel *appModel = appModels.results.firstObject;
//        //获取服务器上应用的最新版本号
//        NSString *updateVersion = appModel.version;
//
//        //祛除字符串中的所有@"."
//        NSUInteger current = [[currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
//        NSUInteger update = [[updateVersion stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
//
//        if(current < update){
//            // 提示更新
//            [self showVersionAlert:appModel];
//        }
//    } failure:^(NSURLSessionDataTask * task, NSError * error) {
//
//        NSLog(@"+++++++++++++Error:%@",error);
//    }];
//}
//
//#pragma mark - 提示
//- (void)showVersionAlert:(AppVersionModel *)appModel
//{
//    //更新地址
//    self.trackViewUrl = appModel.trackViewUrl;
//
//    NSString *titleStr = [NSString stringWithFormat:@"%@", appModel.trackName];
//    NSString *messageStr = [NSString stringWithFormat:@"发现新版本(%@),赶快体验最新版本吧！", appModel.version];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"安装", nil];
//    alert.tag = [APPID intValue];
//    [alert show];
//}
//
//#pragma mark - 判断用户点击了哪一个按钮
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (alertView.tag == [APPID intValue])
//    {
//        if (buttonIndex == 1)
//        {
//            //点击”升级“按钮，就从打开app store上应用的详情页面
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.trackViewUrl]];
//        }
//    }
//}

@end