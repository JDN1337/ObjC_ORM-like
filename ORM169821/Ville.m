//
//  Ville.m
//  ORM169821
//
//  Created by Jordan on 25/03/2014.
//  Copyright (c) 2014 Jordan. All rights reserved.
//

#import "Ville.h"

@implementation Ville

@synthesize ville_id;
@synthesize nom;
@synthesize code_postal;
@synthesize nom_maire;

-(id) initWithNom:(NSString *) nomVille code_postal:(NSNumber *)cp nom_maire:(NSString *)maire{
    
    self = [super init];
    if(self){

        nom = nomVille;
        code_postal =cp;
        nom_maire = maire;
        
    }
    return self;
}






@end
