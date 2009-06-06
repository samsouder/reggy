//
//  MainController.h
//  Reggy
//
//  Created by Samuel Souder on 6/6/09.
//  Copyright Sam Souder 2009 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainController : NSObject 
{
    IBOutlet NSWindow *window;
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSManagedObjectModel *)managedObjectModel;
- (NSManagedObjectContext *)managedObjectContext;

- (IBAction)saveAction:sender;

@end
