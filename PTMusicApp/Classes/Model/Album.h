//
//  Album.h
//  PTMusicApp
//
//  Created by hieu nguyen on 12/20/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Album : NSObject
@property (strong, nonatomic) NSString *albumId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSString *numberSong;
@property (strong, nonatomic) NSString *createdDate;
@property (strong, nonatomic) NSString *status;
@end
