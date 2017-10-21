//
//  RankingList.h
//  色差游戏
//
//  Created by 尚勇杰 on 2017/10/11.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingList : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end
