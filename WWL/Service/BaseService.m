//
//  BaseService.m
//  8a-ios
//
//  Created by Mobile on 21/04/2017.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "BaseService.h"
#import "NSData+Format.h"

@interface BaseService() {
    
}

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation BaseService

#pragma mark - Get Method

- (void)requestGetWithURL:(NSString *)url atPath:(NSString *)path withParams:(NSDictionary *)params withResponse:(void(^)(BOOL success,id res))block
{
    if([self.token length]) {
        NSString* tokenString = [NSString stringWithFormat:@"Bearer{%@}", self.token];
        DDLogInfo(@"[Token] %@", tokenString);
        [[BaseService shared].manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"Authorization"];
    } else {
        DDLogError(@"[Token Error] Token is missing!!");
    }
    
    NSString* requestURL = [NSString stringWithFormat:@"%@%@",url,path];
    DDLogInfo(@"[GET REQUEST] %@, Parameters:%@", requestURL, params);
    
    [[BaseService shared].manager GET:requestURL parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DDLogInfo(@"[GET SUCC RESPONSE - %@]: \nHEADER:%@, \nDATA:%@", requestURL, (NSHTTPURLResponse*)task.response, [responseObject getLogPrintableString]);
        block(YES,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DDLogError(@"[GET ***FAIL*** RESPONSE - %@], \nHEADER:%@ \nError:%@", requestURL, task, error);
        error = [self getFormattedError:task defaultError:error];
        block(NO,error);
    }];
}

#pragma mark - Post Method
- (void)requestPostWithURL:(NSString *)url atPath:(NSString *)path withParams:(NSDictionary *)params withResponse:(void(^)(BOOL success,id res))block
{
    if([self.token length]) {
        NSString* tokenString = [NSString stringWithFormat:@"Bearer{%@}", self.token];
        DDLogInfo(@"[Token] %@", tokenString);
        [[BaseService shared].manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"Authorization"];
    } else {
        DDLogError(@"[Token Error] Token is missing!!");
    }
    
    NSString* requestURL = [NSString stringWithFormat:@"%@%@",url,path];
    DDLogInfo(@"[POST REQUEST] %@, Parameters:%@", requestURL, params);
    
    [[BaseService shared].manager POST:requestURL parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DDLogInfo(@"[POST SUCC RESPONSE - %@]: \nHEADER:%@, \nDATA:%@", requestURL, (NSHTTPURLResponse*)task.response, [responseObject getLogPrintableString]);
        block(YES, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DDLogError(@"[POST ***FAIL*** RESPONSE - %@], \nHEADER:%@ \nError:%@", requestURL, task, error);
        error = [self getFormattedError:task defaultError:error];
        block(NO, error);
    }];
}

/**
 * array: should be string array
 */
-(void)requestPostWithMultiPart:(NSString*) url
                         atPath:(NSString *)path
                     arrayValue:(NSArray*) arrays
                            key:(NSArray*) keys
                     parameters:(NSDictionary*) params
                   withResponse:(void(^)(BOOL success,id res))block {
    if([self.token length]) {
        NSString* tokenString = [NSString stringWithFormat:@"Bearer{%@}", self.token];
        DDLogInfo(@"[Token] %@", tokenString);
        [[BaseService shared].manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"Authorization"];
    } else {
        DDLogError(@"[Token Error] Token is missing!!");
    }
    
    NSString* requestURL = [NSString stringWithFormat:@"%@%@",url,path];
    DDLogInfo(@"[POST MULTIPART REQUEST] %@, Parameters:%@", requestURL, params);
    
    [[BaseService shared].manager POST:requestURL
                            parameters:params
             constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                 int position = 0;
                 for(NSString* item in arrays) {
                     NSData* data = [item dataUsingEncoding:NSUTF8StringEncoding];
                     [formData appendPartWithFormData:data name:[keys objectAtIndex:position]];
                     position++;
                 }
             }
                              progress:nil
                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                   DDLogInfo(@"[POST MULTIPART SUCC RESPONSE - %@]: \nHEADER:%@, \nDATA:%@", requestURL, (NSHTTPURLResponse*)task.response, [responseObject getLogPrintableString]);
                                   block(YES, responseObject);
                               }
                               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                   DDLogError(@"[POST MULTIPART ***FAIL*** RESPONSE - %@], \nHEADER:%@ \nError:%@", requestURL, task, error);
                                   error = [self getFormattedError:task defaultError:error];
                                   block(NO, error);
                               }];
}

-(void)requestPostWithMultiPartData:(NSString*) url
                             atPath:(NSString *)path
                               data:(NSData*) data
                                key:(NSString*) key
                             isFile:(BOOL) isFile
                              param:(NSDictionary*) param
                       withResponse:(void(^)(BOOL success,id res))block {
    if([self.token length]) {
        NSString* tokenString = [NSString stringWithFormat:@"Bearer{%@}", self.token];
        DDLogInfo(@"[Token] %@", tokenString);
        [[BaseService shared].manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"Authorization"];
    } else {
        DDLogError(@"[Token Error] Token is missing!!");
    }
    
    NSString* requestURL = [NSString stringWithFormat:@"%@%@",url,path];
    DDLogInfo(@"[POST MULTIPART REQUEST] %@, Parameters:%@", requestURL, param);
    
    [[BaseService shared].manager POST:requestURL
                            parameters:param
             constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                 if (data) {
                     if(isFile) {
                         [formData appendPartWithFileData:data name:key fileName:key mimeType:@"image/jpeg"];
                     } else {
                         [formData appendPartWithFormData:data name:key];
                     }
                 }
             }
                              progress:nil
                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                   DDLogInfo(@"[POST MULTIPART SUCC RESPONSE - %@]: \nHEADER:%@, \nDATA:%@", requestURL, (NSHTTPURLResponse*)task.response, [responseObject getLogPrintableString]);
                                   block(YES, responseObject);
                               }
                               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                   DDLogError(@"[POST MULTIPART ***FAIL*** RESPONSE - %@], \nHEADER:%@ \nError:%@", requestURL, task, error);
                                   error = [self getFormattedError:task defaultError:error];
                                   block(NO, error);
                               }];
}

#pragma mark - Delete Method
- (void)requestDeleteWithURL:(NSString *)url atPath:(NSString *)path withParams:(NSDictionary *)params withResponse:(void(^)(BOOL success,id res))block
{
    if([self.token length]) {
        NSString* tokenString = [NSString stringWithFormat:@"Bearer{%@}", self.token];
        DDLogInfo(@"[Token] %@", tokenString);
        [[BaseService shared].manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"Authorization"];
    } else {
        DDLogError(@"[Token Error] Token is missing!!");
    }
    
    NSString* requestURL = [NSString stringWithFormat:@"%@%@",url,path];
    DDLogInfo(@"[DELETE REQUEST] %@, Parameters:%@", requestURL, params);
    
    [[BaseService shared].manager DELETE:requestURL
                              parameters:params
                                 success:^(NSURLSessionDataTask *task, id responseObject)
     {
         DDLogInfo(@"[DELETE SUCC RESPONSE - %@]: \nHEADER:%@, \nDATA:%@", requestURL, (NSHTTPURLResponse*)task.response, [responseObject getLogPrintableString]);
         block(YES,responseObject);
     }
                                 failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         DDLogError(@"[DELETE RESPONSE - %@], \nHEADER:%@ \nError:%@", requestURL, task, error);
         error = [self getFormattedError:task defaultError:error];
         block(NO,error);
     }];
    
}

#pragma mark - Put Method
- (void)requestPutWithURL:(NSString *)url atPath:(NSString *)path withParams:(NSDictionary *)params  withResponse:(void(^)(BOOL success,id res))block
{
    if([self.token length]) {
        NSString* tokenString = [NSString stringWithFormat:@"Bearer{%@}", self.token];
        DDLogInfo(@"[Token] %@", tokenString);
        [[BaseService shared].manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"Authorization"];
    } else {
        DDLogError(@"[Token Error] Token is missing!!");
    }
    
    NSString* requestURL = [NSString stringWithFormat:@"%@%@",url,path];
    DDLogInfo(@"[PUT REQUEST] %@, Parameters:%@", requestURL, params);
    
    [[BaseService shared].manager DELETE:requestURL
                              parameters:params
                                 success:^(NSURLSessionDataTask *task, id responseObject)
     {
         DDLogInfo(@"[PUT SUCC RESPONSE - %@]: \nHEADER:%@, \nDATA:%@", requestURL, (NSHTTPURLResponse*)task.response, [responseObject getLogPrintableString]);
         block(YES,responseObject);
     }
                                 failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         DDLogError(@"[PUT RESPONSE - %@], \nHEADER:%@ \nError:%@", requestURL, task, error);
         error = [self getFormattedError:task defaultError:error];
         block(NO,error);
     }];
}

#pragma mark - status code
-(NSInteger) getStatusCode:(NSURLSessionDataTask*) task {
    NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
    return response.statusCode;
}

-(NSError*) getFormattedError:(NSURLSessionDataTask *) task defaultError:(NSError*) err {
     NSInteger statusCode = [self getStatusCode:task];
    if (statusCode == 401) {
        // Handle invalid or expired token.
        err = [NSError errorWithDomain:WWL_ERROR_DOMAIN code:WWL_UNAUTHROIZED_CODE userInfo:@{
                                                                                       NSLocalizedDescriptionKey:@"Your token is expired or invalid now. Please Login again."
                                                                                       }];
    } else if (statusCode >= 400) {
        err = [NSError errorWithDomain:WWL_ERROR_DOMAIN code:WWL_ERROR_CODE userInfo:@{
                                                                                       NSLocalizedDescriptionKey:@"There was a problem communicating with WWL. WWL is working to resolve a problem."
                                                                                       }];
    }
    
    return err;
}

#pragma mark - Private methdos
+(BaseService *)shared{
    static BaseService *shared;
    if (!shared) {
        shared = [[BaseService alloc] init];
        NSURL *baseUrl = [NSURL URLWithString:[AppDelegate shared].apiBaseUrl];
        shared.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
        shared.manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
        shared.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    }
    return shared;
}


@end
