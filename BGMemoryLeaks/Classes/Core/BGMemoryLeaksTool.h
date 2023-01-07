//
//  BGMemoryLeaksTool.h
//  BGMemoryLeaks
//
//  Created by Bingo on 2022/12/9.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGMemoryLeaksTool : NSObject

typedef struct bg_objc_property {
    const char *name;
    const char *attributes;
    bool is_strong;
    bool is_copy;
    bool is_weak;
    bool is_readonly;
    bool is_nonatomic;
    bool is_dynamic;
    char ivar_name[512];
    char type_name[218];
} *bg_objc_property_t;

CF_EXPORT struct bg_objc_property BGExpandProperty(objc_property_t property);
CF_EXPORT BOOL BGIsSystemClass(Class cls);
CF_EXPORT void BGOCMethodSwizzle(Class clas,
                               SEL originalSelector,
                               SEL swizzledSelector);
@end

NS_ASSUME_NONNULL_END
