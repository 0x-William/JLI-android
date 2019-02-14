//
//  DatabaseManager.h
//  PTMusicApp
//
//  Created by hieu nguyen on 12/27/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Song.h"
@interface DatabaseManager : NSObject{
    sqlite3_stmt  *stmt;
    
}
+ (DatabaseManager *)defaultDatabaseManager;

-(void)insertDownloadSong:(Song *)entity;
-(NSMutableArray *)getAllDownloadSong;

-(void)insertPlaylist:(NSString *)name;

-(void)insertSong:(Song *)entity
      andPlaylist:(NSString *)playlist;

-(void)insertSong:(Song *)entity
      ToPlaylist:(NSString *)playlist;
-(void)deletePlaylist;

-(NSMutableArray *)getAllPlaylist;
-(NSMutableArray *)getAllSongwithPlaylist:(NSString *)name;



-(void)activePlaylist:(NSString *)name;
-(void)deletePlaylistwithName:(NSString *)name;
-(void)deleteSongListPlaywithName:(NSString *)name;
-(void)deleteAllSongsOfPlaylistWithName: (NSString *)name;
-(void)removeSongWith:(NSString *)songName
          andPlaylist:(NSString *)playlist;
@end
