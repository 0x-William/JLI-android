//
//  MP3Player.h
//  PTMusicApp
//
//  Created by hieu nguyen on 1/24/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import "MarqueeLabel.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol MP3PlayerDelegate;
@interface MP3Player : UIViewController
@property (weak, nonatomic) IBOutlet MarqueeLabel *nameLbl;
@property (weak, nonatomic) IBOutlet MarqueeLabel *artistLbl;
@property (weak, nonatomic) IBOutlet UIButton *previousBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;

- (IBAction)OnNextDetail:(id)sender;


@property (strong, nonatomic) Song *song;
@property (strong, nonatomic) NSMutableArray *songArr;
@property int index;


- (IBAction)onPrevious:(id)sender;
- (IBAction)onNext:(id)sender;
- (IBAction)onPlayPause:(id)sender;


@property (assign, nonatomic) id<MP3PlayerDelegate> delegate;
-(void) showOrHide;
-(int) getHeight;
@end
@protocol MP3PlayerDelegate <NSObject>

-(void)NextDetailWithSongArr:(NSMutableArray *)songarr andInde:(int )index;


@end
