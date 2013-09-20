//
//  Created by jac on 9/14/12.
//


#import <Foundation/Foundation.h>
#import "TITokenTableViewController.h"


@interface TokenTableMainViewController : TITokenTableViewController <TITokenTableViewDataSource, TITokenTableViewControllerDelegate, UITextViewDelegate> {


    NSArray *_tokenFieldTitlesAll;
    NSArray *_tokenFieldTitlesCompact;
    UITextView * _messageView;
    UITextField *_textFieldSubject;

    CGFloat _oldHeight;

}

-(id)initWithType:(BOOL)sms andPrompt:(NSString*)prompt;

-(NSArray*)getTokens;

@end