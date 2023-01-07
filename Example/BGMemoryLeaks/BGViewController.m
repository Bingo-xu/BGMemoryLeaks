//
//  BGViewController.m
//  BGMemoryLeaks
//
//  Created by bingoxu on 12/09/2022.
//  Copyright (c) 2022 bingoxu. All rights reserved.
//

#import "BGViewController.h"
#import "BGPropertiesLwaksVC.h"
#import "BGPresentLeaksVC.h"
#import "BGPushLeaksVC.h"
#import "BGMemoryLeaks_Example-Swift.h"

@interface BGViewController ()

@property (strong, nonatomic) NSArray *problemsList;

@end

@implementation BGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.problemsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"BGProblemCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    cell.textLabel.text = self.problemsList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[BGPushLeaksVC new] animated:YES];
    } else if(indexPath.row == 1) {
        [self presentViewController:[BGPresentLeaksVC new]  animated:YES completion:nil];
    } else if (indexPath.row == 2) {
        [self.navigationController pushViewController:[BGLeaksSwiftVC new] animated:YES];
    } else if (indexPath.row == 3) {
        [self.navigationController pushViewController:[BGPropertiesLwaksVC new] animated:YES];
    }
}

- (NSArray *)problemsList {
    if (!_problemsList) {
        _problemsList = @[@"OC控制器push泄漏",
                          @"OC控制器present泄漏",
                          @"Swift控制器push泄漏",
                          @"集合类型内存泄露"];
    }
    return _problemsList;
}

@end
