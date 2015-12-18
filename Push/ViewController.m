//
//  ViewController.m
//  Push
//
//  Created by bruce on 15/12/14.
//  Copyright © 2015年 KY. All rights reserved.
//

#import "ViewController.h"
#import "KYPushManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)localNotification:(id)sender {
    
    [[KYPushManager shareInstance] localNotificationOne];
}

@end
