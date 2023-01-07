//
//  BGMemoryLeaksTool.m
//  BGMemoryLeaks
//
//  Created by Bingo on 2022/12/9.
//

#import "BGMemoryLeaksTool.h"
#include <string.h>
#include <dlfcn.h>
#include <mach-o/dyld.h>
#include <mach/vm_types.h>

@implementation BGMemoryLeaksTool

struct bg_objc_property BGExpandProperty(objc_property_t property) {
    struct bg_objc_property m_property = {0};
    
    m_property.name = property_getName(property);
    m_property.attributes = property_getAttributes(property);
    
    if (m_property.name == NULL || m_property.attributes == NULL ||
        m_property.name[0] == '\0' || m_property.attributes[0] == '\0') {
        return m_property;
    }
    
    const char *pos = m_property.attributes;
    do {
        size_t len = strcspn(pos, ",");
        if (len == 1) {
            switch (*pos) {
#define LM_POS_CASE(con, name) { \
case con: m_property.name = true; \
break; }
                    LM_POS_CASE('R', is_readonly)
                    LM_POS_CASE('C', is_copy)
                    LM_POS_CASE('&', is_strong)
                    LM_POS_CASE('W', is_weak)
                    LM_POS_CASE('N', is_nonatomic)
                    LM_POS_CASE('D', is_dynamic)
                default: break;
            }
        } else if (len > 1) {
            switch (*pos) {
#define LM_CPY_CASE(con, name)  \
case con: { \
strncpy(m_property.name, pos + 1, len - 1); \
m_property.name[len] = '\0'; \
break; }
                    LM_CPY_CASE('V', ivar_name)
                    LM_CPY_CASE('T', type_name)
                default: break;
            }
        }
        pos += len;
    } while (*pos++);
    
    return m_property;
}

BOOL BGIsSystemClass(Class cls) {
    NSBundle *bundle = [NSBundle bundleForClass:cls];
    if ([bundle isEqual:[NSBundle mainBundle]]) {
        return NO;
    }
    static NSString *embededDirPath;
    if (!embededDirPath) {
        embededDirPath = [[NSBundle mainBundle].bundleURL URLByAppendingPathComponent:@"Frameworks"].absoluteString;
    }
    BOOL isSyetem = [bundle.bundlePath hasPrefix:embededDirPath];
    if (!isSyetem) {
        NSLog(@"系统类%@",NSStringFromClass(cls));
    }
    return !isSyetem;
}

void BGOCMethodSwizzle(Class clas,
                    SEL originalSelector,
                    SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(clas, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(clas, swizzledSelector);
    if (class_addMethod(clas, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(clas, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
