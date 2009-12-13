//
//  AmexTestCases.m
//  BoutiqueDemo
//
//  Created by Fraser Hess on 12/12/09.
//  Copyright 2009 Sweeter Rhythm. All rights reserved.
//

#import "AmexTestCases.h"
#import "CocoaBoutique.h"

@implementation AmexTestCases

- (void)testAmexNumbers {
	CocoaBoutique *cb = [[CocoaBoutique alloc] init];
	// Test valid Amex card numbers
	STAssertTrue([cb isValidAmexNumber:@"378282246310005"], @"Card number 378282246310005 should return YES");
	STAssertTrue([cb isValidAmexNumber:@"371449635398431"], @"Card number 371449635398431 should return YES");
	STAssertTrue([cb isValidAmexNumber:@"378734493671000"], @"Card number 378734493671000 should return YES");
	STAssertTrue([cb isValidAmexNumber:@"340000000000009"], @"Card number 340000000000009 should return YES");
	
	// Invalid card numbers that look like Amex numbers
	STAssertFalse([cb isValidAmexNumber:nil], @"Card number nil should return NO");
	STAssertFalse([cb isValidAmexNumber:@"0"],@"Card number 0 should return NO");
	STAssertFalse([cb isValidAmexNumber:@"34"],@"Card number 4 should return NO");
	STAssertFalse([cb isValidAmexNumber:@"340000000000004"], @"Card number 34000000000000 should return NO");
	
	// Test other cards
	STAssertFalse([cb isValidAmexNumber:@"5500000000000004"],@"Card number 5500000000000004 should return NO");
	STAssertFalse([cb isValidAmexNumber:@"6491000990139423"],@"Card number 6441000990139424 should return NO");
	
	[cb release];
}

@end
