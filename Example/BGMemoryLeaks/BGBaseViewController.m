//
//  BGBaseViewController.m
//  BGMemoryLeaks_Example
//
//  Created by Bingo on 2022/12/9.
//  Copyright © 2022 bingoxu. All rights reserved.
//

#import "BGBaseViewController.h"

@interface BGBaseViewController ()

@end

@implementation BGBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topButton];
}

- (UIButton *)topButton {
    if (!_topButton) {
        _topButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 50, 50)];
        _topButton.backgroundColor = [UIColor redColor];
        [_topButton setTitle:@"返回"forState:UIControlStateNormal];
        [_topButton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchDown];
    }
    return _topButton;
}

- (void)btnClick {
    if (self.didClickBlock) {
        self.didClickBlock();
    }
}

@end
