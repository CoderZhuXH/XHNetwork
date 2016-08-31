//
//  XHNetwork.h
//  XHNetworkExample
//
//  Created by xiaohui on 16/8/20.
//  Copyright © 2016年 returnoc.com. All rights reserved.
//  https://github.com/CoderZhuXH/XHNetwork

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, XHRequestType) {
    
    XHRequestTypeHTTP  = 1, //HTTP,默认
    XHRequestTypeJSON = 2,//JSON

};

typedef NS_ENUM(NSUInteger, XHResponseType) {
    
    XHResponseTypeTypeJSON = 1,//JSON,默认
    XHResponseTypeData = 2,//Data
    XHResponseTypeXML  = 3,//XML

};

typedef void(^XHNetworkSucess) (id response);
typedef void(^XHNetworkFailure) (NSError *error);

@interface XHNetwork : NSObject

/**
 *  设置baseUrl(不设置,使用完整url)
 *
 *  APP启动时,在AppDelegate中设置一次就可以了
 *  @param baseUrl 接口基础url
 */
+(void)setBaseUrl:(NSString *)baseUrl;

/**
 *  获取baseUrl
 *
 *  @return baseUrl
 */
+(NSString *)baseUrl;

/**
 *  设置请求类型及返回数据类型(不设置,默认使用:请求类型-HTTP,返回数据类型-JSON)
 *
 *  APP启动时,在AppDelegate中设置一次就可以了
 *  @param requestType  请求类型-HTTP(AFHTTPRequest),默认
 *  @param responseType 返回数据类型-JSON(AFJSONResponse),默认
 */
+(void)setRequsetType:(XHRequestType)requestType responseType:(XHResponseType)responseType;

/**
 *  取消单个请求
 *
 *  @param url 请求url
 */
+ (void)cancelRequestWithURL:(NSString *)url;

/**
 *  取消所有请求
 */
+ (void)cancelAllRequest;

/**
 *  POST请求
 *
 *  @param URL     URL String
 *  @param dic     参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)POST:(NSString *)URL parameters:(NSDictionary *)dic success:(XHNetworkSucess)success failure:(XHNetworkFailure)failure;

/**
 *  GET请求
 *
 *  @param URL     URL String
 *  @param dic     参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)GET:(NSString *)URL parameters:(NSDictionary *)dic success:(XHNetworkSucess)success failure:(XHNetworkFailure)failure;

#pragma mark-https相关
/**
 *  设置https证书及相关参数,不调用此方法,默认使用http请求
 *
 *  APP启动时,在AppDelegate中设置一次就可以了
 *  @param certificateName          SSL证书名称,仅支持cer格式.“app.bishe.com.cer”,则填“app.bishe.com”(双击后台提供的crt证书--->钥匙串里导出为cer证书 ---> 将cer文件拖入工程即可)
 *  @param allowInvalidCertificates 是否允许无效证书,也就是自建的证书,默认为NO
 *  @param validatesDomainName      是否验证域名,默认YES(比如域名是www.google.com，YES的话:mail.google.com是无法验证通过的)
 */
+(void)setHttpsCertificateName:(NSString *)certificateName allowInvalidCertificates:(BOOL)allowInvalidCertificates validatesDomainName:(BOOL)validatesDomainName;

@end
