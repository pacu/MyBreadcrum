//
//  ACArchivableTypeTransformer.m
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/3/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import "ACArchivableTypeTransformer.h"

@implementation ACArchivableTypeTransformer
+ (Class)transformedValueClass
{
    return [NSObject class];
}

- (id)transformedValue:(NSDate*)date
{
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:date ];
    return [super transformedValue:data];
}

- (id)reverseTransformedValue:(NSData*)data
{
    if (data == nil)
    {
        return nil;
    }
    
    data = [super reverseTransformedValue:data];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}
@end
