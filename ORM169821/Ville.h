//
//  Ville.h
//  ORM169821
//
//  Created by Jordan on 25/03/2014.
//  Copyright (c) 2014 Jordan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ville : /*EntityVille*/NSObject{
    NSString *nom;
    NSNumber *code_postal;
    NSString *nom_maire;
    NSInteger ville_id;
    
}

@property NSString *nom;
@property NSNumber *code_postal;
@property NSString *nom_maire;
@property NSInteger ville_id;

-(id) initWithNom:(NSString *)nom code_postal:(NSNumber *)cp nom_maire:(NSString *)nom_maire;


@end
