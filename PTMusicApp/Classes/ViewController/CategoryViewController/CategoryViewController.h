//
//  CategoryViewController.h
//  PTMusicApp
//
//  Created by hieu nguyen on 12/6/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Categories.h"
@interface CategoryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *revealBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) Categories *categories;
@property (strong, nonatomic) NSMutableArray *categoryArr, *parentList;
@end
