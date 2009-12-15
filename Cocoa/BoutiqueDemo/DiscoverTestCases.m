//
//  DiscoverTestCases.m
//  BoutiqueDemo
//
//  Copyright (c) 2009 Sweeter Rhythm LLC/No Thirst Software LLC/Atomic Bird LLC
//  All rights reserved.
//  BSD License http://www.opensource.org/licenses/bsd-license.php
//

#import "DiscoverTestCases.h"
#import "CocoaBoutique.h"

@implementation DiscoverTestCases

- (void)testDiscoverNumbers {
	CocoaBoutique *cb = [[CocoaBoutique alloc] init];
	
	// Test valid Discover card numbers
	NSArray *goodNumbers = [NSArray arrayWithObjects:@"6011111111111117", @"6011000990139424", @"6441000990139424", @"6491000990139423",nil];
	
	for (NSString *num in goodNumbers) {
		STAssertTrue([cb isValidDiscoverNumber:num], @"Card number %@ should test as valid", num);
	}
	
	// Invalid card numbers
	STAssertFalse([cb isValidDiscoverNumber:nil], @"Card number nil should return NO");
	
	NSArray *badNumbers = [NSArray arrayWithObjects:@"601100099013", @"6491000990139422", @"4111111111111111", @"5424000000000015",nil];
	
	for (NSString *num in badNumbers) {
		STAssertFalse([cb isValidDiscoverNumber:num], @"Card number %@ should test as invalid", num);
	}

	[cb release];
}

@end
