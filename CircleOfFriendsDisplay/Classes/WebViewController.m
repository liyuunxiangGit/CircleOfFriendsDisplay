//
//  WebViewController.m
//  CircleOfFriendsDisplay
//
//  Created by liyunxiang on 16/12/6.
//  Copyright © 2016年 李云祥. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = item;
    // Do any additional setup after loading the view.
    CGFloat SCREEWIDTH = self.view.frame.size.width;
    CGFloat SCREEHEIGHT = self.view.frame.size.height;
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEWIDTH, SCREEHEIGHT)];
    webView.backgroundColor = [UIColor cyanColor];
    NSURLRequest* request = [NSURLRequest requestWithURL:self.url];//创建NSURLRequest
    [webView loadRequest:request];//加载
    
    [self.view addSubview:webView];
    
    
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
