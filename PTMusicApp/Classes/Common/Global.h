//
//  Global.h
//  PTMusicApp
//
//  Created by hieu nguyen on 1/24/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "MP3Player.h"
#import "PlaySongViewController.h"
#import "footers.h"

@interface Global : NSObject
extern AVPlayer *_audioPlayer;
extern BOOL _isAudioPlayerObserved;
extern NSString *currentAudio;
extern float audioDurationInSecond;
extern BOOL _isRepeat;
extern BOOL _isShuffer;
extern float _playbackRate;
extern MP3Player *gMP3Player;
extern BOOL _isPlaying;
extern BOOL _isTopSong;
extern NSMutableArray *songArr;
extern float screen_height;
extern footer *footerBanner;
extern int viewHeight;
extern BOOL _isPlayList;
extern float linkHeight;
extern PlaySongViewController *gPlayerController;
@end
