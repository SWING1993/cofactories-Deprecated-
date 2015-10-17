//
//  HttpClient.m
//  聚工厂
//
//  Created by 唐佳诚 on 15/7/4.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "HttpClient.h"
#import "AFHTTPRequestSerializer+OAuth2.h"
#import "UpYun.h"
#import "AFNetworking.h"
#import "GetPushModel.h"


#define kClientID @"123"
#define kSecret @"123"
#define API_reset @"/user/reset"
#define API_modifyPassword @"/user/password"
#define API_login @"/user/login"
#define API_verify @"/user/code"
#define API_checkCode @"/user/checkCode"
#define API_register @"/user/register"
#define API_userProfile @"/user/profile"
#define API_favorite @"/user/favorite"
#define API_factoryProfile @"/factory/profile"
#define API_search @"/search"
#define API_drawAccess @"/draw/access"
#define API_updateMenu @"/menu/edit"
#define API_getMenu @"/menu/list"

#define API_searchOrder @"/search/order"
#define API_addOrder @"/order/add"
#define API_orderDetail @"/order"
#define API_closeOrder @"/order/close"
#define API_orderDoing @"/order/doing"
#define API_historyOrder @"/order/history"
#define API_interestOrder @"/order/interest"
#define API_bidOrder @"/order/bid"
#define API_deleteOrder @"/order/"


#define API_partnerList @"/partner/list"
#define API_addPartner @"/partner/add"
#define API_message @"/message"
#define API_pushSetting @"/push/setting"
#define API_pushRegister @"/push/register"
#define API_verifyModify @"/verify/modify"
#define API_verifyInfo @"/verify/info"
#define API_factoryPhoto @"/factory/photo"
#define API_uploadFactory @"/upload/factory"
#define API_uploadVerify @"/upload/verify"
#define API_uploadOrder @"upload/order"
#define API_uploadMaterial @"/upload/material"
#define API_registBid @"/order/bid/"
#define API_sendMaterial @"/material/buy"
#define API_sendMaterialHistory @"/material/history"
#define API_searchMaterial @"/search/material"
#define API_addMaterial @"/material"
#define API_bidMaterial @"/material/buy/bid"
#define API_searchBidMaterial @"/search/materialBuy"
#define API_deleteMateria @"/material/shop/"
#define API_GetIMToken @"/im/token"

@implementation HttpClient

//重置密码
+ (void)postResetPasswordWithPhone:(NSString *)phoneNumber code:(NSString *)code password:(NSString *)password andBlock:(void (^)(int statusCode))block {
    
    NSParameterAssert(phoneNumber);
    NSParameterAssert(password);
    NSParameterAssert(code);
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 3.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:API_reset parameters:@{@"phone": phoneNumber, @"password": password, @"code": code} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block((int)[operation.response statusCode]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block((int)[operation.response statusCode]);
    }];
}

+ (void)modifyPassword:(NSString *)password newPassword:(NSString *)newPassword andBlock:(void (^)(int))block {
    NSParameterAssert(password);
    NSParameterAssert(newPassword);
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager POST:API_modifyPassword parameters:@{@"password": password, @"newPassword": newPassword} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block((int)[operation.response statusCode]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block((int)[operation.response statusCode]);
        }];
    }
}

+ (AFOAuthCredential *)getToken {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    return [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
}

+ (BOOL)deleteToken {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    return [AFOAuthCredential deleteCredentialWithIdentifier:serviceProviderIdentifier];
}

+ (void)validateOAuthWithBlock:(void (^)(int))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        // 存在 access_token
        if (!credential.isExpired) {
            // access_token & refresh_token 没有过期
            AFOAuth2Manager *OAuth2Manager = [[AFOAuth2Manager alloc] initWithBaseURL:baseUrl clientID:kClientID secret:kSecret];
            [OAuth2Manager authenticateUsingOAuthWithURLString:API_login refreshToken:credential.refreshToken success:^(AFOAuthCredential *credential) {
                // 存储 access_token
                [AFOAuthCredential storeCredential:credential withIdentifier:OAuth2Manager.serviceProviderIdentifier];
                block(200);// 刷新 access_token 成功
            } failure:^(NSError *error) {
                block(0);// 网络错误
            }];
        } else {
            // access_token & refresh_token 已经过期
            // 重新登录
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *username = [userDefaults objectForKey:@"username"];
            NSString *password = [userDefaults objectForKey:@"password"];
            AFOAuth2Manager *OAuth2Manager = [[AFOAuth2Manager alloc] initWithBaseURL:baseUrl clientID:kClientID secret:kSecret];
            [OAuth2Manager authenticateUsingOAuthWithURLString:API_login username:username password:password scope:@"/" success:^(AFOAuthCredential *credential) {
                // 存储 access_token
                [AFOAuthCredential storeCredential:credential withIdentifier:OAuth2Manager.serviceProviderIdentifier];
                block(200);// 刷新 access_token 成功
            } failure:^(NSError *error) {
                if ([[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode] == 400) {
                    block(400);// 用户名密码错误
                } else {
                    block(0);// 网络错误
                }
            }];
        }
    } else {
        // 不存在 access_token
        block(404);
    }
}

//发送手机验证码
+ (void)postVerifyCodeWithPhone:(NSString *)phoneNumber andBlock:(void (^)(int))block {
    NSParameterAssert(phoneNumber);
    if (phoneNumber.length != 11) {
        block(400);// 手机格式不正确
        return;
    }
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 3.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:API_verify parameters:@{@"phone": phoneNumber} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block((int)[operation.response statusCode]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block((int)[operation.response statusCode]);
    }];
}

//验证 验证码
+ (void)validateCodeWithPhone:(NSString *)phoneNumber code:(NSString *)code andBlock:(void (^)(int))block {
    NSParameterAssert(phoneNumber);
    NSParameterAssert(code);
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 3.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager GET:API_checkCode parameters:@{@"phone": phoneNumber, @"code": code} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block((int)[operation.response statusCode]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block((int)[operation.response statusCode]);
    }];
}

+ (void)registerWithInviteCode:(NSString *)inviteCode andBlock:(void (^)(NSDictionary *responseDictionary))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        // 已经登录则修改用户资料
        // 构造参数字典
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:0];
        if (inviteCode) {
            [parameters setObject:inviteCode forKey:@"inviteCode"];
        }
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager POST:API_userProfile parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block (responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //            block (error);
        }];
    } else {
        
    }
}


//注册
+ (void)registerWithUsername:(NSString *)username InviteCode:(NSString *)inviteCode password:(NSString *)password factoryType:(int)type verifyCode:(NSString *)code factoryName:(NSString *)factoryName lon:(double)lon lat:(double)lat factorySizeMin:(NSNumber *)factorySizeMin factorySizeMax:(NSNumber *)factorySizeMax factoryAddress:(NSString *)factoryAddress factoryServiceRange:(NSString *)factoryServiceRange andBlock:(void (^)(NSDictionary *))block {
    //    NSParameterAssert(username);
    //    NSParameterAssert(password);
    //    NSParameterAssert(code);
    //    NSParameterAssert(factoryName);
    //    NSParameterAssert(factorySizeMin);
    //    NSParameterAssert(factoryAddress);
    //    if (type == 0 || type == 1) {
    //        NSParameterAssert(factoryServiceRange);
    //    }
    //    if (factorySizeMax == 0) {
    //    }
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 3.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSArray *factorySize = [[NSArray alloc] initWithObjects:factorySizeMin, factorySizeMax, nil];
    [manager POST:API_register parameters:@{@"phone": username,@"inviteCode": inviteCode, @"password": password, @"type": @(type), @"code": code, @"factoryName": factoryName, @"lon": @(lon), @"lat": @(lat), @"factorySize": factorySize, @"factoryAddress": factoryAddress, @"factoryServiceRange": (factoryServiceRange == nil ? @"" : factoryServiceRange)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(@{@"statusCode": @(200), @"message": @"注册成功"});
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        switch ([operation.response statusCode]) {
            case 401:
                block(@{@"statusCode": @(401), @"message": @"邀请码或者验证码错误"});
                break;
            case 409:
                block(@{@"statusCode": @(409), @"message": @"该手机已经注册过"});
                break;
                
            default:
                block(@{@"statusCode": @(0), @"message": @"网络错误"});
                break;
        }
    }];
}

//登录
+ (void)loginWithUsername:(NSString *)username password:(NSString *)password andBlock:(void (^)(int))block {
    NSParameterAssert(username);
    NSParameterAssert(password);
    
    AFOAuth2Manager *OAuth2Manager = [[AFOAuth2Manager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl] clientID:kClientID secret:kSecret];
    
    [OAuth2Manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    OAuth2Manager.requestSerializer.timeoutInterval = 3.f;
    [OAuth2Manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [OAuth2Manager authenticateUsingOAuthWithURLString:API_login username:username password:password scope:@"/" success:^(AFOAuthCredential *credential) {
        // 存储 access_token
        [AFOAuthCredential storeCredential:credential withIdentifier:OAuth2Manager.serviceProviderIdentifier];
        // 保存用户身份
        [self getUserProfileWithBlock:^(NSDictionary *responseDictionary) {
            
            if ([[responseDictionary objectForKey:@"statusCode"] intValue] == 200) {
                DLog(@"登录信息:%@",[responseDictionary objectForKey:@"model"] );
            }
        }];
        block(200);// 登录成功
    } failure:^(NSError *error) {
        if ([[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode] == 400) {
            block(400);// 用户名密码错误
        } else {
            block(0);// 网络错误
        }
    }];
}

+ (BOOL)logout {
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    return [AFOAuthCredential deleteCredentialWithIdentifier:serviceProviderIdentifier];
}

+ (void)getUserProfileWithBlock:(void (^)(NSDictionary *))block {
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        // 已经登录则获取用户信息
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager GET:API_userProfile parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            UserModel *userModel = [[UserModel alloc] initWithDictionary:responseObject];
            block(@{@"statusCode": @(200), @"model": userModel});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @(400), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @(401), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
}

+ (void)modifyUserProfileWithName:(NSString *)name job:(NSString *)job id_card:(NSString *)id_card andBlock:(void (^)(int))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        // 已经登录则修改用户资料
        // 构造参数字典
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:3];
        if (name) {
            [parameters setObject:name forKey:@"name"];
        }
        if (job) {
            [parameters setObject:job forKey:@"job"];
        }
        if (id_card) {
            [parameters setObject:id_card forKey:@"id_card"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager POST:API_userProfile parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block((int)[operation.response statusCode]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block((int)[operation.response statusCode]);
        }];
    } else {
        block(404);// access_token不存在
    }
}

+ (void)addFavoriteWithUid:(NSString *)uid andBlock:(void (^)(int))block {
    NSParameterAssert(uid);
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        // 已经登录则添加收藏
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager POST:API_favorite parameters:@{@"fav": uid} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block((int)[operation.response statusCode]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if ([operation.response statusCode] == 400) {
                NSDictionary *responseDictionary = operation.responseObject;
                if ([[responseDictionary objectForKey:@"code"] intValue] == -1) {
                    // 缺失参数
                    block(-1);
                } else {
                    // 未登录
                    block(400);
                }
            } else {
                block((int)[operation.response statusCode]);
            }
        }];
    } else {
        block(404);// access_token不存在
    }
}

+ (void)listFavoriteWithBlock:(void (^)(NSDictionary *))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager GET:API_favorite parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSArray *jsonArray = (NSArray *)responseObject;
            NSMutableArray *responseArray = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
            for (NSDictionary *dictionary in jsonArray) {
                FactoryModel *factoryModel = [[FactoryModel alloc] initWithDictionary:dictionary];
                [responseArray addObject:factoryModel];
            }
            block(@{@"statusCode": @([operation.response statusCode]), @"responseArray": responseArray});
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
}

+ (void)deleteFavoriteWithUid:(NSString *)uid andBlock:(void (^)(int))block {
    
    NSParameterAssert(uid);
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager DELETE:API_favorite parameters:@{@"fav": uid} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block((int)[operation.response statusCode]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if ([operation.response statusCode] == 400) {
                NSDictionary *responseDictionary = operation.responseObject;
                if ([[responseDictionary objectForKey:@"code"] intValue] == -1) {
                    // 缺失参数
                    block(-1);
                } else {
                    // 未登录
                    block(400);
                }
            } else {
                block((int)[operation.response statusCode]);
            }
        }];
    } else {
        block(404);// access_token不存在
    }
}

+ (void)updateFactoryProfileWithFactoryName:(NSString *)factoryName factoryAddress:(NSString *)factoryAddress factoryServiceRange:(NSString *)factoryServiceRange factorySizeMin:(NSNumber *)factorySizeMin factorySizeMax:(NSNumber *)factorySizeMax factoryLon:(NSNumber *)factoryLon factoryLat:(NSNumber *)factoryLat factoryFree:(id)factoryFree factoryDescription:(NSString *)factoryDescription andBlock:(void (^)(int statusCode))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
        if (factoryName)
            [mutableDictionary setObject:factoryName forKey:@"factoryName"];
        if (factoryDescription)
            [mutableDictionary setObject:factoryDescription forKey:@"factoryDescription"];
        if (factoryAddress)
            [mutableDictionary setObject:factoryAddress forKey:@"factoryAddress"];
        if (factoryServiceRange)
            [mutableDictionary setObject:factoryServiceRange forKey:@"factoryServiceRange"];
        if (factorySizeMin) {
            NSArray *factorySize = [[NSArray alloc] initWithObjects:factorySizeMin, factorySizeMax, nil];
            [mutableDictionary setObject:factorySize forKey:@"factorySize"];
        }
        if (factoryLon)
            [mutableDictionary setObject:factoryLon forKey:@"factoryLon"];
        if (factoryLat)
            [mutableDictionary setObject:factoryLat forKey:@"factoryLat"];
        if (factoryFree) {
            [mutableDictionary setObject:factoryFree forKey:@"factoryFree"];
        }
        [manager POST:API_factoryProfile parameters:mutableDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block((int)[operation.response statusCode]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block((int)[operation.response statusCode]);
        }];
    } else {
        block(404);// access_token不存在
    }
}

+ (void)updateFactoryfactoryTag:(NSString *)factoryTag andBlock:(void (^)(int statusCode))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        if (factoryTag)
            [mutableDictionary setObject:factoryTag forKey:@"tag"];
        [manager POST:API_factoryProfile parameters:mutableDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block((int)[operation.response statusCode]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block((int)[operation.response statusCode]);
        }];
    } else {
        block(404);// access_token不存在
    }
    
    
}

+ (void)getIMTokenWithBlock:(void (^)(NSDictionary *))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        
        [manager GET:API_GetIMToken parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *token = responseObject[@"data"][@"token"];
            block(@{@"statusCode": @([operation.response statusCode]), @"IMToken": token});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }


}
+ (void)getUserProfileWithUid:(NSInteger )uid andBlock:(void (^)(NSDictionary *))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString *url = [[NSString alloc] initWithFormat:@"%@/%ld", API_factoryProfile, (long)uid];
        DLog(@"ghdfuihgviudfhgi%@", url);
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            FactoryModel *userModel = [[FactoryModel alloc] initWithDictionary:responseObject];
            block(@{@"statusCode": @([operation.response statusCode]), @"model": userModel});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
}

//是否有货车
+ (void)updateFactoryProfileWithHasTruck:(id)hasTruck andBlock:(void (^)(int statusCode))block {
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        if (hasTruck) {
            [mutableDictionary setObject:hasTruck forKey:@"hasTruck"];
        }
        [manager POST:API_factoryProfile parameters:mutableDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block((int)[operation.response statusCode]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block((int)[operation.response statusCode]);
        }];
    } else {
        block(404);// access_token不存在
    }
}

+ (void)searchWithFactoryName:(NSString *)factoryName factoryType:(FactoryType)factoryType factoryServiceRange:(NSString *)factoryServiceRange factorySizeMin:(NSNumber *)factorySizeMin factorySizeMax:(NSNumber *)factorySizeMax factoryDistanceMin:(NSNumber *)factoryDistanceMin factoryDistanceMax:(NSNumber *)factoryDistanceMax Truck:(id)hasTruck factoryFree:(id)factoryFree page:(NSNumber *)page andBlock:(void (^)(NSDictionary *responseDictionary))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    if (credential) {
        // 有 access_token
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
    }
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] initWithCapacity:7];
    if (factoryName)
        [mutableDictionary setObject:factoryName forKey:@"factoryName"];
    if (factoryType)
        [mutableDictionary setObject:@(factoryType) forKey:@"factoryType"];
    if (factoryServiceRange)
        [mutableDictionary setObject:factoryServiceRange forKey:@"factoryServiceRange"];
    if (factorySizeMin) {
        NSArray *factorySize = [[NSArray alloc] initWithObjects:factorySizeMin, factorySizeMax, nil];
        [mutableDictionary setObject:factorySize forKey:@"factorySize"];
    }
    if (factoryDistanceMin) {
        NSArray *factoryDistance = [[NSArray alloc] initWithObjects:factoryDistanceMin, factoryDistanceMax, nil];
        [mutableDictionary setObject:factoryDistance forKey:@"factoryDistance"];
    }
    if (hasTruck) {
        [mutableDictionary setObject:hasTruck forKey:@"hasTruck"];
    }
    if (factoryFree) {
        [mutableDictionary setObject:factoryFree forKey:@"factoryFree"];
    }
    if (page) {
        [mutableDictionary setObject:page forKey:@"page"];
    }
    [manager GET:API_search parameters:mutableDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *jsonArray = (NSArray *)responseObject;
        NSMutableArray *responseArray = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
        for (NSDictionary *dictionary in jsonArray) {
            FactoryModel *factoryModel = [[FactoryModel alloc] initWithDictionary:dictionary];
            [responseArray addObject:factoryModel];
        }
        block(@{@"statusCode": @(200), @"responseArray": responseArray});
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(@{@"statusCode": @0, @"message": @"网络错误"});// 网络错误
    }];
}

+ (void)drawAccessWithBlock:(void (^)(int))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager GET:API_drawAccess parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(201);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(400);
                    break;
                    
                case 401:
                    block(401);
                    break;
                    
                case 403:
                    block(403);
                    break;
                    
                case 404:
                    block(404);
                    break;
                    
                    
                default:
                    block(0);
                    break;
            }
        }];
    } else {
        block(404);// access_token不存在
    }
}
/*
 //更新MenuList  严重BUG  已解决
 + (void)updateMenuWithMenuArray:(NSArray *)menuArray andBlock:(void (^)(int))block {
 NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
 NSString *serviceProviderIdentifier = [baseUrl host];
 AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
 if (credential) {
 AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
 [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
 [manager POST:API_updateMenu parameters:@{@"menu": menuArray} success:^(AFHTTPRequestOperation *operation, id responseObject) {
 //            DLog(@"更新MenuList=%@ 数组%@",responseObject,menuArray);
 //            block([operation.response statusCode]);
 block(200);
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 block(400);
 }];
 } else {
 block(404);// access_token不存在
 }
 }
 
 //获取MenuList
 + (void)listMenuWithBlock:(void (^)(NSDictionary *))block {
 NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
 NSString *serviceProviderIdentifier = [baseUrl host];
 AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
 if (credential) {
 AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
 [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
 [manager GET:API_getMenu parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
 block(@{@"statusCode": @([operation.response statusCode]), @"responseArray": responseObject});
 //            block(responseObject);
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 switch ([operation.response statusCode]) {
 case 400:
 block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
 break;
 case 401:
 block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
 break;
 
 default:
 block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
 break;
 }
 }];
 } else {
 block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
 }
 }
 */
+ (void)addMaterialWithType:(NSString *)type name:(NSString *)name usage:(NSString *)usage price:(CGFloat)price width:(NSString *)width description:(NSString *)description andBlock:(void (^)(NSDictionary *responseDictionary))block {
    NSDictionary *parameters = nil;
    if ([type isEqualToString:@"面料"]) {
        parameters = @{@"type":type, @"name":name, @"usage":usage, @"price":@(price), @"width":width, @"description":description};
    } else {
        parameters = @{@"type":type, @"name":name, @"price":@(price), @"description":description};
    }
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        
        // 设置超时时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 3.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager POST:API_addMaterial parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(@{@"statusCode": @([operation.response statusCode]), @"responseObject":responseObject});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                case 403:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"不是面辅料商"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
    
}
+ (void)addOrderWithAmount:(int)amount factoryType:(FactoryType)factoryType factoryServiceRange:(NSString *)factoryServiceRange workingTime:(NSString *)workingTime comment:(NSString *)comment andBlock:(void (^)(NSDictionary *responseDictionary))block {
    //    NSParameterAssert(amount);
    //    NSParameterAssert(factoryType);
    NSDictionary *parameters = nil;
    if (factoryType == 1 || factoryType == 0) {
        // 加工订单
        //        NSParameterAssert(factoryServiceRange);
        //        NSParameterAssert(workingTime);
        parameters = @{@"amount": @(amount), @"factoryType": @(factoryType), @"factoryServiceRange": factoryServiceRange, @"workingTime": workingTime ,@"comment":comment};
    } else {
        parameters = @{@"amount": @(amount), @"factoryType": @(factoryType) ,@"comment":comment};
    }
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        
        // 设置超时时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 3.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager POST:API_addOrder parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(@{@"statusCode": @([operation.response statusCode]), @"data": [responseObject objectForKey:@"data"]});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
}

//历史订单
+ (void)listHistoryOrderWithBlock:(void (^)(NSDictionary *responseDictionary))block {
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager GET:API_historyOrder parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"%@",responseObject);
            NSArray *jsonArray = (NSArray *)responseObject;
            NSMutableArray *responseArray = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
            for (NSDictionary *dictionary in jsonArray) {
                OrderModel *orderModel = [[OrderModel alloc] initWithDictionary:dictionary];
                [responseArray addObject:orderModel];
            }
            block(@{@"statusCode": @([operation.response statusCode]), @"responseArray": responseArray});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
}

//进行中的订单
+ (void)listOrderWithBlock:(void (^)(NSDictionary *responseDictionary))block {
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager GET:API_orderDoing parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"%@",responseObject);
            NSArray *jsonArray = (NSArray *)responseObject;
            NSMutableArray *responseArray = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
            for (NSDictionary *dictionary in jsonArray) {
                OrderModel *orderModel = [[OrderModel alloc] initWithDictionary:dictionary];
                [responseArray addObject:orderModel];
            }
            block(@{@"statusCode": @([operation.response statusCode]), @"responseArray": responseArray});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
}

//关闭订单
+ (void)closeOrderWithOid:(int)oid andBlock:(void (^)(NSDictionary *responseDictionary))block {
    NSParameterAssert(oid);
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString *url = [[NSString alloc] initWithFormat:@"%@/%d", API_closeOrder, oid];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            OrderModel *orderModel = [[OrderModel alloc] initWithDictionary:responseObject];
            block(@{@"statusCode": @([operation.response statusCode]), @"model": orderModel});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
}

+ (void)closeOrderWithOid:(int)oid Uid:(int)uid andBlock:(void (^)(int statusCode))block {
    NSParameterAssert(oid);
    NSParameterAssert(uid);
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString *url = [[NSString alloc] initWithFormat:@"%@/%d", API_closeOrder, oid];
        [manager GET:url parameters:@{@"uid":@(uid)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(200);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            switch ([operation.response statusCode]) {
                case 400:
                    block(400);
                    break;
                case 401:
                    block(401);
                    break;
                    
                default:
                    block(402);
                    break;
            }
        }];
    } else {
        block(404);// access_token不存在
    }
}



+ (void)interestOrderWithOid:(int)oid andBlock:(void (^)(int statusCode))block {
    NSParameterAssert(oid);
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString *url = [[NSString alloc] initWithFormat:@"%@/%d", API_interestOrder, oid];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            //            DLog(@"%@",responseObject);
            //            int statusCode = [responseObject[@"code"] intValue];
            block(200);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(400);
                    break;
                case 401:
                    block(401);
                    break;
                    
                default:
                    break;
            }
        }];
    } else {
        block(404);// access_token不存在
    }
}

+ (void)searchOrderWithRole:(FactoryType)role FactoryServiceRange:(NSString *)factoryServiceRange Time:(NSString *)time AmountMin:(NSNumber *)amountMin AmountMax:(NSNumber *)amountMax  Page:(NSNumber *)page andBlock:(void (^)(NSDictionary *responseDictionary))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    if (credential) {
        // 有 access_token
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
    }
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (role)
        [mutableDictionary setObject:@(role) forKey:@"role"];
    if (factoryServiceRange)
        [mutableDictionary setObject:factoryServiceRange forKey:@"factoryServiceRange"];
    if (time)
        [mutableDictionary setObject:time forKey:@"time"];
    if (amountMin) {
        NSArray *amount = [[NSArray alloc] initWithObjects:amountMin, amountMax, nil];
        [mutableDictionary setObject:amount forKey:@"amount"];
    }
    if (page)
        [mutableDictionary setObject:page forKey:@"page"];
    
    [manager GET:API_searchOrder parameters:mutableDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *jsonArray = (NSArray *)responseObject;
        NSMutableArray *responseArray = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
        for (NSDictionary *dictionary in jsonArray) {
            OrderModel *orderModel = [[OrderModel alloc] initWithDictionary:dictionary];
            [responseArray addObject:orderModel];
        }
        block(@{@"statusCode": @([operation.response statusCode]), @"responseArray": responseArray});
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(@{@"statusCode": @0, @"message": @"网络错误"});// 网络错误
    }];
}


+ (void)getOrderDetailWithOid:(int)oid andBlock:(void (^)(NSDictionary *))block {
    NSParameterAssert(oid);
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString *url = [[NSString alloc] initWithFormat:@"%@/%d", API_orderDetail, oid];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"-----------%@",responseObject);
            OrderModel *orderModel = [[OrderModel alloc] initWithDictionary:responseObject];
            block(@{@"statusCode": @([operation.response statusCode]), @"model": orderModel});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
}

+ (void)listPartnerWithBlock:(void (^)(NSDictionary *))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager GET:API_partnerList parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *jsonArray = (NSArray *)responseObject;
            NSMutableArray *responseArray = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
            for (NSDictionary *dictionary in jsonArray) {
                FactoryModel *factoryModel = [[FactoryModel alloc] initWithDictionary:dictionary];
                [responseArray addObject:factoryModel];
            }
            block(@{@"statusCode": @(200), @"responseArray": responseArray});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @(400), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @(401), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
}

+ (void)addPartnerWithUid:(int)uid andBlock:(void (^)(int))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager POST:API_addPartner parameters:@{@"partner": @(uid)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block([operation.response statusCode]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block([operation.response statusCode]);
        }];
    } else {
        block(404);// access_token不存在
    }
}

+ (void)getSystemMessageWithBlock:(void (^)(NSDictionary *))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager GET:API_message parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            //            DLog(@"消息%@",responseObject);
            NSArray *responseArray = (NSArray *)responseObject;
            NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:0];
            for (NSDictionary *dictionary in responseArray) {
                MessageModel *messageModel = [[MessageModel alloc] initWithDictionary:dictionary];
                [mutableArray addObject:messageModel];
            }
            block(@{@"statusCode": @([operation.response statusCode]), @"responseArray": mutableArray});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
}

+ (void)deletePushSettingWithIndex:(NSNumber *)index andBlock:(void (^)(int statusCode))block{
    
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager DELETE:API_pushSetting parameters:@{@"index":index} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block((int)[operation.response statusCode]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block((int)[operation.response statusCode]);
        }];
    } else {
        block(404);// access_token不存在
    }
    
}


+ (void)addPushSettingWithFactoryType:(FactoryType)factoryType  Type:(NSString *)type FactoryServiceRange:(NSString *)factoryServiceRange factorySizeMin:(NSNumber *)factorySizeMin factorySizeMax:(NSNumber *)factorySizeMax factoryDistanceMin:(NSNumber *)factoryDistanceMin factoryDistanceMax:(NSNumber *)factoryDistanceMax factoryWorkingTimeMin:(NSNumber *)factoryWorkingTimeMin factoryWorkingTimeMax:(NSNumber *)factoryWorkingTimeMax andBlock:(void (^)(int code))block
{
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    if (credential) {
        // 有 access_token
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        if (factoryType)
            [mutableDictionary setObject:@(factoryType) forKey:@"factoryType"];
        if (type) {
            [mutableDictionary setObject:type forKey:@"type"];
        }
        if (factoryServiceRange)
            [mutableDictionary setObject:factoryServiceRange forKey:@"serviceRange"];
        if (factorySizeMin) {
            NSArray *factorySize = [[NSArray alloc] initWithObjects:factorySizeMin, factorySizeMax, nil];
            [mutableDictionary setObject:factorySize forKey:@"size"];
        }
        if (factoryDistanceMin) {
            NSArray *factoryDistance = [[NSArray alloc] initWithObjects:factoryDistanceMin, factoryDistanceMax, nil];
            [mutableDictionary setObject:factoryDistance forKey:@"distance"];
        }
        if (factoryWorkingTimeMin) {
            NSArray *factoryWorkingTime = [[NSArray alloc] initWithObjects:factoryWorkingTimeMin, factoryWorkingTimeMax, nil];
            [mutableDictionary setObject:factoryWorkingTime forKey:@"workingTime"];
        }
        
        [manager POST:API_pushSetting parameters:mutableDictionary success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(200);
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             DLog(@"error=%@",error);
             block(400);
         }];
    }
}




+ (void)registerDeviceWithDeviceId:(NSString *)deviceId andBlock:(void (^)(int))block {
    NSParameterAssert(deviceId);
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager POST:API_pushRegister parameters:@{@"deviceId": deviceId, @"deviceType": @"ios"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block((int)[operation.response statusCode]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block((int)[operation.response statusCode]);
        }];
    } else {
        block(404);// access_token不存在
    }
}


+ (void)getPushSettingWithBlock:(void(^)(NSDictionary *dictionary))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager GET:API_pushSetting parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *responseArray = responseObject;
            NSMutableArray *mutableArr = [[NSMutableArray alloc]initWithCapacity:0];
            
            [responseArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *dic = responseArray[idx];
                GetPushModel *model = [GetPushModel getPushModelWith:dic];
                [mutableArr addObject:model];
                
            }];
            
            block(@{@"statusCode": @([operation.response statusCode]), @"array": mutableArr});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
}

+ (void)pushCommentWithID:(NSString *)ID content:(NSString *)content andBlock:(void (^)(int))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString*token = credential.accessToken;
        NSString *urlString = [NSString stringWithFormat:@"http://news.cofactories.com/?co&op=comment&p=%@&access_token=%@", ID, token];
        [manager POST:urlString parameters:@{@"comment": content} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block((int)[operation.response statusCode]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block((int)[operation.response statusCode]);
        }];
    } else {
        block(404);// access_token不存在
    }
}
//http://news.cofactories.com/?co&op=like&p=1
+ (void)pushLikeWithID:(NSString *)ID andBlock:(void (^)(int))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString *urlString = [NSString stringWithFormat:@"http://news.cofactories.com/?co&op=like&p=%@", ID];
        [manager POST:urlString parameters:@{@"ID": ID} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block((int)[operation.response statusCode]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block((int)[operation.response statusCode]);
        }];
    } else {
        block(404);// access_token不存在
    }
}

+ (void)submitVerifyDetailWithLegalPerson:(NSString *)legalPerson idCard:(NSString *)idCard andBlock:(void (^)(int))block {
    NSParameterAssert(legalPerson);
    NSParameterAssert(idCard);
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager POST:API_verifyModify parameters:@{@"legalPerson": legalPerson, @"idCard": idCard} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block((int)[operation.response statusCode]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block((int)[operation.response statusCode]);
        }];
    } else {
        block(404);// access_token不存在
    }
}

+ (void)getVeifyInfoWithBlock:(void (^)(NSDictionary *))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager GET:API_verifyInfo parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(@{@"statusCode": @([operation.response statusCode]), @"responseDictionary": responseObject});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"===%@", operation.responseString);
            
            DLog(@"%@",error);
            DLog(@"======%d",[operation.response statusCode]);
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
}

+ (void)getFactoryPhotoWithUid:(NSString *)uid type:(NSString *)type andBlock:(void (^)(NSDictionary *))block {
    NSParameterAssert(uid);
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:2];
        [parameters setObject:uid forKey:@"uid"];
        if (type) {
            [parameters setObject:type forKey:@"type"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager GET:API_factoryPhoto parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(@{@"statusCode": @([operation.response statusCode]), @"responseDictionary": responseObject});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
}

+ (void)uploadImageWithImage:(UIImage *)image type:(NSString *)type andblock:(void (^)(NSDictionary *))block {
    NSParameterAssert(image);
    NSParameterAssert(type);
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager GET:API_uploadFactory parameters:@{@"type": type} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"图片上传成功");
            UpYun *upYun = [[UpYun alloc] init];
            upYun.bucket = bucketAPI;//图片测试
            
            upYun.expiresIn = 600;// 10分钟
            [upYun uploadImage:image policy:[responseObject objectForKey:@"policy"] signature:[responseObject objectForKey:@"signature"]];
            block(@{@"statusCode": @([operation.response statusCode]), @"responseDictionary": responseObject});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"NOok%@",error);
            
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
}

+ (void)uploadVerifyImage:(UIImage *)image type:(NSString *)type andblock:(void (^)(NSDictionary *))block {
    NSParameterAssert(image);
    NSParameterAssert(type);
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager GET:API_uploadVerify parameters:@{@"type": type} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            UpYun *upYun = [[UpYun alloc] init];
            upYun.bucket = bucketAPI;//图片测试
            upYun.expiresIn = 600;// 10分钟
            [upYun uploadImage:image policy:[responseObject objectForKey:@"policy"] signature:[responseObject objectForKey:@"signature"]];
            block(@{@"statusCode": @([operation.response statusCode]), @"responseDictionary": responseObject});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
}

+ (void)uploadOrderImageWithImage:(UIImage *)image oid:(NSString *)oid type:(NSString *)type andblock:(void (^)(NSDictionary *dictionary))block {
    NSParameterAssert(image);
    NSParameterAssert(oid);
    NSParameterAssert(type);
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        
        NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        if (oid)
            [mutableDictionary setObject:oid forKey:@"oid"];
        if (type) {
            [mutableDictionary setObject:type forKey:@"type"];
        }
        [manager GET:API_uploadOrder parameters:mutableDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
            UpYun *upYun = [[UpYun alloc] init];
            upYun.bucket = bucketAPI;//图片测试
            upYun.expiresIn = 600;// 10分钟
            [upYun uploadImage:image policy:[responseObject objectForKey:@"policy"] signature:[responseObject objectForKey:@"signature"]];
            block(@{@"statusCode": @([operation.response statusCode]), @"responseDictionary": responseObject});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
    
    
}

+ (void)bidOrderWithOid:(int)oid andBlock:(void (^)(int statusCode))block {
    NSParameterAssert(oid);
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString *url = [[NSString alloc] initWithFormat:@"%@/%d", API_bidOrder, oid];
        [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(200);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(400);
                    break;
                case 401:
                    block(401);
                    break;
                    
                default:
                    break;
            }
        }];
    } else {
        block(404);// access_token不存在
    }
}

+ (void)getInfomationWithKind:(NSString *)kind andBlock:(void (^)(NSDictionary *responseDictionary))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString *url = [NSString stringWithFormat:@"http://news.cofactories.com/?co&op=search&%@", kind];
        NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *jsonArray = (NSArray *)responseObject;
            NSMutableArray *responseArray = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
            for (NSDictionary *dictionary in jsonArray) {
                InformationModel *information = [[InformationModel alloc] initModelWith:dictionary];
                
                [responseArray addObject:information];
            }
            block(@{@"statusCode": @([operation.response statusCode]), @"responseArray": responseArray});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
}

+ (void)getHeaderInfomationWithBlock:(void (^)(NSDictionary *responseDictionary))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString *url = @"http://news.cofactories.com/?co&op=category&cat=置顶";
        
        NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *jsonArray = (NSArray *)responseObject;
            NSMutableArray *responseArray = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
            for (NSDictionary *dictionary in jsonArray) {
                InformationModel *information = [[InformationModel alloc] initModelWith:dictionary];
                [responseArray addObject:information];
            }
            block(@{@"statusCode": @([operation.response statusCode]), @"responseArray": responseArray});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
}

+ (void)getCommentWithOid:(int)oid page:(int)page andBlock:(void (^)(NSDictionary *responseDictionary))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString *url = [NSString stringWithFormat:@"http://news.cofactories.com/?co&op=comments&p=%d&page=%d", oid, page];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSArray *jsonArray = (NSArray *)responseObject;
//            NSMutableArray *responseArray = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
//            for (NSDictionary *dictionary in jsonArray) {
//                CommentModel *comment = [CommentModel getModelWith:dictionary];
//                [responseArray addObject:comment];
//            }
            block(@{@"statusCode": @([operation.response statusCode]), @"responseArray": responseObject});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
}
+ (void)getBidOrderWithOid:(int)oid andBlock:(void (^)(NSDictionary *responseDictionary))block {
    
    NSParameterAssert(oid);
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString *url = [[NSString alloc] initWithFormat:@"%@/%d", API_bidOrder, oid];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *jsonArray = (NSArray *)responseObject;
            NSMutableArray *responseArray = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
            for (NSDictionary *dictionary in jsonArray) {
                BidManagerModel *factoryModel = [BidManagerModel getBidManagerModelWith:dictionary];
                [responseArray addObject:factoryModel];
            }
            block(@{@"statusCode": @([operation.response statusCode]), @"responseArray": responseArray});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
}


+ (void)getMaterialBidOrderWithOid:(int)oid andBlock:(void (^)(NSDictionary *responseDictionary))block {
    
    NSParameterAssert(oid);
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString *url = [[NSString alloc] initWithFormat:@"%@/%d", API_bidMaterial, oid];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *jsonArray = (NSArray *)responseObject;
            NSMutableArray *responseArray = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
            for (NSDictionary *dictionary in jsonArray) {
                MaterialBidFactory *factoryModel = [MaterialBidFactory getBidManagerModelWith:dictionary];
                [responseArray addObject:factoryModel];
            }
            block(@{@"statusCode": @([operation.response statusCode]), @"responseArray": responseArray});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
}

+ (void)deleteOrderWithOrderOid:(int)oid completionBlock:(void(^)(int statusCode))block{
    //NSParameterAssert(oid);
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        
        NSString *url = [[NSString alloc] initWithFormat:@"%@%d", API_deleteOrder, oid];
        
        [manager DELETE:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block((int)[operation.response statusCode]);
        }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    DLog(@"error%@",error);
                }];
    }
    else {
        block(404);// access_token不存在
    }
    
}

+ (void)registMaterialBidWithOid:(NSInteger)oid price:(NSString *)price status:(NSString *)status comment:(NSString *)comment completionBlock:(void(^)(int statusCode))block{
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        
        CGFloat number = [price floatValue];
        [manager POST:API_bidMaterial parameters:@{@"id": [NSNumber numberWithInteger:oid], @"price":[NSNumber numberWithFloat:number], @"status":status, @"comment": comment} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block((int)[operation.response statusCode]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block((int)[operation.response statusCode]);
        }];
    }
    else {
        block(404);// access_token不存在
    }
    
}



+ (void)registBidWithOid:(int)oid commit:(NSString *)commit completionBlock:(void(^)(int statusCode))block{
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString *url = [[NSString alloc] initWithFormat:@"%@%d", API_registBid, oid];
        [manager POST:url parameters:@{@"commit":commit} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block((int)[operation.response statusCode]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block((int)[operation.response statusCode]);
        }];
    }
    else {
        block(404);// access_token不存在
    }
    
}

+ (void)sendMaterialPurchaseInfomationWithType:(NSString *)aType name:(NSString *)aName description:(NSString *)aDescription amount:(NSNumber *)aAmount unit:(NSString *)aUnit completionBlock:(void (^)(NSDictionary *responseDictionary))block{
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary *parameters = [@{} mutableCopy];
        if (aType) {
            [parameters setObject:aType forKey:@"type"];
        }
        if (aName) {
            [parameters setObject:aName forKey:@"name"];
        }
        if (aDescription) {
            [parameters setObject:aDescription forKey:@"description"];
        }
        if (aAmount) {
            [parameters setObject:aAmount forKey:@"amount"];
        }
        if (aUnit) {
            [parameters setObject:aUnit forKey:@"unit"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager POST:API_sendMaterial parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(@{@"statusCode":@([operation.response statusCode]),@"responseObject":responseObject});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block(@{@"statusCode":@([operation.response statusCode])});
        }];
    } else {
        block(@{@"statusCode":@(404)}); // access_token不存在
    }
}

+ (void)uploadMaterialImageWithImage:(UIImage *)image oid:(NSString *)oid type:(NSString *)type andblock:(void (^)(NSDictionary *dictionary))block{
    
    NSParameterAssert(image);
    NSParameterAssert(oid);
    NSParameterAssert(type);
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        
        NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        if (oid)
            [mutableDictionary setObject:oid forKey:@"id"];
        if (type) {
            [mutableDictionary setObject:type forKey:@"type"];
        }
        [manager GET:API_uploadMaterial parameters:mutableDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
            UpYun *upYun = [[UpYun alloc] init];
            upYun.bucket = bucketAPI;
            upYun.expiresIn = 600;
            [upYun uploadImage:image policy:[responseObject objectForKey:@"policy"] signature:[responseObject objectForKey:@"signature"]];
            block(@{@"statusCode": @([operation.response statusCode]), @"responseDictionary": responseObject});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
    
}

+ (void)checkHistoryPublishWithPage:(int)aPage completionBlock:(void (^)(NSDictionary *responseDictionary))block{
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        
        [manager GET:API_sendMaterialHistory parameters:@{@"page":@(aPage)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(@{@"statusCode":@([operation.response statusCode]),@"responseObject":responseObject});
        }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 block(@{@"statusCode":@([operation.response statusCode])});
             }];
    }
    else {
        block(@{@"statusCode":@(404)}); // access_token不存在
    }
    
}

+ (void)checkMaterialHistoryPublishWithPage:(int)aPage completionBlock:(void (^)(NSDictionary *responseDictionary))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        
        [manager GET:API_sendMaterialHistory parameters:@{@"page":@(aPage)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSArray *jsonArray = (NSArray *)responseObject;
//            NSMutableArray *responseArray = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
//            for (NSDictionary *dictionary in jsonArray) {
//
//                SupplyHistory *history = [SupplyHistory getModelWith:dictionary];
//                
//                [responseArray addObject:history];
//            }
            
            block(@{@"statusCode":@([operation.response statusCode]),@"responseObject":responseObject});
        }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 block(@{@"statusCode":@([operation.response statusCode])});
             }];
    }
    else {
        block(@{@"statusCode":@(404)}); // access_token不存在
    }
}

+ (void)searchMaterialWithKeywords:(NSString *)aKeywords type:(NSString *)aType page:(int)aPage completionBlock:(void (^)(NSDictionary *responseDictionary))block{
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        
        [manager GET:API_searchMaterial parameters:@{@"keyword":aKeywords,@"type":aType,@"page":@(aPage)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSArray *jsonArray = (NSArray *)responseObject;
//            NSMutableArray *responseArray = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
//            for (NSDictionary *dictionary in jsonArray) {
//                SupplyHistory *history = [SupplyHistory getModelWith:dictionary];
//                [responseArray addObject:history];
//            }
            block(@{@"statusCode":@([operation.response statusCode]),@"responseObject":responseObject});
            
        }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 block(@{@"statusCode":@([operation.response statusCode])});
             }];
    }
    else {
        block(@{@"statusCode":@(404)}); 
    }
}

+ (void)searchMaterialBidWithKeywords:(NSString *)aKeywords type:(NSString *)aType page:(int)aPage completionBlock:(void (^)(NSDictionary *responseDictionary))block{
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        
        [manager GET:API_searchBidMaterial parameters:@{@"page":@(aPage)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSArray *jsonArray = (NSArray *)responseObject;
//            NSMutableArray *responseArray = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
////            for (NSDictionary *dictionary in jsonArray) {
////                //SupplyHistory *history = [SupplyHistory getModelWith:dictionary];
////                PurchasePublicHistoryModel *search = [PurchasePublicHistoryModel getModelWith:dictionary];
////                [responseArray addObject:search];
////            }
////            
            block(@{@"statusCode":@([operation.response statusCode]),@"responseObject":responseObject});
            
        }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 block(@{@"statusCode":@([operation.response statusCode])});
             }];
    }
    else {
        block(@{@"statusCode":@(404)}); // access_token不存在
    }
    
}



+ (void)getMaterialMessageWithID:(NSString *)oid completionBlock:(void (^)(NSDictionary *responseDictionary))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString *url = [NSString stringWithFormat:@"/material/%@", oid];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *jsonDic = (NSDictionary *)responseObject;
            SupplyHistory *history = [SupplyHistory getModelWith:jsonDic];
            
            block(@{@"statusCode":@([operation.response statusCode]),@"model":history});
            
        }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 block(@{@"statusCode":@([operation.response statusCode])});
             }];
    }
    else {
        block(@{@"statusCode":@(404)}); // access_token不存在
    }
    
}

+ (void)getMaterialDetailMessageWithId:(NSString *)aId completionBlock:(void (^)(NSDictionary *responseDictionary))block{
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        
        NSString *url = [[NSString alloc] initWithFormat:@"%@%@", @"/material/", aId];
        
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(@{@"statusCode":@([operation.response statusCode]),@"responseObject":responseObject});
        }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    block(@{@"statusCode":@([operation.response statusCode])});
                }];
    }
    else {
        block(@{@"statusCode":@(404)});
    }
}

+ (void)getPurchaseBidInformationWithID:(NSInteger)aId completionBlock:(void (^)(NSDictionary *responseDictionary))block{
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        
        NSString *url = [[NSString alloc] initWithFormat:@"%@%zi", @"/material/buy/bid/", aId];
        
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(@{@"statusCode":@([operation.response statusCode]),@"responseObject":responseObject});
        }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
                 block(@{@"statusCode":@([operation.response statusCode])});
             }];
    }
    else {
        block(@{@"statusCode":@(404)});
    }
 
}

+ (void)closeMaterialBidOrderWithWinnerID:(NSInteger)aWinnerID orderID:(NSInteger)aOrderID completionBlock:(void (^)(NSDictionary *responseDictionary))block{
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        
        NSString *url = [[NSString alloc] initWithFormat:@"%@%zi", @"/material/close/", aOrderID];
        
        [manager POST:url parameters:@{@"winner":@(aWinnerID)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(@{@"statusCode":@([operation.response statusCode]),@"responseObject":responseObject});
        }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
                 block(@{@"statusCode":@([operation.response statusCode])});
             }];
    }
    else {
        block(@{@"statusCode":@(404)});
    }

}
+ (void)getNeedMaterialDetailMessageWithId:(NSString *)aId completionBlock:(void (^)(NSDictionary *responseDictionary))block{
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        
        NSString *url = [[NSString alloc] initWithFormat:@"%@%@", @"/material/buy/", aId];
        
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            LookOverNeedModel *model = [LookOverNeedModel getModelWith:responseObject];
            
            block(@{@"statusCode":@([operation.response statusCode]),@"model":model});
        }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
                 block(@{@"statusCode":@([operation.response statusCode])});
             }];
    }
    else {
        block(@{@"statusCode":@(404)});
    }
    
}



+ (void)deleteMaterialWithid:(int)oid completionBlock:(void(^)(int statusCode))block{
    //NSParameterAssert(oid);
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        
        NSString *url = [[NSString alloc] initWithFormat:@"%@%d", API_deleteMateria, oid];
        [manager DELETE:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block((int)[operation.response statusCode]);
        }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    block((int)[operation.response statusCode]);
                    DLog(@"error%@",error);
                }];
    }
    else {
        block(404);// access_token不存在
    }
    
}

+ (void)getAllMaterialWithUserID:(NSInteger)aID completionBlock:(void (^)(NSDictionary *responseDictionary))block{
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];

        NSString *url = [[NSString alloc] initWithFormat:@"%@%zi", @"/material/shop/", aID];
        
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        block(@{@"statusCode":@([operation.response statusCode]),@"modelArray":responseObject});
        }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
                 block(@{@"statusCode":@([operation.response statusCode])});
             }];
    }
    else {
        block(@{@"statusCode":@(404)});
    }

}


+ (void)upDataWithBlock:(void (^)(NSDictionary *upDateDictionary))block {
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    [manager POST:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=1015359842"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *jsonData = responseObject;
        NSArray *infoArray = [jsonData objectForKey:@"results"];
        NSDictionary *releaseInfo = [infoArray firstObject];
        NSString *latestVersion = [releaseInfo objectForKey:@"version"];
        NSString *releaseNotes = [releaseInfo objectForKey:@"releaseNotes"];
        
        NSMutableDictionary * dataDic = [[NSMutableDictionary alloc]initWithCapacity:3];
        [dataDic setObject:@"200" forKey:@"statusCode"];
        [dataDic setObject:latestVersion forKey:@"latestVersion"];
        [dataDic setObject:releaseNotes forKey:@"releaseNotes"];
        block(dataDic);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSMutableDictionary * errorDic = [[NSMutableDictionary alloc]initWithCapacity:2];
        [errorDic setObject:@"400" forKey:@"statusCode"];
        [errorDic setObject:error forKey:@"data"];
        block(errorDic);
    }];
}

@end
