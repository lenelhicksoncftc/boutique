//
//  AppController.h
//  BoutiqueDemo
//
//  Created by Fraser Hess on 3/31/09.
//  Copyright 2009 Sweeter Rhythm. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CocoaBoutique.h"

@interface AppController : NSObject {
	CocoaBoutique *boutique;
	IBOutlet NSMenuItem *purchaseMenu;
	IBOutlet NSMenu *mainMenu;
}

- (IBAction)showBoutique:(id)sender;
- (NSString *)pathToLicenseFile;

@end
