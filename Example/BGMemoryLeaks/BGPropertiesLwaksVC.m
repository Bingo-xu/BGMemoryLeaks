//
//  BGPropertiesLwaksVC.m
//  BGMemoryLeaks_Example
//
//  Created by Bingo on 2022/12/13.
//  Copyright © 2022 bingoxu. All rights reserved.
//

#import "BGPropertiesLwaksVC.h"

#import "BGChildVC.h"
#import "BGLeaksView.h"
#import "BGModel.h"

@interface BGPropertiesLwaksVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *dict;

@end

@implementation BGPropertiesLwaksVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArr = [NSMutableArray array];
    
    //firstLevelView leak
    BGLeaksView *firstLevelView = [[BGLeaksView alloc] initWithFrame:CGRectMake(20, 300, 60, 60)];
    firstLevelView.backgroundColor = [UIColor lightGrayColor];
    
    BGLeakSubView *secondLevelView = [[BGLeakSubView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    secondLevelView.leakTarget = firstLevelView;
    secondLevelView.backgroundColor = [UIColor grayColor];
    [firstLevelView addSubview:secondLevelView];
    [self.view addSubview:firstLevelView];

    // dic user leak
    BGModel *model1 = [BGModel new];
    BGModel *model2 = [BGModel new];
    model2.leakTarget = model1;
    model1.leakTarget = model2;
    
    self.dict = [NSMutableDictionary new];
    [self.dict setObject:model1 forKey:@"model1"];
    
    //arr user leak
    BGModel *model3 = [BGModel new];
    BGModel *model4 = [BGModel new];
    model3.leakTarget = model4;
    model4.leakTarget = model3;
    [self.dataArr addObject:model3];
    
    //tabView leak
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 370, self.view.frame.size.width, 300) style:UITableViewStyleGrouped];
    [self.tableView registerClass:[BGLeakTableViewCell class] forCellReuseIdentifier:@"BGLeakTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //childVC leak
    BGChildVC *childVc1 = [[BGChildVC alloc] initWithModel:[BGModel new]];
    childVc1.view.frame = CGRectMake(0, 300, 300, 100);
    [self.view addSubview:childVc1.view];
    [self addChildViewController:childVc1];
    
    BGChildVC *childVc2 = [[BGChildVC alloc] initWithModel:[BGModel new]];
    childVc2.view.frame = CGRectMake(0, 500, 300, 100);
    [self.view addSubview:childVc2.view];
    [self addChildViewController:childVc2];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BGLeakTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BGLeakTableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Leak Cell: %ld", indexPath.row + 1];
    cell.leakTarget = tableView;
    return cell;
}

@end
