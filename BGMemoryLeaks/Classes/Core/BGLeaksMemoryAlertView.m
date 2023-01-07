//
//  BGLeaksMemoryAlertView.m
//  BGMemoryLeaks
//
//  Created by Bingo on 2022/12/9.
//

#import "BGLeaksMemoryAlertView.h"

#define k_XYWidth [UIScreen mainScreen].bounds.size.width
#define k_XYHeight [UIScreen mainScreen].bounds.size.height
#define k_XYWindow [UIApplication sharedApplication].keyWindow

@interface BGLeaksMemoryAlertView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSArray<NSString *> *dataArr;

@end

@implementation BGLeaksMemoryAlertView

static BGLeaksMemoryAlertView *manager = nil;

+ (instancetype)memoryLeaksAlert {
    if (manager == nil) {
        manager = [[BGLeaksMemoryAlertView alloc] init];
    }
    return manager;
}

- (void)showMemoryLeaksAlertDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self setUpView:dataArr];

    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.2];
        [k_XYWindow addSubview:self.bgView];
    }];
}

- (void)setUpView:(NSArray *)arr {
    CGFloat margin = 15;
    CGFloat width = k_XYWidth - margin*2;
    CGFloat listH = arr.count*60;
    if (listH > k_XYHeight) {
        listH = k_XYHeight - 100;
    }
    if (listH < 100) {
        listH = 100;
    }
    
    self.listView.frame = CGRectMake(0, 0, k_XYWidth - margin*2, listH);
    self.listView.center = self.bgView.center;
    [self.bgView addSubview:self.listView];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(margin, CGRectGetMinY(self.listView.frame) - 30, width, 30)];
    titleL.text = @"内存泄漏信息";
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.backgroundColor = [UIColor whiteColor];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    [self.bgView addSubview:titleL];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(margin,CGRectGetMaxY(self.listView.frame),width, 0.5)];
    line.backgroundColor = [UIColor redColor];
    [self.bgView addSubview:line];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(margin,CGRectGetMaxY(line.frame),width*0.5, 40);
    [leftBtn setTitle:@"OK" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [leftBtn setBackgroundColor:[UIColor whiteColor]];
    [leftBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchDown];
    [self.bgView addSubview:leftBtn];

    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftBtn.frame),CGRectGetMaxY(line.frame), 0.5, 40)];
    line1.backgroundColor = [UIColor redColor];
    [self.bgView addSubview:line1];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(CGRectGetMaxX(line1.frame),CGRectGetMaxY(line.frame), width*0.5 - 0.5, 40);
    [rightBtn setTitle:@"拷贝" forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:[UIColor whiteColor]];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(copyToPasteboard) forControlEvents:UIControlEventTouchDown];
    [self.bgView addSubview:rightBtn];
}

- (void)close {
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        manager = nil;
    }];
}

- (void)copyToPasteboard {
    NSMutableString *str = [NSMutableString string];
    [self.dataArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [str appendFormat:@"%@\n",obj];
    }];
    [[UIPasteboard generalPasteboard] setString:str];
}

#pragma mark --- TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"YKMemoryLeaksAlertCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}

#pragma mark --- LazyLoad Views
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.frame = CGRectMake(0, 0, k_XYWidth, k_XYHeight);
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

- (UITableView *)listView {
    if (!_listView) {
        _listView = [UITableView new];
        _listView.estimatedRowHeight = 30;
        if ([_listView respondsToSelector:@selector(setSeparatorInset:)]){
            [_listView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_listView respondsToSelector:@selector(setLayoutMargins:)]){
            [_listView setLayoutMargins:UIEdgeInsetsZero];
        }
        _listView.backgroundColor = [UIColor whiteColor];
        _listView.delegate = self;
        _listView.dataSource = self;
    }
    return _listView;
}

@end
