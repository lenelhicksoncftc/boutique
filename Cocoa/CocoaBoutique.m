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
		[firstNameField setStringValue:[me valueForProperty:@"First"]];
		[lastNameField setStringValue:[me valueForProperty:@"Last"]];
		//[companyNameField setStringValue:[me valueForProperty:kABOrganizationProperty]];
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
	
	NSString *defaultCountry;
	if ([_delegate respondsToSelector:@selector(defaultCountry)]) {
		defaultCountry = [_delegate defaultCountry];
	} else {
		defaultCountry = [NSString stringWithString:@"United States"];
	}
	[countryPopUp selectItemWithTitle:defaultCountry];
	[countryPopUp synchronizeTitleAndSelectedItem];
}

- (IBAction)processOrder:(id)sender {
	NSString *storeURL = [_delegate storeURL];
	if (![[storeURL substringWithRange:NSMakeRange(0,8)] isEqualToString:@"https://"]  &&
		(![_delegate respondsToSelector:@selector(overrideSSL)]  || ![_delegate overrideSSL])) {
			NSAlert *alert = [NSAlert alertWithMessageText:@"Error" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"Connection does not use SSL"];
			[alert runModal];
			return;
	}
	NSURL *url = [NSURL URLWithString:storeURL];
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
	[urlRequest setHTTPMethod:@"POST"];
	
	NSString *body = [NSString stringWithFormat:@"product=%@&firstName=%@&lastName=%@&creditCardType=%@&creditCardNumber=%@&expDateMonth=%@&expDateYear=%@&cvv2Number=%@&address1=%@&city=%@&state=%@&postal=%@&country=%@&email=%@&company=%@&phone=%@",
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
	 [[[[countryPopUp selectedItem] representedObject] valueForKey:kCountryCodeKey] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
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
	[progressIndicator setHidden:YES];
	[progressIndicator stopAnimation:self];
	if ([[urlDataString substringWithRange:NSMakeRange(0, 6)] isEqualToString:@"ERROR:"]) {
		[_delegate serverError:urlDataString];
		return;
	}
	
	AquaticPrime *licenseValidator = [_delegate licenseValidator];
	BOOL validLicense = [licenseValidator verifyLicenseData:urlData];
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

- (NSArray *)countries {
	return [NSArray arrayWithObjects:
			[NSDictionary dictionaryWithObjectsAndKeys:@"Afghanistan", kCountryNameKey, @"AF", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Åland Islands", kCountryNameKey, @"AX", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Albania", kCountryNameKey, @"AL", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Algeria", kCountryNameKey, @"DZ", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"American Samoa", kCountryNameKey, @"AS", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Andorra", kCountryNameKey, @"AD", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Angola", kCountryNameKey, @"AO", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Anguilla", kCountryNameKey, @"AI", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Antarctica", kCountryNameKey, @"AQ", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Antigua and Barbuda", kCountryNameKey, @"AG", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Argentina", kCountryNameKey, @"AR", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Armenia", kCountryNameKey, @"AM", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Aruba", kCountryNameKey, @"AW", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Australia", kCountryNameKey, @"AU", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Austria", kCountryNameKey, @"AT", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Azerbaijan", kCountryNameKey, @"AZ", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Bahamas", kCountryNameKey, @"BS", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Bahrain", kCountryNameKey, @"BH", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Bangladesh", kCountryNameKey, @"BD", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Barbados", kCountryNameKey, @"BB", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Belarus", kCountryNameKey, @"BY", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Belgium", kCountryNameKey, @"BE", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Belize", kCountryNameKey, @"BZ", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Benin", kCountryNameKey, @"BJ", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Bermuda", kCountryNameKey, @"BM", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Bhutan", kCountryNameKey, @"BT", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Bolivia", kCountryNameKey, @"BO", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Bosnia and Herzegovina", kCountryNameKey, @"BA", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Botswana", kCountryNameKey, @"BW", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Bouvet Island", kCountryNameKey, @"BV", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Brazil", kCountryNameKey, @"BR", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"British Indian Ocean Territory", kCountryNameKey, @"IO", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Brunei Darussalam", kCountryNameKey, @"BN", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Bulgaria", kCountryNameKey, @"BG", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Burkina Faso", kCountryNameKey, @"BF", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Burundi", kCountryNameKey, @"BI", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Cambodia", kCountryNameKey, @"KH", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Cameroon", kCountryNameKey, @"CM", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Canada", kCountryNameKey, @"CA", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Cape Verde", kCountryNameKey, @"CV", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Cayman Islands", kCountryNameKey, @"KY", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Central African Republic", kCountryNameKey, @"CF", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Chad", kCountryNameKey, @"TD", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Chile", kCountryNameKey, @"CL", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"China", kCountryNameKey, @"CN", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Christmas Island", kCountryNameKey, @"CX", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Cocos (Keeling) Islands", kCountryNameKey, @"CC", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Colombia", kCountryNameKey, @"CO", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Comoros", kCountryNameKey, @"KM", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Congo", kCountryNameKey, @"CG", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Congo, the Democratic Republic of the", kCountryNameKey, @"CD", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Cook Islands", kCountryNameKey, @"CK", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Costa Rica", kCountryNameKey, @"CR", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Cote D'ivoire", kCountryNameKey, @"CI", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Croatia", kCountryNameKey, @"HR", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Cuba", kCountryNameKey, @"CU", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Cyprus", kCountryNameKey, @"CY", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Czech Republic", kCountryNameKey, @"CZ", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Denmark", kCountryNameKey, @"DK", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Djibouti", kCountryNameKey, @"DJ", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Dominica", kCountryNameKey, @"DM", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Dominican Republic", kCountryNameKey, @"DO", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Ecuador", kCountryNameKey, @"EC", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Egypt", kCountryNameKey, @"EG", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"El Salvador", kCountryNameKey, @"SV", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Equatorial Guinea", kCountryNameKey, @"GQ", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Eritrea", kCountryNameKey, @"ER", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Estonia", kCountryNameKey, @"EE", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Ethiopia", kCountryNameKey, @"ET", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Falkland Islands (Malvinas)", kCountryNameKey, @"FK", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Faroe Islands", kCountryNameKey, @"FO", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Fiji", kCountryNameKey, @"FJ", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Finland", kCountryNameKey, @"FI", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"France", kCountryNameKey, @"FR", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"French Guiana", kCountryNameKey, @"GF", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"French Polynesia", kCountryNameKey, @"PF", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"French Southern Territories", kCountryNameKey, @"TF", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Gabon", kCountryNameKey, @"GA", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Gambia", kCountryNameKey, @"GM", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Georgia", kCountryNameKey, @"GE", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Germany", kCountryNameKey, @"DE", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Ghana", kCountryNameKey, @"GH", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Gibraltar", kCountryNameKey, @"GI", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Greece", kCountryNameKey, @"GR", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Greenland", kCountryNameKey, @"GL", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Grenada", kCountryNameKey, @"GD", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Guadeloupe", kCountryNameKey, @"GP", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Guam", kCountryNameKey, @"GU", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Guatemala", kCountryNameKey, @"GT", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Guernsey", kCountryNameKey, @"GG", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Guinea", kCountryNameKey, @"GN", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Guinea-Bissau", kCountryNameKey, @"GW", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Guyana", kCountryNameKey, @"GY", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Haiti", kCountryNameKey, @"HT", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Heard Island and Mcdonald Islands", kCountryNameKey, @"HM", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Holy See (Vatican City State)", kCountryNameKey, @"VA", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Honduras", kCountryNameKey, @"HN", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Hong Kong", kCountryNameKey, @"HK", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Hungary", kCountryNameKey, @"HU", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Iceland", kCountryNameKey, @"IS", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"India", kCountryNameKey, @"IN", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Indonesia", kCountryNameKey, @"ID", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Iran, Islamic Republic of", kCountryNameKey, @"IR", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Iraq", kCountryNameKey, @"IQ", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Ireland", kCountryNameKey, @"IE", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Isle of Man", kCountryNameKey, @"IM", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Israel", kCountryNameKey, @"IL", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Italy", kCountryNameKey, @"IT", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Jamaica", kCountryNameKey, @"JM", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Japan", kCountryNameKey, @"JP", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Jersey", kCountryNameKey, @"JE", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Jordan", kCountryNameKey, @"JO", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Kazakhstan", kCountryNameKey, @"KZ", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Kenya", kCountryNameKey, @"KE", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Kiribati", kCountryNameKey, @"KI", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Korea, Democratic People's Republic of", kCountryNameKey, @"KP", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Korea, Republic of", kCountryNameKey, @"KR", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Kuwait", kCountryNameKey, @"KW", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Kyrgyzstan", kCountryNameKey, @"KG", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Lao People's Democratic Republic", kCountryNameKey, @"LA", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Latvia", kCountryNameKey, @"LV", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Lebanon", kCountryNameKey, @"LB", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Lesotho", kCountryNameKey, @"LS", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Liberia", kCountryNameKey, @"LR", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Libyan Arab Jamahiriya", kCountryNameKey, @"LY", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Liechtenstein", kCountryNameKey, @"LI", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Lithuania", kCountryNameKey, @"LT", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Luxembourg", kCountryNameKey, @"LU", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Macao", kCountryNameKey, @"MO", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Macedonia, the Former Yugoslav Republic of", kCountryNameKey, @"MK", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Madagascar", kCountryNameKey, @"MG", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Malawi", kCountryNameKey, @"MW", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Malaysia", kCountryNameKey, @"MY", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Maldives", kCountryNameKey, @"MV", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Mali", kCountryNameKey, @"ML", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Malta", kCountryNameKey, @"MT", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Marshall Islands", kCountryNameKey, @"MH", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Martinique", kCountryNameKey, @"MQ", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Mauritania", kCountryNameKey, @"MR", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Mauritius", kCountryNameKey, @"MU", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Mayotte", kCountryNameKey, @"YT", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Mexico", kCountryNameKey, @"MX", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Micronesia, Federated States of", kCountryNameKey, @"FM", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Moldova, Republic of", kCountryNameKey, @"MD", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Monaco", kCountryNameKey, @"MC", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Mongolia", kCountryNameKey, @"MN", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Montserrat", kCountryNameKey, @"MS", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Morocco", kCountryNameKey, @"MA", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Mozambique", kCountryNameKey, @"MZ", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Myanmar", kCountryNameKey, @"MM", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Namibia", kCountryNameKey, @"NA", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Nauru", kCountryNameKey, @"NR", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Nepal", kCountryNameKey, @"NP", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Netherlands", kCountryNameKey, @"NL", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Netherlands Antilles", kCountryNameKey, @"AN", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"New Caledonia", kCountryNameKey, @"NC", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"New Zealand", kCountryNameKey, @"NZ", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Nicaragua", kCountryNameKey, @"NI", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Niger", kCountryNameKey, @"NE", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Nigeria", kCountryNameKey, @"NG", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Niue", kCountryNameKey, @"NU", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Norfolk Island", kCountryNameKey, @"NF", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Northern Mariana Islands", kCountryNameKey, @"MP", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Norway", kCountryNameKey, @"NO", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Oman", kCountryNameKey, @"OM", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Pakistan", kCountryNameKey, @"PK", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Palau", kCountryNameKey, @"PW", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Palestinian Territory, Occupied", kCountryNameKey, @"PS", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Panama", kCountryNameKey, @"PA", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Papua New Guinea", kCountryNameKey, @"PG", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Paraguay", kCountryNameKey, @"PY", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Peru", kCountryNameKey, @"PE", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Philippines", kCountryNameKey, @"PH", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Pitcairn", kCountryNameKey, @"PN", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Poland", kCountryNameKey, @"PL", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Portugal", kCountryNameKey, @"PT", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Puerto Rico", kCountryNameKey, @"PR", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Qatar", kCountryNameKey, @"QA", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Reunion", kCountryNameKey, @"RE", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Romania", kCountryNameKey, @"RO", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Russian Federation", kCountryNameKey, @"RU", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Rwanda", kCountryNameKey, @"RW", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Saint Helena", kCountryNameKey, @"SH", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Saint Kitts and Nevis", kCountryNameKey, @"KN", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Saint Lucia", kCountryNameKey, @"LC", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Saint Pierre and Miquelon", kCountryNameKey, @"PM", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Saint Vincent and the Grenadines", kCountryNameKey, @"VC", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Samoa", kCountryNameKey, @"WS", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"San Marino", kCountryNameKey, @"SM", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Sao Tome and Principe", kCountryNameKey, @"ST", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Saudi Arabia", kCountryNameKey, @"SA", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Senegal", kCountryNameKey, @"SN", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Serbia and Montenegro", kCountryNameKey, @"CS", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Seychelles", kCountryNameKey, @"SC", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Sierra Leone", kCountryNameKey, @"SL", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Singapore", kCountryNameKey, @"SG", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Slovakia", kCountryNameKey, @"SK", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Slovenia", kCountryNameKey, @"SI", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Solomon Islands", kCountryNameKey, @"SB", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Somalia", kCountryNameKey, @"SO", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"South Africa", kCountryNameKey, @"ZA", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"South Georgia and the South Sandwich Islands", kCountryNameKey, @"GS", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Spain", kCountryNameKey, @"ES", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Sri Lanka", kCountryNameKey, @"LK", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Sudan", kCountryNameKey, @"SD", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Suriname", kCountryNameKey, @"SR", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Svalbard and Jan Mayen", kCountryNameKey, @"SJ", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Swaziland", kCountryNameKey, @"SZ", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Sweden", kCountryNameKey, @"SE", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Switzerland", kCountryNameKey, @"CH", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Syrian Arab Republic", kCountryNameKey, @"SY", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Taiwan, Province of China", kCountryNameKey, @"TW", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Tajikistan", kCountryNameKey, @"TJ", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Tanzania, United Republic of", kCountryNameKey, @"TZ", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Thailand", kCountryNameKey, @"TH", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Timor-Leste", kCountryNameKey, @"TL", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Togo", kCountryNameKey, @"TG", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Tokelau", kCountryNameKey, @"TK", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Tonga", kCountryNameKey, @"TO", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Trinidad and Tobago", kCountryNameKey, @"TT", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Tunisia", kCountryNameKey, @"TN", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Turkey", kCountryNameKey, @"TR", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Turkmenistan", kCountryNameKey, @"TM", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Turks and Caicos Islands", kCountryNameKey, @"TC", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Tuvalu", kCountryNameKey, @"TV", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Uganda", kCountryNameKey, @"UG", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Ukraine", kCountryNameKey, @"UA", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"United Arab Emirates", kCountryNameKey, @"AE", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"United Kingdom", kCountryNameKey, @"GB", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"United States", kCountryNameKey, @"US", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"United States Minor Outlying Islands", kCountryNameKey, @"UM", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Uruguay", kCountryNameKey, @"UY", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Uzbekistan", kCountryNameKey, @"UZ", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Vanuatu", kCountryNameKey, @"VU", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Venezuela", kCountryNameKey, @"VE", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Viet Nam", kCountryNameKey, @"VN", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Virgin Islands, British", kCountryNameKey, @"VG", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Virgin Islands, U.S.", kCountryNameKey, @"VI", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Wallis and Futuna", kCountryNameKey, @"WF", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Western Sahara", kCountryNameKey, @"EH", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Yemen", kCountryNameKey, @"YE", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Zambia", kCountryNameKey, @"ZM", kCountryCodeKey, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Zimbabwe", kCountryNameKey, @"ZW", kCountryCodeKey, nil],
			nil];
}

@end
