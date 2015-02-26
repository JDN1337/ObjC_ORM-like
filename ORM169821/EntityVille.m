//
//  EntityVille.m
//  ORM169821
//
//  Created by Jordan on 26/03/2014.
//  Copyright (c) 2014 Jordan. All rights reserved.
//

#import "EntityVille.h"


@implementation EntityVille

-(EntityVille *) initTable{
    
    self = [super init];
    if(self){
        
        const char *sql = "CREATE TABLE IF NOT EXISTS ville (ID INTEGER PRIMARY KEY AUTOINCREMENT, nom TEXT, nom_maire TEXT, code_postal INTEGER)";
        
        SQLiteManager *sqliteManager = [[SQLiteManager alloc] init];
        [sqliteManager initTable:sql];
        
    }
    return self;
}

-(Ville *)getFromDb:(NSString *) identifier{
    SQLiteManager *sqliteManager = [[SQLiteManager alloc] init];
    NSArray *ville_array = [sqliteManager select:nil from:self.getTable where:[NSString stringWithFormat:@"id = %@",identifier]];
    
    NSString *nomVille = [[ville_array objectAtIndex:(0)] valueForKey:(@"nom")];
    NSString *nomMaire = [[ville_array objectAtIndex:(0)] valueForKey:(@"nom_maire")];
    NSNumber *cpVille = [[ville_array objectAtIndex:(0)] valueForKey:(@"code_postal")];
    
    Ville *ville = [[Ville alloc] initWithNom:nomVille code_postal:cpVille nom_maire:nomMaire];
    ville.ville_id = [identifier intValue];
    
    return ville;
}

-(BOOL) insertInDb:(Ville *)ville{
    //Dictionnaire des données à insérer
    NSMutableDictionary *dataSave = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [NSString stringWithFormat:@"%@",ville.nom], @"nom",
                                     [NSString stringWithFormat:@"%@",ville.code_postal], @"code_postal",
                                     [NSString stringWithFormat:@"%@",ville.nom_maire], @"nom_maire",
                                     nil];
    
    //Insertion des données dans la table
    SQLiteManager *sqliteManager = [[SQLiteManager alloc] init];
    ville.ville_id = [sqliteManager insertData:dataSave into: self.getTable];
    
    if(ville.ville_id > -1){
        return YES;
    }else{
        return NO;
    }
}

-(BOOL) deleteFromDb:(Ville *)ville{
    SQLiteManager *sqliteManager = [[SQLiteManager alloc] init];
    return [sqliteManager deleteWithId:(int)ville.ville_id from:self.getTable];
}

-(NSString *) getTable{
    NSString *className = /*NSStringFromClass([self class])*/@"ville";
    return className;
}

@end
