//
//  RevealCell.m
//  JStyle2
//
//  Created by hieu nguyen on 11/3/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "RevealCell.h"

@implementation RevealCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:self.frame];
    img.image = [UIImage imageNamed:@"bg_item_menu_select.png"];
    
    [self setSelectedBackgroundView:img];
}

@end
