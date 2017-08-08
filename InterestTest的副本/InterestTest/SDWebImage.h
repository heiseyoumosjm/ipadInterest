//
//  SDWebImage.h
//  zhenpin
//
//  Created by Sailor on 16/5/23.
//  Copyright © 2016年 iSailor. All rights reserved.
//

#ifndef SDWebImage_h
#define SDWebImage_h

//判断NSData是否什么类型的图片(例如:jpg,png,gif)
#import "NSData+ImageContentType.h"

//是SDWebImage包的一部分
#import "SDImageCache.h"      //缓存相关
#import "SDWebImageCompat.h"  //组件相关
#import "SDWebImageDecoder.h" //解码相关

//图片下载以及下载管理器
#import "SDWebImageDownloader.h"
#import "SDWebImageDownloaderOperation.h"

//管理以及操作
#import "SDWebImageManager.h"
#import "SDWebImageOperation.h"

//UIButton类目
#import "UIButton+WebCache.h"

//gif类目
#import "UIImage+GIF.h"

//图片其他类目
#import "UIImage+MultiFormat.h"
//#import "UIImage+WebP.h"
#import "UIImageView+WebCache.h"

#endif /* SDWebImage_h */
