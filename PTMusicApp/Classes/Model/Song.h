//
//  Song.h
//  PTMusicApp
//
//  Created by hieu nguyen on 12/13/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject
@property (strong, nonatomic) NSString *songId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *lyrics;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *singerName;
@property (strong, nonatomic) NSString *albumId;
@property (strong, nonatomic) NSString *authorId;
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *hot;
@property (strong, nonatomic) NSString *news;
@property (strong, nonatomic) NSString *localMP3;

@property (strong, nonatomic) NSString *downloadNum;
@property (strong, nonatomic) NSString *viewNum;
@property (strong, nonatomic) NSString *image;
@end
