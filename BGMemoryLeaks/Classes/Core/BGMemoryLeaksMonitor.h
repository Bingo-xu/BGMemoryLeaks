//
//  BGMemoryLeaksMonitor.h
//  BGMemoryLeaks
//
//  Created by Bingo on 2022/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGMemoryLeaksMonitor : NSObject

+ (instancetype)shareInstance;

/**添加白名单类*/
+ (void)addWhiteList:(NSArray <NSString *> *)whiteList;

/**是否白名单类*/
+ (BOOL)isWhiteList:(NSString *)classStr;

/**
 开启与停止检测
 */
+ (void)start;

+ (void)stop;

/**是否已启动*/
+ (BOOL)isRunning;

#pragma mark- 内部使用方法
- (void)addLoadedObject:(NSObject *)object key:(NSString *)key;

- (id)loadedObjectForkey:(NSString *)key;

- (BOOL)addLoadedObjectToArr:(NSObject *)object;

/**
 输出内存泄漏信息
 @param leakObjectInfo 回调信息
 @param isAlert 是否弹窗
 */
+ (void)outputLeakObjectInfo:(void (^)(NSArray * _Nonnull))leakObjectInfo isAlert:(BOOL)isAlert;

/**内存泄漏弹窗*/
+ (void)showLeaksAlert;

@end

NS_ASSUME_NONNULL_END
