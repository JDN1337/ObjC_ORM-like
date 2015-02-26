//
//  EntityVille.h
//  ORM169821
//
//  Created by Jordan on 26/03/2014.
//  Copyright (c) 2014 Jordan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLiteManager.h"
#import "Ville.h"

@interface EntityVille : NSObject

-(EntityVille *) initTable;
-(Ville *)getFromDb:(NSString *) identifier;
-(BOOL) insertInDb:(Ville *)ville;
-(BOOL) deleteFromDb:(Ville *)ville;
-(NSString *) getTable;

@end
