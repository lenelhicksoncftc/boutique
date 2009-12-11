//
//  AppController.h
//  BoutiqueDemo
//
//  Copyright (c) 2009 Sweeter Rhythm LLC/No Thirst Software LLC/Atomic Bird LLC
//  All rights reserved.
//  BSD License http://www.opensource.org/licenses/bsd-license.php
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
