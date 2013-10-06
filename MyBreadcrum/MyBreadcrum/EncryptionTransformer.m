//
//  EncryptionTransformer.m
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/2/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import "EncryptionTransformer.h"


#import "RNEncryptor.h"
#import "RNDecryptor.h"

#import "ACAppDelegate.h"

@interface EncryptionTransformer (Private)


@end
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
    // discussion. They key should be established from either credential data when the app
    // is meant to be used only by one user or based on one of the new UUID replacements if it
    // is device dependent. For this POC no special key will be chosen. Bare in mind that
    // any key that is present in the code is public, because people can read it.
    
    return [APP_DELEGATE encryptionKey];
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
    NSError * error = nil;
    NSData *xValue = [RNEncryptor encryptData:data withSettings:kRNCryptorAES256Settings password:[self key] error:&error];
#if DEBUG
    if (error)
        NSLog(@"Error encrypting data %@",error);
#endif
    return xValue;
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
    
    NSError * error = nil;
    NSData *value = [RNDecryptor decryptData:data withPassword:[self key] error:&error];
#if DEBUG
    if (error)
        NSLog(@"Error encrypting data %@",error);
#endif
    
    // secure apps should not profusely log data or give too much detail on security issues
    return value;
}

@end