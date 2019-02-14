//
//  CategoryViewController.m
//  PTMusicApp
//
//  Created by hieu nguyen on 12/6/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import "CategoryViewController.h"
#import "SWRevealViewController.h"
#import "AlbumCell.h"
#import "Categories.h"
#import "AsyncImageView.h"
#import "ModelManager.h"
#import "MBProgressHUD.h"
#import "TopSongViewController.h"
#import "PlaySongViewController.h"


@interface CategoryViewController ()<MP3PlayerDelegate>

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.categories.categoryId.length==0) {
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getData) userInfo:nil repeats:NO];
        [self setRevealBtn];
    }
    else{
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getSubCate) userInfo:nil repeats:NO];
        [self.lblTitle setText:self.categories.name];
        [self.revealBtn setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
        [self.revealBtn addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self setupCollectionView];

    
    // Do any additional setup after loading the view from its nib.
}

-(void)NextDetailWithSongArr:(NSMutableArray *)songarr andInde:(int)index{
    PlaySongViewController *play = [[PlaySongViewController alloc]initWithNibName:@"PlaySongViewController" bundle:nil];
    play.songArr = songarr;
    play.index = index;
    play.pauseOnLoad = ![Util isMusicPlaying];
    [self.navigationController pushViewController:play animated:YES];
    
}
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    int height = self.view.frame.size.height;
    if (gMP3Player.song.songId.length>0) {
        self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, 66, self.collectionView.frame.size.width, height - 116);
        gMP3Player.view.frame = CGRectMake(0, height - 50, self.collectionView.frame.size.width, 50);
        
    }
    else{
        self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, 66, self.collectionView.frame.size.width, height - 66);
    }
    [gMP3Player.view removeFromSuperview];
    [self.view addSubview: gMP3Player.view];
    gMP3Player.delegate = self;
}
-(void)viewDidAppear:(BOOL)animated{
    
    int height = self.view.frame.size.height;
    if (gMP3Player.song.songId.length>0) {
        self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, 66, self.collectionView.frame.size.width, height - 116);
        gMP3Player.view.frame = CGRectMake(0, height - 50, self.collectionView.frame.size.width, 50);
        
    }
    else{
        self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, 66, self.collectionView.frame.size.width, height - 66);
    }
    [gMP3Player.view removeFromSuperview];
    [self.view addSubview: gMP3Player.view];
    
}
-(void)setRevealBtn{
    SWRevealViewController *revealController = self.revealViewController;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [_revealBtn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)getData{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [ModelManager getListCategoryWithSuccess:^(NSMutableArray *arr) {
            self.categoryArr = arr;
            [self getParents];
            [self.collectionView reloadData];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } failure:^(NSString *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    });
}
-(void)getParents{
    self.parentList = [[NSMutableArray alloc] init];
    
    for (int i=0; i<self.categoryArr.count; i++) {
        Categories *a = [self.categoryArr objectAtIndex:i];
        if ([a.parentId isEqualToString:@"0"]) {
            [self.parentList addObject:a];
        }
    }
    
    self.categoryArr = self.parentList;
}
-(void)getSubCate{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [ModelManager getSubCategoryWithCategory:self.categories andSuccess:^(NSMutableArray *arr) {
            self.categoryArr = arr;
            [self.collectionView reloadData];
            
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } failure:^(NSString *err) {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    });
}
-(void)setupCollectionView {
    [self.collectionView registerClass:[AlbumCell class] forCellWithReuseIdentifier:@"AlbumCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:1.0f];
    [flowLayout setMinimumLineSpacing:10.0f];
    [flowLayout setItemSize:CGSizeMake(300, 170)];
    [self.collectionView setCollectionViewLayout:flowLayout];
    self.collectionView.contentSize = [self collectionViewContentSize];
    
}


- (CGSize)collectionViewContentSize
{
    return CGSizeMake(300, self.collectionView.frame.size.height);
}



#pragma mark - UICollectionView Datasource
// 1

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.categoryArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(screen_height < 1000)
        return CGSizeMake(300, 170);
    else
        return CGSizeMake(355, 170);
}

// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumCell *cell = (AlbumCell *)[_collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumCell" forIndexPath:indexPath];

    Categories *a = [self.categoryArr objectAtIndex:indexPath.row];
    cell.avatarImg.imageURL = [NSURL URLWithString:a.image];
    cell.avatarImg.translatesAutoresizingMaskIntoConstraints = YES;
    cell.nameLbl.text = a.name;
    cell.nameLbl.textAlignment = NSTextAlignmentCenter;
    cell.nameLbl.translatesAutoresizingMaskIntoConstraints = YES;
    if(screen_height < 1000){
        [cell.avatarImg setFrame:CGRectMake(7, 8, 286, 120)];
        [cell.nameLbl setFrame:CGRectMake(15, 137, 270, 25)];
    } else {
        [cell.avatarImg setFrame:CGRectMake(7, 8, 341, 120)];
        [cell.nameLbl setFrame:CGRectMake(15, 137, 335, 25)];
    }

    cell.backgroundColor = [UIColor whiteColor];

    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
    Categories *cate = [self.categoryArr objectAtIndex:indexPath.row];
    if ([cate.isParent isEqualToString:@"1"]) {
        CategoryViewController *cateVC = [[CategoryViewController alloc]initWithNibName:@"CategoryViewController" bundle:nil];
        cateVC.categories = cate;
        [self.navigationController pushViewController:cateVC animated:YES];
        
    }
    else{
        TopSongViewController *top = [[TopSongViewController alloc]initWithNibName:@"TopSongViewController" bundle:nil];
        top.category = [self.categoryArr objectAtIndex:indexPath.row];
        top.fromWhichView = VIEW_CATEGORIES;
        [self.navigationController pushViewController:top animated:YES];
    }
    
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}



// 3
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(18, 18, 18, 18);
}

@end
