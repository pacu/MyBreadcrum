//
//  EncryptionTransformer.m
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/2/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import "EncryptionTransformer.h"
#import <RNCryptor/RNCryptor.h>
#import <RNCryptor/RNEncryptor.h>
#import <RNCryptor/RNDecryptor.h>

@implementation EncryptionTransformer

+ (Class)transformedValueClass
{
    return [NSData class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
    
}

- (NSString*)key
{
    // Your version of this class might get this key from the app delegate or elsewhere.
    return @"secret key";
}

- (id)transformedValue:(NSData*)data
{
    // If there's no key (e.g. during a data migration), don't try to transform the data
    if (nil == [self key])
    {
        return data;
    }
    
    if (nil == data)
    {
        return nil;
    }
    
    return [data dataAES256EncryptedWithKey:[self key]];
}

- (id)reverseTransformedValue:(NSData*)data
{
    // If there's no key (e.g. during a data migration), don't try to transform the data
    if (nil == [self key])
    {
        return data;
    }
    
    if (nil == data)
    {
        return nil;
    }
    
    return [data dataAES256DecryptedWithKey:[self key]];
}

@end