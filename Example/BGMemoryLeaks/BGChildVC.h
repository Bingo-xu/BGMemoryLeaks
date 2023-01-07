//
//  BGChildVC.h
//  BGMemoryLeaks_Example
//
//  Created by Bingo on 2022/12/13.
//  Copyright © 2022 bingoxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BGChildVC : UIViewController

@property (nonatomic, strong) BGModel *model;

- (instancetype)initWithModel:(BGModel *)model;

@end

NS_ASSUME_NONNULL_END
