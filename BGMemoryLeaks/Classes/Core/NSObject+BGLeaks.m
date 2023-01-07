//
//  NSObject+BGLeaks.m
//  BGMemoryLeaks
//
//  Created by Bingo on 2022/12/9.
//

#import "NSObject+BGLeaks.h"
#import "BGMemoryLeaksMonitor.h"
#import "BGMemoryLeaksTool.h"

@implementation NSObject (BGLeaks)

- (dispatch_queue_t)serialQueue {
    static dispatch_queue_t _serialQueue = nil;
    static dispatch_once_t oncePredicate;
      dispatch_once(&oncePredicate, ^{
          _serialQueue = dispatch_queue_create("serial",DISPATCH_QUEUE_SERIAL);
      });
    return _serialQueue;
}

//默认所有非系统类都可收集
- (BOOL)bgLeaksMonitorObjectCanBeCollected {
    BOOL isCan = !BGIsSystemClass(self.class) && ![self isWitheList];
    NSLog(@"能否检测%d,类名%@",isCan,NSStringFromClass(self.class));
    return isCan ;
}

- (BOOL)isWitheList {
    return [BGMemoryLeaksMonitor isWhiteList:NSStringFromClass([self class])];
}

- (void)bgLeaksMonitorCollectObjectForKey:(NSString *)keyStr
                                condition:(id)condition
                                 callBack:(nullable void (^)(NSMutableDictionary * _Nonnull))callBack {
    
    if ([self isWitheList]) {
        return;
    }
    
    dispatch_async([self serialQueue], ^{
        Class cls = self.class;
        NSMutableDictionary *objectMap = [NSMutableDictionary dictionary];
        //先收集属性 属性可能有强引用指向对象本身
        while (cls && !BGIsSystemClass(cls)) {
            unsigned int count = 0;
            objc_property_t *properties = class_copyPropertyList(cls, &count);
            for (unsigned int i = 0; i < count; i++) {
                objc_property_t property = properties[i];
                struct bg_objc_property mProperty = BGExpandProperty(property);
                
                // 过滤掉不是 strong / copy 的属性
                // 以及没有对应 ivar 的属性，比如 vc 的 view 属性
                // 强行通过 view 属性调用，可能会触发 viewDidLoad 导致意外的 bug
                if ((!mProperty.is_copy && !mProperty.is_strong) || mProperty.ivar_name[0] == '\0') {
                    continue;
                }
                
                Ivar ivar = class_getInstanceVariable(cls, mProperty.ivar_name);
                const char *type = ivar_getTypeEncoding(ivar);
                
                // 过滤掉不是对象的 ivar
                if (type != NULL && type[0] != '@') {
                    continue;
                }
                id object = object_getIvar(self, ivar);
                if ([object bgLeaksMonitorObjectCanBeCollected]) {
                    NSString *propertyName = [NSString stringWithCString:mProperty.name encoding:NSUTF8StringEncoding];
                    NSString *keyName = [NSString stringWithFormat:@"%@.%@",keyStr,propertyName];
                    //强引用属性放hashmap
                   if ([[BGMemoryLeaksMonitor shareInstance] addLoadedObjectToArr:object]) {
                       [[BGMemoryLeaksMonitor shareInstance] addLoadedObject:object key:keyName];
                       objectMap[propertyName] = object;
                   }
                }
            }
            free(properties);
            cls = [cls superclass];
        }
        
        //收集对象本身 由于重写了UIview UIcontroller的LeaksMonitorObjectCanBeCollected方法 可能导致系统定义的UIview UIcontroller会被收集 所以增加!YKIsSystemClass(self.class)过滤
        if (!BGIsSystemClass(self.class) &&
            [self bgLeaksMonitorObjectCanBeCollected] &&
            [[BGMemoryLeaksMonitor shareInstance] addLoadedObjectToArr:self]){
            [[BGMemoryLeaksMonitor shareInstance] addLoadedObject:self key:keyStr];
        }
       
        if (callBack) {
            callBack(objectMap);
        }

        [objectMap enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [obj bgLeaksMonitorCollectObjectForKey:[NSString stringWithFormat:@"%@.%@",keyStr,key] condition:nil callBack:nil];
        }];
    });
}

@end
