//
//  ACAppDelegate.h
//  MyBreadcrum
//
//  Created by Francisco Gindre on 9/30/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "User.h"

#define APP_DELEGATE (ACAppDelegate*)[[UIApplication sharedApplication] delegate]

@interface ACAppDelegate : UIResponder <UIApplicationDelegate>{
@private
    NSManagedObjectContext          *_managedObjectContext;
    NSManagedObjectModel            *_managedObjectModel;
    NSPersistentStoreCoordinator    *_persistentStoreCoordinator;
}

@property (strong, nonatomic) UIWindow  *window;
@property (strong, nonatomic) User      *currentUser;



@property (nonatomic, strong, readonly) NSManagedObjectContext          *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel            *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator    *persistentStoreCoordinator;

-(NSURL *)applicationDocumentsDirectory;

-(NSString*)encryptionKey;
-(BOOL)saveContext;
@end
