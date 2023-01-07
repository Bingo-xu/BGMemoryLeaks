//
//  BGLeaksMemoryAlertView.h
//  BGMemoryLeaks
//
//  Created by Bingo on 2022/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGLeaksMemoryAlertView : UIView

+ (instancetype)memoryLeaksAlert;

- (void)showMemoryLeaksAlertDataArr:(NSArray *)dataArr;

@end

NS_ASSUME_NONNULL_END
