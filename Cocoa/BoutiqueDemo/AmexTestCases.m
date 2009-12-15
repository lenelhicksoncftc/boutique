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
	NSArray *goodNumbers = [NSArray arrayWithObjects:@"378282246310005", @"371449635398431", @"378734493671000", @"340000000000009", nil];
	
	for (NSString *num in goodNumbers) {
		STAssertTrue([cb isValidAmexNumber:num], @"Card number %@ should test as valid", num);
	}
	
	// Invalid card numbers
	STAssertFalse([cb isValidAmexNumber:nil], @"Card number nil should return NO");
	NSArray *badNumbers = [NSArray arrayWithObjects:@"0", @"34", @"340000000000004", @"5500000000000004", @"6491000990139423", nil];
	
	for (NSString *num in badNumbers) {
		STAssertFalse([cb isValidAmexNumber:num], @"Card number %@ should test as invalid", num);
	}
	
	[cb release];
}

@end
