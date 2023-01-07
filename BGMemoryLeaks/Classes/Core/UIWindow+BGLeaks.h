//
//  UIWindow+BGLeaks.h
//  BGMemoryLeaks
//
//  Created by Bingo on 2022/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (BGLeaks)

+ (void)bgLeaksMonitorWindowsSetup;

@end

NS_ASSUME_NONNULL_END
