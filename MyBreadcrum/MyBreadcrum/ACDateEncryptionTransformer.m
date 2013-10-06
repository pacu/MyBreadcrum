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

-(id)transformedValue:(NSDate*)value{
    return [super transformedValue:value];
}
-(NSDate*)reverseTransformedValue:(NSData*)value{
    return [super reverseTransformedValue:value];
}
@end
