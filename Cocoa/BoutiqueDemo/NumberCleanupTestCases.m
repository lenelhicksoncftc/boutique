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
	STAssertEqualObjects([cb stripNonDigits:@"4111111111111111"],@"4111111111111111",@"Returned string not cleaned correctly");
	STAssertEqualObjects([cb stripNonDigits:@"4111-1111-1111-1111"],@"4111111111111111",@"Returned string not cleaned correctly");
	STAssertEqualObjects([cb stripNonDigits:@"4111 1111 1111 1111"],@"4111111111111111",@"Returned string not cleaned correctly");
	STAssertEqualObjects([cb stripNonDigits:@"zzzz4111 1111 1111 1111"],@"4111111111111111",@"Returned string not cleaned correctly");
	STAssertEqualObjects([cb stripNonDigits:@"1a2b3c"],@"123",@"Returned string not cleaned correctly");
	STAssertEqualObjects([cb stripNonDigits:@"123jkl"],@"123",@"Returned string not cleaned correctly");
	STAssertEqualObjects([cb stripNonDigits:@"!@#$%^&1234"],@"1234",@"Returned string not cleaned correctly");
	STAssertEqualObjects([cb stripNonDigits:@"4111- 1111- 1111- 1111"],@"4111111111111111",@"Returned string not cleaned correctly");
	STAssertEqualObjects([cb stripNonDigits:@"fraggle"],@"",@"Returned string not cleaned correctly");
	STAssertEqualObjects([cb stripNonDigits:@"0123456789"],@"0123456789",@"Returned string not cleaned correctly");
	STAssertEqualObjects([cb stripNonDigits:@"-123456.789"],@"123456789",@"Returned string not cleaned correctly");

	[cb release];
}
@end
