//
//  main.m
//  ORM169821
//
//  Created by Jordan on 25/03/2014.
//  Copyright (c) 2014 Jordan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLiteManager.h"
#import "Ville.h"
#import "EntityVille.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        //Instanciation de l'objet permettant les requêtes
        SQLiteManager *sqliteManager = [[SQLiteManager alloc] init];
        //Initialisation de la base de donnée. Si elle n'existe pas elle est créée.
        [sqliteManager initDb];
        
        
//////////INSERTION OBJET SIMPLE//////////
        NSString *objetSimple = @"coucou";
        
        NSLog(@"Insertion d'un objet simple, le string: %@", objetSimple);
        NSInteger idObjetSimple = [sqliteManager insertSimpleData:objetSimple into:@"simpleObject"];
        NSArray *result = [sqliteManager selectAllFrom:@"simpleObject"];
        NSLog(@"Voici les données de la table simpleObject: %@", result);
        
        NSString *objetSimpleLoaded = [sqliteManager selectSimpleDataWithId:idObjetSimple];
        NSLog(@"Voici l'objet simple récupéré en base: %@", objetSimpleLoaded);
        
//////////INSERTION OBJET COMPLEX//////////
        //Instanciation d'un objet Ville (la table correspondante à la classe est créée si elle n'existait pas)
        EntityVille *villeManager = [[EntityVille alloc] initTable];
        Ville *paris = [[Ville alloc] initWithNom:@"Paris" code_postal:@75 nom_maire:@"Delanoe"];
        NSLog(@"La table ville a été créée en base de données si elle n'existait pas");
        
        //Insertion en base de données
        BOOL parisInserted = [villeManager insertInDb:paris];
        if (parisInserted){
            NSLog(@"Une ville (Paris) a été insérée en base de données");
        }
        else{
            NSLog(@"Erreur: La ville n'a pas été insérée en base de données");
        }
        
        Ville *marseille = [[Ville alloc] initWithNom:@"Marseille" code_postal:@13 nom_maire:@"Gaudin"];
        
        BOOL marseilleInserted = [villeManager insertInDb:marseille];
        if(marseilleInserted){
            NSLog(@"Une ville (Marseille) a été insérée en base de données");
        }
        else{
            NSLog(@"Erreur: La ville n'a pas été insérée en base de données");
        }
        
        //Récupération des données de la table ville
        NSArray *les_villes = [sqliteManager selectAllFrom:@"ville"];
        NSLog(@"Voici les villes récupérées en base de données: %@", les_villes);
        
        //Création d'un objet Ville à partir d'une ville récupérer dans la table (ici Paris)
        Ville *villeRecup = (Ville *)[villeManager getFromDb:[NSString stringWithFormat:@"%d", (int)paris.ville_id]];
        NSLog(@"Instanciation d'un objet ville récupéré en base (id = %ld): \nVoici les propriétés de l'objet: \n\tNom:%@ \n\tcode_postal:%@ \n\tnom_maire:%@", paris.ville_id, villeRecup.nom, villeRecup.code_postal, villeRecup.nom_maire);
        
        
        //Suppression d'un objet en base
        BOOL marseilleDeleted = [villeManager deleteFromDb:marseille];
        
        if(marseilleDeleted){
            NSLog(@"Une ville (Marseille) a été supprimée de la base de données");
            
            //Récupération des données de la table ville
            les_villes = [sqliteManager selectAllFrom:@"ville"];
            NSLog(@"Voici l'état de la table ville après la suppression: %@", les_villes);
            
        }else{
            NSLog(@"La ville n'a pas été supprimée de la base de données");
        }
        
        [sqliteManager closeDb];
        
    }
    return 0;
}

