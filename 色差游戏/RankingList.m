//
//  RankingList.m
//  色差游戏
//
//  Created by 尚勇杰 on 2017/10/11.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "RankingList.h"
#import "RankingListCell.h"
#import <SDAutoLayout/SDAutoLayout.h>

@implementation RankingList

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.tableView = [[UITableView alloc]initWithFrame:self.bounds];
        [self addSubview:self.tableView];
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.tableView registerClass:[RankingListCell class] forCellReuseIdentifier:@"cell"];
        
    }
    
    return self;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"list"];
    return array.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RankingListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.rankingText.text = [NSString stringWithFormat:@"Number %ld",indexPath.row];
    NSArray *originalArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"list"];
    //block比较方法，数组中可以是NSInteger，NSString（需要转换）
//    NSComparator finderSort = ^(id string1,id string2){
//
//        if ([string1 integerValue] > [string2 integerValue]) {
//            return (NSComparisonResult)NSOrderedDescending;
//        }else if ([string1 integerValue] < [string2 integerValue]){
//            return (NSComparisonResult)NSOrderedAscending;
//        }else
//            return (NSComparisonResult)NSOrderedSame;
//    };
    
    //数组排序：
    NSArray *resultArray = [originalArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 compare:obj1]; //降序
        

    }];
    cell.numText.text = [NSString stringWithFormat:@"%@",resultArray[indexPath.row]];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]init];
    UILabel *lable = [[UILabel alloc]init];
    [view addSubview:lable];
    lable.font = [UIFont fontWithName:@"Georgia-Italic" size:26];
    lable.textColor = [UIColor magentaColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"Ranking List";
    lable.sd_layout.leftSpaceToView(view, 0).rightSpaceToView(view, 0).topSpaceToView(view, 0).bottomSpaceToView(view, 0);
    lable.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    
    
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
    
}




@end
