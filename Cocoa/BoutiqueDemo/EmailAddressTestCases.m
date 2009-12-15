//
//  EmailAddressTestCases.m
//  BoutiqueDemo
//
//  Created by Fraser Hess on 12/11/09.
//  Copyright 2009 Sweeter Rhythm. All rights reserved.
//

#import "EmailAddressTestCases.h"
#import "CocoaBoutique.h"

@implementation EmailAddressTestCases

-(void)testEmailValidation {
	CocoaBoutique *cb = [[CocoaBoutique alloc] init];
	
	// Positive tests
	NSArray *goodEmails = [NSArray arrayWithObjects:@"fraser@sweeterrhythm.com", @"fraser@sweeterrhythm.com.au", @"fraser@mail.sweeterrhythm.com.au", @"noreply-ads@facebookmail.com", @"circadm@ald.lib.co.us", @"fraser.hess@sr.com", @"NOREPLY@DIRECTV.com", @"ayrshire4096@hotmail.com", @"1password@gmail.com", @"notification+a2_f6aay@facebookmail.com", @"qdoba_mexican_grill@marketing.qdoba.com", @"number10@petitions.pm.gov.uk", nil];
	
	for (NSString *email in goodEmails) {
		STAssertTrue([cb validateEmail:email], @"Email address %@ should test as valid", email);
	}
	
	// Negative tests
	STAssertFalse([cb validateEmail:nil], @"Nil should test as invalid");
	NSArray *badEmails = [NSArray arrayWithObjects:@"", @"frasersweeterrhythm.com", @"fraser@sweeterrhythm", @"DIRECTV <NOREPLY@DIRECTV.com>", @"Abc.@example.com", @"Abc..123@example.com", @"A@b@c@example.com", @"rené@facebook.com", nil];
	
	for (NSString *email in badEmails) {
		STAssertFalse([cb validateEmail:email], @"Email address %@ should test as invalid", email);
	}

	[cb release];
}

@end
