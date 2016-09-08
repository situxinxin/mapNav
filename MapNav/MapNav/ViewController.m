//
//  ViewController.m
//  MapNav
//
//  Created by 新新 on 16/9/8.
//  Copyright © 2016年 司徒新新. All rights reserved.
//

#import "ViewController.h"

#import "NavChooseView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(100, 100, 100, 100);
    
    btn.backgroundColor = [UIColor blueColor];
    
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
}


- (void)btnAction
{
    [[NavChooseView getChooseNavView] startLat:@"112.12" lng:@"12" detailedAddress:@"" shopName:@"国贸SOHO东"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
