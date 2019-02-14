//
//  RevealCell.h
//  JStyle2
//
//  Created by hieu nguyen on 11/3/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RevealCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

@property (strong, nonatomic) IBOutlet UIView *ViewSelect;

@end
