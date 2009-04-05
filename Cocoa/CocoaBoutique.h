//
//  CocoaBoutique.h
//
//  Created by Fraser Hess on 2/23/09.
//

#import <Cocoa/Cocoa.h>
#import "AquaticPrime.h"

@interface CocoaBoutique : NSWindowController {
	id _delegate;
	
	IBOutlet NSTextField *firstNameField;
	IBOutlet NSTextField *lastNameField;
	IBOutlet NSTextField *companyNameField;
	IBOutlet NSTextField *streetAddressField;
	IBOutlet NSTextField *cityField;
	IBOutlet NSTextField *stateField;
	IBOutlet NSTextField *postalField;
	IBOutlet NSPopUpButton *countryPopUp;
	IBOutlet NSTextField *emailField;
	IBOutlet NSTextField *phoneField;
	IBOutlet NSTextField *nameOnCardField;
	IBOutlet NSPopUpButton *cardTypePopUp;
	IBOutlet NSTextField *cardNumberField;
	IBOutlet NSTextField *securityNumberField;
	IBOutlet NSPopUpButton *expirationMonthPopUp;
	IBOutlet NSPopUpButton *expirationYearPopUp;
	IBOutlet NSProgressIndicator *progressIndicator;
	
	NSMutableData *serverResponseData;
	NSURLConnection *serverConnection;
}

- (id)delegate;
- (void)setDelegate:(id)new_delegate;

- (IBAction)processOrder:(id)sender;

@end

@interface NSObject (CocoaBoutiqueDelegateMethods)
- (NSString *)storeURL;
- (NSString *)productName;
- (void)serverError:(NSString *)error;
- (AquaticPrime *)licenseValidator;
- (void)validLicense:(BOOL)valid withLicenseData:(NSData *)licenseData;
@end

