//
//  ViewController.m
//  色差游戏
//
//  Created by mac on 16/7/14.
//  Copyright © 2016年 CYC. All rights reserved.
//

#import "ViewController.h"
#import "ColorGameView.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface ViewController () {
    NSLock *_lock;
    ColorGameView *_colorView;

}
@property (strong, nonatomic)  UILabel *score;
@property (strong, nonatomic)  UILabel *time;
@property (nonatomic, strong)  UIButton *pasetBtn;
@property (nonatomic, strong)  UIButton *resetBtn;
@property (nonatomic, strong)  UIButton *mainBtn;
@property (nonatomic, strong)   NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lock = [[NSLock alloc] init];
    self.view.backgroundColor = [UIColor brownColor];
    _colorView = [[ColorGameView alloc] initWithFrame:CGRectZero];
    //游戏还未开始，不能点击
    _colorView.userInteractionEnabled = NO;
    [self.view addSubview:_colorView];
    
    //加载view
    [self setView];
    
    //开始游戏
    [self setload];
    
    
    if (self.state == YES) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(timerAction:)
                                                    userInfo:nil
                                                     repeats:YES];
    }else{
        
        self.time.hidden = YES;
        self.pasetBtn.hidden = YES;
        [self.score removeFromSuperview];
        self.score = [[UILabel alloc]init];
        self.score.text = @"0";
        [self.view addSubview:self.score];
        self.score.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:60.0];
        self.score.textColor = [UIColor purpleColor];
        self.score.sd_layout.bottomSpaceToView(_colorView, 20).centerXEqualToView(self.view).heightIs(45.0).widthIs(80);
        
    }
}

#pragma mark - set view
- (void)setView{
    
    self.score = [[UILabel alloc]init];
    [self.view addSubview:self.score];
    self.score.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:60.0];
    self.score.textColor = [UIColor purpleColor];
    self.score.sd_layout.bottomSpaceToView(_colorView, 20).leftSpaceToView(self.view, 40).heightIs(45.0).widthIs(80);
    
    self.time = [[UILabel alloc]init];
    [self.view addSubview:self.time];
    self.time.font = [UIFont fontWithName:@"DBLCDTempBlack" size:32.0];
    self.time.textColor = [UIColor yellowColor];
    self.time.textAlignment = NSTextAlignmentRight;
    self.time.sd_layout.bottomSpaceToView(_colorView, 20).rightSpaceToView(self.view, 40).heightIs(30).widthIs(150);
    
    
    self.resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.resetBtn];
    [self.resetBtn setTitle:@"RESET" forState:UIControlStateNormal];
    [self.resetBtn setBackgroundColor:[UIColor brownColor]];
    [self.resetBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    self.resetBtn.titleLabel.font = [UIFont fontWithName:@"Georgia-Italic" size:40.0];
    [self.resetBtn addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    self.resetBtn.sd_layout.centerXEqualToView(self.view).topSpaceToView(_colorView, 20).heightIs(50).widthIs(200);
    
    
    self.mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.mainBtn];
    [self.mainBtn setTitle:@"MENU" forState:UIControlStateNormal];
    [self.mainBtn setBackgroundColor:[UIColor brownColor]];
    [self.mainBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    self.mainBtn.titleLabel.font = [UIFont fontWithName:@"Georgia-Italic" size:40.0];
    [self.mainBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.mainBtn.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.resetBtn, 20).heightIs(50).widthIs(200);
    
    self.pasetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.pasetBtn];
    [self.pasetBtn setTitle:@"PAUSE" forState:UIControlStateNormal];
    [self.pasetBtn setBackgroundColor:[UIColor magentaColor]];
    [self.pasetBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    self.pasetBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:30.0];
    self.pasetBtn.selected = YES;
    [self.pasetBtn addTarget:self action:@selector(pause:) forControlEvents:UIControlEventTouchUpInside];
    self.pasetBtn.sd_layout.centerXEqualToView(self.view).bottomSpaceToView(_colorView, 10).heightIs(50).widthIs(140);
    self.pasetBtn.layer.masksToBounds = YES;
    self.pasetBtn.layer.cornerRadius = 8;
    
    
}

- (void)pause:(UIButton *)btn{
    
    if ([_time.text integerValue] <= 0){
        
        btn.userInteractionEnabled = NO;
        [SVProgressHUD showInfoWithStatus:@"Time is up!"];
        
        return;
        
    }
    
    if (btn.selected == YES) {
        btn.selected = NO;
        _colorView.userInteractionEnabled = NO;
    [self.timer setFireDate:[NSDate distantFuture]];
    [self.pasetBtn setTitle:@"PLAY" forState:UIControlStateNormal];

        
    }else{
        btn.selected = YES;
        _colorView.userInteractionEnabled = YES;
        [self.timer setFireDate:[NSDate distantPast]];
        [self.pasetBtn setTitle:@"PAUSE" forState:UIControlStateNormal];

    }
    
    
}


- (void)back:(UIButton *)btn{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - 实现点击逻辑
- (void)setload{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"count"
                                               object:nil];
    
    _colorView.userInteractionEnabled = YES;
    //发送通知，刷新一下集合视图，使其初始为四个单元
    [[NSNotificationCenter defaultCenter] postNotificationName:@"start" object:nil];
    //时间重置60秒
    _time.text = @"60";
    //得分重置0分
    _score.text = @"0";
}

//重置
- (void)start:(UIButton *)sender {

    [self.timer invalidate];
    self.timer = nil;
    //能点击了
    _colorView.userInteractionEnabled = YES;
    //发送通知，刷新一下集合视图，使其初始为四个单元
    [[NSNotificationCenter defaultCenter] postNotificationName:@"start" object:nil];
    sender.tag = 4980;
    //时间重置60秒
    _time.text = @"60";
    //得分重置0分
    _score.text = @"0";
   self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(timerAction:)
                                   userInfo:nil
                                    repeats:YES];
    
}

- (void)timerAction:(NSTimer *)timer {
    
    _time.text = [NSString stringWithFormat:@"%ld", [_time.text integerValue] - 1];
    self.pasetBtn.userInteractionEnabled = YES;
    
    if ([_time.text integerValue] < 0) {
        
       NSMutableArray *array = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"list"];
        NSMutableArray *arr = [NSMutableArray array];

        if (array.count > 0) {
            NSMutableArray *newsearchRecordArray = [NSMutableArray arrayWithArray:array];
            [newsearchRecordArray addObject:self.score.text];
            [[NSUserDefaults standardUserDefaults] setObject:newsearchRecordArray forKey:@"list"];
        }else{
            [arr addObject:self.score.text];
            [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"list"];
        }
        
        //关闭定时器，防止与下一个定时器重复
        [timer invalidate];
        _time.text = @"0";
        UIButton *button = [self.view viewWithTag:4980];
        //恢复按钮可按状态
        button.enabled = YES;
        //不能再点击了
        _colorView.userInteractionEnabled = NO;
        
        NSString *sorce = [NSString stringWithFormat:@"游戏结束,您过了%@关!",self.score.text];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showSuccessWithStatus:sorce];
        
//        [SVProgressHUD showWithStatus:sorce];
//        [SVProgressHUD sho]
        
//        //游戏结束,弹出提示
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"游戏结束"
//                                                                       message:_score.text
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:@"继续游戏"
//                                                   style:UIAlertActionStyleDefault
//                                                 handler:^(UIAlertAction * _Nonnull action) {
//                                                     NSLog(@"继续游戏");
//                                                 }]];
//        [self presentViewController:alert animated:YES completion:nil];
        
    } 
    
}

- (void)receiveNotification:(NSNotification *)notification {
    _score.text = notification.object;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc{
    
    [self.timer invalidate];
    self.timer = nil;
    
}

@end
