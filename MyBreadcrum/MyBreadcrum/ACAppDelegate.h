//
//  ACAppDelegate.h
//  MyBreadcrum
//
//  Created by Francisco Gindre on 9/30/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ACAppDelegate : UIResponder <UIApplicationDelegate>{
@private
    NSManagedObjectContext          *managedObjectContext_;
    NSManagedObjectModel            *managedObjectModel_;
    NSPersistentStoreCoordinator    *persistentStoreCoordinator_;
}

@property (strong, nonatomic) UIWindow *window;




@property (nonatomic, strong, readonly) NSManagedObjectContext          *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel            *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator    *persistentStoreCoordinator;

-(NSURL *)applicationDocumentsDirectory;

-(NSString*)encryptionKey;
@end
