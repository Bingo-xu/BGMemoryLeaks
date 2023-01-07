//
//  NSObject+BGLeaks.h
//  BGMemoryLeaks
//
//  Created by Bingo on 2022/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (BGLeaks)

///是否可被收集，可收集则可向对象发送
- (BOOL)bgLeaksMonitorObjectCanBeCollected;

- (void)bgLeaksMonitorCollectObjectForKey:(NSString *)key
                                condition:(nullable id)condition
                                 callBack:(nullable void(^)(NSMutableDictionary *))callBack;

@end

NS_ASSUME_NONNULL_END
