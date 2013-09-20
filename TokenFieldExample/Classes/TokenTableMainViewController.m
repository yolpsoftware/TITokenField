//
//  Created by jac on 9/14/12.
//


#import "TokenTableExampleViewController.h"
#import "TIContact.h"
#import <AddressBook/AddressBook.h>


//#define kOtherCellBodyHeight 300

@interface TokenTableExampleViewController () {
    BOOL _typeSms;
    NSString* _prompt;
    NSMutableArray * _masterList;
}

@property (nonatomic) BOOL showCompactFields;
@end

@implementation TokenTableExampleViewController

- (id)initWithType:(BOOL)sms andPrompt:(NSString*)prompt {
    self = [super init];
    if (self) {
        _prompt = prompt;
        _tokenFieldTitlesAll = @[prompt];
        _typeSms = sms;
		//_tokenFieldTitlesCompact = @[prompt];
        //_oldHeight = kOtherCellBodyHeight;
    }

    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	//
/*	UIBarButtonItem *dismissKeyboard =
	[[UIBarButtonItem alloc] initWithTitle:@"Done"
									 style:UIBarButtonItemStylePlain
									target:self
									action:@selector(dismissKeyboard:)];
	[self.navigationItem setRightBarButtonItem:dismissKeyboard];
	
	UIBarButtonItem *toggleCCVisibility =
	[[UIBarButtonItem alloc] initWithTitle:@"Toggle CC"
									 style:UIBarButtonItemStylePlain
									target:self
									action:@selector(toggleCCVisibility:)];
	[self.navigationItem setLeftBarButtonItem:toggleCCVisibility];*/

    ABAddressBookRef addressBook = ABAddressBookCreate();
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (granted)
                [self loadFromAddressBook];
            else
                [self showNoAuthWarningSign];
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        [self loadFromAddressBook];
    }
    else {
        [self showNoAuthWarningSign];
    }
    CFRelease(addressBook);
    [self loadFromAddressBook];
}

- (void)showNoAuthWarningSign {
    //[self showFooter:[[NSBundle mainBundle] localizedStringForKey:@"You have denied access to your contacts." value:nil table:nil]];
}

- (void)loadFromAddressBook {
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    _masterList = [[NSMutableArray alloc] init];
    for (int i = 0; i < nPeople; i++) {
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
        CFStringRef firstNameCf = (CFStringRef)ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        CFStringRef lastNameCf = (CFStringRef)ABRecordCopyValue(ref, kABPersonLastNameProperty);
        NSString* firstName = (__bridge NSString*)firstNameCf;
        NSString* lastName = (__bridge NSString*)lastNameCf;
        NSString* contactFirstLast;
        if ([firstName length] == 0) {
            if ([lastName length] == 0) {
                CFStringRef orgCf = (CFStringRef)ABRecordCopyValue(ref, kABPersonOrganizationProperty);
                contactFirstLast = [NSString stringWithFormat:@"%@", (__bridge NSString *)orgCf];
                CFRelease(orgCf);
            }
            else {
                contactFirstLast = lastName;
            }
        }
        else if ([lastName length] == 0) {
            contactFirstLast = firstName;
        }
        else {
            contactFirstLast = [NSString stringWithFormat:@"%@%@%@", firstName, @" ", lastName];
        }
        if (_typeSms) {
            ABMultiValueRef phones = ABRecordCopyValue(ref, kABPersonPhoneProperty);
            for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++) {
                CFStringRef mobileLabelCf = (CFStringRef)ABMultiValueCopyLabelAtIndex(phones, j);
                NSString* mobileLabel = (__bridge NSString*)mobileLabelCf;
                mobileLabel = [[mobileLabel componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"!<>$_"]] componentsJoinedByString: @""];
                mobileLabel = NSLocalizedString(mobileLabel, nil);
                CFStringRef mobileCf = (CFStringRef)ABMultiValueCopyValueAtIndex(phones, j);
                //NSString* token = [NSString stringWithFormat:@"%@%@%@%@%@", contactFirstLast, @"$", mobileLabel, @"$", mobile];
                
                TIContact* contact = [TIContact contactWithName:contactFirstLast email:(__bridge NSString*)mobileCf label:mobileLabel];
                //if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
                [_masterList addObject:contact];
                CFRelease(mobileLabelCf);
                CFRelease(mobileCf);
            }
            CFRelease(phones);
        }
        else {
            ABMultiValueRef emails = ABRecordCopyValue(ref, kABPersonEmailProperty);
            for(CFIndex j = 0; j < ABMultiValueGetCount(emails); j++) {
                CFStringRef emailLabelCf = (CFStringRef)ABMultiValueCopyLabelAtIndex(emails, j);
                NSString* emailLabel = (__bridge NSString*)emailLabelCf;
                emailLabel = [[emailLabel componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"!<>$_"]] componentsJoinedByString: @""];
                emailLabel = NSLocalizedString(emailLabel, nil);
                CFStringRef emailCf = (CFStringRef)ABMultiValueCopyValueAtIndex(emails, j);
                //NSString* token = [NSString stringWithFormat:@"%@%@%@%@%@", contactFirstLast, @"$", emailLabel, @"$", email];
                
                TIContact* contact = [TIContact contactWithName:contactFirstLast email:(__bridge NSString*)emailCf label:emailLabel];
                //if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
                [_masterList addObject:contact];
                CFRelease(emailLabelCf);
                CFRelease(emailCf);
            }
            CFRelease(emails);
        }
        //[contactFirstLast release];
        CFRelease(firstNameCf);
        CFRelease(lastNameCf);
    }
    
    CFRelease(allPeople);
    CFRelease(addressBook);
    [self setSourceArray:_masterList];
	//self.sourceArray = [Names listOfNames];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self _recalculateHeightOfTextView:_messageView];
}

-(NSArray*)getTokens {
    return [super tokenFieldForPrompt:_prompt].tokens;
}

#pragma mark - Bar buttons

- (void)dismissKeyboard:(id)object
{
	[self.view endEditing:YES];
}

- (void)toggleCCVisibility:(id)object
{
	self.showCompactFields = !self.showCompactFields;
}

#pragma mark - Hiding of fields

- (void)setShowCompactFields:(BOOL)showCompactFields
{
	if (_showCompactFields != showCompactFields)
	{
		_showCompactFields = showCompactFields;

		NSIndexPath *CCRow =
		[NSIndexPath indexPathForRow:1 inSection:0];
		
		NSIndexPath *BCCRow =
		[NSIndexPath indexPathForRow:2 inSection:0];
		
		if (showCompactFields)
		{
			[self.tableView deleteRowsAtIndexPaths:@[CCRow, BCCRow]
								  withRowAnimation:UITableViewRowAnimationAutomatic];
		}
		
		else
		{
			[self.tableView insertRowsAtIndexPaths:@[CCRow, BCCRow]
								  withRowAnimation:UITableViewRowAnimationAutomatic];
		}
	}
}

#pragma mark - TITokenFieldDelegate

- (NSString *)tokenField:(TITokenField *)tokenField displayStringForRepresentedObject:(id)object
{
	if ([object respondsToSelector:@selector(fullName)])
		return [object fullName];
	
	return [object description];
}

- (NSString *)tokenField:(TITokenField *)tokenField searchResultStringForRepresentedObject:(id)object
{
	if ([object respondsToSelector:@selector(fullName)])
		return [object fullName];
	
	return [object description];
}

- (NSString *)tokenField:(TITokenField *)tokenField searchResultSubtitleForRepresentedObject:(id)object
{
	if ([object respondsToSelector:@selector(email)])
		return [object email];
	
	return [object description];	
}

#pragma mark - TokenTableViewDataSource

- (NSString *)tokenFieldPromptAtRow:(NSUInteger)row {
	if (self.showCompactFields)
		return _tokenFieldTitlesCompact[row];
	
    return _tokenFieldTitlesAll[row];
}

- (NSUInteger)numberOfTokenRows {
	if (self.showCompactFields)
		return _tokenFieldTitlesCompact.count;
	
    return _tokenFieldTitlesAll.count;
}

- (UIView *)accessoryViewForField:(TITokenField *)tokenField {

    return NULL;
//    UIButton * addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
//   	[addButton addTarget:self action:@selector(showContactsPicker:) forControlEvents:UIControlEventTouchUpInside];
//   	[tokenField setRightView:addButton];
//
//    return addButton;
}


#pragma mark - TokenTableViewDataSource (Other table cells)

- (CGFloat)tokenTableView:(TITokenTableViewController *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.row) {
/*        case kOtherCellSubject:
            return 44;
        case kOtherCellBody:
            return _oldHeight;*/
        default:
            return 0;
    }
}


- (NSInteger)tokenTableView:(TITokenTableViewController *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


- (UITableViewCell *)tokenTableView:(TITokenTableViewController *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;


    //static NSString *CellIdentifierSubject = @"SubjectCell";
    //static NSString *CellIdentifierBody = @"BodyCell";

    // todo save the cells to keep their text active
    switch (indexPath.row) {
/*        case kOtherCellSubject:
            cell = [tableView.tableView dequeueReusableCellWithIdentifier:CellIdentifierSubject];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierSubject];
                if(!_textFieldSubject) {
                    //UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, cell.frame.size.height / 2 - textView.font.lineHeight, tableView.tableView.bounds.size.width, 30)];
                    _textFieldSubject = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
					CGRect subjectFrame = CGRectMake(10, cell.frame.size.height / 2 - _textFieldSubject.font.lineHeight / 2, tableView.tableView.bounds.size.width, 30);
                    _textFieldSubject.frame = CGRectIntegral(subjectFrame);
                    _textFieldSubject.placeholder = @"Subject";
					_textFieldSubject.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                }

				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				[cell.contentView addSubview:_textFieldSubject];
            }
            break;

        case kOtherCellBody:
            cell = [tableView.tableView dequeueReusableCellWithIdentifier:CellIdentifierBody];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierBody];
                cell.frame = CGRectMake(0, 0, cell.frame.size.width, kOtherCellBodyHeight);
                if (!_messageView) {
                    _messageView = [[UITextView alloc] initWithFrame:cell.frame];
                   	[_messageView setScrollEnabled:NO];
                   	[_messageView setAutoresizingMask:UIViewAutoresizingNone];
                   	[_messageView setDelegate:self];
                   	[_messageView setFont:[UIFont systemFontOfSize:15]];
                   	[_messageView setText:@"Some message. The whole view resizes as you type, not just the text view."];

					_messageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                }

				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				[cell.contentView addSubview:_messageView];
            }
            break;*/

        default:
            break;
    }

    return cell;

}

- (void)showContactsPicker:(id)sender {

	// Show some kind of contacts picker in here.
	// For now, here's how to add and customize tokens.

	//NSArray * names = [Names listOfNames];

	TIContact *contact = [_masterList objectAtIndex:(arc4random() % _masterList.count)];
	
	TIToken * token = [self.currentSelectedTokenField addTokenWithTitle:contact.fullName representedObject:contact.email];
	[token setAccessoryType:TITokenAccessoryTypeDisclosureIndicator];
	// If the size of the token might change, it's a good idea to layout again.
	[self.currentSelectedTokenField layoutTokensAnimated:YES];

	NSUInteger tokenCount = self.currentSelectedTokenField.tokens.count;
	[token setTintColor:((tokenCount % 3) == 0 ? [TIToken redTintColor] : ((tokenCount % 2) == 0 ? [TIToken greenTintColor] : [TIToken blueTintColor]))];
}


#pragma mark - TokenTableViewControllerDelegate

- (void)textViewDidChange:(UITextView *)textView
{
	[self _recalculateHeightOfTextView:textView];
}

- (void)_recalculateHeightOfTextView:(UITextView *)textView
{
	CGFloat newHeight = textView.contentSize.height + textView.font.lineHeight;
	
    if (newHeight < 0) { //kOtherCellBodyHeight) {
        newHeight = 0;   //kOtherCellBodyHeight;
    }
	
	CGRect newTextFrame = textView.frame;
	newTextFrame.size = textView.contentSize;
	newTextFrame.size.height = newHeight;
		
	[textView setFrame:newTextFrame];
	
    _oldHeight = newHeight;
	
    [self updateContentSize];
}


@end
