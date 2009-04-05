//
//  CocoaBoutique.m
//
//  Created by Fraser Hess on 2/23/09.
//

#import "CocoaBoutique.h"
#import <AddressBook/AddressBook.h>


@implementation CocoaBoutique

- (id)delegate {
	return _delegate;
}

- (void)setDelegate:(id)new_delegate {
	_delegate = new_delegate;
}

- (id)init {
	if (![super initWithWindowNibName:@"Boutique"]) {
		return nil;
	}
	return self;
}

- (void)windowDidLoad {
	ABPerson *me = [[ABAddressBook sharedAddressBook] me];
	if (me != nil) {
//		NSLog(@"me: %@", me);
		
		[firstNameField setStringValue:[me valueForProperty:@"First"]];
		[lastNameField setStringValue:[me valueForProperty:@"Last"]];
		[companyNameField setStringValue:[me valueForProperty:@"Organization"]];
		ABMultiValue *address = [me valueForProperty:@"Address"];
		if ([address count] > 0) {
			NSDictionary *address1 = [address valueForIdentifier:[address primaryIdentifier]];
			[streetAddressField setStringValue:[address1 objectForKey:@"Street"]];
			[cityField setStringValue:[address1 objectForKey:@"City"]];
			[stateField setStringValue:[address1 objectForKey:@"State"]];
			[postalField setStringValue:[address1 objectForKey:@"ZIP"]];
		}
		ABMultiValue *emails = [me valueForProperty:@"Email"];
		if ([emails count] > 0) {
			[emailField setStringValue:[emails valueForIdentifier:[emails primaryIdentifier]]];
		}
		ABMultiValue *phones = [me valueForProperty:@"Phone"];
		if ([phones count] > 0) {
			[phoneField setStringValue:[phones valueForIdentifier:[phones primaryIdentifier]]];
		}
		
	}
}

- (IBAction)processOrder:(id)sender {
	NSURL *url = [NSURL URLWithString:[_delegate storeURL]];
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
	[urlRequest setHTTPMethod:@"POST"];
	
	NSString *body = [NSString stringWithFormat:@"product=%@&firstName=%@&lastName=%@&creditCardType=%@&creditCardNumber=%@&expDateMonth=%@&expDateYear=%@&cvv2Number=%@&address1=%@&city=%@&state=%@&postal=%@&email=%@&company=%@&phone=%@",
	 [_delegate productName],
	 [[firstNameField stringValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
	 [[lastNameField stringValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
	 [[[cardTypePopUp selectedItem] title] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
	 [[cardNumberField stringValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
	 [[[expirationMonthPopUp selectedItem] title] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
	 [[[expirationYearPopUp selectedItem] title] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
	 [[securityNumberField stringValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
	 [[streetAddressField stringValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
	 [[cityField stringValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
	 [[stateField stringValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
	 [[postalField stringValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
	 [[emailField stringValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
	 [[companyNameField stringValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
	 [[phoneField stringValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
	];

	
	
	[urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	
	[progressIndicator setHidden:NO];
	[progressIndicator startAnimation:self];
	serverResponseData = [[NSMutableData alloc] init];
	serverConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
}

- (void)processServerResponse:(NSData *)urlData {
	NSString *urlDataString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
	if ([[urlDataString substringWithRange:NSMakeRange(0, 6)] isEqualToString:@"ERROR:"]) {
		[_delegate serverError:urlDataString];
		return;
	}
	
	AquaticPrime *licenseValidator = [_delegate licenseValidator];
	BOOL validLicense = [licenseValidator verifyLicenseData:urlData];
	[progressIndicator setHidden:YES];
	[progressIndicator stopAnimation:self];
	[_delegate validLicense:validLicense withLicenseData:urlData];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[serverResponseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[serverConnection release], serverConnection = nil;
	[self processServerResponse:serverResponseData];
	[serverResponseData release], serverResponseData = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[serverConnection release], serverConnection = nil;
	[self processServerResponse:nil];
	[serverResponseData release], serverResponseData = nil;
}

@end
