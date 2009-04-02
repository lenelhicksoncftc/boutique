//
//  AppController.m
//  BoutiqueDemo
//
//  Created by Fraser Hess on 3/31/09.
//  Copyright 2009 Sweeter Rhythm. All rights reserved.
//

#import "AppController.h"


@implementation AppController

- (IBAction)showBoutique:(id)sender {
	if (!boutique) {
		boutique = [[CocoaBoutique alloc] init];
		[boutique setDelegate:self];
	}
	[boutique showWindow:self];
}

#pragma mark CocoaBoutique delegate methods

- (NSString *)productName {
	return [NSString stringWithString:@"Demo"];
}

- (NSString *)storeURL {
	return [NSString stringWithString:@"http://demo.com/purchaseSoftware.php"];
}

@end
