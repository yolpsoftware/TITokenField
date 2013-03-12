//
//  TITokenContact.h
//  TokenFieldExample
//
//  Created by Lin Junjie on 13/11/12.
//
//

#import <Foundation/Foundation.h>

// If no label is provided, use this
#define TICONTACT_DEFAULT_LABEL		@"other"

@interface TIContact : NSObject

// Full name of the contact
@property (nonatomic, copy) NSString *fullName;

// Email address associated with the contact. 
@property (nonatomic, copy) NSString *email;

// Label describing the type of email address.
@property (nonatomic, copy) NSString *emailLabel;

// Phone number associated with contact
@property (nonatomic, copy) NSString *phone;

// Label describing the type of phone number
@property (nonatomic, copy) NSString *phoneLabel;

+ (id)contactWithName:(NSString *)name
				email:(NSString *)email
				label:(NSString *)label;

- (id)initWithName:(NSString *)name
			 email:(NSString *)email
			 label:(NSString *)label;

@end
