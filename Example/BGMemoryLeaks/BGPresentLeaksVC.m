//
//  BGPresentLeaksVC.m
//  BGMemoryLeaks_Example
//
//  Created by Bingo on 2022/12/13.
//  Copyright © 2022 bingoxu. All rights reserved.
//

#import "BGPresentLeaksVC.h"

@interface BGPresentLeaksVC ()

@end

@implementation BGPresentLeaksVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.didClickBlock = ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
}


@end
