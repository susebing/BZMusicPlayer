//
//  BZBaseViewController.m
//  BZMusicPlayer
//
//  Created by zhengbing on 2017/1/18.
//  Copyright © 2017年 zhengbing. All rights reserved.
//

#import "BZBaseViewController.h"

@interface BZBaseViewController ()

@end

@implementation BZBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"点击访问：http://www.cnblogs.com/markbin";

    UITapGestureRecognizer *gst = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navagationTap)];
    [self.navigationController.navigationBar addGestureRecognizer:gst];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)navagationTap{
    NSURL *URL = [NSURL URLWithString:@"http://www.cnblogs.com/markbin"];
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [[UIApplication sharedApplication] openURL:URL options:@{}
           completionHandler:^(BOOL success) {
           }];
    } else {
        [[UIApplication sharedApplication] openURL:URL];
    }
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
