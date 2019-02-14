//
//  DashBoardViewController.m
//  PTMusicApp
//
//  Created by Giap Nguyen on 8/26/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "DashBoardViewController.h"
#import "MBProgressHUD.h"
@interface DashBoardViewController ()

@end

@implementation DashBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *user_id = [NSString stringWithFormat:@"%@",[Util objectForKey:USER_ID]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@userid=%@",BASE_URL_MENDY_DASHBOARD,GET_DASHBOARD,user_id]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    // Do any additional setup after loading the view from its nib.
    [self setRevealBtn];
}
-(void)setRevealBtn{
    SWRevealViewController *revealController = self.revealViewController;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [_revealBtn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
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

//- (IBAction)onBack:(UIButton *)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}
- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    CGSize contentSize = theWebView.scrollView.contentSize;
    CGSize viewSize = self.view.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    theWebView.scrollView.minimumZoomScale = rw;
    theWebView.scrollView.maximumZoomScale = rw;
    theWebView.scrollView.zoomScale = rw;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    if([self.webView canGoBack]){
        [self.backBtn setAlpha:0.65];
    } else {
        [self.backBtn setAlpha:0.1];
    }
    if([self.webView canGoForward]){
        [self.forwardBtn setAlpha:0.65];
    } else {
        [self.forwardBtn setAlpha:0.1];
    }
}


- (IBAction)onBackTouch:(id)sender {
    [self.webView goBack];
}

- (IBAction)onForwardTouch:(id)sender {
    [self.webView goForward];
    
}
@end
