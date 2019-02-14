//
//  ForumViewController.m
//  PTMusicApp
//
//  Created by Pro on 1/11/16.
//  Copyright © 2016 Fruity Solution. All rights reserved.
//

#import "ForumViewController.h"
#import "MBProgressHUD.h"

@interface ForumViewController ()

@end

@implementation ForumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *user_id = [NSString stringWithFormat:@"%@",[Util objectForKey:USER_ID]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?userID=%@",BASE_URL_MENDY_FORUM, user_id]];
    NSString *param = [[NSUserDefaults standardUserDefaults] stringForKey:@"params"];
    NSLog(@"%@?userID=%@",BASE_URL_MENDY_FORUM, user_id);
    if(param == nil || [param isEqual:@""]){
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    } else {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.myjli.com%@&userID=%@",[param substringFromIndex:4],user_id]];
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    
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

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    CGSize contentSize = theWebView.scrollView.contentSize;
    CGSize viewSize = self.view.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    theWebView.scrollView.minimumZoomScale = rw;
    theWebView.scrollView.maximumZoomScale = rw;
    theWebView.scrollView.zoomScale = rw;
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
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (IBAction)onBackTouch:(id)sender {
    [self.webView goBack];
}

- (IBAction)onForwardTouch:(id)sender {
    [self.webView goForward];
    
}

- (IBAction)onHomeTouch:(id)sender {
    NSString *user_id = [NSString stringWithFormat:@"%@",[Util objectForKey:USER_ID]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?userID=%@",BASE_URL_MENDY_FORUM, user_id]];
    NSString *param = [[NSUserDefaults standardUserDefaults] stringForKey:@"params"];
    NSLog(@"%@?userID=%@",BASE_URL_MENDY_FORUM, user_id);
    if(param == nil || [param isEqual:@""]){
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    } else {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.myjli.com%@&userID=%@",[param substringFromIndex:4],user_id]];
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }

}
@end
