//
//  ToolHelper.m
//  zhenpin
//
//  Created by Sailor on 16/5/23.
//  Copyright © 2016年 iSailor. All rights reserved.
//

#import "ToolHelper.h"

NSDate *date;
NSDateFormatter *dateFormatter;

@implementation ToolHelper

/**
 *  初始化方法
 */
+ (ToolHelper*)toolHelper
{
    static ToolHelper *toolHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        toolHelper = [[ToolHelper alloc] init];
        dateFormatter=[[NSDateFormatter alloc]init];
    });
    return toolHelper;
}

/**
 *  生成随机字符串
 */
- (NSString*)randomString
{
    char data[15];
    for (int x=0;x<10;data[x++] = (char)('a' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:10 encoding:NSUTF8StringEncoding];
}

/**
 *  裁剪图片
 */
- (UIImage *)cropImage:(UIImage*)image
{
    // Create rectangle from middle of current image
    CGRect croprect = CGRectMake((image.size.width -200)/3, 0 ,
                                 (200), 300);
    // Draw new image in current graphics context
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], croprect);
    // Create new cropped UIImage
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    return croppedImage;
}

- (int)charactersInString:(NSString*)string
{
    int strlength = 0;
    char* p = (char*)[string cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[string lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++)
    {
        if (*p)
        {
            p++;
            strlength++;
        }
        else
        {
            p++;
        }
    }
    return (strlength+1)/2;
}

/**
 *  分割字符串
 *
 *  @param string 被分割的字符串
 *  @param sep    分隔符
 *
 *  @return 返回可变数组
 */
- (NSMutableArray*)stringToArr:(NSString*)string seprate:(NSString*)sep
{
    return [NSMutableArray arrayWithArray:[string componentsSeparatedByString:sep]];
}
/**
 *  分割数组
 *  生成字符串
 */
- (NSString *)stringToString:(NSMutableArray*)array seprate:(NSString*)sep
{
    return [array componentsJoinedByString:sep];
}

-(UIImage *)scaleToScreenWidth:(UIImage *)origin
{
    CGSize originSize = origin.size;
    CGSize newSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*originSize.height/originSize.width);
    
    UIGraphicsBeginImageContext(originSize);
    [origin drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (BOOL)basicUserDefaults:(NSString*)key
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:key])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
        return YES;
    }
    else
    {
        return NO;
    }
}

-(BOOL)firstLaunch
{
    return [self basicUserDefaults:[NSString stringWithFormat:@"firstLaunch%@",APIVersion]];
}
-(BOOL)firstLogin
{
    return [self basicUserDefaults:[NSString stringWithFormat:@"firstlogin%@",APIVersion]];
}

- (void)oppsiteUserDefaults:(NSString*)key
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:key])
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:key];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
    }
}

- (NSString*)formatDate:(NSUInteger)time style:(NSString*)style
{
    date = [NSDate dateWithTimeIntervalSince1970:time];
    dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:style];
    return [dateFormatter stringFromDate:date];
}

//当前时间
- (NSString*)nonceTime
{
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:TimeDetailedStyle];
    NSString * na = [df stringFromDate:currentDate];
    
    return na;
}

- (NSString*)rangeDate:(NSInteger)timeInt
{
    //计算时间
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * newDateFormatter = [dateFormatter dateFromString:[[ToolHelper toolHelper] formatDate:timeInt style:@"yyyy-MM-dd HH:mm:ss"]];       //取出的时间
    
    NSTimeZone * timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate * current_date = [[NSDate alloc] init];
    
    NSTimeInterval time = [current_date timeIntervalSinceDate:newDateFormatter];
    
    int month = ((int)time)/(3600*24*30);
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minute = ((int)time)%(3600*24)/60;
    int second = ((int)time)%(3600*24*60*60);
    if(month!=0)
    {
        return [NSString stringWithFormat:@"%i%@",month,@"个月前"];
    }
    else if(days!=0)
    {
        return [NSString stringWithFormat:@"%i%@",days,@"天前"];
    }
    else if(hours!=0)
    {
        return [NSString stringWithFormat:@"%i%@",hours,@"小时前"];
    }
    else if(minute!=0)
    {
        return [NSString stringWithFormat:@"%i%@",minute,@"分钟前"];
    }
    else
    {
        return [NSString stringWithFormat:@"%i%@",second,@"秒前"];
    }
}

- (NSString *)flattenHTML:(NSString *)html
{
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO)
    {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    
    NSCharacterSet *nbsp = [NSCharacterSet characterSetWithCharactersInString:@"&nbsp;"];
    html = [html stringByTrimmingCharactersInSet:nbsp];
    return [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)formatDistance:(float)distance
{
    return [NSString stringWithFormat:distance>1000?@"%dkm":@"%dm",(int)roundf(distance>1000?distance/1000:distance)];
}

/**
 *  验证邮箱
 */
- (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
- (BOOL)validateName:(NSString *)name
{
//    ^[[\u4e00-\u9fa5a-zA-Z0-9_/-]+$ [a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]{1,15}+
//    NSString *nameRegex = @"^[\u4e00-\u9fa5a-zA-Z]+[\u4e00-\u9fa5a-zA-Z0-9\-_]*$";
    NSString *nameRegex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]{1,15}+";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    NSLog(@"%d",[nameTest evaluateWithObject:name]);
    return [nameTest evaluateWithObject:name];
}

/**
 *  验证手机号
 */
- (BOOL)validatePhone:(NSString *)phone
{
    NSString *phoneRegex = @"^1+[3578]+\\d{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

/*
 * MD5加密
 */
- (NSString *)encryptMD5:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02X", digest[i]];
    }
    return output;
}

/*
 * 计算文字长度
 */
- (CGSize)sizeWithString:(NSString *)string andSize:(NSInteger)size
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 10000) //限制最大的宽度和高度
                                       options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin  //采用换行模式
                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]}      //传人的字体字典
                                       context:nil];
    return rect.size;
}

/*
 * 替换某个范围的子串
 */
- (NSString *)byReplacingCharActer:(NSString *)phone
{
    if([self validatePhone:phone])
    {
        return [phone stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"XXXXX"];
    }
    else
    {
        return phone;
    }
}

/*
 * 截取一定长度的串
 */
- (NSString *)interceptReplacingString:(NSString *)time
{
    return [time substringToIndex:16];
}

/*
 * 判断是否有http://子串
 */
- (BOOL)ReplacingCharActer:(NSString *)portrait
{
    NSRange theRange = [portrait rangeOfString:@"http://"];
    if(theRange.length == 0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

/*
 * 判断是否无值
 */
- (BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL)
    {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        return YES;
    }
    return NO;
}
//指定宽度按比例缩放
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}
NSMutableAttributedString *GetAttributedText(NSString *value) {//这里调整富文本的段落格式
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:value];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8.0];
    //    [paragraphStyle setParagraphSpacing:11];  //调整段间距
    //    [paragraphStyle setHeadIndent:75.0];//段落整体缩进
    //    [paragraphStyle setFirstLineHeadIndent:.0];//首行缩进
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [value length])];
    return attributedString;
}
- (CGFloat)calculateMeaasgeHeightWithText:(NSString *)string andWidth:(CGFloat)width andFont:(UIFont *)font {
    static UILabel *stringLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{//生成一个同于计算文本高度的label
        stringLabel = [[UILabel alloc] init];
        stringLabel.numberOfLines = 0;
    });
    stringLabel.font = font;
    stringLabel.attributedText = GetAttributedText(string);
    return [stringLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)].height;
}


@end
