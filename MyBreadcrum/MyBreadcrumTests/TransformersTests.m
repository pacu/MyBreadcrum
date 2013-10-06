//
//  TransformersTests.m
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/3/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ACDateEncryptionTransformer.h"
#import "ACImageEncryptionTransformer.h"
#import "StringEncryptionTransformer.h"

@interface TransformersTests : XCTestCase

@end

@implementation TransformersTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

-(void)testDateEncryption{
    ACDateEncryptionTransformer * cryptor = [[ACDateEncryptionTransformer alloc]init];
    NSDate *expectedDate = [NSDate date];
    
    NSData *encryptedDate =[cryptor transformedValue:expectedDate];
    XCTAssertNotEqual(encryptedDate, expectedDate, @"this should not be the same");
    XCTAssertNotNil(encryptedDate, @"encryptedDate can't be nil" );
    
    NSDate *decryptedDate = [cryptor reverseTransformedValue:encryptedDate];
    XCTAssertNotNil(decryptedDate, @"decrypted data should not be nil");
    XCTAssertNotEqualObjects(encryptedDate, decryptedDate, @"decrypted date and encrypted data should not be the same");
    XCTAssertTrue([decryptedDate isEqualToDate:expectedDate], @"decrypted data is not what was expected");
    
    
}


@end
