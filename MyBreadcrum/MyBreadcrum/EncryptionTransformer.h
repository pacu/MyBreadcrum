//
//  EncryptionTransformer.h
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/2/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryptionTransformer : NSValueTransformer
{}

/**
 * Returns the key used for encrypting / decrypting values during transformation.
 */
- (NSString*)key;

@end
