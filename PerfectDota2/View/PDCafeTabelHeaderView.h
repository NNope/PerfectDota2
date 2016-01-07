//
//  PDCafeTabelHeaderView.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/28.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDCafeConditionButton.h"

typedef enum {
    PDCafeTabelHeaderBtnArea,           // 区域选择
    PDCafeTabelHeaderBtnDistance,       // 距离
    PDCafeTabelHeaderBtnScale,          // 规模
    
}PDCafeTabelHeaderBtnType;

typedef void(^clickHandle)(PDCafeTabelHeaderBtnType btnType);

@interface PDCafeTabelHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *BtnArea;
@property (weak, nonatomic) IBOutlet PDCafeConditionButton *BtnDistance;
@property (weak, nonatomic) IBOutlet PDCafeConditionButton *BtnScale;
@property (nonatomic, copy)  clickHandle clickhandle;

- (void)setPDCafeTabelHeaderViewClickBlock:(clickHandle)clickhandle;

- (IBAction)areaClick:(id)sender;
- (IBAction)distanceClick:(id)sender;
- (IBAction)scaleClick:(id)sender;

@end
