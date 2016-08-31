//
//  XHNetwork.m
//  XHNetworkExample
//
//  Created by xiaohui on 16/8/20.
//  Copyright © 2016年 returnoc.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHNetwork

#import "XHNetwork.h"
#import "AFHTTPSessionManager.h"

#ifdef DEBUG
#define DebugLog(...) NSLog(__VA_ARGS__)
#else
#define DebugLog(...)
#endif

typedef NSURLSessionTask XHURLSessionTask;


static NSString *xh_networkBaseUrl = nil;
static XHRequestType  xh_requestType  = XHRequestTypeJSON;
static XHResponseType xh_responseType = XHResponseTypeTypeJSON;
static NSMutableArray *xh_requestTasks;

/**
 *  是否使用https
 */
static BOOL xh_useHttps = NO;
/**
 *  SSL证书名称
 */
static NSString *xh_httpsCertificateName = nil;
/**
 *  是否允许无效证书
 */
static BOOL xh_allowInvalidCertificates = NO;

/**
 *  是否验证域名
 */
static BOOL xh_validatesDomainName = YES;

@implementation XHNetwork

+(void)setRequsetType:(XHRequestType)requestType responseType:(XHResponseType)responseType
{
    xh_requestType = requestType;
    xh_responseType = responseType;
}

+(void)setBaseUrl:(NSString *)baseUrl
{
    xh_networkBaseUrl = baseUrl;
}

+(NSString *)baseUrl
{
    return xh_networkBaseUrl;
}

+ (void)cancelRequestWithURL:(NSString *)url {
    
    if (url == nil) return;
    
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(XHURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[XHURLSessionTask class]]
                && [task.currentRequest.URL.absoluteString hasSuffix:url]) {
                [task cancel];
                [[self allTasks] removeObject:task];
                return;
            }
        }];
    };
}
+ (void)cancelAllRequest {
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(XHURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[XHURLSessionTask class]]) {
                [task cancel];
            }
        }];
        
        [[self allTasks] removeAllObjects];
    };
}
+(void)setHttpsCertificateName:(NSString *)certificateName allowInvalidCertificates:(BOOL)allowInvalidCertificates validatesDomainName:(BOOL)validatesDomainName
{
    xh_useHttps = YES;
    xh_httpsCertificateName = certificateName;
    xh_allowInvalidCertificates = allowInvalidCertificates;
    xh_validatesDomainName = validatesDomainName;
}


+(void)POST:(NSString *)URL parameters:(NSDictionary *)dic success:(XHNetworkSucess)success failure:(XHNetworkFailure)failure
{
    AFHTTPSessionManager *manager = [self manager];
    
    //https ssl 验证
    if(xh_useHttps) [manager setSecurityPolicy:[self customSecurityPolicy]];

    [manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DebugLog(@"error=%@",error);
        
        failure(error);
    }];

}
+(void)GET:(NSString *)URL parameters:(NSDictionary *)dic success:(XHNetworkSucess)success failure:(XHNetworkFailure)failure
{

    AFHTTPSessionManager *manager = [self manager];
    
    //https ssl 验证
    if(xh_useHttps) [manager setSecurityPolicy:[self customSecurityPolicy]];
    
    [manager GET:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DebugLog(@"error=%@",error);
        
        failure(error);
    }];

}

#pragma mark - Private

+(AFHTTPSessionManager *)manager
{
    AFHTTPSessionManager *manager = nil;
    if([self baseUrl] !=nil)
    {
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self baseUrl]]];

    }
    else
    {
        manager = [AFHTTPSessionManager manager];
    }
    
    switch (xh_requestType) {
        case XHRequestTypeJSON:
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        case XHRequestTypeHTTP:
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        default:
            break;
    }
    switch (xh_responseType) {
        case XHResponseTypeTypeJSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case XHResponseTypeXML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        case XHResponseTypeData: {
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        }
        default:
            break;
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    return manager;
    
}

+ (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (xh_requestTasks == nil) {
            xh_requestTasks = [[NSMutableArray alloc] init];
        }
    });
    
    return xh_requestTasks;
}
+ (AFSecurityPolicy*)customSecurityPolicy
{
    //先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:xh_httpsCertificateName ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    //AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = xh_allowInvalidCertificates;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = xh_validatesDomainName;
    
    securityPolicy.pinnedCertificates = [NSSet setWithArray:@[certData]];
    
    return securityPolicy;
}
@end
