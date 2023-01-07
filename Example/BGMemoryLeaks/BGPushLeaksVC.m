//
//  BGPushLeaksVC.m
//  BGMemoryLeaks_Example
//
//  Created by Bingo on 2022/12/9.
//  Copyright © 2022 bingoxu. All rights reserved.
//

#import "BGPushLeaksVC.h"

@interface BGPushLeaksVC ()

@property (nonatomic,strong) NSArray *bgList;

@end

@implementation BGPushLeaksVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bgList = [NSMutableArray new];
    NSMutableArray *newCodes = [self.bgList mutableCopy];
    self.bgList = [newCodes copy];
    
//    self.didClickBlock = ^{
//        [self.navigationController popViewControllerAnimated:YES];
//    };
}


@end
