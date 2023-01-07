//
//  BGMemoryLeaks.m
//  BGMemoryLeaks
//
//  Created by Bingo on 2022/12/9.
//

#import "BGMemoryLeaks.h"
#import "BGMemoryLeaksMonitor.h"

@implementation BGMemoryLeaks

/**添加白名单类*/
+ (void)addWhiteList:(NSArray <NSString *> *)whiteList {
    [BGMemoryLeaksMonitor addWhiteList:whiteList];
}

/**
 开启检测
 */
+ (void)startDetection {
    [BGMemoryLeaksMonitor start];
}

/**停止检测**/
+ (void)stopDetection {
    [BGMemoryLeaksMonitor stop];
}

/**
 默认2s自动弹窗内存泄漏弹窗
 timeInterval 弹窗延迟时间
 isAuto 是否自动弹。NO需要自己选择弹窗时机
 **/
+ (void)leaksAlertConfigWith:(CGFloat)timeInterval isAuto:(BOOL)isAuto {
    
}


/**
 输出内存泄漏信息
 @param leakObjectInfo 回调信息
 @param isAlert 是否弹窗
 */
+ (void)outputLeakObjectInfo:(void (^)(NSArray * _Nonnull))leakObjectInfo isAlert:(BOOL)isAlert {
    
}

@end
