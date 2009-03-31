//
//  CocoaBoutique.h
//
//  Created by Fraser Hess on 2/23/09.
//

#import <Cocoa/Cocoa.h>

@interface CocoaBoutique : NSObject {
	id _delegate;
}

- (id)delegate;
- (void)setDelegate:(id)new_delegate;

@end
