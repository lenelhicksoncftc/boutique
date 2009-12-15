//
//  LuhnTestCases.m
//  BoutiqueDemo
//
//  Copyright (c) 2009 Sweeter Rhythm LLC/No Thirst Software LLC/Atomic Bird LLC
//  All rights reserved.
//  BSD License http://www.opensource.org/licenses/bsd-license.php
//

#import "LuhnTestCases.h"
#import "CocoaBoutique.h"

@implementation LuhnTestCases

- (void)testLuhnAlgorithm {
	CocoaBoutique *cb = [[CocoaBoutique alloc] init];
	
	// Positive tests
	NSArray *goodNumbers = [NSArray arrayWithObjects:@"4408041234567893", @"41111111111114", @"4111111111111111", @"4012888888881881", @"5555555555554444", @"5105105105105100", @"5500000000000004", @"378282246310005", @"371449635398431", @"378734493671000", @"6011111111111117", @"6011000990139424", @"5424000000000015", @"0", @"30569309025904", @"38520000023237", @"3530111333300000", @"3566002020360505", @"6331101999990016", nil];
	
	for (NSString *num in goodNumbers) {
		STAssertTrue([cb isValidLuhnNumber:num], @"Card number %@ should test as valid", num);
	}
	
	// Negative tests
	STAssertFalse([cb isValidLuhnNumber:nil], @"Card number nil should return NO");

	NSArray *badNumbers = [NSArray arrayWithObjects:@"4408041234567890", @"4111111111111110", @"5105105105105101",nil];
	
	for (NSString *num in badNumbers) {
		STAssertFalse([cb isValidLuhnNumber:num], @"Card number %@ should test as invalid", num);
	}
	
	[cb release];
}

@end
