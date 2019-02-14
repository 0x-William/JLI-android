//
//  DatabaseManager.m
//  PTMusicApp
//
//  Created by hieu nguyen on 12/27/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import "DatabaseManager.h"
#import "Song.h"
#import "Util.h"

@implementation DatabaseManager


static DatabaseManager        *sharedObject = nil;

+ (DatabaseManager *)defaultDatabaseManager{
    if (sharedObject == nil) {
        @synchronized(self){
            if (sharedObject == nil) {
                sharedObject = [[DatabaseManager alloc] init];
            }
        }
    }
    return sharedObject;
}

- (NSString *)getDBPath {
    // Get path of database.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"PTMusicApp.sqlite"];
}
-(void)insertDownloadSong:(Song *)entity {
    sqlite3 *database;
    NSString *dbPath = [self getDBPath];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        sqlite3_stmt *compiledStatement = nil;
        
        NSString *sqlQuery = [NSString stringWithFormat:@"insert into DownLoad (id, name , lyrics , link , singer_name , album_id , category_id ) values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")", entity.songId,entity.name,entity.lyrics, entity.link,entity.singerName,entity.albumId,entity.categoryId];
        if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
            
            if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
                NSLog(@"SQL execution failed: %s", sqlite3_errmsg(database));
                
            }
        }
        
        sqlite3_finalize(compiledStatement);
        
    }
    sqlite3_close(database);
}

-(NSMutableArray *)getAllDownloadSong
{
    
    NSMutableArray *arrr = [[NSMutableArray alloc] init];
    
    sqlite3 *database;
    
    NSString *dbPath = [self getDBPath];
    
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *selectStatement;
        NSString *selectSql = [NSString stringWithFormat:@"select * from DownLoad"];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &selectStatement, NULL) == SQLITE_OK) {
            while(sqlite3_step(selectStatement) == SQLITE_ROW){
                
                Song *s = [[Song alloc]init];
                s.songId = [NSString stringWithCString:(char *)sqlite3_column_text(selectStatement, 0) encoding:NSUTF8StringEncoding];
                // id should be <song id>_<playlist name>
                NSArray* splitBy_ = [s.songId componentsSeparatedByString: @"_"];
                if ([splitBy_ count] > 0)
                    s.songId = [splitBy_ objectAtIndex:0];
                
                
                s.name = [NSString stringWithCString:(char *)sqlite3_column_text(selectStatement, 2) encoding:NSUTF8StringEncoding];
                s.lyrics = [NSString stringWithCString:(char *)sqlite3_column_text(selectStatement, 3) encoding:NSUTF8StringEncoding];
                s.singerName = [NSString stringWithCString:(char *)sqlite3_column_text(selectStatement, 5) encoding:NSUTF8StringEncoding];
                s.link = [NSString stringWithCString:(char *)sqlite3_column_text(selectStatement, 4) encoding:NSUTF8StringEncoding];
                
                s.lyrics =[s.lyrics stringByReplacingOccurrencesOfString:@"\"" withString:@"'"] ;
                s.name =[s.name stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
                s.singerName =[s.singerName stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
                
                
                [arrr addObject:s];
                
            }
        }
        sqlite3_finalize(selectStatement);
        
    }
    sqlite3_close(database);
    return arrr;
    
}



-(void)insertPlaylist:(NSString *)name
{
    sqlite3 *database;
    NSString *dbPath = [self getDBPath];
    NSString *playListName =[name stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        sqlite3_stmt *compiledStatement = nil;
        
        NSString *sqlQuery = [NSString stringWithFormat:@"insert into playlist (name,isActive) values ('%@',1)",playListName];
        
        if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
            if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
                NSLog(@"SQL execution failed: %s", sqlite3_errmsg(database));
            }
        }
        
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
}

-(void)activePlaylist:(NSString *)name{
    sqlite3 *database;
    NSString *dbPath = [self getDBPath];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        sqlite3_stmt *compiledStatement = nil;
        
        NSString *sqlQuery = [NSString stringWithFormat:@"update playlist Set isActive = 1 Where name='%@'",name];
        if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
            
            if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
                NSLog(@"SQL execution failed: %s", sqlite3_errmsg(database));
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    [self deletePlaylist];
}

-(void)deletePlaylistwithName:(NSString *)name
{
    sqlite3 *database;
    NSString *dbPath = [self getDBPath];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        sqlite3_stmt *compiledStatement = nil;
        
        NSString *sqlQuery = [NSString stringWithFormat:@"DELETE from detail WHERE playlist = '%@'",name];

        if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &compiledStatement, nil) == SQLITE_OK) {
            
            if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
                NSLog(@"SQL execution failed: %s", sqlite3_errmsg(database));
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
}

-(void)deleteSongListPlaywithName:(NSString *)name{
    sqlite3 *database;
    NSString *dbPath = [self getDBPath];
    [Util removeObjectForKey:@"errorDelete"];
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        sqlite3_stmt *compiledStatement = nil;
        
        NSString *sqlQuery = [NSString stringWithFormat:@"DELETE from playlist Where name ='%@' and isActive= 1 ",name];
        
        if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &compiledStatement, nil) == SQLITE_OK) {
            
            if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
                NSLog(@"SQL execution failed: %s", sqlite3_errmsg(database));
                [Util setObject:[NSString stringWithFormat:@"%s",sqlite3_errmsg(database)] forKey:@"errorDelete"];
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
}

-(void)deleteAllSongsOfPlaylistWithName: (NSString *)name{
    sqlite3 *database;
    NSString *dbPath = [self getDBPath];
    [Util removeObjectForKey:@"errorDelete"];
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        sqlite3_stmt *compiledStatement = nil;
        
        NSString *sqlQuery = [NSString stringWithFormat:@"DELETE from SongListPlay Where playlist ='%@'",name];
        
        if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &compiledStatement, nil) == SQLITE_OK) {
            
            if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
                NSLog(@"SQL execution failed: %s", sqlite3_errmsg(database));
                [Util setObject:[NSString stringWithFormat:@"%s",sqlite3_errmsg(database)] forKey:@"errorDelete"];
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
}

-(void)deletePlaylist
{
    sqlite3 *database;
    NSString *dbPath = [self getDBPath];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        sqlite3_stmt *compiledStatement = nil;
        
        NSString *sqlQuery = [NSString stringWithFormat:@"DELETE from playlist WHERE isActive = 0"];

        if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &compiledStatement, nil) == SQLITE_OK) {
            
            if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
                NSLog(@"SQL execution failed: %s", sqlite3_errmsg(database));

            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
}

-(void)insertSong:(Song *)entity
      andPlaylist:(NSString *)playlist

{
    sqlite3 *database;
    NSString *dbPath = [self getDBPath];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        sqlite3_stmt *compiledStatement = nil;
        
        NSString *sqlQuery = [NSString stringWithFormat:@"insert into detail (id, playlist , name , lyrics , link , singer_name , album_id , category_id ) values('%@','%@','%@','%@','%@','%@','%@','%@')", entity.songId, playlist ,entity.name,entity.lyrics, entity.link,entity.singerName,entity.albumId,entity.categoryId];
        if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
            
            if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
                NSLog(@"SQL execution failed: %s", sqlite3_errmsg(database));
                
            }
        }
        
        sqlite3_finalize(compiledStatement);
        
    }
    sqlite3_close(database);
 
}

-(void)removeSongWith:(NSString *)songID
      andPlaylist:(NSString *)playlist

{
    sqlite3 *database;
    NSString *dbPath = [self getDBPath];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        sqlite3_stmt *compiledStatement = nil;
        NSString *playListName =[playlist stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
        
        NSString *sqlQuery = [NSString stringWithFormat:@"delete from SongListPlay where id = '%@_%@'", songID, playListName];
        if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
            
            if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
                NSLog(@"SQL execution failed: %s", sqlite3_errmsg(database));
                
            }
        }
        
        sqlite3_finalize(compiledStatement);
        
    }
    sqlite3_close(database);
    
}

//SongListPlay
-(void)insertSong:(Song *)entity
       ToPlaylist:(NSString *)playlist{
    sqlite3 *database;
    NSString *dbPath = [self getDBPath];
    [Util removeObjectForKey:@"errorsql"];
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        sqlite3_stmt *compiledStatement = nil;
        NSString *lyrics =[entity.lyrics stringByReplacingOccurrencesOfString:@"'" withString:@"\""] ;
        NSString *name =[entity.name stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
        NSString *singerName =[entity.singerName stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
        NSString *playListName =[playlist stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
        
        NSString *sqlQuery = [NSString stringWithFormat:@"insert into SongListPlay (id, playlist , name , lyrics , link , singer_name , album_id , category_id ) values('%@','%@','%@','%@','%@','%@','%@','%@')", [NSString stringWithFormat:@"%@_%@", entity.songId, playListName], playListName ,name,lyrics, entity.link,singerName,entity.albumId,entity.categoryId];
        if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
            
            if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
                NSLog(@"SQL execution failed: %s", sqlite3_errmsg(database));
                [Util setObject:[NSString stringWithFormat:@"%s",sqlite3_errmsg(database)] forKey:@"errorsql"];
            }
        }
        
        sqlite3_finalize(compiledStatement);
        
    }
    sqlite3_close(database);
}

-(NSMutableArray *)getAllPlaylist
{
    
    sqlite3 *database;
    NSString *dbPath = [self getDBPath];
    NSMutableArray *content = [[NSMutableArray alloc]init];;
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *selectStatement;
        NSString *selectSql = [NSString stringWithFormat:@"select * from playlist"];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &selectStatement, NULL) == SQLITE_OK) {
            while(sqlite3_step(selectStatement) == SQLITE_ROW){
                
                if ((const char*)sqlite3_column_text(selectStatement, 1)) {
                    NSString *name = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(selectStatement, 1)];
                    NSString *playListName =[name stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
                        [content addObject:playListName];
                    
                }

            }
        }
        sqlite3_finalize(selectStatement);
        
    }
    sqlite3_close(database);
    return content;
    
}


-(NSMutableArray *)getAllSongwithPlaylist:(NSString *)name
{
    NSMutableArray *arrr = [[NSMutableArray alloc] init];
    
    sqlite3 *database;
    
    NSString *dbPath = [self getDBPath];

    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *selectStatement;
        NSString *playListName =[name stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
        NSString *selectSql = [NSString stringWithFormat:@"select * from SongListPlay where playlist = '%@'",playListName];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &selectStatement, NULL) == SQLITE_OK) {
            while(sqlite3_step(selectStatement) == SQLITE_ROW){
                
                Song *s = [[Song alloc]init];
                s.songId = [NSString stringWithCString:(char *)sqlite3_column_text(selectStatement, 0) encoding:NSUTF8StringEncoding];
                // id should be <song id>_<playlist name>
                NSArray* splitBy_ = [s.songId componentsSeparatedByString: @"_"];
                if ([splitBy_ count] > 0)
                    s.songId = [splitBy_ objectAtIndex:0];
                
                
                s.name = [NSString stringWithCString:(char *)sqlite3_column_text(selectStatement, 2) encoding:NSUTF8StringEncoding];
                s.lyrics = [NSString stringWithCString:(char *)sqlite3_column_text(selectStatement, 3) encoding:NSUTF8StringEncoding];
                s.singerName = [NSString stringWithCString:(char *)sqlite3_column_text(selectStatement, 5) encoding:NSUTF8StringEncoding];
                s.link = [NSString stringWithCString:(char *)sqlite3_column_text(selectStatement, 4) encoding:NSUTF8StringEncoding];
                
                s.lyrics =[s.lyrics stringByReplacingOccurrencesOfString:@"\"" withString:@"'"] ;
                s.name =[s.name stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
                s.singerName =[s.singerName stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
                
                
                [arrr addObject:s];

            }
        }
        sqlite3_finalize(selectStatement);
        
    }
    sqlite3_close(database);
    return arrr;
}
@end
