//
//  ACDateEncryptionTransformer.m
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/3/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import "ACDateEncryptionTransformer.h"

@implementation ACDateEncryptionTransformer
+ (Class)transformedValueClass
{
    return [NSDate class];
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
