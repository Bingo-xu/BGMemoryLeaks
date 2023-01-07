//
//  BGMemoryLeaksModel.h
//  BGMemoryLeaks
//
//  Created by Bingo on 2022/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGMemoryLeaksModel : NSObject

@property (nonatomic, assign) BOOL isIgnore;

@property (nonatomic,   copy) NSString *LeakStr;

@end

NS_ASSUME_NONNULL_END
