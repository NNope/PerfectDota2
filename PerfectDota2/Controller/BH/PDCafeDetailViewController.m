//
//  PDCafeDetailViewController.m
//  PerfectDota2
//
//  Created by 谈Xx on 16/1/20.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "PDCafeDetailViewController.h"
#import "PDCafeModel.h"
#import "PDCafeMapViewController.h"

@interface PDCafeDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *lblCafeName;
@property (weak, nonatomic) IBOutlet UIButton *btnCafePhone;
@property (weak, nonatomic) IBOutlet UILabel *lblMachineCount;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblAddressDetail;
@property (weak, nonatomic) IBOutlet UIButton *btnToMap;
@property (weak, nonatomic) IBOutlet UIImageView *imgCafeInner;
@property (weak, nonatomic) IBOutlet UIButton *btnToMap2;

@end

@implementation PDCafeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.titleType = PDTitleTypeInfoAndShare;
    self.titleView.title = @"网吧详情";
    self.view.size = [UIScreen mainScreen].bounds.size;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setCafeDetail];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
}

- (void)setCafeDetail
{
    
    self.lblCafeName.text = _cafeModel.cafe_name;
    [self.btnCafePhone setTitle:_cafeModel.phone forState:UIControlStateNormal];
    self.lblMachineCount.text = _cafeModel.machine_count;
    self.lblDistance.text = [NSString stringWithFormat:@"%.2f",_cafeModel.distance];
    self.lblAddressDetail.text = _cafeModel.address_detail;
    [self.imgCafeInner sd_setImageWithURL:[NSURL URLWithString:_cafeModel.cafe_inner_img_small] placeholderImage:nil];
    
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = CGRectZero;
    [self.view addSubview:webView];// 有strong就不用addsubview
    self.webView = webView;
}


- (IBAction)btnPhoneClick:(id)sender
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_cafeModel.phone]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (IBAction)btnToMap:(id)sender
{
    PDCafeMapViewController *mapVc = [[PDCafeMapViewController alloc] init];
    mapVc.cafeModel = self.cafeModel;
    [self.navigationController pushViewController:mapVc animated:YES];
}
@end
