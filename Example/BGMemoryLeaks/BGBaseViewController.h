//
//  BGBaseViewController.h
//  BGMemoryLeaks_Example
//
//  Created by Bingo on 2022/12/9.
//  Copyright © 2022 bingoxu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickActionBlcok)(void);

@interface BGBaseViewController : UIViewController

@property (nonatomic, strong) UIButton *topButton;

@property (nonatomic, copy) ClickActionBlcok didClickBlock;

@end

NS_ASSUME_NONNULL_END
