//
//  UIViewController+BGLeaks.m
//  BGMemoryLeaks
//
//  Created by Bingo on 2022/12/9.
//

#import "UIViewController+BGLeaks.h"
#import "BGMemoryLeaksTool.h"
#import "BGMemoryLeaksMonitor.h"
#import "NSObject+BGLeaks.h"

@implementation UIViewController (BGLeaks)

+ (void)bgLeaksMonitorVCSetup {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BGOCMethodSwizzle(self.class, @selector(viewDidDisappear:), @selector(bgLeaksMonitorViewDidDisappear:));
    });
}

- (void)bgLeaksMonitorViewDidDisappear:(BOOL)animated {
    [self bgLeaksMonitorViewDidDisappear:animated];
    if (![BGMemoryLeaksMonitor isRunning]) {
        return;
    }
    
    if (![[self bgRootParentViewController] isMovingFromParentViewController] &&
        ![[self bgRootParentViewController] isBeingDismissed]) {
        return;
    }

    [self bgLeaksMonitorCollectObjectForKey:NSStringFromClass([self class])
                                 condition:nil
                                  callBack:nil];
    //2s后弹窗
    [BGMemoryLeaksMonitor showLeaksAlert];
}

- (UIViewController *)bgRootParentViewController {
    UIViewController *root = self;
    while(root.parentViewController) {
        root = root.parentViewController;
    }
    return root;
}

- (BOOL)bgLeaksMonitorObjectCanBeCollected {
    return YES;
}

- (void)bgLeaksMonitorCollectObjectForKey:(NSString *)key
                                condition:(id)condition
                                 callBack:(void (^)(NSMutableDictionary * _Nonnull))callBack {
    //获取所有强引用属性
    __block NSMutableDictionary *mapObject;
    [super bgLeaksMonitorCollectObjectForKey:key condition:nil callBack:^(NSMutableDictionary * _Nonnull dict) {
        mapObject = dict;
    }];
    
    if (![NSThread isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            // 规避 presentedViewController / childViewControllers 属性不生成 ivar 的情况
            [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *keyName = [NSString stringWithFormat:@"%@.child_%ld.%@",key,idx,NSStringFromClass([obj class])];
                [obj bgLeaksMonitorCollectObjectForKey:keyName
                                             condition:nil
                                              callBack:nil];
            }];
            
            if (self.presentedViewController) {
                NSString *keyName = [NSString stringWithFormat:@"%@.present.%@",key,NSStringFromClass([self.presentedViewController class])];
                [self.presentedViewController bgLeaksMonitorCollectObjectForKey:keyName condition:nil callBack:nil];
            }

            // 这里必须确认 viewLoaded ，否则直接调用 self.view 会触发 viewDidLoad 方法
            if (self.viewLoaded) {
                [self.view bgLeaksMonitorCollectObjectForKey:key condition:mapObject callBack:nil];
            }
        });
    }
}


@end
