//
//  MP3Player.m
//  PTMusicApp
//
//  Created by hieu nguyen on 1/24/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "MP3Player.h"
#import "DatabaseManager.h"
#import "ModelManager.h"
#import "Validator.h"
#import "PlaySongViewController.h"

@interface MP3Player ()

@end

@implementation MP3Player

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameLbl.textColor = [UIColor whiteColor];
    self.nameLbl.font = [UIFont systemFontOfSize:14];
    self.artistLbl.textColor = [UIColor whiteColor];
    self.artistLbl.font = [UIFont systemFontOfSize:10];
    
    self.songArr = [[DatabaseManager defaultDatabaseManager]getAllSongwithPlaylist:CURRENT_PLAYLIST];
    NSString *current = [NSString stringWithFormat:@"%@",[Util objectForKey:CURRENT_SONG_ID_KEY]];
    if (self.songArr.count == 0 && current.length == 0) {
        self.view.hidden = YES;
    }
    
    for (Song *s in gMP3Player.songArr) {
        NSLog(@"song: %@ save: %@",s.songId,current);
        if ([s.songId isEqualToString:current]) {
            self.song = s;
            break;
        }
    }
    NSURL *urlAudio = [NSURL URLWithString:self.song.link];
    
    if(self.song && [NSString stringWithFormat:@"%@",[Util objectForKey:[NSString stringWithFormat:@"%@_localFile",self.song.songId]]])
    {
        self.song.localMP3 = [NSString stringWithFormat:@"%@",[Util objectForKey:[NSString stringWithFormat:@"%@_localFile",self.song.songId]]];
        urlAudio = [NSURL fileURLWithPath:self.song.localMP3];
    }
    
    currentAudio = self.song.songId;
    _audioPlayer = [AVPlayer playerWithURL:urlAudio];
    AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:self.song.link] options:nil];
    
    CMTime audioDuration = audioAsset.duration;
    
    audioDurationInSecond = CMTimeGetSeconds(audioDuration);
    
    self.nameLbl.text = self.song.name;
    self.artistLbl.text = self.song.singerName;
    // Do any additional setup after loading the view from its nib.
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSError *setCategoryError = nil;
    BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    if (!success) { /* handle the error condition */ }
    
    NSError *activationError = nil;
    success = [audioSession setActive:YES error:&activationError];
    if (!success) {}
    if(viewHeight > 700){
        self.previousBtn.frame = CGRectMake(600, 0, 50, 50);
        self.pauseBtn.frame = CGRectMake(655, 0, 50, 50);
        self.nextBtn.frame = CGRectMake(710, 0, 50, 50);
    }
    [self showOrHide];
}

-(void) showOrHide{
    if (self.song.songId.length == 0)
        self.view.hidden = YES;
    else
        self.view.hidden = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)play{
    
    NSLog(@"play from MP3Player");
    NSURL *urlAudio = [NSURL URLWithString:self.song.link];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:urlAudio];
    NSArray *tracks = [playerItem tracks];
    for (AVPlayerItemTrack *playerItemTrack in tracks)
    {
        // find video tracks
        if ([playerItemTrack.assetTrack hasMediaCharacteristic:AVMediaCharacteristicVisual])
        {
            playerItemTrack.enabled = NO; // disable the track
        }
    }
    _audioPlayer = [AVPlayer playerWithURL:urlAudio];
    
    if([NSString stringWithFormat:@"%@",[Util objectForKey:[NSString stringWithFormat:@"%@_localFile",self.song.songId]]])
    {
        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[self.song.link lastPathComponent]];
        

        self.song.localMP3 = [NSString stringWithFormat:@"%@",[Util objectForKey:[NSString stringWithFormat:@"%@_localFile",self.song.songId]]];
        NSURL *url = [[NSURL alloc] initFileURLWithPath: filePath];
        AVAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
        CMTime audioDuration = asset.duration;
        
        audioDurationInSecond = CMTimeGetSeconds(audioDuration);
        NSLog(@"Duration :%f",audioDurationInSecond);
       
        AVPlayerItem *anItem = [AVPlayerItem playerItemWithAsset:asset];
        _audioPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        
        _audioPlayer = [AVPlayer playerWithPlayerItem:anItem];

        
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    [_audioPlayer play];
}

-(void)itemDidFinishPlaying:(NSNotification *) notification {
    float currentTimeInSecond = CMTimeGetSeconds([_audioPlayer currentTime]);

    if (currentTimeInSecond > audioDurationInSecond-1) {
        [ModelManager updateSong:self.song.songId path:LISTEN_SONG WithSuccess:^(NSDictionary *dic) {
            NSDictionary *songDic = dic[@"data"];
            self.song.viewNum = [Validator getSafeString:songDic[@"view"]];
        } failure:^(NSString *err) {
            
        }];
    }
}

- (IBAction)onPrevious:(id)sender {
    if (_isShuffer) {
        self.index =arc4random_uniform((int)self.songArr.count);
    }
    else{
        self.index --;
    }
    if (self.index<0) {
        self.index = (int)self.songArr.count -1;
    }
    self.song = [self.songArr objectAtIndex:self.index];
    self.nameLbl.text = self.song.name;
    self.artistLbl.text = self.song.singerName;
    currentAudio = self.song.songId;
    [Util setObject:self.song.songId forKey:CURRENT_SONG_ID_KEY];
    [self play];
}

- (IBAction)onNext:(id)sender {
    if (_isShuffer) {
        self.index =arc4random_uniform((int)self.songArr.count);
    }
    else{
        self.index ++;
    }
    if (self.index>=self.songArr.count) {
        self.index = 0;
    }
    self.song = [self.songArr objectAtIndex:self.index];
    self.nameLbl.text = self.song.name;
    self.artistLbl.text = self.song.singerName;
    [self play];
    currentAudio = self.song.songId;
    [Util setObject:self.song.songId forKey:CURRENT_SONG_ID_KEY];
}

- (IBAction)onPlayPause:(id)sender {
    _isPlaying = !_isPlaying;
    if(_isPlaying)
    {
        [_audioPlayer play];
        [_audioPlayer setRate:_playbackRate];
        [self.pauseBtn setBackgroundImage:[UIImage imageNamed:@"btn_pause_small.png"] forState:UIControlStateNormal];
        
    }else
    {
        [self.pauseBtn setBackgroundImage:[UIImage imageNamed:@"btn_play_small.png"] forState:UIControlStateNormal];
        NSLog(@"onPlayPause.pause");
        [_audioPlayer pause];
        
    }
}

- (IBAction)OnNextDetail:(id)sender {
    if (self.songArr.count>0) {
        [self.delegate NextDetailWithSongArr:self.songArr andInde:self.index];
    }
}
-(int) getHeight
{
    if (self.view.frame.size.height == 0)
        return 50;
    else
        return self.view.frame.size.height;
}
@end
