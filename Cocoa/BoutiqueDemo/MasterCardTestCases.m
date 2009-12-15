//
//  MasterCardTestCases.m
//  BoutiqueDemo
//
//  Copyright (c) 2009 Sweeter Rhythm LLC/No Thirst Software LLC/Atomic Bird LLC
//  All rights reserved.
//  BSD License http://www.opensource.org/licenses/bsd-license.php
//

#import "MasterCardTestCases.h"
#import "CocoaBoutique.h"

@implementation MasterCardTestCases

- (void)testMasterCardNumbers {
	CocoaBoutique *cb = [[CocoaBoutique alloc] init];
	// Test valid MasterCard numbers
	NSArray *goodNumbers = [NSArray arrayWithObjects:@"5424000000000015", @"5555555555554444", @"5105105105105100", @"5500000000000004", nil];
	
	for (NSString *num in goodNumbers) {
		STAssertTrue([cb isValidMasterCardNumber:num], @"Card number %@ should test as valid", num);
	}
	
	// Invalid card numbers
	STAssertFalse([cb isValidMasterCardNumber:nil], @"Card number nil should return NO");
	NSArray *badNumbers = [NSArray arrayWithObjects:@"5105105105105101", @"4111111111111111",@"6011111111111117",nil];
	
	for (NSString *num in badNumbers) {
		STAssertFalse([cb isValidMasterCardNumber:num], @"Card number %@ should test as invalid", num);
	}

	[cb release];
}

@end
