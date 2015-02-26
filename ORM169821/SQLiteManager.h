//
//  SQLiteManager.h
//  ORM169821
//
//  Created by Jordan on 25/03/2014.
//  Copyright (c) 2014 Jordan. All rights reserved.
//

#define dbName @"169821_SupinfORM.db"

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SQLiteManager : NSObject{
    sqlite3 *database;
}

@property sqlite3 *database;

-(void) initDb;
-(void) initTable:(const char *)sql;

-(int) insertSimpleData:(NSString *)data into:(NSString *)table;
-(int) insertData:(NSDictionary *)data into:(NSString *)table;

-(NSArray *)selectAllFrom:(NSString *)table;
-(NSArray *)select:(NSString *)field from:(NSString *)table where:(NSString *)condition;
-(NSString *)selectSimpleDataWithId:(NSInteger)idObjetSimple;

-(BOOL)deleteWithId:(int)idRow from:(NSString *)table;



-(void) closeDb;

@end
