//
//  CocoaBoutique.h
//
//  Copyright (c) 2009 Sweeter Rhythm LLC/No Thirst Software LLC/Atomic Bird LLC
//  All rights reserved.
//  BSD License http://www.opensource.org/licenses/bsd-license.php
//

#import <Cocoa/Cocoa.h>
#import "AquaticPrime.h"

#define kCountryNameKey @"country"
#define kCountryCodeKey @"code"
#define kCardTypeNameKey @"name"
#define kCardTypeCodeKey @"code"

@interface CocoaBoutique : NSWindowController {
	id _delegate;
	NSArray *_countries;
	
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
	IBOutlet NSPopUpButton *cardTypePopUp;
	IBOutlet NSTextField *cardNumberField;
	IBOutlet NSTextField *securityNumberField;
	IBOutlet NSPopUpButton *expirationMonthPopUp;
	IBOutlet NSPopUpButton *expirationYearPopUp;
	IBOutlet NSTextField *couponCodeField;
	IBOutlet NSProgressIndicator *progressIndicator;
	IBOutlet NSTextField *transIDField;
	IBOutlet NSProgressIndicator *llProgressIndicator;
	IBOutlet NSTextField *emailLookupField;
	IBOutlet NSProgressIndicator *emProgressIndicator;
	IBOutlet NSTabView *tabview;
	IBOutlet NSButton *purchaseButton;
	NSProgressIndicator *currentPI;
	
	NSMutableData *serverResponseData;
	NSURLConnection *serverConnection;
}

- (id)delegate;
- (void)setDelegate:(id)newDelegate;
- (NSArray *)countries;
- (void)setCountries:(NSArray *)newArray;
- (NSArray *)cardTypes;

- (IBAction)processOrder:(id)sender;
- (IBAction)lookupLicense:(id)sender;
- (IBAction)switchToLicenseLookup:(id)sender;
- (IBAction)switchToPurchase:(id)sender;
- (IBAction)emailTransactionIDs:(id)sender;
- (void)connectionToScript:(NSString *)script withBody:(NSString *)body indicator:(NSProgressIndicator *)pi;
- (void)processServerResponse:(NSData *)urlData;
- (NSString *)cleanNumber:(NSString *)numberString;
- (BOOL)isValidLuhnNumber:(NSString *)numberString;
- (BOOL)isValidVisaNumber:(NSString *)numberString;
- (BOOL)isValidDiscoverNumber:(NSString *)numberString;
- (BOOL)isValidMasterCardNumber:(NSString *)numberString;
- (BOOL)isValidAmexNumber:(NSString *)numberString;
- (BOOL)validateNotEmpty: (NSString *)candidate;
- (BOOL)validateEmail: (NSString *)candidate;
- (void)validateForm:(NSNotification *)note;
@end

@interface NSObject (CocoaBoutiqueDelegateMethods)

/*!
    @method     storeURL
    @abstract   Delegate method. Returns the URL path to the folder containing the PHP Cocoa Boutique files.
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

/*!
 @method     overrideSSL
 @abstract   Optional delegate method. Indicates that SSL should not be required for connecting to the online store.  Useful for development and testing.
 */

- (BOOL)overrideSSL;

/*!
 @method     defaultCountry
 @abstract   Optional delegate method. Override the default country.
 */

- (NSString *)defaultCountry;

@end

