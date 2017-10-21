//
//  GameController.m
//  色差游戏
//
//  Created by 尚勇杰 on 2017/10/10.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "GameController.h"
#import "ViewController.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "RankingList.h"
#import "ZJAnimationPopView.h"
#import <SVProgressHUD/SVProgressHUD.h>

#define KW [UIScreen mainScreen].bounds.size.width
#define KH [UIScreen mainScreen].bounds.size.height

@interface GameController ()
@property (weak, nonatomic) IBOutlet UIButton *normal;
@property (weak, nonatomic) IBOutlet UIButton *time;
@property (weak, nonatomic) IBOutlet UIButton *rankingList;

@end

@implementation GameController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.normal.layer.masksToBounds = YES;
    self.time.layer.masksToBounds = YES;
    self.rankingList.layer.masksToBounds = YES;

    self.normal.layer.cornerRadius = 15;
    self.time.layer.cornerRadius = 15;
    self.rankingList.layer.cornerRadius = 15;
    
    // Do any additional setup after loading the view.
}
- (IBAction)normalMode:(UIButton *)sender {
    
    ViewController *vc = [[ViewController alloc]init];
    vc.state = NO;
    [self presentViewController:vc animated:YES completion:nil];
    
}
- (IBAction)timepattern:(id)sender {
    ViewController *vc = [[ViewController alloc]init];
    vc.state = YES;
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)rankingList:(id)sender {
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"list"];
    if (array.count < 1) {
        [SVProgressHUD showInfoWithStatus:@"您还没有开始玩呢"];
    }else{
        
        ZJAnimationPopStyle popStyle = ZJAnimationPopStyleCardDropFromLeft;
        ZJAnimationDismissStyle dismissStyle = ZJAnimationDismissStyleCardDropToRight;
        
        UIView *view = [[RankingList alloc]initWithFrame:CGRectMake(KW - 40, 85, KW - 80, KH - 170)];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 15;
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        view.layer.borderWidth = 1.0;
        // 1.初始化
        ZJAnimationPopView *popView = [[ZJAnimationPopView alloc] initWithCustomView:view popStyle:popStyle dismissStyle:dismissStyle];
        
        // 2.设置属性，可不设置使用默认值，见注解
        // 2.1 显示时点击背景是否移除弹框
        popView.isClickBGDismiss = YES;
        // 2.2 显示时背景的透明度
        popView.popBGAlpha = 0.5f;
        // 2.3 显示时是否监听屏幕旋转
        popView.isObserverOrientationChange = YES;
        // 2.4 显示时动画时长
        //    popView.popAnimationDuration = 0.8f;
        // 2.5 移除时动画时长
        //    popView.dismissAnimationDuration = 0.8f;
        
        // 2.6 显示完成回调
        popView.popComplete = ^{
            NSLog(@"显示完成");
        };
        // 2.7 移除完成回调
        popView.dismissComplete = ^{
            NSLog(@"移除完成");
        };
        
        // 3.处理自定义视图操作事件
//        [self handleCustomActionEnvent:popView];
        
        // 4.显示弹框
        [popView pop];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
