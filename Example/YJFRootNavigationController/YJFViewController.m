//
//  YJFViewController.m
//  YJFRootNavigationController
//
//  Created by acct<blob>=<NULL> on 11/03/2017.
//  Copyright (c) 2017 acct<blob>=<NULL>. All rights reserved.
//

#import "YJFViewController.h"
#import "YJFTestViewController.h"

#define YJFColor(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1];
#define YJFColorAlpha(r,g,b,a) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:a];

#define YJFRandomColor YJFColor((arc4random_uniform(255)),(arc4random_uniform(255)),(arc4random_uniform(255)))


#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define YJFKeyPath(objc,keyPath) @(((void)objc.keyPath,#keyPath))



@interface YJFViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@end

@implementation YJFViewController


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    
    float y = self.tableView.contentOffset.y;

    CGFloat value = y/200;
    [self.navigationController.navigationBar setValue:@(value) forKeyPath:@"backgroundView.alpha"];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    self.navigationController.navigationBar.barTintColor = YJFRandomColor;
    
    [self.tableView addObserver:self forKeyPath:YJFKeyPath(self.tableView, contentOffset) options:NSKeyValueObservingOptionNew context:nil];

}


#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%zd-%zd",indexPath.section,indexPath.row];
//    cell.backgroundColor = YJFRandomColor;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.navigationController pushViewController:[YJFTestViewController new] animated:YES];
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW , kScreenH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollsToTop=YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.estimatedRowHeight = 200;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        
    }
    return _tableView;
}

@end
