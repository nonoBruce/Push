//
//  ViewController.m
//  Push
//
//  Created by bruce on 15/12/14.
//  Copyright © 2015年 KY. All rights reserved.
//

#import "ViewController.h"
#import "KYPushManager.h"
#import "NoticeViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *noticeButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化通知按钮，判断有没有推送
    [self noticeButtonImage];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeButtonImage) name:KYHASNOTIFICATION object:nil];//注册按钮通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushViewController) name:KYPUSHNOTIFICATION object:nil];//注册按钮通知
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //
    [self noticeButtonImage];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (IBAction)localNotification:(id)sender {
    
    [[KYPushManager shareInstance] localNotificationOne];
}

#pragma mark - 推送按钮
- (void)pushViewController{
    NoticeViewController *noticeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NoticeViewController"];
    [self.navigationController pushViewController:noticeViewController animated:YES];
    [[KYPushManager shareInstance] isRead];
    
}
- (void)noticeButtonImage {
    UIImage *image = nil;
    if([ KYPushManager shareInstance].hasNotice){
        image = [UIImage imageNamed:@"has-message-icon-gray"];
    }else{
        image = [UIImage imageNamed:@"message-icon-gray"];
    }
    [self.noticeButton setImage:image forState:UIControlStateNormal];
}

- (IBAction)noticeView:(UIButton *)btn {
    [[KYPushManager shareInstance] isRead];
    //初始化通知按钮，判断有没有推送
    [self noticeButtonImage];
}

@end
