//
//  BGLeaksView.h
//  BGMemoryLeaks_Example
//
//  Created by Bingo on 2022/12/13.
//  Copyright © 2022 bingoxu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGLeaksView : UIView

@property (nonatomic, strong) id leakTarget;

@end

@interface BGLeakSubView : BGLeaksView


@end

@interface BGLeakTableViewCell : UITableViewCell

@property (nonatomic, strong) id leakTarget;

@end

NS_ASSUME_NONNULL_END
