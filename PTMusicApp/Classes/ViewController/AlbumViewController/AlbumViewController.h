//
//  AlbumViewController.h
//  PTMusicApp
//
//  Created by hieu nguyen on 12/6/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *revealBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *albumArr;
@property BOOL isLoadingMoreData;
@property int currentPage;
@end
