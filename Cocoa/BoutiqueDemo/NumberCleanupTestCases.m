//
//  NumberCleanupTestCases.m
//  BoutiqueDemo
//
//  Copyright (c) 2009 Sweeter Rhythm LLC/No Thirst Software LLC/Atomic Bird LLC
//  All rights reserved.
//  BSD License http://www.opensource.org/licenses/bsd-license.php
//

#import "NumberCleanupTestCases.h"
#import "CocoaBoutique.h"

@implementation NumberCleanupTestCases


- (void)testNumberCleanup {
	CocoaBoutique *cb = [[CocoaBoutique alloc] init];
	STAssertEqualObjects([cb cleanNumber:@"4111111111111111"],@"4111111111111111",@"Returned string not cleaned correctly");
	STAssertEqualObjects([cb cleanNumber:@"4111-1111-1111-1111"],@"4111111111111111",@"Returned string not cleaned correctly");
	STAssertEqualObjects([cb cleanNumber:@"4111 1111 1111 1111"],@"4111111111111111",@"Returned string not cleaned correctly");
	STAssertEqualObjects([cb cleanNumber:@"zzzz4111 1111 1111 1111"],@"4111111111111111",@"Returned string not cleaned correctly");
	STAssertEqualObjects([cb cleanNumber:@"1a2b3c"],@"123",@"Returned string not cleaned correctly");
	STAssertEqualObjects([cb cleanNumber:@"123jkl"],@"123",@"Returned string not cleaned correctly");
	STAssertEqualObjects([cb cleanNumber:@"!@#$%^&1234"],@"1234",@"Returned string not cleaned correctly");
	STAssertEqualObjects([cb cleanNumber:@"4111- 1111- 1111- 1111"],@"4111111111111111",@"Returned string not cleaned correctly");
	STAssertEqualObjects([cb cleanNumber:@"fraggle"],@"",@"Returned string not cleaned correctly");
	STAssertEqualObjects([cb cleanNumber:@"0123456789"],@"0123456789",@"Returned string not cleaned correctly");
	STAssertEqualObjects([cb cleanNumber:@"-123456.789"],@"123456789",@"Returned string not cleaned correctly");

	[cb release];
}
@end
