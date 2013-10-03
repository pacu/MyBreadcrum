//
//  StringEncryptionTransformer.m
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/3/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import "StringEncryptionTransformer.h"

@implementation StringEncryptionTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

- (id)transformedValue:(NSString*)string
{
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [super transformedValue:data];
}

- (id)reverseTransformedValue:(NSData*)data
{
    if (nil == data)
    {
        return nil;
    }
    
    data = [super reverseTransformedValue:data];
    
    return [[NSString alloc] initWithBytes:[data bytes]
                                     length:[data length]
                                  encoding:NSUTF8StringEncoding];
}

@end
