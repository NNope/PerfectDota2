//
//  PDHistoryCityCell.m
//  PerfectDota2
//
//  Created by 谈Xx on 16/1/6.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "PDHistoryCityCell.h"
#import "PDLocationTool.h"

@implementation PDHistoryCityCell

- (void)awakeFromNib {
    // Initialization code

}

//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
//    {
//        self.separatorInset = UIEdgeInsetsZero;
//    }
//    return self;
//    
//}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.historyCitys = [[PDLocationTool shareTocationTool] readHistoryCity];
    for (int i = 0; i < self.historyCitys.count; i++)
    {
        PDHistoryCityButton *city = (PDHistoryCityButton *)self.contentView.subviews[i+1];
        [city setTitle:self.historyCitys[i] forState:UIControlStateNormal];
        city.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btn1Click:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(pdHistoryCityButtonDidClick:)])
    {
        [self.delegate pdHistoryCityButtonDidClick:sender];
    }
}

- (IBAction)btn2Click:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(pdHistoryCityButtonDidClick:)])
    {
        [self.delegate pdHistoryCityButtonDidClick:sender];
    }
}


- (IBAction)btn3Click:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(pdHistoryCityButtonDidClick:)])
    {
        [self.delegate pdHistoryCityButtonDidClick:sender];
    }
}
@end
