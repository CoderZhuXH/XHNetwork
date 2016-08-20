//
//  XHNetwork.h
//  XHNetworkExample
//
//  Created by xiaohui on 16/8/20.
//  Copyright © 2016年 returnoc.com. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  成功
 */
typedef void(^httpRequestSucess) (id responseObject);
/**
 *  失败
 */
typedef void(^httpRequestFailed) (NSError *error);

@interface XHNetwork : NSObject

/**
 *  POST请求
 *
 *  @param URL     URL String
 *  @param dic     参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)POST:(NSString *)URL parameters:(NSDictionary *)dic success:(httpRequestSucess)success failure:(httpRequestFailed)failure;

@end
