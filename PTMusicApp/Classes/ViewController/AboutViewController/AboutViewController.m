//
//  AboutViewController.m
//  PTMusicApp
//
//  Created by hieu nguyen on 12/6/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import "AboutViewController.h"
#import "SWRevealViewController.h"
#import "PlaySongViewController.h"
#import "MBProgressHUD.h"

@interface AboutViewController ()<MP3PlayerDelegate>

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    NSString *user_id = [NSString stringWithFormat:@"%@",[Util objectForKey:USER_ID]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?userid=%@",BASE_URL_MEDY, user_id]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self setRevealBtn];
    
    [self.view addSubview: gMP3Player.view];
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

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    CGSize contentSize = theWebView.scrollView.contentSize;
    CGSize viewSize = self.view.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    theWebView.scrollView.minimumZoomScale = rw;
    theWebView.scrollView.maximumZoomScale = rw;
    theWebView.scrollView.zoomScale = rw;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:( NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


@end
