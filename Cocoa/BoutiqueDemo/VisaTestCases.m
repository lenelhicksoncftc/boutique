//
//  VisaTestCases.m
//  BoutiqueDemo
//
//  Created by Fraser Hess on 12/10/09.
//  Copyright 2009 Sweeter Rhythm. All rights reserved.
//

#import "VisaTestCases.h"
#import "CocoaBoutique.h"

@implementation VisaTestCases

- (void)testVisaNumbers {
	CocoaBoutique *cb = [[CocoaBoutique alloc] init];
	// Test valid Visa card numbers
	STAssertTrue([cb isValidVisaNumber:@"4408041234567893"],@"Card number 4408041234567893 should return YES");
	STAssertTrue([cb isValidVisaNumber:@"4111111111111111"],@"Card number 4111111111111111 should return YES");
	STAssertTrue([cb isValidVisaNumber:@"4012888888881881"],@"Card number 4012888888881881 should return YES");
	// Test 13 character number
	STAssertTrue([cb isValidVisaNumber:@"4222222222222"],@"Card number 4222222222222 should return YES");
	
	// Invalid card numbers that look like Visa numbers
	STAssertFalse([cb isValidVisaNumber:nil], @"Card number nil should return NO");
	STAssertFalse([cb isValidVisaNumber:@"4408041234567890"],@"Card number 4408041234567890 should return NO");
	STAssertFalse([cb isValidVisaNumber:@"41111111111114"],@"Card number 41111111111114 should return NO");
	STAssertFalse([cb isValidVisaNumber:@"4111111111111110"],@"Card number 4111111111111110 should return NO");
	
	// Test other cards
	STAssertFalse([cb isValidVisaNumber:@"5500000000000004"],@"Card number 5500000000000004 should return NO");
	STAssertFalse([cb isValidVisaNumber:@"6491000990139423"],@"Card number 6441000990139424 should return NO");

	[cb release];
}

@end
