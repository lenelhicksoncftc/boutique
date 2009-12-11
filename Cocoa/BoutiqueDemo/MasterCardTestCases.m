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
	STAssertTrue([cb isValidMasterCardNumber:@"5424000000000015"],@"Card number 5424000000000015 should return YES");
	STAssertTrue([cb isValidMasterCardNumber:@"5555555555554444"],@"Card number 5555555555554444 should return YES");
	STAssertTrue([cb isValidMasterCardNumber:@"5105105105105100"],@"Card number 5105105105105100 should return YES");
	STAssertTrue([cb isValidMasterCardNumber:@"5500000000000004"],@"Card number 5500000000000004 should return YES");
	
	// Invalid card numbers that look like MasterCard numbers
	STAssertFalse([cb isValidMasterCardNumber:nil], @"Card number nil should return NO");
	STAssertFalse([cb isValidMasterCardNumber:@"5105105105105101"],@"Card number 5105105105105101 should return NO");
	
	// Test other cards
	STAssertFalse([cb isValidMasterCardNumber:@"4111111111111111"],@"Card number 4111111111111111 should return NO");
	STAssertFalse([cb isValidMasterCardNumber:@"6011111111111117"],@"Card number 6011111111111117 should return NO");
	[cb release];
}

@end
