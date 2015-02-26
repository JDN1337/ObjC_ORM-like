//
//  SQLiteManager.m
//  ORM169821
//
//  Created by Jordan on 25/03/2014.
//  Copyright (c) 2014 Jordan. All rights reserved.
//

#import "SQLiteManager.h"

@implementation SQLiteManager
@synthesize database;
    
-(void) initDb{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:dbName];
    
    bool databaseAlreadyExists = [[NSFileManager defaultManager] fileExistsAtPath:dbPath];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK){
        NSLog(@"Database OPENED:");
        NSLog(@"Voici le path de la base de données: %@", dbPath);
        
        //Si la Base n'éxistait pas on créé la table des simples objets
        if(!databaseAlreadyExists){
            
            const char *sql = "CREATE TABLE IF NOT EXISTS simpleObject (id INTEGER PRIMARY KEY AUTOINCREMENT, string TEXT)";
            char *error;
            if (sqlite3_exec(database, sql, NULL, NULL, &error) == SQLITE_OK){
                //NSLog(@"Table simpleObjet créée");
            }
            else{
                NSLog(@"Erreur: %s", error);
            }
        }
        
        sqlite3_close(database);
    }
    
}

//Retourne l'id de l'objet inséré ou -1 sinon
-(int) insertSimpleData:(NSString *)data into:(NSString *)table{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (string) VALUES ('%@')", table, data];
    
    char *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:dbName];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK){
        
        //On créé la table si elle n'existe pas
        const char *sqlCreate= "CREATE TABLE IF NOT EXISTS simpleObject (id INTEGER PRIMARY KEY AUTOINCREMENT, string TEXT)";
        
        if (sqlite3_exec(database, sqlCreate, NULL, NULL, &error) == SQLITE_OK){
            //NSLog(@"Table simpleObjet créée");
        }
        else{
            NSLog(@"Erreur: %s", error);
        }
        
        //Insertion des données
        if ( sqlite3_exec(database, [sql UTF8String], NULL, NULL, &error) == SQLITE_OK){
            //NSLog(@"Data inserted.");
            int identifier = (int)sqlite3_last_insert_rowid(database);
            return identifier;
        }else{
            NSLog(@"Error: %s", error);
            return -1;
        }
        
        sqlite3_close(database);
    }
    
    return -1;
}

//Retourne l'id de l'objet inséré ou -1 sinon
-(int) insertData:(NSDictionary *)data into:(NSString *)table{
    
    NSArray *keys = [data allKeys];
    //NSArray *values = [data allValues];
    NSString * sql;
    
    NSString *keysSql = @"";
    NSString *valuesSql = @"";
    for (NSString *key in keys) {
        keysSql = [NSString stringWithFormat:@"%@,%@",keysSql,key];
        valuesSql = [NSString stringWithFormat:@"%@,'%@'",valuesSql, [data objectForKey:(key)]];
    }
    keysSql = [keysSql substringFromIndex:1];
    valuesSql = [valuesSql substringFromIndex:1];
    sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",table, keysSql, valuesSql];
    
    //NSLog(@"SQL: %@", sql);

    char *error;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:dbName];

    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK){
        if ( sqlite3_exec(database, [sql UTF8String], NULL, NULL, &error) == SQLITE_OK){
            //NSLog(@"Data inserted.");
            int identifier = (int)sqlite3_last_insert_rowid(database);
            return identifier;
        }else{
            NSLog(@"Error: %s", error);
            return -1;
        }
        
        sqlite3_close(database);
    }
    
    return -1;
}

-(void) initTable:(const char *)sqlStat{
    const char *sql = sqlStat;
    char *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:dbName];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK){
        if (sqlite3_exec(database, sql, NULL, NULL, &error) == SQLITE_OK){
            //NSLog(@"Table created.");
        }else{
            NSLog(@"Error: %s", error);
        }
        
        sqlite3_close(database);
    }
}


//METHODE POUR RECUP LES COLONNES AVEC LEURS ID
- (NSDictionary *)indexByColumnName:(sqlite3_stmt *)init_statement {
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    int num_fields = sqlite3_column_count(init_statement);
    for(int index_value = 0; index_value < num_fields; index_value++) {
        const char* field_name = sqlite3_column_name(init_statement, index_value);
        if (!field_name){
            field_name="";
        }
        NSString *col_name = [NSString stringWithUTF8String:field_name];
        NSNumber *index_num = [NSNumber numberWithInt:index_value];
        [keys addObject:col_name];
        [values addObject:index_num];
    }
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    //[keys release];
    //[values release];
    return dictionary;
}


//SELECT//
-(NSArray *)_select:(NSString *)sql{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:dbName];
    
	NSMutableArray *dataReturn = [[NSMutableArray alloc] init];
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        const char *sqlStatement = (const char*)[sql UTF8String];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            NSDictionary *dictionary = [self indexByColumnName:compiledStatement];
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				NSMutableDictionary * row = [[NSMutableDictionary alloc] init];
				for (NSString *field in dictionary) {
					char * str = (char *)sqlite3_column_text(compiledStatement, [[dictionary objectForKey:field] intValue]);
					if (!str){
						str=" ";
					}
					NSString * value = [NSString stringWithUTF8String:str];
					[row setObject:value forKey:field];
				}
				[dataReturn addObject:row];
				//[row release];
            }
        }else {
            NSAssert1(0, @"Error sqlite3_prepare_v2 :. '%s'", sqlite3_errmsg(database));
        }
        sqlite3_finalize(compiledStatement);
	}else {
        NSAssert1(0, @"Error sqlite3_open :. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_close(database);
	return dataReturn;
}
-(NSArray *)selectAllFrom:(NSString *)table{
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@",table];
    return [self _select:sql];
}
-(NSArray *)select:(NSString *)field from:(NSString *)table where:(NSString *)condition{
    if (field == nil) {
        field = @"*";
    }
    if (condition == nil) {
        condition = @"1=1";
    }
    NSString *selectFromWhere = @"SELECT %@ FROM %@ WHERE %@";
    NSString * sql = [NSString stringWithFormat:selectFromWhere,field, table, condition];
    return [self _select:sql];
}
-(NSString *)selectSimpleDataWithId:(NSInteger)idObjetSimple{
    
    NSArray *resultArray = [self select:@"string" from:@"simpleObject" where:[NSString stringWithFormat:@"id = %li", idObjetSimple]];
    
    NSString *resultReturn = [[resultArray objectAtIndex:(0)] valueForKey:(@"string")];
    
    return resultReturn;
}

-(BOOL)deleteWithId:(int)idRow from:(NSString *)table{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:dbName];
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = %d",table,idRow];
        const char *sqlStatement = (const char*)[sql UTF8String];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error sqlite3_prepare_v2 :. '%s'", sqlite3_errmsg(database));
            return NO;
        }
        if(SQLITE_DONE != sqlite3_step(compiledStatement)) {
            NSAssert1(0, @"Error sqlite3_step :. '%s'", sqlite3_errmsg(database));
            return NO;
        }else{
            sqlite3_finalize(compiledStatement);
            sqlite3_close(database);
            return YES;
        }
    }else{
        NSAssert1(0, @"Error sqlite3_open :. '%s'", sqlite3_errmsg(database));
        return NO;
    }
}


-(void) closeDb{
    sqlite3_close(database);
    NSLog(@"Database CLOSED");
}


@end
