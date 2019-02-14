//
//  AlbumViewController.m
//  PTMusicApp
//
//  Created by hieu nguyen on 12/6/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import "AlbumViewController.h"
#import "SWRevealViewController.h"
#import "ModelManager.h"
#import "MBProgressHUD.h"
#import "Album.h"
#import "AlbumCell.h"
#import "AsyncImageView.h"
#import "PlaySongViewController.h"
#import "TopSongViewController.h"

@interface AlbumViewController ()<MP3PlayerDelegate, UIScrollViewDelegate>{
    NSString *user_id;
}

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    user_id = [NSString stringWithFormat:@"%@",[Util objectForKey:USER_ID]];
    [self setupCollectionView];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getData) userInfo:nil repeats:NO];
    [self setRevealBtn];
    [self loadAdmobs];
    // Do any additional setup after loading the view from its nib.
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
-(void)viewWillAppear:(BOOL)animated{
    [self.view addSubview: gMP3Player.view];
    [gMP3Player showOrHide];
    gMP3Player.delegate = self;
    
    if (gMP3Player.song.songId.length>0) {
        self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.view.frame.size.height-[gMP3Player getHeight]-self.collectionView.frame.origin.y);
        gMP3Player.view.frame = CGRectMake(0, viewHeight - 50, self.collectionView.frame.size.width, 50);
    }
    else{
        self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.view.frame.size.height-self.collectionView.frame.origin.y);
    }
}
-(void)getData{//refresh
    self.currentPage = 1;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [ModelManager getListAlbumWithPage:self.currentPage userID:user_id andSuccess:^(NSMutableArray *arr) {
            self.albumArr = arr;
            [self.collectionView reloadData];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } failure:^(NSString *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    });
}
-(void) loadMore{
    self.currentPage = self.currentPage + 1;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [ModelManager getListAlbumWithPage:self.currentPage userID:user_id andSuccess:^(NSMutableArray *arr) {
            if ([arr count] > 0)
            {
                [self.albumArr addObjectsFromArray:arr];
                [self.collectionView reloadData];
            }
            self.isLoadingMoreData = NO;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } failure:^(NSString *err) {
            self.isLoadingMoreData = NO;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    });
}
-(void)setRevealBtn{
    SWRevealViewController *revealController = self.revealViewController;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [_revealBtn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)setupCollectionView {
    [self.collectionView registerClass:[AlbumCell class] forCellWithReuseIdentifier:@"AlbumCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:1.0f];
    [flowLayout setMinimumLineSpacing:10.0f];
    [flowLayout setItemSize:CGSizeMake(135, 180)];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    self.collectionView.contentSize = [self collectionViewContentSize];
    // pull to refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(onCollectionViewRefresh:)
             forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
    //
    //self.collectionView.delegate = self;
    self.isLoadingMoreData = NO;
    //
    self.currentPage = 1;
}

- (void)onCollectionViewRefresh:(id)sender
{
    [(UIRefreshControl *)sender endRefreshing];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getData) userInfo:nil repeats:NO];
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(50, self.view.frame.size.height-self.collectionView.frame.origin.y);
}
#pragma mark - UICollectionView Datasource
// 1

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.albumArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(135, 180);
}

// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
        AlbumCell *cell = (AlbumCell *)[_collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumCell" forIndexPath:indexPath];
        
        Album *a = [self.albumArr objectAtIndex:indexPath.row];
        cell.avatarImg.imageURL = [NSURL URLWithString:a.image];
        cell.nameLbl.text = a.name;
        cell.nameLbl.textAlignment = NSTextAlignmentCenter;
//        cell.nameLbl.fadeLength = 10;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Album *a = [self.albumArr objectAtIndex:indexPath.row];
    TopSongViewController *top =[[TopSongViewController alloc]initWithNibName:@"TopSongViewController" bundle:nil];
    top.album = a;
    top.fromWhichView = VIEW_ALBUMS;
    [self.navigationController pushViewController:top animated:YES];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(18, 18, 18, 18);
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height + 80)
    {
        if (self.isLoadingMoreData == NO)
        {
            self.isLoadingMoreData = YES;
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(loadMore) userInfo:nil repeats:NO];
        }
    }
}
-(void)loadAdmobs{
//    adBanner.view.frame = CGRectMake(0, SCREEN_HEIGHT_PORTRAIT-50, SCREEN_WIDTH_PORTRAIT, 50);
//    [self.view addSubview:adBanner.view];
}
@end
