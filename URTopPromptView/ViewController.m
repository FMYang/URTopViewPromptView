//
//  ViewController.m
//  URTopPromptView
//
//  Created by 杨方明 on 15/10/26.
//  Copyright (c) 2015年 云润大数据. All rights reserved.
//

#import "ViewController.h"
#import "URTopPromptView.h"
#import "TestVC.h"

@interface ViewController ()
{
    BOOL isShow;
}
@end

@implementation ViewController

- (instancetype)init
{
    if(self = [super init])
    {
        isShow = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"ViewController";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 40);
    [btn setTitle:@"Show View" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(100, 160, 100, 40);
    [btn1 setTitle:@"push" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
}

- (void)btn1Click
{
    TestVC *testVC = [[TestVC alloc]init];
    [self.navigationController pushViewController:testVC animated:YES];
}

- (void)btnClick
{
//    if(isShow)
//    {
//        [self dismissPromptView];
//    }
//    else
//    {
//        [URTopPromptView showTopPromptViewText:@"为您推荐10条新闻"];
//    }
//    
//    isShow = !isShow;
//    
    [URTopPromptView showTopPromptViewText:@"为您推荐10条新闻"
                             dissmissAfter:10.5
                                      view:self.view];

}

- (void)dismissPromptView
{
    [URTopPromptView dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
