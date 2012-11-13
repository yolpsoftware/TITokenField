//
//  TokenTableViewController.m
//  TokenFieldExample
//
//  Created by jac on 9/5/12.
//
//

#import "TITokenTableViewController.h"

@interface TITokenTableViewController ()

@end

@implementation TITokenTableViewController

@synthesize showAlreadyTokenized, sourceArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	if (self)
	{
		
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
	self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds
												  style:UITableViewStylePlain];
	
	self.tableView.autoresizingMask =
	UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	
	[self.view insertSubview:self.tableView atIndex:0];
    
	[self setup];
}


-(void) setup {
    self.tokenFields = [NSMutableDictionary dictionary];
    
    for(NSUInteger i = 0; i < self.tokenDataSource.numberOfTokenRows; i++) {
        NSString *tokenPromptText = [self.tokenDataSource tokenFieldPromptAtRow:i];
        
        TITokenField *tokenField = [[TITokenField alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 42)];
		tokenField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
        [tokenField addTarget:self action:@selector(tokenFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
        [tokenField addTarget:self action:@selector(tokenFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
        [tokenField addTarget:self action:@selector(tokenFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
        [tokenField addTarget:self action:@selector(tokenFieldFrameWillChange:) forControlEvents:TITokenFieldControlEventFrameWillChange];
        [tokenField addTarget:self action:@selector(tokenFieldFrameDidChange:) forControlEvents:TITokenFieldControlEventFrameDidChange];
        
        [tokenField addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidBegin];
        [tokenField addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidEnd];
        
		if (self.tokenizingCharacters)
			[tokenField setTokenizingCharacters:self.tokenizingCharacters];
		
		if (self.tokenFieldFont)
			[tokenField setFont:self.tokenFieldFont];
		
        [tokenField setDelegate:self];
        [tokenField setPromptText:tokenPromptText];
        
        UIView *accessoryView = [self.tokenDataSource accessoryViewForField:tokenField];
        if (accessoryView) {
            [tokenField setRightView:accessoryView];
			
			// Hook up the didTapOnAccesoryView action
			if ([accessoryView respondsToSelector:@selector(addTarget:action:forControlEvents:)])
			{
				[(id) accessoryView addTarget:tokenField
									   action:@selector(didTapOnAccessoryView:)
							 forControlEvents:UIControlEventTouchUpInside];
			}
        }
        
        [self.tokenFields setObject:tokenField forKey:tokenPromptText];
        
    }
    
    showAlreadyTokenized = NO;
    resultsArray = [[NSMutableArray alloc] init];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
        
   		UITableViewController * tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
   		[tableViewController.tableView setDelegate:self];
   		[tableViewController.tableView setDataSource:self];
   		[tableViewController setContentSizeForViewInPopover:CGSizeMake(400, 400)];
        
   		resultsTable = tableViewController.tableView;
        
   		popoverController = [[UIPopoverController alloc] initWithContentViewController:tableViewController];
   	}
   	else
   	{
   		resultsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 + 1, self.view.bounds.size.width, self.view.bounds.size.height)];
		
		resultsTable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
   		[resultsTable setSeparatorColor:[UIColor colorWithWhite:0.85 alpha:1]];
   		[resultsTable setBackgroundColor:[UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1]];
   		[resultsTable setDelegate:self];
   		[resultsTable setDataSource:self];
   		[resultsTable setHidden:YES];
   		[self.view addSubview:resultsTable];
        [self.view  bringSubviewToFront:resultsTable];
   		popoverController = nil;
   	}
    
	NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter];

    [notifCenter addObserver:self
					selector:@selector(keyboardWillShow:)
						name:UIKeyboardWillShowNotification
					  object:nil];
	
   	[notifCenter addObserver:self
					selector:@selector(keyboardWillHide:)
						name:UIKeyboardWillHideNotification
					  object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Token field properties

- (void)setTokenizingCharacters:(NSCharacterSet *)tokenizingCharacters
{
	if (_tokenizingCharacters != tokenizingCharacters)
	{
		_tokenizingCharacters = tokenizingCharacters;
		
		for (TITokenField *tokenField in self.tokenFields)
		{
			[tokenField setTokenizingCharacters:tokenizingCharacters];
		}
	}
}

- (void)setTokenFieldFont:(UIFont *)tokenFieldFont
{
	
	if (_tokenFieldFont != tokenFieldFont)
	{
		_tokenFieldFont = tokenFieldFont;
		
		for (TITokenField *tokenField in self.tokenFields)
		{
			[tokenField setFont:tokenFieldFont];
		}
	}
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        NSUInteger rows = self.tokenDataSource.numberOfTokenRows;
        
        // another cell that is not a TIToken (e.g. subject, body)
        if ([self.tokenDataSource respondsToSelector:@selector(tokenTableView:numberOfRowsInSection:)]) {
            rows += [self.tokenDataSource tokenTableView:self numberOfRowsInSection:section];
        }
        
        return rows;
        
    }
    if (tableView == resultsTable) {
        return resultsArray.count;
    }
    return 0;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) {
        
        
        if (indexPath.row < self.tokenDataSource.numberOfTokenRows)
		{
			NSString *promptAtRow =
			[self.tokenDataSource tokenFieldPromptAtRow:(NSUInteger)indexPath.row];
            TITokenField *tokenField = self.tokenFields[promptAtRow];
            CGFloat height = tokenField.frame.size.height;
            return height;
        }
		else
		{
            // a row that is not a token field: delegate
            if ([self.tokenDataSource respondsToSelector:@selector(tokenTableView:heightForRowAtIndexPath:)]) {
                
                NSIndexPath * idx = [NSIndexPath indexPathForRow:indexPath.row - self.tokenDataSource.numberOfTokenRows inSection:indexPath.section];
                
                return [self.tokenDataSource tokenTableView: self heightForRowAtIndexPath:idx];
            }
        }
        
    }
    if (tableView == resultsTable) {
        //todo
        //        if (tokenField && [tokenField.delegate respondsToSelector:@selector(tokenField:resultsTableView:heightForRowAtIndexPath:)]){
        //       		return [tokenField.delegate tokenField:tokenField resultsTableView:tableView heightForRowAtIndexPath:indexPath];
        //       	}
        
       	return 44;
    }
    
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    // DISPLAYING THE TOKEN TABLE
    if (tableView == self.tableView) {
        static NSString *CellIdentifier = @"Cell";
        
        // any TokenCell
        if (indexPath.row < self.tokenDataSource.numberOfTokenRows)
		{

            if (!cell)
			{
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

				NSString *promptAtRow =
				[self.tokenDataSource tokenFieldPromptAtRow:(NSUInteger)indexPath.row];

				TITokenField *tokenField = self.tokenFields[promptAtRow];
                [cell.contentView addSubview:tokenField];
            }
            
        }
		
		else
		{
            // another cell that is not a TIToken (e.g. subject, body)
            if ([self.tokenDataSource respondsToSelector:@selector(tokenTableView:cellForRowAtIndexPath:)]) {
                
                NSIndexPath *idx = [NSIndexPath indexPathForRow:indexPath.row - self.tokenDataSource.numberOfTokenRows inSection:indexPath.section];
                
                cell = [self.tokenDataSource tokenTableView:self cellForRowAtIndexPath:idx];
            }
        }
        
    }
    
    
    // DISPLAYING THE SEARCH RESULT
    if (tableView == resultsTable) {
        id representedObject = [resultsArray objectAtIndex:(NSUInteger) indexPath.row];
        

        //todo, shall the delegate be able to give a result cell ?
        if ([self.currentSelectedTokenField.delegate respondsToSelector:@selector(tokenField:resultsTableView:cellForRepresentedObject:)])
		{
            return [self.currentSelectedTokenField.delegate tokenField:self.currentSelectedTokenField
													  resultsTableView:tableView
											  cellForRepresentedObject:representedObject];
        }
        
        static NSString *CellIdentifier = @"ResultsCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        NSString *subtitle =
		[self searchResultSubtitleForRepresentedObject:representedObject
										  inTokenField:self.currentSelectedTokenField];
        
        if (!cell) {
            
            if (subtitle) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            } else {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
        }
        
        cell.detailTextLabel.text = subtitle;
        [cell.textLabel setText:[self searchResultStringForRepresentedObject:representedObject]];
        
    }
    
    
    
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == self.tableView) {
        if ([self.delegate respondsToSelector:@selector(tokenTableViewController:didSelectRowAtIndex:)]) {
            NSInteger row = indexPath.row - self.tokenDataSource.numberOfTokenRows;
            [self.delegate tokenTableViewController:self didSelectRowAtIndex:row];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }

    if (tableView == resultsTable) {
        
        TITokenField *tokenField = self.currentSelectedTokenField;
        if (tokenField) {
            id representedObject = [resultsArray objectAtIndex:(NSUInteger) indexPath.row];
            TIToken *token = [[TIToken alloc] initWithTitle:[self displayStringForRepresentedObject:representedObject] representedObject:representedObject];
            [tokenField addToken:token];
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self setSearchResultsVisible:NO forTokenField:tokenField];
        }
    }
    
}

#pragma mark TextField Methods

#pragma mark TextField Methods

- (void)tokenFieldDidBeginEditing:(TITokenField *)field {
    
    if([self.delegate respondsToSelector:@selector(tokenTableViewController:didSelectTokenField:)]) {
        [self.delegate tokenTableViewController:self didSelectTokenField:field];
    }
    
    self.currentSelectedTokenField = field;
    
    UIView * cell = field.superview;
    while (cell && ![cell isKindOfClass:[UITableViewCell class]]) {
        cell = cell.superview;
    }
    
    
    
    
    
	[resultsArray removeAllObjects];
	[resultsTable reloadData];
}

- (void)tokenFieldDidEndEditing:(TITokenField *)field {
	[self tokenFieldDidBeginEditing:field];
    
    [self setSearchResultsVisible:NO forTokenField:field];
    
    self.currentSelectedTokenField = nil;
    
    if([self.delegate respondsToSelector:@selector(tokenTableViewController:didSelectTokenField:)]) {
        [self.delegate tokenTableViewController:self didSelectTokenField:field];
    }
}

- (void)tokenFieldTextDidChange:(TITokenField *)field {
	[self resultsForSearchString:[field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}

- (void)tokenFieldFrameWillChange:(TITokenField *)field {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, field);
    
    // this resizes the table cells animated
    [self updateContentSize];

}

- (void)tokenFieldFrameDidChange:(TITokenField *)field {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, field);
    //[self.tableView endUpdates];
    //	[self updateContentSize];
}

#pragma mark Results Methods
- (NSString *)displayStringForRepresentedObject:(id)object {
    
    TITokenField *tokenField = self.currentSelectedTokenField;
    
	if ([tokenField.delegate respondsToSelector:@selector(tokenField:displayStringForRepresentedObject:)]){
		return [tokenField.delegate tokenField:tokenField displayStringForRepresentedObject:object];
	}
    
	if ([object isKindOfClass:[NSString class]]){
		return (NSString *)object;
	}
    
	return [NSString stringWithFormat:@"%@", object];
}

- (NSString *)searchResultStringForRepresentedObject:(id)object   {
    TITokenField *tokenField = self.currentSelectedTokenField;
    
	if ([tokenField.delegate respondsToSelector:@selector(tokenField:searchResultStringForRepresentedObject:)]){
		return [tokenField.delegate tokenField:tokenField searchResultStringForRepresentedObject:object];
	}
    
	return [self displayStringForRepresentedObject:object];
}

- (NSString *)searchResultSubtitleForRepresentedObject:(id)object inTokenField:(TITokenField *)tokenField {
    
	if ([tokenField.delegate respondsToSelector:@selector(tokenField:searchResultSubtitleForRepresentedObject:)]){
		return [tokenField.delegate tokenField:tokenField searchResultSubtitleForRepresentedObject:object];
	}
    
	return nil;
}

- (void)setSearchResultsVisible:(BOOL)visible forTokenField:(TITokenField *)tokenField {
    
    // dont set it twice
    if (_searchResultIsVisible == visible) {
        return;
    }
    
    _searchResultIsVisible = visible;
    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
		if (visible) [self presentpopoverAtTokenFieldCaretAnimated:YES inTokenField:tokenField];
		else [popoverController dismissPopoverAnimated:YES];
	}
	else
	{
        NSInteger scrollToRow = 0;
        
        if (visible) {
            // showing the search result table: scroll the current cell to top
            NSInteger count = self.tokenDataSource.numberOfTokenRows;
            for (NSUInteger row = 0; row < count; row++) {
                NSString *rowPrompt = [self.tokenDataSource tokenFieldPromptAtRow:row];
                if ([rowPrompt isEqualToString:tokenField.promptText]) {
                    scrollToRow = row;
                    break;
                }
            }
            
            _contentOffsetBeforeResultTable = self.tableView.contentOffset;
            
            // find the containing cell to bring it to front
            UIView *cell = tokenField.superview;
            while (cell && ![cell isKindOfClass:[UITableViewCell class]]) {
                cell = cell.superview;
            }
            
            if (cell) {
                [self.tableView bringSubviewToFront:cell];
            }
            
            NSIndexPath * idx = [NSIndexPath indexPathForRow:scrollToRow inSection:0];

			[UIView animateWithDuration:0.3 animations:^{
				[self.tableView scrollToRowAtIndexPath:idx atScrollPosition:UITableViewScrollPositionTop animated:NO];
				// size is from the token till the beginning of the keyboard
				resultsTable.frame = CGRectMake(0, tokenField.frame.size.height + 1, self.view.bounds.size.width, self.view.bounds.size.height - _keyboardHeight - tokenField.frame.size.height);
			} completion:^(BOOL finished) {
				// Make it visible only if the the result table is still
				// meant to be visible. For example the user might have
				// continued typing more text that does not match anything
				// and thus would have already hidden the table during the
				// animation
				if (_searchResultIsVisible)
				{
					[self.view bringSubviewToFront:resultsTable];
					[resultsTable setHidden:NO];
				}
			}];
	
        }
		
		else {
            // hiding result table, scroll back to where we were,
			[self.tableView setContentOffset:_contentOffsetBeforeResultTable];
			[resultsTable setHidden:!visible];
        }
        
		[tokenField setResultsModeEnabled:visible];
        
        self.tableView.scrollEnabled = !visible;
    }
}

- (void)resultsForSearchString:(NSString *)searchString {
    
    TITokenField *tokenField = self.currentSelectedTokenField;
	// The brute force searching method.
	// Takes the input string and compares it against everything in the source array.
	// If the source is massive, this could take some time.
	// You could always subclass and override this if needed or do it on a background thread.
	// GCD would be great for that.
    
	[resultsArray removeAllObjects];
	[resultsTable reloadData];
    
	[sourceArray enumerateObjectsUsingBlock:^(id sourceObject, NSUInteger idx, BOOL *stop){
        
		NSString * query = [self searchResultStringForRepresentedObject:sourceObject];
        NSString * querySubtitle = [self searchResultSubtitleForRepresentedObject:sourceObject inTokenField:tokenField];
		if ([query rangeOfString:searchString options:NSCaseInsensitiveSearch].location != NSNotFound || (querySubtitle && [querySubtitle rangeOfString:searchString options:NSCaseInsensitiveSearch].location != NSNotFound)){
            
			__block BOOL shouldAdd = ![resultsArray containsObject:sourceObject];
			if (shouldAdd && !showAlreadyTokenized){
                
				[tokenField.tokens enumerateObjectsUsingBlock:^(TIToken * token, NSUInteger idx, BOOL *secondStop){
					if ([token.representedObject isEqual:sourceObject]){
						shouldAdd = NO;
						*secondStop = YES;
					}
				}];
			}
            
			if (shouldAdd) [resultsArray addObject:sourceObject];
		}
	}];
    
	[resultsArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		return [[self searchResultStringForRepresentedObject:obj1 ] localizedCaseInsensitiveCompare:[self searchResultStringForRepresentedObject:obj2]];
	}];
	[resultsTable reloadData];
	[self setSearchResultsVisible:(resultsArray.count > 0) forTokenField:tokenField];
}

- (void)presentpopoverAtTokenFieldCaretAnimated:(BOOL)animated inTokenField:(TITokenField *)tokenField {
    
    UITextPosition * position = [tokenField positionFromPosition:tokenField.beginningOfDocument offset:2];
    
	[popoverController presentPopoverFromRect:[tokenField caretRectForPosition:position] inView:tokenField
					 permittedArrowDirections:UIPopoverArrowDirectionUp animated:animated];
}



- (void)tokenFieldChangedEditing:(TITokenField *)tokenField {
	// There's some kind of annoying bug where UITextFieldViewModeWhile/UnlessEditing doesn't do anything.
	[tokenField setRightViewMode:(tokenField.editing ? UITextFieldViewModeAlways : UITextFieldViewModeNever)];
}



-(void) updateContentSize {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}


- (void)keyboardWillShow:(NSNotification *)notification {
    
	CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	_keyboardHeight = keyboardRect.size.height > keyboardRect.size.width ? keyboardRect.size.width : keyboardRect.size.height;
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
	_keyboardHeight = 0;
    
}

- (void)dealloc {
	[self setDelegate:nil];
}




@end
