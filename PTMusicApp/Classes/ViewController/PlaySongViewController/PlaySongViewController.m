//
//  PlaySongViewController.m
//  PTMusicApp
//
//  Created by hieu nguyen on 12/20/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import "PlaySongViewController.h"
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "MP3Player.h"
#import "DatabaseManager.h"
#import "TopSongCell.h"
#import "REPagedScrollView.h"
#import "UIImageView+WebCache.h"
#import "ModelManager.h"
#import "Validator.h"
#import "ShowPlayListViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "Util.h"
#import "UIView+Toast.h"
#import "intercom.h"

@interface PlaySongViewController ()<ShowPlayListViewControllerDelegate>{
    NSTimer *timer;
}

@end

@implementation PlaySongViewController


- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    NSLog(@"received event!");
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause: {

                NSLog(@"interruption received: sxdf");
                break;
            }
            case UIEventSubtypeRemoteControlPlay: {
                NSLog(@"interruption received: sxdf");
                break;
            }
            case UIEventSubtypeRemoteControlPause: {
                NSLog(@"interruption received: sxdf");
                break;
            }
            default:
                break;
        }
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
     self.seconds = 15.0;
    //setTitle for buttton
    
    [self.nextSecondsBtn setTitle:[NSString stringWithFormat:@"+%.1f",self.seconds] forState:UIControlStateNormal];
    
    [self.previousSecondsBtn setTitle:[NSString stringWithFormat:@"-%.1f",self.seconds] forState:UIControlStateNormal];
   // [self.previousBtn setBackgroundImage:[UIImage imageNamed:@"1b.png"] forState:UIControlStateNormal];
    
    [self fixMultiScreenSize];
    
   
    
    CGRect rect = self.pageView.frame;
    rect.size.width = SCREEN_WIDTH_PORTRAIT;
    REPagedScrollView *scrollView = [[REPagedScrollView alloc] initWithFrame:rect];
    
    scrollView.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    scrollView.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:scrollView];
    
    [self.tblView setBackgroundColor:[UIColor clearColor]];
    self.tblView.separatorColor = [UIColor clearColor];
    //[self.view2 setBackgroundColor:[UIColor redColor]];
    [scrollView addPage:self.view2];
    
    [scrollView addPage:self.view1];
    [scrollView scrollToPageWithIndex:1 animated:NO];
    //[scrollView setBackgroundColor:[UIColor redColor]];
    //[self.pageView setBackgroundColor:[UIColor greenColor]];
    
    self.song = [self.songArr objectAtIndex:self.index];
    self.downloadLbl.text = self.song.downloadNum;
    self.viewLbl.text = self.song.viewNum;
    [self setRepeatBtn];
    //[self setShuffleBtn];
    if (!self.pauseOnLoad)
         [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(play) userInfo:nil repeats:NO];
//        [self play];
    else
    {
         [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(play) userInfo:nil repeats:NO];
//        [self fillSongInfo];// re-fill info when on pause
    }
    self.songNameLbl.textAlignment = NSTextAlignmentCenter;
    self.songNameLbl.font =[UIFont systemFontOfSize:16];
    self.songNameLbl.textColor = [UIColor whiteColor];
    self.artistNameLbl.textAlignment = NSTextAlignmentCenter;
    self.artistNameLbl.font = [UIFont systemFontOfSize:12];
    self.artistNameLbl.textColor = [UIColor whiteColor];
    gPlayerController = self;
    
    [self.view bringSubviewToFront:self.footerView];
    
    //[self.footerView bringSubviewToFront:_slider];
    //[self.footerView bringSubviewToFront:self.speedView];
    [self.footerView bringSubviewToFront:_speedSlider];
    // Do any additional setup after loading the view from its nib.
    
}
-(void)viewWillAppear:(BOOL)animated{
    footerBanner.view.backgroundColor = [UIColor redColor];
    int footerHeightView = 50;
    footerBanner.view.frame = CGRectMake(0,self.footerView.frame.size.height - footerHeightView + 20, SCREEN_WIDTH_PORTRAIT, footerHeightView);
    [self.footerView addSubview:footerBanner.view];
    [self.footerView bringSubviewToFront:footerBanner.view];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    //[self.footerView setHidden:TRUE];
}

#pragma mark - audio session management
- (BOOL) canBecomeFirstResponder {
    return YES;
}

-(void) fixMultiScreenSize{
    int footerHeightView = 150;
    int heightOfPagingCircle = 36;
    
    
    self.pageView.frame=CGRectMake(self.pageView.frame.origin.x, self.pageView.frame.origin.y, SCREEN_WIDTH_PORTRAIT, screen_height-self.pageView.frame.origin.y-footerHeightView-linkHeight + 30);
    
    
    self.footerView.frame = CGRectMake(0,screen_height-footerHeightView-linkHeight + 30, SCREEN_WIDTH_PORTRAIT, footerHeightView); // the player always is bottom
    self.footerView.backgroundColor = [UIColor clearColor];
    
    
    self.view2.frame =CGRectMake(self.view2.frame.origin.x, self.view2.frame.origin.y, SCREEN_WIDTH_PORTRAIT, self.pageView.frame.size.height-heightOfPagingCircle);
    
    
    self.tblView.frame = CGRectMake(self.view2.frame.origin.x, self.view2.frame.origin.y + heightOfPagingCircle, SCREEN_WIDTH_PORTRAIT, self.view2.frame.size.height-heightOfPagingCircle);
    
    
    _view1.frame =_view2.frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    gMP3Player.index = self.index;
    gMP3Player.song = self.song;
    gMP3Player.songArr = self.songArr;
    [[DatabaseManager defaultDatabaseManager]deletePlaylistwithName:CURRENT_PLAYLIST];
    for (Song *s in gMP3Player.songArr) {
        [[DatabaseManager defaultDatabaseManager]insertSong:s andPlaylist:CURRENT_PLAYLIST];
        
    }
    [Util setObject:gMP3Player.song.songId forKey:CURRENT_SONG_ID_KEY];
    gMP3Player.nameLbl.text = self.song.name;
    gMP3Player.artistLbl.text = self.song.singerName;
    gMP3Player.view.hidden = NO;
    
}

-(void)playInThread{
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(play) object:nil];
    [thread start];
}

-(void)play{
    
    [MBProgressHUD showHUDAddedTo: self.view animated:YES];
    if ([self.song.songId isEqualToString: currentAudio]) {
        float currentTimeInSecond = CMTimeGetSeconds([_audioPlayer currentTime]);
        [self.slider setValue:currentTimeInSecond/audioDurationInSecond];
        [self fillSongInfo];
        
        self.playBtn.selected = NO;
        [self onPlay:nil];
    }
    else{
        //
        
        currentAudio = self.song.songId;
        [self.slider setValue:0.0f];
        NSString *authorID = self.song.singerName;
        NSString *categoryID = self.song.categoryId;
        NSString *titleID = self.song.name;
        [Intercom logEventWithName:@"listened to app audio" metaData: @{
                                                                 @"category": categoryID,
                                                                 @"title": titleID,
                                                                 @"author": authorID
                                                                 }];
        
        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
       
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[self.song.link lastPathComponent]];
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        
        
        
        if (fileExists) {
            NSURL *url = [[NSURL alloc] initFileURLWithPath: filePath];
            AVAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
            CMTime audioDuration = asset.duration;
            
            audioDurationInSecond = CMTimeGetSeconds(audioDuration);
            NSLog(@"Duration :%f",audioDurationInSecond);
            [self fillSongInfo];
            AVPlayerItem *anItem = [AVPlayerItem playerItemWithAsset:asset];
            _audioPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;

            
            _audioPlayer = [AVPlayer playerWithPlayerItem:anItem];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(playerItemDidReachEnd:)
                                                         name:AVPlayerItemDidPlayToEndTimeNotification
                                                       object:[_audioPlayer currentItem]];

            
                }else
                   
                    
                    
                {
                    
        
        AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:self.song.link] options:nil];
        
        CMTime audioDuration = audioAsset.duration;
        
        audioDurationInSecond = CMTimeGetSeconds(audioDuration);
        NSLog(@"Duration :%f",audioDurationInSecond);
        [self fillSongInfo];
        
        NSURL *urlAudio = [NSURL URLWithString:self.song.link];
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:urlAudio];
        
        _audioPlayer = [[AVPlayer alloc]initWithPlayerItem:item];
        _audioPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[_audioPlayer currentItem]];

        if([NSString stringWithFormat:@"%@",[Util objectForKey:[NSString stringWithFormat:@"%@_localFile",self.song.songId]]])
        {
            self.song.localMP3 = [NSString stringWithFormat:@"%@",[Util objectForKey:[NSString stringWithFormat:@"%@_localFile",self.song.songId]]];
            urlAudio = [NSURL fileURLWithPath:self.song.localMP3];
            
            
        }
        
        NSError *error;
        
        if (error)
        {
            NSLog(@"Error in audioPlayer: %@",
                  [error localizedDescription]);

        } else {
           
        }
                }
        self.playBtn.selected = NO;
        [self onPlay:nil];
      
    }
    [Util setObject:self.song.songId forKey:CURRENT_SONG_ID_KEY];
}

-(void) fillSongInfo{
    self.titleLbl.text = self.song.name;
    self.songNameLbl.text = self.song.name;
    self.artistNameLbl.text = self.song.singerName;
    if (self.song.downloadNum.length == 0) {
        self.song.downloadNum = @"0";
    }
    if (self.song.viewNum.length == 0) {
        self.song.viewNum = @"0";
    }
    self.downloadLbl.text = self.song.downloadNum;
    self.viewLbl.text = self.song.viewNum;
    gMP3Player.nameLbl.text = self.song.name;
    gMP3Player.artistLbl.text = self.song.singerName;
    float currentTimeInSecond = CMTimeGetSeconds([_audioPlayer currentTime]);
    self.currentTimeLbl.text = [Util durationToString:currentTimeInSecond];
    self.totalTimeLbl.text = [Util durationToString:audioDurationInSecond];
    float percenSlider = currentTimeInSecond/audioDurationInSecond;
    _slider.value = percenSlider;
    [self.imgView setImageWithURL:[NSURL URLWithString:self.song.image] placeholderImage:[UIImage imageNamed:@"icon_bg.png"]];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"btn_play.png"] forState:UIControlStateNormal];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    //    AVPlayerItem *p = [notification object];
    //    [p seekToTime:kCMTimeZero];
}

-(void)OnAddSong:(NSString *)name{
    
    [[DatabaseManager defaultDatabaseManager]insertSong:self.song ToPlaylist:name];
    NSString * err = [NSString stringWithFormat:@"%@",[Util objectForKey:@"errorsql"]];
    if (err.length>0) {
        [Util showMessage:@"Already in the playlist" withTitle:APP_NAME];
    }else{
        [Util showMessage:@"Add PlayList Success" withTitle:APP_NAME];
    }
    [self onCancel];
}

-(void)onCancel{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

-(void)updateSilder
{
    
//    if(_audioPlayer.rate != _playbackRate)
//        _audioPlayer.rate = _playbackRate;
    float currentTimeInSecond = CMTimeGetSeconds([_audioPlayer currentTime]);
    
    if (currentTimeInSecond<0) {
        currentTimeInSecond = 0;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
//    <bug3> add
    if (currentTimeInSecond>0) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
//    </bug3>
    float percenSlider = currentTimeInSecond/audioDurationInSecond;
    // at the end of the song
    
    if (currentTimeInSecond>=audioDurationInSecond && currentTimeInSecond > 0) {
       
        // increase number of views to server
        [_audioPlayer pause]; // the song is over
        self.slider.value = 0;
        
        if (_isShuffer) { // random
            self.index =arc4random_uniform((int)self.songArr.count);
            self.song = [self.songArr objectAtIndex:self.index];
            [self.tblView reloadData];
            //<bug5> add
            gMP3Player.index = self.index;
            //</bug5>

            [self play];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        }
        else{ // repeat

            self.index ++;

            if(self.index >= self.songArr.count){
                self.index = 0;
            }
            
            self.song = [self.songArr objectAtIndex:self.index];
            self.titleLbl.text = self.song.name;
            self.songNameLbl.text = self.song.name;
            self.artistNameLbl.text = self.song.singerName;
//          <bug1> add
            currentAudio = @"";
//          </bug1>
            [self.tblView reloadData];
            //<bug5> add
            gMP3Player.index = self.index;
            //</bug5>
            [self play];
            if(!_isRepeat){

                _isPlaying = _playBtn.selected;
                _playBtn.selected = !_playBtn.selected;
                [_audioPlayer pause];
                [self.playBtn setBackgroundImage:[UIImage imageNamed:@"btn_play.png"] forState:UIControlStateNormal];
                [gMP3Player.pauseBtn setBackgroundImage:[UIImage imageNamed:@"btn_play.png"] forState:UIControlStateNormal];
                [_updateTimer invalidate];
                _updateTimer = nil;

            }
        }
       
        [ModelManager updateSong:self.song.songId path:@"songView?" WithSuccess:^(NSDictionary *dic){
             //<bug6>add
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            //</bug6>
            NSArray *songDic = dic[@"data"];
            
            for (NSDictionary *dic in songDic) {
                self.downloadLbl.text = [Validator getSafeString:dic[@"download"]];
                self.viewLbl.text = [Validator getSafeString:dic[@"listen"]];
            }
            
            
        } failure:^(NSString *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
     //<bug6>add
    else {

        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         //<bug6>add
    }
    self.currentTimeLbl.text = [Util durationToString:currentTimeInSecond];
    _slider.value = percenSlider;
    //    NSLog(@"update %.2f",percenSlider);
    
    
}

- (void) hightLightSongAtIndex:(int) index{
//    <bug2> remove
//    //NSLog(@"hightLight: %d", index);
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//    [self.tblView selectRowAtIndexPath:indexPath
//                              animated:YES
//                        scrollPosition:UITableViewScrollPositionMiddle];
//    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(reloadTableview) object:nil];
//    [thread start];
//    </bug2>
}

-(float)getCurrentProgress {
    
    CMTime duration = _audioPlayer.currentItem.asset.duration;
    float seconds = CMTimeGetSeconds(duration);
    
    float currentTime = CMTimeGetSeconds([_audioPlayer currentTime]);
    
    return currentTime/seconds;
}

- (IBAction)onAddPlayList:(id)sender {
    ShowPlayListViewController *create = [[ShowPlayListViewController alloc]initWithNibName:@"ShowPlayListViewController" bundle:nil];
    create.delegate = self;
    [self presentPopupViewController:create animationType:MJPopupViewAnimationFade];
}

- (IBAction)onDownload:(id)sender {
    
    if (self.song.localMP3 != @"(null)" && self.song.localMP3.length > 0) {
        [Util showMessage:@"You have downloaded this audio." withTitle:APP_NAME];
    }
    else{
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.mode = MBProgressHUDModeAnnularDeterminate;
        HUD.labelText = @"Downloading";
        NSURL* url = [NSURL URLWithString:self.song.link];
        __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        __weak ASIHTTPRequest *request_ = request;
        [request setDownloadProgressDelegate:self];
        [request setCompletionBlock:^{
            NSData* data = [request_ responseData];
            if ( data.length/1024.0f/1024.0f > 1)
            {
                [[DatabaseManager defaultDatabaseManager] insertDownloadSong:self.song];
                NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString  *documentsDirectory = [paths objectAtIndex:0];
                
                NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[self.song.link lastPathComponent]];
                [data writeToFile:filePath atomically:YES];
                [Util setObject:filePath forKey:[NSString stringWithFormat:@"%@_localFile",self.song.songId]];
                self.song.localMP3 = filePath;
                HUD.mode = MBProgressHUDModeCustomView;
                
                HUD.labelText = @"Download successfully!";
                
                
                
                
                [ModelManager updateSong:self.song.songId path:DOWNLOAD_SONG WithSuccess:^(NSDictionary *dic) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                    NSDictionary *songDic = dic[@"data"];
//                    self.downloadLbl.text = [Validator getSafeString:songDic[@"download"]];
                } failure:^(NSString *err) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [self.view makeToast:err duration:3.0 position:CSToastPositionCenter];
                }];
                
                
                
            }
        }];
        [request setFailedBlock:^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSLog(@"error");
            HUD.labelText = @"Download error";
            [HUD hide:YES afterDelay:1.0];
            
        }];
        [request startAsynchronous];
    }
    
    
    
}
- (IBAction)onSlider:(id)sender {
    float value = _slider.value;

    self.currentTimeLbl.text = [Util durationToString:value*audioDurationInSecond];
    if(_audioPlayer)
    {
        CMTime newTime = CMTimeMakeWithSeconds(value*audioDurationInSecond,1);
        [_updateTimer invalidate];
        [_audioPlayer seekToTime:newTime completionHandler:^(BOOL finished) {
            if(finished)
            {
                _updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSilder) userInfo:nil repeats:YES];
                [_audioPlayer play];
            }
        }];
    }
}
- (IBAction)onSpeedPlus:(id)sender {
    if(_speedSlider.value < 2)
        _speedSlider.value += 0.1;
    _playbackRate = _speedSlider.value;
    _audioPlayer.rate = _playbackRate;
    [self changeSpeed];
    
}

- (IBAction)onSpeedMinus:(id)sender {
    if(_speedSlider.value > 0.5)
        _speedSlider.value -= 0.1;
    _playbackRate = _speedSlider.value;
    _audioPlayer.rate = _playbackRate;
    [self changeSpeed];
}

- (IBAction)onSpeedNormal:(id)sender {
    _speedSlider.value = 1.0;
    _playbackRate = _speedSlider.value;
    _audioPlayer.rate = _playbackRate;
    self.speedLabel.text = @"1.0x";
    [self.speedBtn setTitle:@"1.0x" forState:UIControlStateNormal];
}
- (IBAction)onSpeedSlider:(id)sender {
    _playbackRate = _speedSlider.value;
    _audioPlayer.rate = _playbackRate;
    [self changeSpeed];
    
}

- (void) changeSpeed{
    NSNumber *numberLots = [NSNumber numberWithDouble:_playbackRate];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.roundingIncrement = [NSNumber numberWithDouble:0.1];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    self.speedLabel.text = [NSString stringWithFormat:@"%@x", [formatter stringFromNumber:numberLots]];
    [self.speedBtn setTitle:[NSString stringWithFormat:@"%@x", [formatter stringFromNumber:numberLots]] forState:UIControlStateNormal];
    
    
    _playBtn.selected = true;
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"btn_pause.png"] forState:UIControlStateNormal];
    
    [_updateTimer invalidate];
    _updateTimer = nil;
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSilder) userInfo:nil repeats:YES];
}

- (IBAction)onSpeedChange:(id)sender {
//    _isShuffer = !_isShuffer;
//    [self setShuffleBtn];
    if(self.speedView.hidden){
        self.speedView.hidden = false;
        self.slider.hidden = true;
        //[self.speedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    else{
        self.speedView.hidden = true;
        self.slider.hidden = false;
        //[self.speedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
}

- (IBAction)onPrevious:(id)sender {
    
    if (_isShuffer) {
        self.index =arc4random_uniform((int)self.songArr.count);
    }
    else{
        //if (!_isRepeat)
            self.index --;
    }
    if (self.index<0) {
        self.index = (int)self.songArr.count -1;
    }
    self.song = [self.songArr objectAtIndex:self.index];
    self.downloadLbl.text = self.song.downloadNum;
    self.viewLbl.text = self.song.viewNum;
    gMP3Player.song = self.song;
    [Util setObject:gMP3Player.song.songId forKey:CURRENT_SONG_ID_KEY];
    // hightlight the current song on list
    [self.tblView reloadData];
    [self playInThread];
}

- (IBAction)onNext:(id)sender {
    
    if (_isShuffer) {
        self.index =arc4random_uniform((int)self.songArr.count);
    }
    else{
        //if (!_isRepeat)
            self.index ++;
    }
    if (self.index>=self.songArr.count) {
        self.index = 0;
    }
    self.song = [self.songArr objectAtIndex:self.index];
    self.downloadLbl.text = self.song.downloadNum;
    self.viewLbl.text = self.song.viewNum;
    gMP3Player.song = self.song;
    [Util setObject:gMP3Player.song.songId forKey:CURRENT_SONG_ID_KEY];
    // hightlight the current song on list
    [self.tblView reloadData];
    
    [self playInThread];
}

- (IBAction)onPlay:(id)sender {
    _isPlaying = _playBtn.selected;
    _playBtn.selected = !_playBtn.selected;
    
    if(_playBtn.selected)
    {
        
        [_audioPlayer play];
        [_audioPlayer setRate:_playbackRate];
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"btn_pause.png"] forState:UIControlStateNormal];
        _updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSilder) userInfo:nil repeats:YES];
        
    }else
    {
        [_audioPlayer pause];
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"btn_play.png"] forState:UIControlStateNormal];
        [_updateTimer invalidate];
        _updateTimer = nil;
    }
    [gMP3Player onPlayPause:nil];
    
}

- (IBAction)onRightAction:(id)sender {
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setFrame:CGRectMake(SCREEN_WIDTH_PORTRAIT-180, 35, 180, 30.0)];
    if(dropDown == nil) {
        [dropDownClock hideDropDown:button1];
        [self rel];
        CGFloat f = 40;
        
        dropDown = [[NIDropDown alloc]showDropDown:button1 :&f :[NSMutableArray arrayWithArray:@[@"Make available offline"]] :nil :@"down"];
        [self.view addSubview:dropDown];
        dropDown.delegate = self;
    }
    else {
        [dropDownClock hideDropDown:button1];
        [dropDown hideDropDown:button1];
        [self rel];
    }
}

- (IBAction)nextSeconds:(id)sender {
  
    float value = _slider.value + self.seconds / audioDurationInSecond ;
    if (value > audioDurationInSecond) {
        value = audioDurationInSecond;
       
    }
    
    self.currentTimeLbl.text = [Util durationToString:value*audioDurationInSecond];
    if(_audioPlayer)
    {
        CMTime newTime = CMTimeMakeWithSeconds(value*(audioDurationInSecond),1);
        [_updateTimer invalidate];
        [_audioPlayer seekToTime:newTime completionHandler:^(BOOL finished) {
            if(finished)
            {
                _updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSilder) userInfo:nil repeats:YES];
            }
        }];
    }
}

- (IBAction)previousSeconds:(id)sender {
    float value = _slider.value -  self.seconds / audioDurationInSecond ;
    if (value < 0.0) {
        value = 0.0;
    }
    
    self.currentTimeLbl.text = [Util durationToString:value*audioDurationInSecond];
    if(_audioPlayer)
    {
        CMTime newTime = CMTimeMakeWithSeconds(value*(audioDurationInSecond),1);
        [_updateTimer invalidate];
        [_audioPlayer seekToTime:newTime completionHandler:^(BOOL finished) {
            if(finished)
            {
                _updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSilder) userInfo:nil repeats:YES];
            }
        }];
    }

}

- (IBAction)onClockAction:(id)sender {
    
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setFrame:CGRectMake(SCREEN_WIDTH_PORTRAIT-130, 35, 150.0, 30.0)];
    if(dropDownClock == nil) {
        [dropDown hideDropDown:button1];
        [self rel];
        CGFloat f = 150;
        
        dropDownClock = [[NIDropDown alloc]showDropDown:button1 :&f :[NSMutableArray arrayWithArray:@[@"15 minutes",@"30 minutes",@"45 minutes",@"60 minutes"]] :nil :@"down"];
        [self.view addSubview:dropDownClock];
        dropDownClock.delegate = self;
    }
    else {
        [dropDown hideDropDown:button1];
        [dropDownClock hideDropDown:button1];
        [self rel];
    }

    
}
-(IBAction)onShowDropdown:(id)sender{
    
    [dropDownClock hideDropDown:nil];
    dropDownClock = nil;
    [dropDown hideDropDown:nil];
    dropDown = nil;
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    
    [self.tblView reloadData];
//    dropDown = nil;
//    dropDownClock = nil;
    if (sender == dropDown) {
        switch (sender.indexPath.row) {
                
            case 0:
                [self onDownload:nil];
                break;
            case 1:
                [self onAddPlayList:nil];
                break;
            default:
                break;
        }

    }else if (sender == dropDownClock) {
        [timer invalidate];
        if (_isPlaying) {
            switch (sender.indexPath.row) {
                case 0:
                {
                    timer = [NSTimer scheduledTimerWithTimeInterval:900 target:self selector:@selector(onPause) userInfo:nil repeats:NO];
                }
                    break;
                case 1:
                    timer = [NSTimer scheduledTimerWithTimeInterval:1800 target:self selector:@selector(onPause) userInfo:nil repeats:NO];
                    break;
                case 2:
                    timer = [NSTimer scheduledTimerWithTimeInterval:2700 target:self selector:@selector(onPause) userInfo:nil repeats:NO];
                    break;
                case  3:
                    timer = [NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(onPause) userInfo:nil repeats:NO];
                    break;
                    
                default:
                    break;
            }

        }
           }
      dropDown = nil;
        dropDownClock = nil;
   }
-(void) onPause {
    
    [_audioPlayer pause];
    _isPlaying = _playBtn.selected;
    _playBtn.selected = !_playBtn.selected;
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"btn_play.png"] forState:UIControlStateNormal];
    
    
}
-(void)rel{
    dropDown = nil;
    dropDownClock = nil;
}


- (IBAction)onRepeat:(id)sender {
    _isRepeat = !_isRepeat;
    [self setRepeatBtn];
}



-(void)setRepeatBtn{
    if (_isRepeat) {
        [self.repeatBtn setBackgroundImage:[UIImage imageNamed:@"btn_repeat_on.png"] forState:UIControlStateNormal];
    }
    else{
        [self.repeatBtn setBackgroundImage:[UIImage imageNamed:@"btn_repeat_off.png"] forState:UIControlStateNormal];
    }
}
//-(void)setShuffleBtn{
//    if (_isShuffer) {
//        [_shuffleBtn setBackgroundImage:[UIImage imageNamed:@"btn_shuffle_on.png"] forState:UIControlStateNormal];
//    }
//    else{
//        [_shuffleBtn setBackgroundImage:[UIImage imageNamed:@"btn_shuffle_off.png"] forState:UIControlStateNormal];
//    }
//}
- (IBAction)onBack:(id)sender {
    //    [_audioPlayer pause];
    //    [_updateTimer invalidate];
    _updateTimer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onShare:(id)sender {
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    [sharingItems addObject:self.song.link];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.songArr.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tblView deselectRowAtIndexPath:indexPath animated:NO];
    
    TopSongCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopSongCell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TopSongCell" owner:nil options:nil] objectAtIndex:0];
        
       
    }
    Song *s = [self.songArr objectAtIndex:indexPath.row];
    
    cell.nameLbl.text = s.name;
    
    NSLog(@"total : %d\n song number: %d\n name: %@",self.songArr.count,indexPath.row,s.name);
    
    cell.artistLbl.text = s.singerName;
    
    cell.nameLbl.textColor = [UIColor whiteColor];
    
    cell.artistLbl.textColor = [UIColor colorWithRed:0.384 green:0.776 blue:0.78 alpha:1];
    
    cell.separatorLbl.backgroundColor =[Util colorFromHexString:@"#32586d" andAlpha:0.5];
    if (indexPath.row == self.index){
        
        [cell setBackgroundColor:[Util colorFromHexString:@"#593546" andAlpha:0.5]];
    }
    else
        [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    <bug3>
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    </bug3>
    self.song = [self.songArr objectAtIndex:indexPath.row];
    self.index = (int) indexPath.row;
//    [self hightLightSongAtIndex: self.index];
    [self play];
    [self.tblView reloadData];
}

-(void)reloadTableview{
    [self.tblView reloadData];
}
@end
