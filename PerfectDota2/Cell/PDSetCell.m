//
//  PDSetCell.m
//  PerfectDota2
//
//  Created by 谈Xx on 16/2/23.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "PDSetCell.h"
#import "PDSetLabelItem.h"
#import "PDSetSwitchItem.h"
#import "PDSetArrowItem.h"
@interface PDSetCell()

/**
 *  箭头
 */
@property (strong, nonatomic) UIImageView *rightArrow;
/**
 *  开关
 */
@property (strong, nonatomic) UIButton *rightSwitch;

@end

@implementation PDSetCell

#pragma mark - 懒加载

- (UIImageView *)rightArrow
{
    if (_rightArrow == nil) {
        self.rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_arraw"]];
    }
    return _rightArrow;
}

- (UIButton *)rightSwitch
{
    if (_rightSwitch == nil)
    {
        self.rightSwitch = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rightSwitch setImage:[UIImage imageNamed:@"setting_icon_off"] forState:UIControlStateNormal];
        [self.rightSwitch setImage:[UIImage imageNamed:@"setting_icon_on"] forState:UIControlStateSelected];
        self.rightSwitch.size = [UIImage imageNamed:@"setting_icon_on"].size;
        [self.rightSwitch addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightSwitch;
}

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"common";
    PDSetCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PDSetCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

// 默认设置
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 设置标题的字体
        self.textLabel.font = [UIFont systemFontOfSize:14];
        [self.textLabel setTextColor:RGB(55, 55, 55)];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        
        // 去除cell的默认背景色
        self.backgroundColor = [UIColor clearColor];
        
        // 设置背景view
        self.backgroundView = [[UIImageView alloc] init];
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
//        self.selectedBackgroundView = [[UIImageView alloc] init];
    }
    return self;
}

- (void)setItem:(PDSetItem *)item
{
    _item = item;
    
    // 1.设置基本数据
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.subtitle;
    
    // 2.设置右边的内容
    if (item.isBadge)
    { // 紧急情况：左边有提醒
//        self.bageView.badgeValue = item.badgeValue;
//        self.accessoryView = self.bageView;
    }
    if ([item isKindOfClass:[PDSetArrowItem class]])
    {
        self.accessoryView = self.rightArrow;
    }
    else if ([item isKindOfClass:[PDSetSwitchItem class]])
    {
        PDSetSwitchItem *switchItem = (PDSetSwitchItem *)item;
        self.rightSwitch.selected = switchItem.isSelected;
        self.accessoryView = self.rightSwitch;
    }
//    else if ([item isKindOfClass:[PDSetLabelItem class]])
//    {
////        HMCommonLabelItem *labelItem = (HMCommonLabelItem *)item;
////        // 设置文字
////        self.rightLabel.text = labelItem.text;
////        // 根据文字计算尺寸
////        self.rightLabel.size = [labelItem.text sizeWithFont:self.rightLabel.font];
////        self.accessoryView = self.rightLabel;
//    }
    else
    { // 取消右边的内容
        self.accessoryView = nil;
    }
}

#pragma mark - 调整子控件的位置
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.x = CGRectGetMinX(self.textLabel.frame) + 5;

    if (self.item.isLeftSub)
    {
        self.detailTextLabel.x = CGRectGetMaxX(self.textLabel.frame) + 5;
    }
}

- (void)switchClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
