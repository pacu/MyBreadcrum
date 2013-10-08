//
//  Location.h
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/6/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Breadcrumb;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSSet *breadcrum;
@end

@interface Location (CoreDataGeneratedAccessors)

- (void)addBreadcrumObject:(Breadcrumb *)value;
- (void)removeBreadcrumObject:(Breadcrumb *)value;
- (void)addBreadcrum:(NSSet *)values;
- (void)removeBreadcrum:(NSSet *)values;

@end
