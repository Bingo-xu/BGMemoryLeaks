//
//  UIView+BGLeaks.m
//  BGMemoryLeaks
//
//  Created by Bingo on 2022/12/9.
//

#import "UIView+BGLeaks.h"
#import "NSObject+BGLeaks.h"
#import "BGMemoryLeaksMonitor.h"

@implementation UIView (BGLeaks)

- (BOOL)bgLeaksMonitorObjectCanBeCollected {
    return YES;
}

- (void)bgLeaksMonitorCollectObjectForKey:(NSString *)key
                                condition:(nullable id)conditionObject
                                 callBack:(nullable void (^)(NSMutableDictionary * _Nonnull))callBack {
    
    //先过滤掉view属性 避免重复检测
    if (![NSThread isMainThread]) {
        __block NSMutableArray *views = nil;
        dispatch_sync(dispatch_get_main_queue(), ^{
            views = [[NSMutableArray alloc] initWithArray:self.subviews];
            if (conditionObject) {
                NSMutableDictionary *mapObject = (NSMutableDictionary *)conditionObject;
                [mapObject enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if ([views containsObject:obj]) {
                        [views removeObject:obj];
                    }
                }];
            }
        });
//        [super bgLeaksMonitorCollectObjectForKey:key condition:nil callBack:nil];
        
        [views bgLeaksMonitorCollectObjectForKey:[NSString stringWithFormat:@"%@.subView",key] condition:nil callBack:nil];
    }
}

@end
