//
//  SearchViewController.h
//  PTMusicApp
//
//  Created by hieu nguyen on 12/6/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIButton *revealBtn;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSMutableArray *songArr;
@end
