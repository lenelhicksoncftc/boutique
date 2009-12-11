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
	STAssertFalse([cb isValidLuhnNumber:nil], @"Card number nil should return NO");
	STAssertFalse([cb isValidLuhnNumber:@"4408041234567890"],@"Card number 4408041234567890 should return NO");
	STAssertTrue([cb isValidLuhnNumber:@"4408041234567893"],@"Card number 4408041234567893 should return YES");
	STAssertTrue([cb isValidLuhnNumber:@"41111111111114"],@"Card number 41111111111114 should return YES");
	STAssertTrue([cb isValidLuhnNumber:@"4111111111111111"],@"Card number 4111111111111111 should return YES");
	STAssertFalse([cb isValidLuhnNumber:@"4111111111111110"],@"Card number 4111111111111110 should return NO");
	STAssertTrue([cb isValidLuhnNumber:@"4012888888881881"],@"Card number 4012888888881881 should return YES");
	STAssertTrue([cb isValidLuhnNumber:@"5555555555554444"],@"Card number 5555555555554444 should return YES");
	STAssertTrue([cb isValidLuhnNumber:@"5105105105105100"],@"Card number 5105105105105100 should return YES");
	STAssertFalse([cb isValidLuhnNumber:@"5105105105105101"],@"Card number 5105105105105101 should return NO");
	STAssertTrue([cb isValidLuhnNumber:@"5500000000000004"],@"Card number 5500000000000004 should return YES");
	STAssertTrue([cb isValidLuhnNumber:@"378282246310005"],@"Card number 378282246310005 should return YES");
	STAssertTrue([cb isValidLuhnNumber:@"371449635398431"],@"Card number 371449635398431 should return YES");
	STAssertTrue([cb isValidLuhnNumber:@"378734493671000"],@"Card number 378734493671000 should return YES");
	STAssertTrue([cb isValidLuhnNumber:@"6011111111111117"],@"Card number 6011111111111117 should return YES");
	STAssertTrue([cb isValidLuhnNumber:@"6011000990139424"],@"Card number 6011000990139424 should return YES");
	STAssertTrue([cb isValidLuhnNumber:@"5424000000000015"],@"Card number 5424000000000015 should return YES");
	STAssertTrue([cb isValidLuhnNumber:@"6011111111111117"],@"Card number 6011111111111117 should return YES");

	[cb release];
}

@end
