# BGMemoryLeaks

  一款用于自动检测项目中基于控制器引用链，内存泄漏检测的利器，支持 ObjC，Swift。
##功能介绍
*基于控制器引用链
*  自动监控 **`Controller`** 的泄漏；
*  自动监控 **`View`** 的泄漏；
*  自动监控集合对象的泄漏
*  自动监控强引用属性对象的泄漏
*  支持alert内存泄漏信息
*  借助 [FBRetainCycleDetector](https://github.com/facebook/FBRetainCycleDetector) 快速排查循环引用链 只在 `ObjC` 上有效 】；

## 接入说明

```ruby
pod 'BGMemoryLeaks'
```
*   如果想查看控制器的强引用链，可导入：Facebook 的 [FBRetainCycleDetector](https://github.com/facebook/FBRetainCycleDetector) 框架即可。
```
pod 'FBRetainCycleDetector', :git => 'https://github.com/facebook/FBRetainCycleDetector.git', :branch => 'main', :configurations => ['Debug']
```

### 基本使用
启动内存检测：

```
    [BGMemoryLeaks startDetection];
```

如果是一些不想收集的对象，比如单例、或者一些想缓存的页面，可以加入白名单列表
```
objective-c
+ (void)addWhiteList:(NSArray <NSString *> *)whiteList;
```

####alert展示内存泄漏信息
#####默认界面消失2s后弹出内存泄漏弹窗
#####配置alert出现时间和是否自动弹出
```
/**
 默认2s自动弹窗内存泄漏弹窗
 timeInterval 弹窗延迟时间
 isAuto 是否自动弹。NO需要自己选择弹窗时机
 **/
+ (void)leaksAlertConfigWith:(CGFloat)timeInterval isAuto:(BOOL)isAuto;
```
#####设置不自动弹出，可以在合适时机调用内存泄漏信息输出方法，例如app从后台切到前台，支持弹框展示内存泄漏详细
```
  [BGMemoryLeaks outputLeakObjectInfo:^(NSArray * _Nonnull info) {
        NSLog(@"%@",info);
    } isAlert:YES];
```
###实现原理
####监测入口：
通常情况，如果控制器经过了`viewDidDisappear`方法，且满足释放条件，所以我们可以与控制器的`viewDidDisappear`进行方法交换来触发监测动作即可，实现代码如下
```objective-c
- (void)bgLeaksMonitorViewDidDisappear:(BOOL)animated {
    [self bgLeaksMonitorViewDidDisappear:animated];
    if (![BGMemoryLeaksMonitor isRunning]) {
        return;
    }
    
    if (![[self bgRootParentViewController] isMovingFromParentViewController] &&
        ![[self bgRootParentViewController] isBeingDismissed]) {
        return;
    }

    [self bgLeaksMonitorCollectObjectForKey:NSStringFromClass([self class])
                                 condition:nil
                                  callBack:nil];
    //2s后弹窗
    [BGMemoryLeaksMonitor showLeaksAlert];
}
```
还有一种监测入口出现在KeyWindow变更根控制器时，由于直接设置根控制器不会触发 `viewDidDisappear `方法，所以需要`setRootViewController`方法交换触发监测动作即可 ：
```
- (void)bgLeaksMonitorSetRootViewController:(UIViewController *)rootViewController {
    if (self.rootViewController && ![self.rootViewController isEqual:rootViewController]) {
        [self bgLeaksMonitorCollectObjectForKey:NSStringFromClass(self.rootViewController.class) condition:nil callBack:nil];
    }
    [self bgLeaksMonitorSetRootViewController:rootViewController];
}
```
####收集对象信息
1.收集控制器强引用属性对象
2.收集控制器所有子控制器对象
3.收集控制器所有view对象
4.会对实现下面协议方法的系统类收集、其他系统类过滤
```objective-c
- (BOOL)LeaksMonitorObjectCanBeCollected {
    return YES;
}
```
以上操作会进行循环遍历，对象均用`NSMapTable`进行收集


## Author

bingoxu, bingoxu@yeahka.com

## License

BGMemoryLeaks is available under the MIT license. See the LICENSE file for more info.
