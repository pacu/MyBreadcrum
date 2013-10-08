//
//  Breadcrum.h
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/6/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Location.h"
@class User;

@interface Breadcrumb : NSManagedObject

@property (nonatomic, retain) NSDate        *date;
@property (nonatomic, retain) NSString      *notes;
@property (nonatomic, retain) UIImage       *thumb;
@property (nonatomic, retain) NSString      *title;
@property (nonatomic, retain) Location      *location;
@property (nonatomic, retain) User          *user;

@end
