//懒人周末Api


#import "BaseViewModel.h"

@interface LanrenInfoViewModel : BaseViewModel



+ (AFHTTPRequestOperation *)getAppClientWithSuccessCompet:(void (^)(id responseObject))     success
                                             ErrorComplet:(void (^)(NSNumber *errorCode))   error
                                              FailComplet:(void (^)(NSError *error))        fail;


+ (AFHTTPRequestOperation *)indexInfoListForPagr:(NSInteger)  page
                                   SuccessCompet:(void (^)(id responseObject))  success
                                    ErrorComplet:(void (^)(NSNumber *errorCode)) error
                                     FailComplet:(void (^)(NSError *error))  fail
                                        UseCache:(BOOL)  isUse;

@end
