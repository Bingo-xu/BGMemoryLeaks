//
//  NSArray+BGLeaks.m
//  BGMemoryLeaks
//
//  Created by Bingo on 2022/12/9.
//

#import "NSArray+BGLeaks.h"
#import "NSObject+BGLeaks.h"

@implementation NSArray (BGLeaks)

- (BOOL)bgLeaksMonitorObjectCanBeCollected {
    return YES;
}


- (void)bgLeaksMonitorCollectObjectForKey:(NSString *)key
                                condition:(nullable id)conditionObject
                                 callBack:(nullable void (^)(NSMutableDictionary * _Nonnull))callBack {
//    [super bgLeaksMonitorCollectObjectForKey:key condition:nil callBack:nil];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *keyName = [NSString stringWithFormat:@"%@.arr_%ld.%@",key,idx,NSStringFromClass([obj class])];
        [obj bgLeaksMonitorCollectObjectForKey:keyName condition:nil callBack:nil];
    }];
}


@end
