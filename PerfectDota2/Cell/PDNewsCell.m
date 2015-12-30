//
//  PDNewsCell.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/10.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDNewsCell.h"

@implementation PDNewsCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setPdNewsModel:(PDNewsModel *)pdNewsModel{
    _pdNewsModel = pdNewsModel;

    // 图片
    [self.picView sd_setImageWithURL:[NSURL URLWithString:pdNewsModel.pic] placeholderImage:[UIImage imageNamed:@"img_default"]];
    // title
    self.titleLabel.text = pdNewsModel.title;
    // desc
    self.descLabel.text = pdNewsModel.desc;
    // type
    self.typeLabel.text = pdNewsModel.type;
    // date 2015-12-10
    NSString *lbldate = [pdNewsModel.date substringFromIndex:[pdNewsModel.date rangeOfString:@"-"].location+1];
    self.dateLabel.text = lbldate;
}

-(void)layoutSubviews
{
    // 修改日期的约束
    if (!self.pdNewsModel.type)
    {
        self.typeBG.hidden = YES;
        for(NSLayoutConstraint * constraint in self.BGView.constraints){
            if ([constraint.identifier isEqualToString:@"leadingView"])
            {
                constraint.priority =750;
                
            }
            if ([constraint.identifier isEqualToString:@"leadingBG"])
            {
                constraint.priority =250;
                
            }
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
