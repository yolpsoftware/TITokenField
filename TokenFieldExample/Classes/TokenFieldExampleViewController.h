//
//  TokenFieldExampleViewController.h
//  TokenFieldExample
//
//  Created by Tom Irving on 29/01/2011.
//  Copyright 2011 Tom Irving. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsTokenField.h"

@interface TokenFieldExampleViewController : UIViewController <TITokenFieldDelegate, UITextViewDelegate> {

	//ContactsTokenField * tokenFieldView;
	TITokenFieldView * tokenFieldView;
	UITextView * messageView;
	
	CGFloat keyboardHeight;
}

@end

