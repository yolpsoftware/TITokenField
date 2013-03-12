//
//  TITokenContact.m
//  TokenFieldExample
//
//  Created by Lin Junjie on 13/11/12.
//
//

#import "TIContact.h"

@implementation TIContact

+ (id)contactWithName:(NSString *)name
				email:(NSString *)email
				label:(NSString *)label
{
	TIContact *contact =
	[[TIContact alloc] initWithName:name email:email label:label];
	
	return contact;
}

- (id)init
{
	return [self initWithName:@"" email:@"" label:@""];
}

- (id)initWithName:(NSString *)name
			 email:(NSString *)email
			 label:(NSString *)label
{
	self = [super init];
	
	if (self)
	{
		_fullName = [name copy];
		_email = [email copy];
		_emailLabel = [label copy];		
	}
	
	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"TITokenContact: %@ (email: %@, %@ / phone: %@, %@)",
			self.fullName, self.email, self.emailLabel, self.phone, self.phoneLabel];
}

#pragma mark - 

- (NSString *)phoneLabel
{
	if (!_phoneLabel)
	{
		_phoneLabel = [TICONTACT_DEFAULT_LABEL copy];
	}
	
	return _phoneLabel;
}

- (NSString *)emailLabel
{
	if (!_emailLabel)
	{
		_emailLabel = [TICONTACT_DEFAULT_LABEL copy];
	}
	
	return _emailLabel;
}

@end
