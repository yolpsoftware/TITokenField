//
//  ContactsTokenField.m
//  ContactsTokenField
//
//  Created by Jonas Sourlier on 10.06.12.
//  Copyright (c) 2012 Yolp Softwaredesign GmbH. All rights reserved.
//

#import "ContactsTokenField.h"
#import <AddressBook/AddressBook.h>

@implementation ContactsTokenField

//@synthesize sms;
//@synthesize selectedName;
//@synthesize selectedToken;

- (void)setupSms
{
    [[[UIAlertView alloc] initWithTitle:@"test" message:@"msg" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
        ABAddressBookRef addressBook = ABAddressBookCreate();
        
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
        CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
        
        NSMutableArray *masterList = [[NSMutableArray alloc] init];
        for (int i = 0; i < nPeople; i++) {
            ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
            NSString* firstName = (NSString *)ABRecordCopyValue(ref, kABPersonFirstNameProperty);
            NSString* lastName = (NSString *)ABRecordCopyValue(ref, kABPersonLastNameProperty);
            NSString* contactFirstLast = [NSString stringWithFormat:@"%@%@%@", firstName, @" ", lastName];
            //[ref getPhones];
            [firstName release];
            [lastName release];
            [masterList addObject:contactFirstLast];
            [contactFirstLast release];
        }

        [super setSourceArray:masterList];
        //[masterList release];
        
}

- (id)initWithFrame:(CGRect)frame {
	
    if ((self = [super initWithFrame:frame])){
		[self setupSms];
	}
	
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	
	if ((self = [super initWithCoder:aDecoder])){
		[self setupSms];
	}
	
	return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setupSms];
    }
    
    return self;
}

@end
