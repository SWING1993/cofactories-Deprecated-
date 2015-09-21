//
//  HttpClient.h
//  聚工厂
//
//  Created by 唐佳诚 on 15/7/4.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFOAuth2Manager.h"
#import "UserModel.h"
#import "FactoryModel.h"
#import "OrderModel.h"
#import "MessageModel.h"
#import "UpYun.h"
#import "BidManagerModel.h"


@interface HttpClient : NSObject

#pragma mark - API RESTful方法

/*!
 重置密码

 @param phoneNumber 手机号码(11位)
 @param block       回调函数 会返回 0->(网络错误) 200->(成功) 400->(手机格式不正确) 409->(需要等待冷却) 502->(发送错误)
 */
+ (void)postResetPasswordWithPhone:(NSString *)phoneNumber code:(NSString *)code password:(NSString *)password andBlock:(void (^)(int statusCode))block;
/*!
 修改密码

 @param password    旧密码
 @param newPassword 新密码
 @param block       回调函数 会返回 0->(网络错误) 200->(成功) 403->(旧密码错误) 404->(access_token不存在)
 */
+ (void)modifyPassword:(NSString *)password newPassword:(NSString *)newPassword andBlock:(void (^)(int statusCode))block;
/*!
 返回登录凭据

 @return 返回 AFOAuthCredential 包含 access_token 等登录信息
 */
+ (AFOAuthCredential *)getToken;
/*!
 删除凭据
 
 @return 返回 BOOL 值表示是否成功删除
 */
+ (BOOL)deleteToken;
/*!
 刷新 access_token

 @param block 回调函数 会返回 0->(网络错误) 200->(成功) 400->(用户名密码错误) 404->(access_token不存在)
 */
+ (void)validateOAuthWithBlock:(void (^)(int statusCode))block;
/*!
 发送手机验证码

 @param phoneNumber 手机号码(11位)
 @param block       回调函数 会返回 0->(网络错误) 200->(成功) 400->(手机格式不正确) 409->(需要等待冷却) 502->(发送错误)
 */
+ (void)postVerifyCodeWithPhone:(NSString *)phoneNumber andBlock:(void (^)(int statusCode))block;
/*!
 校验验证码

 @param phoneNumber 手机号码
 @param code        验证码
 @param block       回调函数 会返回 0->(网络错误) 200->(验证码正确) 401->(验证码过期或者无效)
 */
+ (void)validateCodeWithPhone:(NSString *)phoneNumber code:(NSString *)code andBlock:(void (^)(int statusCode))block;
/*!
 注册账号
 工厂规模必须从小到大排序,如果规模范围是 x 到无限大,则 factorySizeMin = @(x), factorySizeMax = nil;

 @param username            用户名(手机号码)
 @param password            密码
 @param type                工厂类型(enum)
 @param code                验证码
 @param factoryName         工厂名称
 @param lon                 工厂经度
 @param lat                 工厂纬度
 @param factorySizeMin      工厂规模最小值(必须是最小值,且用 NSNumber 包装)
 @param factorySizeMax      工厂规模最大值(必须是最大值,且用 NSNumber 包装)
 @param factoryAddress      工厂地址
 @param factoryServiceRange 业务类型
 @param block               回调函数 会返回 @{@"statusCode": @201, @"responseObject": 字典}->(注册成功) @{@"statusCode": @401, @"message": @"验证码错误"}->(验证码错误) @{@"statusCode": @409, @"message": @"该手机已经注册过""}->(手机已经注册过) @{@"statusCode": @0, @"message": @"网络错误"}->(网络错误)
 */
+ (void)registerWithUsername:(NSString *)username InviteCode:(NSString *)inviteCode password:(NSString *)password factoryType:(int)type verifyCode:(NSString *)code factoryName:(NSString *)factoryName lon:(double)lon lat:(double)lat factorySizeMin:(NSNumber *)factorySizeMin factorySizeMax:(NSNumber *)factorySizeMax factoryAddress:(NSString *)factoryAddress factoryServiceRange:(NSString *)factoryServiceRange andBlock:(void (^)(NSDictionary *responseDictionary))block;


//邀请码
+ (void)registerWithInviteCode:(NSString *)inviteCode andBlock:(void (^)(NSDictionary *responseDictionary))block;


/*!
 登录账号

 @param username 用户名(手机号码)
 @param password 密码
 @param block    回调函数 会返回 0->(网络错误) 200->(登录成功) 400->(用户名密码错误)
 */
+ (void)loginWithUsername:(NSString *)username password:(NSString *)password andBlock:(void (^)(int statusCode))block;
/*!
 登出账号

 @return BOOL 是否登出成功
 */
+ (BOOL)logout;
/*!
 获取用户资料

 @param block 回调函数 会返回 @{@"statusCode": @200, @"model": UserModel对象}->(获取成功) @{@"statusCode": @0, @"message": @"网络错误"}->(网络错误) @{@"statusCode": @400, @"message": @"未登录"} @{@"statusCode": @401, @"message": @"access_token过期或者无效"} @{@"statusCode": @404, @"message": @"access_token不存在"}
 */
+ (void)getUserProfileWithBlock:(void (^)(NSDictionary *responseDictionary))block;
/*!
 修改用户资料

 @param name    真实姓名
 @param job     职务
 @param id_card 身份证号
 @param block   回调函数 会返回 0->(网络错误) 200->(更新成功) 400->(未登录) 401->(access_toke过期或者无效) 404->(access_token不存在)
 */

+ (void)modifyUserProfileWithName:(NSString *)name job:(NSString *)job id_card:(NSString *)id_card andBlock:(void (^)(int statusCode))block;

/*!
 添加收藏

 @param uid   需要收藏的uid
 @param block 回调函数 会返回 0->(网络错误) -1->(缺失参数) 201->(添加成功) 400->(未登录) 401->(access_toke过期或者无效) 404->(access_token不存在)
 */
+ (void)addFavoriteWithUid:(NSString *)uid andBlock:(void (^)(int statusCode))block;
/*!
 列出收藏

 @param block 回调函数 会返回 @{@"statusCode": @200, @"responseArray": UserModel的可变数组}->(获取成功) @{@"statusCode": @0, @"message": @"网络错误"}->(网络错误) @{@"statusCode": @400, @"message": @"未登录"}->(未登录) @{@"statusCode": @401, @"message": @"access_token过期或者无效"}->(access_token过期或者无效) @{@"statusCode": @404, @"message": @"access_token不存在"}
 */
+ (void)listFavoriteWithBlock:(void (^)(NSDictionary *responseDictionary))block;
/*!
 删除收藏

 @param block 回调函数 会返回 0->(网络错误) -1->(缺失参数) 200->(添加成功) 400->(未登录) 401->(access_toke过期或者无效) 404->(access_token不存在)
 */
+ (void)deleteFavoriteWithUid:(NSString *)uid andBlock:(void (^)(int statusCode))block;
/*!
 更新工厂资料
 工厂规模必须从小到大排序,如果规模范围是 x 到无限大,则 factorySizeMin = @(x), factorySizeMax = nil;

 @param factoryName         工厂名称
 @param factoryAddress      工厂地址
 @param factoryServiceRange 业务类型
 @param factorySizeMin      工厂规模最小值(必须是最小值,且用 NSNumber 包装)
 @param factorySizeMax      工厂规模最大值(必须是最大值,且用 NSNumber 包装)
 @param factoryLon          工厂经度
 @param factoryLat          工厂纬度
 @param factoryDescription  工厂描述
 @param factoryFree         工厂空闲状态(服装厂传nil,加工厂传yyyy-MM-DD字符串,代裁厂锁眼钉扣厂传NSNumber,关闭状态都传NSNumber对象)
 @param block               回调函数 会返回 0->(网络错误) 200->(更新成功) 400->(未登录) 401->(access_token过期或无效) 404->(access_token不存在)
 */
+ (void)updateFactoryProfileWithFactoryName:(NSString *)factoryName factoryAddress:(NSString *)factoryAddress factoryServiceRange:(NSString *)factoryServiceRange factorySizeMin:(NSNumber *)factorySizeMin factorySizeMax:(NSNumber *)factorySizeMax factoryLon:(NSNumber *)factoryLon factoryLat:(NSNumber *)factoryLat factoryFree:(id)factoryFree factoryDescription:(NSString *)factoryDescription andBlock:(void (^)(int statusCode))block;

/*!
 设置工厂标签

 @param factoryTag 工厂标签
 @param block      回调函数 会返回 0->(网络错误) 200->(更新成功) 400->(未登录) 401->(access_token过期或无效) 404->(access_token不存在)
 */
+ (void)updateFactoryfactoryTag:(NSString *)factoryTag andBlock:(void (^)(int statusCode))block;

/*!
 获取任意用户资料

 @param uid   用户uid
 @param block 回调函数 会返回 @{@"statusCode": @200, @"model": UserModel对象}->(获取成功) @{@"statusCode": @0, @"message": @"网络错误"}->(网络错误) @{@"statusCode": @400, @"message": @"未登录"} @{@"statusCode": @401, @"message": @"access_token过期或者无效"} @{@"statusCode": @404, @"message": @"access_token不存在"}
 */
+ (void)getUserProfileWithUid:(NSInteger )uid andBlock:(void (^)(NSDictionary *responseDictionary))block;

///*!
// 获取任意用户资料
//
// @param uid   用户uid
// @param block 回调函数 会返回 @{@"statusCode": @200, @"model": UserModel对象}->(获取成功) @{@"statusCode": @0, @"message": @"网络错误"}->(网络错误) @{@"statusCode": @400, @"message": @"未登录"} @{@"statusCode": @401, @"message": @"access_token过期或者无效"} @{@"statusCode": @404, @"message": @"access_token不存在"}
// */
//+ (void)getUserProfileWithUid:(NSString *)uid andBlock:(void (^)(NSDictionary *responseDictionary))block;
/*!
 搜索工厂
 工厂规模必须从小到大排序,如果规模范围是 x 到无限大,则 factorySizeMin = @(x), factorySizeMax = nil;

 @param factoryName         工厂名称
 @param factoryType         工厂类型
 @param factoryServiceRange 业务类型
 @param factorySizeMin      工厂规模最小值(必须是最小值,且用 NSNumber 包装)
 @param factorySizeMax      工厂规模最大值(必须是最大值,且用 NSNumber 包装)
 @param factoryDistanceMin  工厂距离最小值(必须是最小值,且用 NSNumber 包装)
 @param factoryDistanceMax  工厂距离最大值(必须是最大值,且用 NSNumber 包装)
 @param block               回调函数 会返回 @{@"statusCode": @200, @"model": FactoryModel对象数组}->(获取成功) @{@"statusCode": @0, @"message": @"网络错误"}->(网络错误)
 */
+ (void)searchWithFactoryName:(NSString *)factoryName factoryType:(FactoryType)factoryType factoryServiceRange:(NSString *)factoryServiceRange factorySizeMin:(NSNumber *)factorySizeMin factorySizeMax:(NSNumber *)factorySizeMax factoryDistanceMin:(NSNumber *)factoryDistanceMin factoryDistanceMax:(NSNumber *)factoryDistanceMax Truck:(id)hasTruck factoryFree:(id)factoryFree page:(NSNumber *)page andBlock:(void (^)(NSDictionary *responseDictionary))block;

//是否有货车
+ (void)updateFactoryProfileWithHasTruck:(id)hasTruck andBlock:(void (^)(int statusCode))block;

/*!
 抽奖验证接口

 @param block 回调函数 会返回 0->(网络错误) 201->(可以抽奖) 400->(未登录) 401->(access_toke过期或者无效) 403->(没有抽奖资格) 404->(access_token不存在)
 */
+ (void)drawAccessWithBlock:(void (^)(int statusCode))block;
/*!
 整体更新菜单

 @param menuArray 菜单id数组
 @param block     回调函数 会返回 0->(网络错误) 200->(更新成功) 400->(未登录) 401->(access_toke过期或者无效) 404->(access_token不存在)

 + (void)updateMenuWithMenuArray:(NSArray *)menuArray andBlock:(void (^)(int statusCode))block;

 */
/*!
 菜单列表

 @param block 回调函数 会返回 @{@"statusCode": @200, @"responseArray": 菜单id数组}->(获取成功) @{@"statusCode": @0, @"message": @"网络错误"}->(网络错误) @{@"statusCode": @400, @"message": @"未登录"}->(未登录) @{@"statusCode": @401, @"message": @"access_token过期或者无效"}->(access_token过期或者无效) @{@"statusCode": @404, @"message": @"access_token不存在"}
 
 + (void)listMenuWithBlock:(void (^)(NSDictionary *responseDictionary))block;

 */

/*!
 创建订单接口

 @param amount              订单数量
 @param factorytype         工厂类型
 @param factoryServiceRange 业务类型(加工订单必填)
 @param workingTime         工期(加工订单必填)
 @param block               回调函数 会返回 @{@"statusCode": @200, @"data": 订单返回字典}->(获取成功) @{@"statusCode": @0, @"message": @"网络错误"}->(网络错误) @{@"statusCode": @400, @"message": @"未登录"}->(未登录) @{@"statusCode": @401, @"message": @"access_token过期或者无效"}->(access_token过期或者无效) @{@"statusCode": @404, @"message": @"access_token不存在"}
 */
+ (void)addOrderWithAmount:(int)amount factoryType:(FactoryType)factoryType factoryServiceRange:(NSString *)factoryServiceRange workingTime:(NSString *)workingTime comment:(NSString *)comment andBlock:(void (^)(NSDictionary *responseDictionary))block;


//历史订单
+ (void)listHistoryOrderWithBlock:(void (^)(NSDictionary *responseDictionary))block;


//进行中的订单
+ (void)listOrderWithBlock:(void (^)(NSDictionary *responseDictionary))block;

//关闭订单
//+ (void)closeOrderWithOid:(int)oid andBlock:(void (^)(NSDictionary *responseDictionary))block;

+ (void)closeOrderWithOid:(int)oid Uid:(int)uid andBlock:(void (^)(int statusCode))block;


//订单搜索
+ (void)searchOrderWithRole:(FactoryType)role FactoryServiceRange:(NSString *)factoryServiceRange Time:(NSString *)time AmountMin:(NSNumber *)amountMin AmountMax:(NSNumber *)amountMax  Page:(NSNumber *)page andBlock:(void (^)(NSDictionary *responseDictionary))block;

//感兴趣
+ (void)interestOrderWithOid:(int)oid andBlock:(void (^)(int statusCode))block ;



/*!
 订单详情接口

 @param oid   订单编号oid
 @param block 回调函数 会返回 @{@"statusCode": @200, @"model": 订单模型}->(获取成功) @{@"statusCode": @0, @"message": @"网络错误"}->(网络错误) @{@"statusCode": @400, @"message": @"未登录"}->(未登录) @{@"statusCode": @401, @"message": @"access_token过期或者无效"}->(access_token过期或者无效) @{@"statusCode": @404, @"message": @"access_token不存在"}
 */
+ (void)getOrderDetailWithOid:(int)oid andBlock:(void (^)(NSDictionary *responseDictionary))block;
/*!
 获得合作商列表

 @param block 回调函数 会返回 @{@"statusCode": @200, @"responseArray": 合作商数组}->(获取成功) @{@"statusCode": @0, @"message": @"网络错误"}->(网络错误) @{@"statusCode": @400, @"message": @"未登录"}->(未登录) @{@"statusCode": @401, @"message": @"access_token过期或者无效"}->(access_token过期或者无效) @{@"statusCode": @404, @"message": @"access_token不存在"}
 */
+ (void)listPartnerWithBlock:(void (^)(NSDictionary *responseDictionary))block;
/*!
 添加合作商

 @param uid   用户uid
 @param block 回调函数 会返回 0->(网络错误) 201->(添加成功) 400->(未登录) 401->(access_toke过期或者无效) 404->(access_token不存在)
 */
+ (void)addPartnerWithUid:(int)uid andBlock:(void (^)(int statusCode))block;
/*!
 获取系统消息

 @param block 回调函数 会返回 @{@"statusCode": @200, @"responseArray": 消息模型数组}->(获取成功) @{@"statusCode": @0, @"message": @"网络错误"}->(网络错误) @{@"statusCode": @400, @"message": @"未登录"}->(未登录) @{@"statusCode": @401, @"message": @"access_token过期或者无效"}->(access_token过期或者无效) @{@"statusCode": @404, @"message": @"access_token不存在"}

 */
+ (void)getSystemMessageWithBlock:(void (^)(NSDictionary *responseDictionary))block;



/*!
 删除推送设置

 @param parameters index ->需要删除的设置在设置数组中的索引
 @param access_token
 @param block      回调函数 会返回 0->(网络错误) 201->(更新成功) 400->(未登录) 401->(access_toke过期或者无效) 404->(access_token不存在)
 */
+ (void)deletePushSettingWithIndex:(NSNumber *)index andBlock:(void (^)(int statusCode))block;

/*!
 添加推送设置

 @param parameters 推送设置数组(具体项目看API文档)
 @param block      回调函数 会返回 0->(网络错误) 201->(更新成功) 400->(未登录) 401->(access_toke过期或者无效) 404->(access_token不存在)
 */
+ (void)addPushSettingWithFactoryType:(FactoryType)factoryType  Type:(NSString *)type FactoryServiceRange:(NSString *)factoryServiceRange factorySizeMin:(NSNumber *)factorySizeMin factorySizeMax:(NSNumber *)factorySizeMax factoryDistanceMin:(NSNumber *)factoryDistanceMin factoryDistanceMax:(NSNumber *)factoryDistanceMax factoryWorkingTimeMin:(NSNumber *)factoryWorkingTimeMin factoryWorkingTimeMax:(NSNumber *)factoryWorkingTimeMax andBlock:(void (^)(int code))block ;


/*!
 获取推送设置

 @param parameters 推送设置数组(具体项目看API文档)
 @param block      回调函数 会返回 0->(网络错误) 201->(更新成功) 400->(未登录) 401->(access_toke过期或者无效) 404->(access_token不存在)
 */
+ (void)getPushSettingWithBlock:(void(^)(NSDictionary *dictionary))block;

/*!
 注册设备(推送助手)

 @param deviceId 设备id
 @param block    回调函数 会返回 0->(网络错误) 201->(注册成功) 400->(未登录) 401->(access_toke过期或者无效) 404->(access_token不存在)
 */
+ (void)registerDeviceWithDeviceId:(NSString *)deviceId andBlock:(void (^)(int statusCode))block;


/*!
 提交认证资料

 @param legalPerson 法人姓名
 @param idCard      身份证号码
 @param block       回调函数 会返回 0->(网络错误) 201->(注册成功) 400->(未登录) 401->(access_toke过期或者无效) 404->(access_token不存在)
 */
+ (void)submitVerifyDetailWithLegalPerson:(NSString *)legalPerson idCard:(NSString *)idCard andBlock:(void (^)(int statusCode))block;
/*!
 获得认证信息

 @param block 回调函数 会返回 @{@"statusCode": @200, @"responseDictionary": 认证信息字典}->(获取成功) @{@"statusCode": @0, @"message": @"网络错误"}->(网络错误) @{@"statusCode": @400, @"message": @"未登录"}->(未登录) @{@"statusCode": @401, @"message": @"access_token过期或者无效"}->(access_token过期或者无效) @{@"statusCode": @404, @"message": @"access_token不存在"}
 */
+ (void)getVeifyInfoWithBlock:(void (^)(NSDictionary *dictionary))block;
/*!
 获取工厂图片url

 @param uid   用户uid
 @param type  图片类型(environment, equipment, employee)
 @param block 会返回 @{@"statusCode": @200, @"responseDictionary": 图片信息字典}->(获取成功) @{@"statusCode": @0, @"message": @"网络错误"}->(网络错误) @{@"statusCode": @400, @"message": @"未登录"}->(未登录) @{@"statusCode": @401, @"message": @"access_token过期或者无效"}->(access_token过期或者无效) @{@"statusCode": @404, @"message": @"access_token不存在"}
 */
+ (void)getFactoryPhotoWithUid:(NSString *)uid type:(NSString *)type andBlock:(void (^)(NSDictionary *dictionary))block;
/*!
 上传工厂图片

 @param image 图片
 @param type  图片类型(environment, equipment, employee, avatar)
 @param block 回调函数 会返回 @{@"statusCode": @200, @"responseDictionary": 字典}->(获取成功) @{@"statusCode": @0, @"message": @"网络错误"}->(网络错误) @{@"statusCode": @400, @"message": @"未登录"}->(未登录) @{@"statusCode": @401, @"message": @"access_token过期或者无效"}->(access_token过期或者无效) @{@"statusCode": @404, @"message": @"access_token不存在"}
 */
+ (void)uploadImageWithImage:(UIImage *)image type:(NSString *)type andblock:(void (^)(NSDictionary *dictionary))block;
/*!
 认证图片上传

 @param image 图片
 @param type  图片类型(idCard, license, photo)
 @param block 回调函数 会返回 @{@"statusCode": @200, @"responseDictionary": 字典}->(获取成功) @{@"statusCode": @0, @"message": @"网络错误"}->(网络错误) @{@"statusCode": @400, @"message": @"未登录"}->(未登录) @{@"statusCode": @401, @"message": @"access_token过期或者无效"}->(access_token过期或者无效) @{@"statusCode": @404, @"message": @"access_token不存在"}
 */
+ (void)uploadVerifyImage:(UIImage *)image type:(NSString *)type andblock:(void (^)(NSDictionary *dictionary))block;


//订单图片上传
+ (void)uploadOrderImageWithImage:(UIImage *)image oid:(NSString *)oid type:(NSString *)type andblock:(void (^)(NSDictionary *dictionary))block;

/*!
 登记投标

 @param oid   订单oid
 @param block 回调函数block
 */
+ (void)bidOrderWithOid:(int)oid andBlock:(void (^)(int statusCode))block ;

/*!
 获取投标工厂

 @param oid   oid
 @param block 回调函数block
 */
+ (void)getBidOrderWithOid:(int)oid andBlock:(void (^)(NSDictionary *responseDictionary))block ;


/**删除订单
 * @param oid   订单oid
 */
+ (void)deleteOrderWithOrderOid:(int)oid completionBlock:(void(^)(int statusCode))block;

/**登记投标
 *@param oid   订单oid
  @param string 备注
 */
+ (void)registBidWithOid:(int)oid commit:(NSString *)commit completionBlock:(void(^)(int statusCode))block;

/**资讯列表(中间资讯)
 *
 */
+ (void)getHeaderInfomationWithBlock:(void (^)(NSDictionary *responseDictionary))block;

/**资讯列表(下边资讯)
 *
 */
+ (void)getInfomationWithKind:(NSString *)kind andBlock:(void (^)(NSDictionary *responseDictionary))block;

/**评论列表
 *@param oid   ID
 */
+ (void)getCommentWithOid:(int)oid andBlock:(void (^)(NSDictionary *responseDictionary))block;
/** 提交评论
 *@param ID   ID
  @param content  评论内容
 */

+ (void)pushCommentWithID:(NSString *)ID content:(NSString *)content andBlock:(void (^)(int))block;
/** 点赞
 *@param ID   ID
 */
+ (void)pushLikeWithID:(NSString *)ID andBlock:(void (^)(int))block;

/** 提交面辅料信息
 *@param
 */


+ (void)addMaterialWithType:(NSString *)type name:(NSString *)name usage:(NSString *)usage price:(int)price width:(int)width description:(NSString *)description andBlock:(void (^)(NSDictionary *responseDictionary))block;
/**发布求购信息
 *
 */
+ (void)sendMaterialPurchaseInfomationWithType:(NSString *)aType name:(NSString *)aName description:(NSString *)aDescription amount:(NSNumber *)aAmount unit:(NSString *)aUnit completionBlock:(void (^)(NSDictionary *responseDictionary))block;

/**面辅料图片上传
 *
 */
+ (void)uploadMaterialImageWithImage:(UIImage *)image oid:(NSString *)oid type:(NSString *)type andblock:(void (^)(NSDictionary *dictionary))block;

/**查看历史发布
 *
 */

+ (void)checkHistoryPublishWithPage:(int)aPage completionBlock:(void (^)(NSDictionary *responseDictionary))block;
/**查看面辅料历史发布
 *
 */
+ (void)checkMaterialHistoryPublishWithPage:(int)aPage completionBlock:(void (^)(NSDictionary *responseDictionary))block;


@end
