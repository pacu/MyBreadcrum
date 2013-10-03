//
//  ACImageEncryptionTransformer.m
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/3/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import "ACImageEncryptionTransformer.h"

@implementation ACImageEncryptionTransformer

+ (Class)transformedValueClass
{
    return [UIImage class];
}

- (id)transformedValue:(UIImage*)image
{
    NSData* data =UIImagePNGRepresentation(image);
    return [super transformedValue:data];
}

- (id)reverseTransformedValue:(NSData*)data
{
    if (data == nil)
    {
        return nil;
    }
    
    data = [super reverseTransformedValue:data];
    
    return [UIImage imageWithData:data];
}


@end
