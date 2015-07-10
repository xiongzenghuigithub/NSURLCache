

#import <Foundation/Foundation.h>

@interface NSObject (Commom)


////获取fileName的完整地址
//+ (NSString* )pathInCacheDirectory:(NSString *)fileName;
//
////创建缓存文件夹
//+ (BOOL)createDirInCache:(NSString *)dirName;
//
////图片
//+ (BOOL)saveImage:(UIImage *)image imageName:(NSString *)imageName;
//+ (NSData*)loadImageDataWithName:( NSString *)imageName;
//+ (BOOL)deleteImageCache;
//
////网络请求
//+ (BOOL)saveResponseData:(NSDictionary *)data toPath:(NSString *)requestPath;//缓存请求回来的json对象
//+ (id)loadResponseWithPath:(NSString *)requestPath;//返回一个NSDictionary类型的json数据
//+ (BOOL)deleteResponseCache;
//
////统一处理JSON字典
//-(id)handleResponse:(id)responseJSON;

//NSUserDefaults
+ (void)saveObject:(id)object forKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;

@end
