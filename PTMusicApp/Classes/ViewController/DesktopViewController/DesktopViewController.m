//
//  AboutViewController.m
//  PTMusicApp
//
//  Created by hieu nguyen on 12/6/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import "DesktopViewController.h"
#import "SWRevealViewController.h"
#import "PlaySongViewController.h"
#import "MBProgressHUD.h"

@interface DesktopViewController ()<MP3PlayerDelegate>

@end

@implementation DesktopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    NSString *user_id = [NSString stringWithFormat:@"%@",[Util objectForKey:USER_ID]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?userid=%@&v=%@",BASE_URL_MEDY_DESKTOP, user_id,version]];
//    NSURL *url = [NSURL URLWithString:@"http://interbuild.co/test/test.php"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    [self setRevealBtn];
    
    //[self.view addSubview: gMP3Player.view];
    self.webView.frame = CGRectMake(0, 67, self.webView.frame.size.width, self.view.frame.size.height -67);
    [NSHTTPCookieStorage sharedHTTPCookieStorage].cookieAcceptPolicy = NSHTTPCookieAcceptPolicyAlways;
    
    gMP3Player.delegate = self;
}

-(void)NextDetailWithSongArr:(NSMutableArray *)songarr andInde:(int)index{
    PlaySongViewController *play = [[PlaySongViewController alloc]initWithNibName:@"PlaySongViewController" bundle:nil];
    play.songArr = songarr;
    play.index = index;
    play.pauseOnLoad = ![Util isMusicPlaying];
    [self.navigationController pushViewController:play animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setRevealBtn{
    SWRevealViewController *revealController = self.revealViewController;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [_revealBtn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSURL *requestURL =request.URL;

    NSString *javaScript = [NSString stringWithFormat:@"(function() { arrs = document.getElementsByTagName('a'); for(i = 0; i < arrs.length; i++){if(arrs[i].href == '%@') return arrs[i].className; } return ''; })();", request.URL, nil];
    
    // Make the UIWebView method call
    NSString *response = [self.webView stringByEvaluatingJavaScriptFromString:javaScript];
    
    if ( [response containsString:@"external-link"] ) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return false;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    CGSize contentSize = theWebView.scrollView.contentSize;
    CGSize viewSize = self.view.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    theWebView.scrollView.minimumZoomScale = 1;
    theWebView.scrollView.maximumZoomScale = 5;
    //theWebView.scrollView.zoomScale = rw;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if([self.webView canGoBack])
        [self.backBtn setAlpha:0.65];
    else
        [self.backBtn setAlpha:0.1];
    
    if([self.webView canGoForward])
        [self.fwdBtn setAlpha:0.65];
    else
        [self.fwdBtn setAlpha:0.1];
        
    if([self.webView canGoBack])
        self.webView.frame = CGRectMake(0, 111, self.webView.frame.size.width, self.view.frame.size.height -111);
    else
        self.webView.frame = CGRectMake(0, 67, self.webView.frame.size.width, self.view.frame.size.height -67);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}


- (IBAction)homeBtnTap:(id)sender {
    NSString *user_id = [NSString stringWithFormat:@"%@",[Util objectForKey:USER_ID]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?userid=%@&v=2",BASE_URL_MEDY_DESKTOP, user_id]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}
- (IBAction)backBtnTouch:(id)sender {
    [self.webView goBack];
}

- (IBAction)fwdBtnTouch:(id)sender {
    [self.webView goForward];
    
}
@end
