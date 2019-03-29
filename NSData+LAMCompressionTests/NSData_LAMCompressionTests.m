//
//  NSData_LAMCompressionTests.m
//  NSData+LAMCompressionTests
//
//  Created by Lee Morgan on 7/15/15.
//  Copyright © 2015 Lee Morgan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSData+LAMCompression.h"

@interface NSData_LAMCompressionTests : XCTestCase

@end

@implementation NSData_LAMCompressionTests

- (void)setUp {
	[super setUp];
}

- (void)tearDown {
	[super tearDown];
}

/// lam_dataWithContentsOfArchive
- (void)test_lam_dataWithContentsOfArchive {
	
	NSData *verifiedData = [self testDataOfType:@"txt"];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"TestData" ofType:@"lzfse"];
	NSAssert(path != nil, @"Failed to get test data path");
	
	
	// Test with good path
	NSData *uncompressedData = [NSData lam_dataWithContentsOfArchive:path];
	XCTAssertTrue([uncompressedData isEqualToData:verifiedData]);
	
	// Test invalid path
	NSData *nilUncompressedData = [NSData lam_dataWithContentsOfArchive:nil];
	XCTAssertNil(nilUncompressedData);
}

/// lam_dataWithContentsOfArchvie:compression: tests
- (void)test_lam_dataWithContentsOfArchvie_compression {
	
	NSData *verifiedData = [self testDataOfType:@"txt"];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"TestData" ofType:@"lzfse"];
	NSAssert(path != nil, @"Failed to get test data path");
	
	
	// Test with good path and compression
	NSData *uncompressedData = [NSData lam_dataWithContentsOfArchive:path usedCompression:LAMCompressionLZFSE];
	XCTAssertTrue([uncompressedData isEqualToData:verifiedData]);
	
	// Test wrong compression algorithm
	NSData *uncompressedData2 = [NSData lam_dataWithContentsOfArchive:path usedCompression:LAMCompressionLZ4];
	XCTAssertNil(uncompressedData2);
	
	// Test invalid compression algorithm
	XCTAssertThrows([NSData lam_dataWithContentsOfArchive:path usedCompression:42]);
	
	// Test invalid path
	NSData *nilUncompressedData = [NSData lam_dataWithContentsOfArchive:nil usedCompression:LAMCompressionLZFSE];
	XCTAssertNil(nilUncompressedData);
}

/// lam_initWithContentsOfArchive tests
- (void)test_lam_initWithContentsOfArchive {
	
	NSData *verifiedData = [self testDataOfType:@"txt"];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"TestData" ofType:@"lzfse"];
	NSAssert(path != nil, @"Failed to get test data path");
	
	
	// Test with good path
	NSData *uncompressedData = [[NSData alloc] lam_initWithContentsOfArchive:path];
	XCTAssertTrue([uncompressedData isEqualToData:verifiedData]);
	
	// Test invalid path
	NSData *nilUncompressedData = [[NSData alloc] lam_initWithContentsOfArchive:nil];
	XCTAssertNil(nilUncompressedData);
}

/// lam_initWithContentsOfArchive_compression tests
- (void)test_lam_initWithContentsOfArchive_compression {
	
	NSData *verifiedData = [self testDataOfType:@"txt"];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"TestData" ofType:@"lzfse"];
	
	// Test with good path and compression
	NSData *uncompressedData = [[NSData alloc] lam_initWithContentsOfArchive:path compression:LAMCompressionLZFSE];
	XCTAssertTrue([uncompressedData isEqualToData:verifiedData]);
	
	// Test invalid compression algorithm
	NSData *uncompressedData2 = [[NSData alloc] lam_initWithContentsOfArchive:path compression:LAMCompressionLZ4];
	XCTAssertNil(uncompressedData2);
	
	// Test invalid compression algorithm
	XCTAssertThrows([[NSData alloc] lam_initWithContentsOfArchive:path compression:42]);
	
	// Test invalid path
	NSData *nilUncompressedData = [[NSData alloc] lam_initWithContentsOfArchive:nil compression:LAMCompressionLZFSE];
	XCTAssertNil(nilUncompressedData);
}

/// lam_uncompressedDataUsingCompression tests
- (void)test_uncompressedDataUsingCompression {
	
	NSData *compressedData;
	NSData *uncompressedData;
	NSData *verifiedData = [self testDataOfType:@"txt"];
	
	// Test LZ4
	compressedData = [self testDataOfType:@"lz4"];
	uncompressedData = [compressedData lam_uncompressedDataUsingCompression:LAMCompressionLZ4];
	XCTAssertTrue([uncompressedData isEqualToData:verifiedData]);
	
	// Test ZLIB
	compressedData = [self testDataOfType:@"zlib"];
	uncompressedData = [compressedData lam_uncompressedDataUsingCompression:LAMCompressionZLIB];
	XCTAssertTrue([uncompressedData isEqualToData:verifiedData]);
	
	// Test LZMA
	compressedData = [self testDataOfType:@"lzma"];
	uncompressedData = [compressedData lam_uncompressedDataUsingCompression:LAMCompressionLZMA];
	XCTAssertTrue([uncompressedData isEqualToData:verifiedData]);
	
	// Test LZFSE
	compressedData = [self testDataOfType:@"lzfse"];
	uncompressedData = [compressedData lam_uncompressedDataUsingCompression:LAMCompressionLZFSE];
	XCTAssertTrue([uncompressedData isEqualToData:verifiedData]);
	
	
	// Test nil data input
	// Since we're sending a message to nil, we'd had better get nil back
	compressedData = nil;
	uncompressedData = [compressedData lam_uncompressedDataUsingCompression:LAMCompressionLZ4];
	XCTAssertNil(uncompressedData);
	
	// Test invalid compression input
	compressedData = [self testDataOfType:@"lzfse"];
	XCTAssertThrows([compressedData lam_uncompressedDataUsingCompression:-1]);
	XCTAssertThrows([compressedData lam_uncompressedDataUsingCompression:42]);
}


/// lam_compressedDataUsingCompression tests
- (void)test_compressedDataUsingCompression {
	
	NSData *uncompressedData = [self testDataOfType:@"txt"];
	NSData *compressedData;
	NSData *verifiedData;
	
	// Test LZ4
	compressedData = [uncompressedData lam_compressedDataUsingCompression:LAMCompressionLZ4];
	verifiedData = [self testDataOfType:@"lz4"];
	XCTAssertTrue([compressedData isEqualToData:verifiedData]);
	
	// Test ZLIB
	compressedData = [uncompressedData lam_compressedDataUsingCompression:LAMCompressionZLIB];
	verifiedData = [self testDataOfType:@"zlib"];
	XCTAssertTrue([compressedData isEqualToData:verifiedData]);
	
	// Test LZMA
	compressedData = [uncompressedData lam_compressedDataUsingCompression:LAMCompressionLZMA];
	verifiedData = [self testDataOfType:@"lzma"];
	XCTAssertTrue([compressedData isEqualToData:verifiedData]);
	
	// Test LZFSE
	compressedData = [uncompressedData lam_compressedDataUsingCompression:LAMCompressionLZFSE];
	verifiedData = [self testDataOfType:@"lzfse"];
	XCTAssertTrue([compressedData isEqualToData:verifiedData]);
	
	// Test invalid compression input
	XCTAssertThrows([uncompressedData lam_compressedDataUsingCompression:-1]);
	XCTAssertThrows([uncompressedData lam_compressedDataUsingCompression:42]);
}

/// Basic in memory Compression and Uncompression test
- (void)test_simpleStringCompression {
	
	NSString *testString = @"Hello World";
	NSData *testStringData = [NSData dataWithBytes:[testString cStringUsingEncoding:NSUTF8StringEncoding] length:testString.length];
	
	NSData *compressedData = [testStringData lam_compressedDataUsingCompression:LAMCompressionLZFSE];
	NSData *uncompressedData = [compressedData lam_uncompressedDataUsingCompression:LAMCompressionLZFSE];
	
	NSString *uncompressedString = [NSString stringWithUTF8String:uncompressedData.bytes];
	
	XCTAssertEqualObjects(testString, uncompressedString);
}

/// Don't infinite loop when given bad data
- (void)test_infiniteLoopDecompression {
    
    NSString *testString = @"[]";
    NSData *testStringData = [testString dataUsingEncoding:NSUTF8StringEncoding];
    
    [testStringData lam_uncompressedDataUsingCompression:LAMCompressionLZFSE];
    
    XCTAssertTrue(YES, @"Test didn't hang in infinite loop");
}


//--------------------------------------------------------
// Support Methods
//--------------------------------------------------------

/// Test Support method
- (NSData *)testDataOfType:(NSString *)type {
	
	NSString *testDataPath = [[NSBundle mainBundle] pathForResource:@"TestData" ofType:type];
	NSData *testData = [NSData dataWithContentsOfFile:testDataPath];
	
	NSAssert(testData != nil, @"Failed to load test data");
	
	return testData;
}

@end
