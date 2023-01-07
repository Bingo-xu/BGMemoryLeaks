//
//  BGModel.h
//  BGMemoryLeaks_Example
//
//  Created by Bingo on 2022/12/13.
//  Copyright © 2022 bingoxu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGModel : NSObject

@property (nonatomic, strong) NSMutableDictionary *dict;
@property (nonatomic, strong) id leakTarget;

@end

NS_ASSUME_NONNULL_END
