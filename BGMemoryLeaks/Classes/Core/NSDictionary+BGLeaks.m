//
//  NSDictionary+BGLeaks.m
//  BGMemoryLeaks
//
//  Created by Bingo on 2022/12/9.
//

#import "NSDictionary+BGLeaks.h"
#import "NSObject+BGLeaks.h"

@implementation NSDictionary (BGLeaks)

- (BOOL)bgLeaksMonitorObjectCanBeCollected {
    return YES;
}

- (void)bgLeaksMonitorCollectObjectForKey:(NSString *)key
                                condition:(nullable id)conditionObject
                                 callBack:(nullable void (^)(NSMutableDictionary * _Nonnull))callBack {
//    [super bgLeaksMonitorCollectObjectForKey:key condition:nil callBack:nil];
    // 字典对 key 执行 copy，原则上也要 collect ，但是考虑到 key 一般不为自定义对象，所以忽略
    [self.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id value = [self valueForKey:obj];
        NSString *keyName = [NSString stringWithFormat:@"%@.%@:%@",key,obj,NSStringFromClass([value class])];
        [value bgLeaksMonitorCollectObjectForKey:keyName condition:nil callBack:nil];
    }];
}

@end
