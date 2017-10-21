//
//  RankingListCell.m
//  色差游戏
//
//  Created by 尚勇杰 on 2017/10/11.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "RankingListCell.h"
#import <SDAutoLayout/SDAutoLayout.h>

@implementation RankingListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.rankingText = [[UILabel alloc]init];
        [self.contentView addSubview:self.rankingText];
        self.rankingText.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:26];
        self.rankingText.textColor = [UIColor purpleColor];
        self.rankingText.textAlignment = NSTextAlignmentLeft;
    self.rankingText.sd_layout.centerYEqualToView(self.contentView).heightIs(40).widthIs(150).leftSpaceToView(self.contentView, 15);
        
        self.numText = [[UILabel alloc]init];
        [self.contentView addSubview:self.numText];
        self.numText.font = [UIFont fontWithName:@"Georgia-Italic" size:30];
        self.numText.textColor = [UIColor cyanColor];
        self.numText.textAlignment = NSTextAlignmentRight;
    self.numText.sd_layout.centerYEqualToView(self.contentView).heightIs(40).leftSpaceToView(self.rankingText,20).rightSpaceToView(self.contentView, 15);
        
        UIView *line = [[UIView alloc]init];
        [self.contentView addSubview:line];
        line.backgroundColor = [UIColor lightGrayColor];
        line.sd_layout.leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView, 10).bottomSpaceToView(self.contentView, 0.5).heightIs(0.5);
        
    }
    
    return self;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
