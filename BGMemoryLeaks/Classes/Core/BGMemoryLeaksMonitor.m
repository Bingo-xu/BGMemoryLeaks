//
//  BGMemoryLeaksMonitor.m
//  BGMemoryLeaks
//
//  Created by Bingo on 2022/12/9.
//

#import "BGMemoryLeaksMonitor.h"
#import "BGMemoryLeaksModel.h"
#import "UIWindow+BGLeaks.h"
#import "UIViewController+BGLeaks.h"
#import "BGLeaksMemoryAlertView.h"

@interface BGMemoryLeaksMonitor ()

@property (nonatomic, assign) BOOL isRunning;
///内存泄漏名单
@property (nonatomic, strong) NSMapTable  *leakObjectTable;
///防止对象重复添加
@property (nonatomic, strong) NSHashTable *isAddedObject;
///泄漏信息
@property (nonatomic, strong) NSMutableArray *leakArr;
///白名单 不被收集的对象
@property (nonatomic, strong) NSMutableSet <NSString *>*whiteList;

@property (nonatomic, assign) CGFloat timeInterval;

@property (nonatomic, assign) BOOL isAlert;

@end

@implementation BGMemoryLeaksMonitor

+ (instancetype)shareInstance {
    static BGMemoryLeaksMonitor *_singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[super allocWithZone:NULL] init];
        _singleton.timeInterval = 2;
        _singleton.isAlert = YES;
    });
    return _singleton;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [BGMemoryLeaksMonitor shareInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return [BGMemoryLeaksMonitor shareInstance];
}

/**添加白名单类*/
+ (void)addWhiteList:(NSArray <NSString *> *)whiteList {
    [[BGMemoryLeaksMonitor shareInstance].whiteList addObjectsFromArray:whiteList];
}

/**是否白名单类*/
+ (BOOL)isWhiteList:(NSString *)classStr {
    return [[BGMemoryLeaksMonitor shareInstance].whiteList containsObject:classStr];
}

/**
 开启检测
 */
+ (void)start {
    [UIViewController bgLeaksMonitorVCSetup];
    [UIWindow bgLeaksMonitorWindowsSetup];
    [BGMemoryLeaksMonitor shareInstance].isRunning = YES;
}

/**停止检测**/
+ (void)stop {
    [BGMemoryLeaksMonitor shareInstance].isRunning = NO;
}

/**是否已启动*/
+ (BOOL)isRunning {
    return [BGMemoryLeaksMonitor shareInstance].isRunning;
}

/**
 输出内存泄漏信息
 @param leakObjectInfo 回调信息
 @param isAlert 是否弹窗
 */
+ (void)outputLeakObjectInfo:(void (^)(NSArray * _Nonnull))leakObjectInfo isAlert:(BOOL)isAlert {
    [[BGMemoryLeaksMonitor shareInstance] outputLeakObjectInfo:leakObjectInfo isAlert:isAlert];
}

+ (void)leaksAlertConfigWith:(CGFloat)timeInterval isAuto:(BOOL)isAuto {
    [BGMemoryLeaksMonitor shareInstance].timeInterval = timeInterval;
    [BGMemoryLeaksMonitor shareInstance].isAlert = isAuto;
}

+ (void)showLeaksAlert {
    if (![BGMemoryLeaksMonitor shareInstance].isAlert) {
        return;
    }
    [[BGMemoryLeaksMonitor shareInstance] performSelector:@selector(showAlert) withObject:nil afterDelay:[BGMemoryLeaksMonitor shareInstance].timeInterval];
}

- (void)showAlert {
    [self outputLeakObjectInfo:nil isAlert:YES];
}

#pragma mark- 内部使用方法
- (void)addLoadedObject:(NSObject *)object key:(NSString *)key {
    [self.leakObjectTable setObject:object forKey:key];
}

- (id)loadedObjectForkey:(NSString *)key {
    return [self.leakObjectTable objectForKey:key];
}

- (BOOL)addLoadedObjectToArr:(NSObject *)object {
    if ([self.isAddedObject containsObject:object]) {
        return NO;
    } else {
        [self.isAddedObject addObject:object];
        return YES;
    }
}

- (void)outputLeakObjectInfo:(void (^)(NSArray * _Nonnull))leakObjectInfo isAlert:(BOOL)isAlert {
    if (self.isRunning) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *leakObjectArr = [[self.leakObjectTable keyEnumerator] allObjects];
            if ([leakObjectArr count] > 0) {
                [self.leakArr removeAllObjects];
                NSMutableArray *leakObjectKeyArr = [NSMutableArray array];
                [leakObjectArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    BGMemoryLeaksModel *model = [BGMemoryLeaksModel new];
                    model.LeakStr = obj;
                    [leakObjectKeyArr addObject:model];
                }];
                //筛选出同个控制器的放一个数组
                [self reAllocateData:leakObjectKeyArr];
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    if (isAlert) {
                        NSMutableArray *leakStrArr = [NSMutableArray array];
                        [self.leakArr enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSString *retainCyclesStr = [self addRetainCycleDetectorCandidate:[self.leakObjectTable objectForKey:obj]];
                            [leakStrArr addObject:[NSString stringWithFormat:@"%@%@",obj,retainCyclesStr]];
                        }];
                        [[BGLeaksMemoryAlertView memoryLeaksAlert] showMemoryLeaksAlertDataArr:leakStrArr];
                    }
                    NSLog(@"BGLeakObjectInfo:%@",self.leakArr);
                    if (leakObjectInfo) {
                        leakObjectInfo(self.leakArr);
                    }
                });
            }
        });
    }
}

- (void)reAllocateData:(NSMutableArray *)leakObjectKeyArr {
    if (leakObjectKeyArr.count == 0) {
        return;
    }
    BGMemoryLeaksModel *firstModel = [leakObjectKeyArr firstObject];
    NSString *first = [firstModel.LeakStr componentsSeparatedByString:@"."][0];
    NSMutableArray *arr = [NSMutableArray array];
    for (BGMemoryLeaksModel *model in leakObjectKeyArr) {
        if ([model.LeakStr hasPrefix:first]) {
            [arr addObject:model];
        }
    }
    
    NSArray *sortArray = [arr sortedArrayUsingComparator:^NSComparisonResult(BGMemoryLeaksModel *  _Nonnull obj1, BGMemoryLeaksModel *  _Nonnull obj2) {
        if (obj1.LeakStr.length > obj2.LeakStr.length) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    //输出内容过滤
    for (NSUInteger i=0; i<sortArray.count; i++) {
        BGMemoryLeaksModel *model = sortArray[i];
        if (model.isIgnore) {
            continue;
        }
        for (NSUInteger j = i+1; j < sortArray.count; j++) {
            BGMemoryLeaksModel *modelJ = sortArray[j];
            if (modelJ.isIgnore) {
                continue;
            }
            if ([modelJ.LeakStr containsString:model.LeakStr]) {
                modelJ.isIgnore = YES;
            }
        }
        [self.leakArr addObject:model.LeakStr];
    }
    
    [leakObjectKeyArr removeObjectsInArray:sortArray];
    [self reAllocateData:leakObjectKeyArr];
}


//借助FBRetainCycleDetector 查出快速排查泄漏原因 只在OC上有效
- (NSString *)addRetainCycleDetectorCandidate:(id)candidate {
    // 动态判断是否有 FBRetainCycleDetector
    if (NSClassFromString(@"FBRetainCycleDetector")) {
        id detector = [NSClassFromString(@"FBRetainCycleDetector") new];
        
        if ([detector respondsToSelector:NSSelectorFromString(@"addCandidate:")]
            && [detector respondsToSelector:NSSelectorFromString(@"findRetainCyclesWithMaxCycleLength:")]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [detector performSelector:NSSelectorFromString(@"addCandidate:") withObject:candidate];
            NSSet *retainCycles = [detector performSelector:NSSelectorFromString(@"findRetainCyclesWithMaxCycleLength:") withObject:@100];
#pragma clang diagnostic pop
            return retainCycles.count > 0?[NSString stringWithFormat:@": 强引用链%@",retainCycles.debugDescription]:@"";
        }
        return @"";
     }
    return @"";
}

#pragma mark - lazy
- (NSHashTable *)isAddedObject {
    if (!_isAddedObject) {
        _isAddedObject = [NSHashTable weakObjectsHashTable];
    }
    return _isAddedObject;
}

- (NSMapTable *)leakObjectTable {
    if (!_leakObjectTable) {
        _leakObjectTable = [NSMapTable strongToWeakObjectsMapTable];
    }
    return _leakObjectTable;
}

- (NSMutableArray *)leakArr {
    if (!_leakArr) {
        _leakArr = [NSMutableArray array];
    }
    return _leakArr;
}

- (NSMutableSet<NSString *> *)whiteList {
    if (!_whiteList) {
        _whiteList = [NSMutableSet set];
    }
    return _whiteList;
}

@end

