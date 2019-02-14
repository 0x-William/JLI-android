//
//  TopSongCell.h
//  PTMusicApp
//
//  Created by hieu nguyen on 12/13/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopSongCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *artistLbl;
@property (weak, nonatomic) IBOutlet UILabel *separatorLbl;

@end
