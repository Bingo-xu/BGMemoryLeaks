//
//  UIWindow+BGLeaks.m
//  BGMemoryLeaks
//
//  Created by Bingo on 2022/12/9.
//

#import "UIWindow+BGLeaks.h"
#import "BGMemoryLeaksTool.h"
#import "BGMemoryLeaksMonitor.h"
#import "NSObject+BGLeaks.h"

@implementation UIWindow (BGLeaks)

+ (void)bgLeaksMonitorWindowsSetup {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            BGOCMethodSwizzle(self.class, @selector(setRootViewController:), @selector(bgLeaksMonitorSetRootViewController:));
        });
       
    });
}

- (void)bgLeaksMonitorSetRootViewController:(UIViewController *)rootViewController {
    if (self.rootViewController && ![self.rootViewController isEqual:rootViewController]) {
        [self bgLeaksMonitorCollectObjectForKey:NSStringFromClass(self.rootViewController.class) condition:nil callBack:nil];
    }
    [self bgLeaksMonitorSetRootViewController:rootViewController];
}

@end
