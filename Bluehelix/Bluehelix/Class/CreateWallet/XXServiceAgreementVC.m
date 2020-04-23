//
//  XXServiceAgreementVC.m
//  Bluehelix
//
//  Created by Bhex on 2020/03/21.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXServiceAgreementVC.h"
#import "XXServiceContentView.h"

@interface XXServiceAgreementVC ()

@end

@implementation XXServiceAgreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)buildUI {
    self.titleLabel.text = LocalizedString(@"ServiceAgreement");
    self.navView.hidden = YES;
    XXServiceContentView *contentView = [[XXServiceContentView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:contentView];
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
