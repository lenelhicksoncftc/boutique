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

/*!
    @method     storeURL
    @abstract   Delegate method. Returns the URL for the purchaseSoftware.php
*/

- (NSString *)storeURL;

/*!
    @method     productName
    @abstract   Delegate method. Returns the name of the product
    @discussion The returned string is looked up in the products table of the store's MySQL database. A failure to find the product name will return an error.
*/

- (NSString *)productName;

/*!
    @method     serverError:
    @abstract   Delegate method. Called when an error occurs during the communication with web server
    @param error A string containing the error reported
*/

- (void)serverError:(NSString *)error;

/*!
    @method     licenseValidator
    @abstract   Delegate method.
    @discussion Returns an AquaticPrime object.  It should be setup using the obfuscated public key.
*/

- (AquaticPrime *)licenseValidator;

/*!
    @method     validLicense:withLicenseData:
    @abstract   Delegate method. Called when license data has been retrieved from the web server
    @param valid Is the license data valid?
    @param licenseData The AquaticPrime license data
*/

- (void)validLicense:(BOOL)valid withLicenseData:(NSData *)licenseData;
@end

