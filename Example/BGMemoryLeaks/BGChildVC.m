//
//  BGChildVC.m
//  BGMemoryLeaks_Example
//
//  Created by Bingo on 2022/12/13.
//  Copyright © 2022 bingoxu. All rights reserved.
//

#import "BGChildVC.h"
#import "BGLeaksView.h"

@interface BGChildVC ()

@end

@implementation BGChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor greenColor];
    BGLeaksView *leakView = [BGLeaksView new];
    [self.view addSubview:leakView];
    leakView.leakTarget = self;
}


- (instancetype)initWithModel:(BGModel *)model {
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

@end
