//
//  User.h
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/6/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject


@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSSet *breadcrum;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addBreadcrumObject:(NSManagedObject *)value;
- (void)removeBreadcrumObject:(NSManagedObject *)value;
- (void)addBreadcrum:(NSSet *)values;
- (void)removeBreadcrum:(NSSet *)values;

@end
