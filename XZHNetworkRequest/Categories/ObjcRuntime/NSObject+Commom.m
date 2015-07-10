
#define kPath_ImageCache @"ImageCache"
#define kPath_ResponseCache @"ResponseCache"

#import "NSObject+Commom.h"

@implementation NSObject (Commom)

#pragma mark -
+ (NSString *)getCacheDir {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

#pragma mark -

//判断传入的文件路径是否存在文件，是否时文件夹
+ (BOOL)fileIsExsits:(NSString *)filePath IsDir:(BOOL *)isDir{
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:isDir];
}

+ (NSString* )pathInCacheDirectory:(NSString *)fileName
{
    return [[self getCacheDir] stringByAppendingPathComponent:fileName];
}

+ (BOOL) createDirInCache:(NSString *)dirName
{
    NSString *dirPath = [self pathInCacheDirectory:dirName];
    BOOL isDir = NO;
    BOOL existed = [self fileIsExsits:dirName IsDir:&isDir];
    BOOL isCreated = NO;
    if ( !(isDir == YES && existed == YES) )
    {
        isCreated = [[NSFileManager defaultManager]
                     createDirectoryAtPath:dirPath
                     withIntermediateDirectories:YES
                     attributes:nil
                     error:nil
                     ];
    }
    if (existed) {
        isCreated = YES;
    }
    return isCreated;
}

#pragma mark -
+ (BOOL) saveImage:(UIImage *)image imageName:(NSString *)imageName
{
    if ([self createDirInCache:kPath_ImageCache]) {
        NSString * directoryPath = [self pathInCacheDirectory:kPath_ImageCache];
        BOOL isDir = NO;
        BOOL existed = [self fileIsExsits:directoryPath IsDir:&isDir];
        bool isSaved = false;
        if ( isDir == YES && existed == YES )
        {
            isSaved = [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:imageName] options:NSAtomicWrite error:nil];
        }
        return isSaved;
    }else{
        return NO;
    }
}

+ (NSData*) loadImageDataWithName:( NSString *)imageName
{
    NSString * directoryPath = [self pathInCacheDirectory:kPath_ImageCache];
    BOOL isDir = NO;
    BOOL dirExisted = [self fileIsExsits:directoryPath IsDir:&isDir];
    if ( isDir == YES && dirExisted == YES )
    {
        NSString *abslutePath = [NSString stringWithFormat:@"%@/%@", directoryPath, imageName];
        BOOL fileExisted = [self fileIsExsits:abslutePath IsDir:nil];
        if (!fileExisted) {
            return NULL;
        }
        NSData *imageData = [NSData dataWithContentsOfFile : abslutePath];
        return imageData;
    }
    else
    {
        return NULL;
    }
}

+ (BOOL) deleteImageCache{
    return [self deleteCacheWithPath:kPath_ImageCache];
}


#pragma mark -
+ (BOOL)saveResponseData:(NSDictionary *)data toPath:(NSString *)requestPath{
    
//    User *loginUser = [Login curLoginUser];
//    if (!loginUser) {
//        return NO;
//    }else{
//        requestPath = [NSString stringWithFormat:@"%@_%@", loginUser.global_key, requestPath];
//    }
//    if ([self createDirInCache:kPath_ResponseCache]) {
//        NSString *abslutePath = [NSString stringWithFormat:@"%@/%@.plist", [self pathInCacheDirectory:kPath_ResponseCache], [requestPath md5Str]];
//        return [data writeToFile:abslutePath atomically:YES];
//    }else{
//        return NO;
//    }
    
    return YES;
}
+ (id) loadResponseWithPath:(NSString *)requestPath{//返回一个NSDictionary类型的json数据
//    User *loginUser = [Login curLoginUser];
//    if (!loginUser) {
//        return nil;
//    }else{
//        requestPath = [NSString stringWithFormat:@"%@_%@", loginUser.global_key, requestPath];
//    }
//    NSString *abslutePath = [NSString stringWithFormat:@"%@/%@.plist", [self pathInCacheDirectory:kPath_ResponseCache], [requestPath md5Str]];
//    return [NSMutableDictionary dictionaryWithContentsOfFile:abslutePath];
    
    return nil;
}

#pragma mark -
+ (BOOL) deleteResponseCache{
    return [self deleteCacheWithPath:kPath_ResponseCache];
}

+ (BOOL) deleteCacheWithPath:(NSString *)cachePath{
    NSString *dirPath = [self pathInCacheDirectory:cachePath];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    bool isDeleted = false;
    if ( isDir == YES && existed == YES )
    {
        isDeleted = [fileManager removeItemAtPath:dirPath error:nil];
    }
    return isDeleted;
}

#pragma mark -
-(id)handleResponse:(id)responseJSON{
    NSError *error = nil;
    //code为非0值时，表示有错
//    NSNumber *resultCode = [responseJSON valueForKeyPath:@"code"];
    
//    if (resultCode.intValue != 0) {
//        error = [NSError errorWithDomain:kNetPath_Code_Base code:resultCode.intValue userInfo:responseJSON];
//        [self showError:error];
//        
//        if (resultCode.intValue == 1000) {//用户未登录
//            [Login doLogout];
//            [((AppDelegate *)[UIApplication sharedApplication].delegate) setupLoginViewController];
//        }
//    }
    return error;
}

#pragma mark - 
+ (void)saveObject:(id)object forKey:(NSString *)key {
    [USER_DEFAULT setObject:object forKey:key];
}

+ (id)objectForKey:(NSString *)key {
    return [USER_DEFAULT objectForKey:key];
}

@end
