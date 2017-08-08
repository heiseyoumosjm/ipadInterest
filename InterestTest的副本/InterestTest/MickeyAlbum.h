//
//  MickeyAlbum.h
//  SuperEngineers
//
//  Created by 商佳敏 on 16/6/17.
//  Copyright © 2016年 商佳敏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWebImageManager.h"

typedef enum
{
    MickeyAlbumOutImgViewPointLeftUp =1,
    MickeyAlbumOutImgViewPointRightUp,
    MickeyAlbumOutImgViewPointLeftDown,
    MickeyAlbumOutImgViewPointRightDown
}MickeyAlbumOutImgViewPointType;
#define myScreenHeight  [UIScreen mainScreen].bounds.size.height
#define myScreenWidth [UIScreen mainScreen].bounds.size.width

@protocol MickeyAlbumDelegate <NSObject>
- (void)getCurPage:(NSInteger)curPage;

@end

@interface MickeyAlbum :UIViewController<UIScrollViewDelegate>
@property (nonatomic,assign)CGRect photoFrame;
@property (nonatomic,strong)id<MickeyAlbumDelegate>myDelegate;
-(id)initWithImgUrlArr:(NSArray*)array CurPage:(NSInteger)curpage;
-(id)initWithImgULocationArr:(NSArray*)array CurPage:(NSInteger)curpage;

@end