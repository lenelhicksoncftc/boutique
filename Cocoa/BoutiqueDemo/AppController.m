//
//  AppController.m
//  BoutiqueDemo
//
//  Created by Fraser Hess on 3/31/09.
//  Copyright 2009 Sweeter Rhythm. All rights reserved.
//

#import "AppController.h"
#import "AquaticPrime.h"

@implementation AppController

- (IBAction)showBoutique:(id)sender {
	if (!boutique) {
		boutique = [[CocoaBoutique alloc] init];
		[boutique setDelegate:self];
	}
	[boutique showWindow:self];
}

- (void)awakeFromNib {
	// Hide Purchase menu if license exists
	if ([[NSFileManager defaultManager] fileExistsAtPath:[self pathToLicenseFile]]) {
		if ([[self licenseValidator] verifyLicenseFile:[self pathToLicenseFile]])
			[mainMenu removeItem:purchaseMenu];
	}
}

- (NSString *)applicationSupportFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    return [basePath stringByAppendingPathComponent:@"BoutiqueDemo"];
}

- (NSString *)pathToLicenseFile {
	return [[self applicationSupportFolder] stringByAppendingPathComponent:@"license.plist"];
}																		

#pragma mark CocoaBoutique delegate methods

- (NSString *)productName {
	return [NSString stringWithString:@"Demo"];
}

- (NSString *)storeURL {
	return [NSString stringWithString:@"http://demo.com/store/"];
}

- (AquaticPrime *)licenseValidator {
	
	// This string is specially constructed to prevent key replacement 	// *** Begin Public Key ***
	NSMutableString *key = [NSMutableString string];
	[key appendString:@"0x"];
	[key appendString:@"A"];
	[key appendString:@"A"];
	[key appendString:@"6C2C8BDFFE238FD5611C8CF6A5"];
	[key appendString:@"6250C0723850FE87483FA8B30EFAE7"];
	[key appendString:@"69"];
	[key appendString:@"0"];
	[key appendString:@"0"];
	[key appendString:@"04B06B286E77C1592779635496"];
	[key appendString:@"8EA"];
	[key appendString:@"9"];
	[key appendString:@"9"];
	[key appendString:@"05D9933AFCDBACBAC9E6B90A6"];
	[key appendString:@"E8F069B9BEC"];
	[key appendString:@"D"];
	[key appendString:@"D"];
	[key appendString:@"D95165C88CFBABE82"];
	[key appendString:@"8967A3B495"];
	[key appendString:@"C"];
	[key appendString:@"C"];
	[key appendString:@"2F3A6B6124D640822C"];
	[key appendString:@"19B37DC7DC852"];
	[key appendString:@"4"];
	[key appendString:@"4"];
	[key appendString:@"928C66676F98D03"];
	[key appendString:@"7D237"];
	[key appendString:@"5"];
	[key appendString:@"5"];
	[key appendString:@"29245D6C8D787434409139B"];
	[key appendString:@"1A24D1F3A781964A91"];
	// *** End Public Key *** 
	return [AquaticPrime aquaticPrimeWithKey:key];
}

- (void)serverError:(NSString *)error {
	NSAlert *alert = [NSAlert alertWithMessageText:@"Error" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:error];
	[alert runModal];
}

- (void)validLicense:(BOOL)valid withLicenseData:(NSData *)licenseData {
	NSLog(@"%@", licenseData);
	if (valid) {
		NSString *applicationSupportFolder = [self applicationSupportFolder];
		if (![[NSFileManager defaultManager] fileExistsAtPath:applicationSupportFolder isDirectory:NULL] ) {
			[[NSFileManager defaultManager] createDirectoryAtPath:applicationSupportFolder attributes:nil];
		}
		[licenseData writeToFile:[self pathToLicenseFile] atomically:YES];
		NSAlert *alert = [NSAlert alertWithMessageText:@"License Validated" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"Congrats"];
		[alert runModal];
	} else {
		NSAlert *alert = [NSAlert alertWithMessageText:@"License Not Validated" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"Sorry."];
		[alert runModal];
	}
}

// Optional delegate method to override SSL requirement
- (BOOL)overrideSSL {
	return NO;
}

@end
