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
	STAssertTrue([cb validateEmail:@"fraser@sweeterrhythm.com"],@"Email should be valid");
	STAssertTrue([cb validateEmail:@"fraser@sweeterrhythm.com.au"],@"Email should be valid");
	STAssertTrue([cb validateEmail:@"fraser@mail.sweeterrhythm.com.au"],@"Email should be valid");
	STAssertTrue([cb validateEmail:@"noreply-ads@facebookmail.com"],@"Email should be valid");
	STAssertTrue([cb validateEmail:@"circadm@ald.lib.co.us"],@"Email should be valid");
	STAssertTrue([cb validateEmail:@"fraser.hess@sr.com"],@"Email should be valid");
	STAssertTrue([cb validateEmail:@"NOREPLY@DIRECTV.com"],@"Email should be valid");
	STAssertTrue([cb validateEmail:@"ayrshire4096@hotmail.com"],@"Email should be valid");
	STAssertTrue([cb validateEmail:@"1password@gmail.com"],@"Email should be valid");
	STAssertTrue([cb validateEmail:@"notification+a2_f6aay@facebookmail.com"],@"Email should be valid");
	STAssertTrue([cb validateEmail:@"qdoba_mexican_grill@marketing.qdoba.com"],@"Email should be valid");
	STAssertTrue([cb validateEmail:@"number10@petitions.pm.gov.uk"],@"Email should be valid");
	STAssertTrue([cb validateEmail:@"noreply-ads@facebookmail.com"],@"Email should be valid");
	STAssertTrue([cb validateEmail:@"noreply-ads@facebookmail.com"],@"Email should be valid");
	STAssertTrue([cb validateEmail:@"noreply-ads@facebookmail.com"],@"Email should be valid");
	STAssertTrue([cb validateEmail:@"noreply-ads@facebookmail.com"],@"Email should be valid");
	STAssertTrue([cb validateEmail:@"noreply-ads@facebookmail.com"],@"Email should be valid");

	// Negative tests
	STAssertFalse([cb validateEmail:@"frasersweeterrhythm.com"],@"Email isn't valid");
	STAssertFalse([cb validateEmail:@"fraser@sweeterrhythm"],@"Email isn't valid");
	STAssertFalse([cb validateEmail:@"DIRECTV <NOREPLY@DIRECTV.com>"],@"Email isn't valid");
	STAssertFalse([cb validateEmail:@"Abc.@example.com"],@"Email isn't valid");
	STAssertFalse([cb validateEmail:@"Abc..123@example.com"],@"Email isn't valid");
	STAssertFalse([cb validateEmail:@"A@b@c@example.com"],@"Email isn't valid");
	STAssertFalse([cb validateEmail:@"rené@facebook.com"],@"Email isn't valid");

	
	[cb release];
}

@end
