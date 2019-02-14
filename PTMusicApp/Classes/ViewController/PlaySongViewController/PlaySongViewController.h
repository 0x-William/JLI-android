//
//  PlaySongViewController.h
//  PTMusicApp
//
//  Created by hieu nguyen on 12/20/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Song.h"
#import "MarqueeLabel.h"
#import "NIDropDown.h"

@interface PlaySongViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NIDropDownDelegate,UINavigationControllerDelegate>{

    NIDropDown *dropDown;
    NIDropDown *dropDownClock;
    
}

@property (strong, nonatomic) Song *song;
@property (strong, nonatomic) NSMutableArray *songArr;

@property (weak, nonatomic) IBOutlet UIButton *downloadIcon;
@property (weak, nonatomic) IBOutlet UIButton *noOfViewIcon;
@property int index;
@property BOOL pauseOnLoad;

@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UIScrollView *pageView;


@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIView *speedView;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
- (IBAction)onBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLbl;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *repeatBtn;

@property (weak, nonatomic) IBOutlet UIButton *previousBtn;
@property (weak, nonatomic) IBOutlet UIButton *speedBtn;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UISlider *speedSlider;
@property (weak, nonatomic) IBOutlet UILabel *downloadLbl;
@property (weak, nonatomic) IBOutlet UILabel *viewLbl;

@property (weak, nonatomic) IBOutlet MarqueeLabel *songNameLbl;
@property (weak, nonatomic) IBOutlet MarqueeLabel *artistNameLbl;

@property (strong, nonatomic) IBOutlet UIButton *nextSecondsBtn;
@property (strong, nonatomic) IBOutlet UIButton *previousSecondsBtn;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UIButton *speedLabel1;

@property float seconds;
@property NSTimer* updateTimer;

- (IBAction)onRepeat:(id)sender;
- (IBAction)onSpeedPlus:(id)sender;
- (IBAction)onSpeedMinus:(id)sender;
- (IBAction)onSpeedNormal:(id)sender;

- (IBAction)onSpeedSlider:(id)sender;
- (IBAction)onSlider:(id)sender;
- (IBAction)onSpeedChange:(id)sender;
- (IBAction)onPrevious:(id)sender;
- (IBAction)onNext:(id)sender;
- (IBAction)onPlay:(id)sender;
- (IBAction)onRightAction:(id)sender;
- (IBAction)nextSeconds:(id)sender;
- (IBAction)previousSeconds:(id)sender;
- (IBAction)onClockAction:(id)sender;
-(void) remoteControlReceivedWithEvent:(UIEvent *)receivedEvent;
- (void) updateSilder;
- (void) play;
- (void) changeSpeed;
@end
