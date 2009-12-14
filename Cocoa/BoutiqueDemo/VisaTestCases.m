//
//  VisaTestCases.m
//  BoutiqueDemo
//
//  Copyright (c) 2009 Sweeter Rhythm LLC/No Thirst Software LLC/Atomic Bird LLC
//  All rights reserved.
//  BSD License http://www.opensource.org/licenses/bsd-license.php
//

#import "VisaTestCases.h"
#import "CocoaBoutique.h"

@implementation VisaTestCases

- (void)testVisaNumbers {
	CocoaBoutique *cb = [[CocoaBoutique alloc] init];
	
	// Test valid Visa card numbers
	NSArray *goodNumbers = [NSArray arrayWithObjects:@"4408041234567893", @"4111111111111111", @"4012888888881881", @"4222222222222",nil];
	
	for (NSString *num in goodNumbers) {
		STAssertTrue([cb isValidVisaNumber:num], @"Card number %@ should test as valid", num);
	}
	
	// Invalid card numbers
	STAssertFalse([cb isValidVisaNumber:nil], @"Card number nil should return NO");
	NSArray *badNumbers = [NSArray arrayWithObjects:@"4408041234567890", @"41111111111114", @"4111111111111110", @"4452517017358008", @"4640180219717067", @"0", @"4", @"422222222222", @"5500000000000004", @"6491000990139423", nil];
	
	for (NSString *num in badNumbers) {
		STAssertFalse([cb isValidVisaNumber:num], @"Card number %@ should test as invalid", num);
	}

	[cb release];
}

@end
