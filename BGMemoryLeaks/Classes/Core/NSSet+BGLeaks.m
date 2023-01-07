//
//  NSSet+BGLeaks.m
//  BGMemoryLeaks
//
//  Created by Bingo on 2022/12/9.
//

#import "NSSet+BGLeaks.h"
#import "NSObject+BGLeaks.h"
@implementation NSSet (BGLeaks)

- (BOOL)bgLeaksMonitorObjectCanBeCollected {
    return YES;
}

- (void)bgLeaksMonitorCollectObjectForKey:(NSString *)key
                                condition:(nullable id)conditionObject
                                 callBack:(nullable void (^)(NSMutableDictionary * _Nonnull))callBack {
//    [super bgLeaksMonitorCollectObjectForKey:key condition:nil callBack:nil];

    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *keyName = [NSString stringWithFormat:@"%@.set.%@",key,NSStringFromClass([obj class])];
        [obj bgLeaksMonitorCollectObjectForKey:keyName condition:nil callBack:nil];
    }];
}


@end
