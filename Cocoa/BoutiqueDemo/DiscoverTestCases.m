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
	STAssertTrue([cb isValidDiscoverNumber:@"6011111111111117"],@"Card number 6011111111111117 should return YES");
	STAssertTrue([cb isValidDiscoverNumber:@"6011000990139424"],@"Card number 6011000990139424 should return YES");
	STAssertTrue([cb isValidDiscoverNumber:@"6441000990139424"],@"Card number 6441000990139424 should return YES");
	STAssertTrue([cb isValidDiscoverNumber:@"6491000990139423"],@"Card number 6491000990139423 should return YES");
	
	// Invalid card numbers that look like Discover numbers
	STAssertFalse([cb isValidDiscoverNumber:nil], @"Card number nil should return NO");
	STAssertFalse([cb isValidDiscoverNumber:@"601100099013"],@"Card number 601100099013 should return NO");
	STAssertFalse([cb isValidDiscoverNumber:@"6491000990139422"],@"Card number 6491000990139422 should return NO");

	// Test other cards
	STAssertFalse([cb isValidDiscoverNumber:@"4111111111111111"],@"Card number 4111111111111111 should return NO");
	STAssertFalse([cb isValidDiscoverNumber:@"5424000000000015"],@"Card number 5424000000000015 should return NO");

	[cb release];
}

@end
