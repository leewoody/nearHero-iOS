//
//  SearchViewController.m
//  nearhero
//
//  Created by APPLE on 26/09/2016.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "Constants.h"
#import "UserInfo.h"
#import "URLBuilder.h"
#import "GenericFetcher.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "UserSettings.h"


@interface SearchViewController ()

@end

@implementation SearchViewController{
    UIGestureRecognizer *singleFingertapper ;
    UserInfo* userinfo;
    NSMutableArray* searchRecord;
    NSMutableArray* allSearches;
    NSMutableArray* searchResults;
    NSMutableArray* filteredItems;
    NSMutableArray* displayedItems;
    bool isCancelButtonClicked;
    UserInfo *userInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    userInfo = [UserInfo instance];
    [self.searchView becomeFirstResponder];
    
    //for cancel button check
    isCancelButtonClicked = false;
    //end
    self.searchView.returnKeyType = UIReturnKeyDone;
    self.searchView.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    self.searchView.text = [userInfo valueForKey:krecentSearch];
    NSLog(@"%@",self.searchView.text);
    self.searchTableView.separatorColor = [UIColor clearColor];
    self.searchView.delegate = self;
    
    [self.searchView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
       //for tap gesture
    singleFingertapper = [[UITapGestureRecognizer alloc]
                          initWithTarget:self action:@selector(dismissView:)];
    [self.topView addGestureRecognizer:singleFingertapper];
    //end
    self.searchView.delegate = self;
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    userinfo = [UserInfo instance];
    

    //for searching...
    filteredItems = [[NSMutableArray alloc]init];
    displayedItems = [[NSMutableArray alloc]init];
    //end...
    
    searchRecord = [userinfo valueForKey:kmost_recent_search];
    allSearches = [userinfo valueForKey:kuser_all_searches];

    if(allSearches == nil){
        allSearches = [[NSMutableArray alloc]init];
    }
    if(searchRecord == nil){
        searchRecord = [[NSMutableArray alloc]initWithCapacity:3];
    }
    
    searchResults = [[NSMutableArray alloc]init];

    //for searching...
    displayedItems = searchRecord;
    
    //for hiding suggestions button
    if([searchRecord count] == 0){
        [self.suggestions setHidden:YES];
    }
   [self.searchTableView reloadData];
    if(![[userInfo valueForKey:krecentSearch] isEqualToString:@" "])
    {
        self.searchView.returnKeyType = UIReturnKeySearch;
    }
    else{
        self.searchbarView.returnKeyType = UIReturnKeyDone;
    }
    


}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark - textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if((textField.text.length > 0 || string.length > 0) && (![string isEqualToString:@""]) )
    {
        self.searchView.returnKeyType = UIReturnKeySearch;
        [self.searchView reloadInputViews];

    }
    else{
        self.searchView.returnKeyType = UIReturnKeyDone;
        [self.searchView reloadInputViews];

    }

    return YES;
}
-(void)textFieldDidChange :(UITextField *)theTextField{

    if(![theTextField.text isEqualToString:@""])
        theTextField.returnKeyType = UIReturnKeySearch;
    NSLog( @"text changed: %@", theTextField.text);
    NSLog(@"Text field did begin editing");
    NSLog(@"updateSearchResultsForSearchController");
    
    NSString *searchString = self.searchView.text;
    if([searchString isEqualToString:@""]){
        displayedItems = searchRecord;
    }
    else{
    
    NSLog(@"searchString=%@", searchString);
    // Check if the user cancelled or deleted the search term so we can display the full list instead.
    if (![searchString isEqualToString:@""]) {
        
        [filteredItems removeAllObjects];
        for (NSString *str in allSearches) {
            if ([searchString isEqualToString:@""] || [str hasPrefix:searchString]) {
                NSLog(@"str=%@", str);
                [filteredItems addObject:str];
            }
        }
        displayedItems = filteredItems;
    }
    else {
        
        displayedItems = [allSearches mutableCopy];
        if(isCancelButtonClicked == true){
            [displayedItems removeAllObjects];
            displayedItems = searchRecord;
            isCancelButtonClicked = false;
        }
    }
    }
    [self.searchTableView reloadData];
}
// This method is called once we complete editing
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"Text field ended editing");
}

// This method enables or disables the processing of return key
-(BOOL) textFieldShouldReturn:(UITextField *)textField{

    if(self.searchView.returnKeyType == UIReturnKeyDone){
       
        [self dismissView:nil];
        [self.view removeFromSuperview];
       
    }
    else if(self.searchView.returnKeyType==UIReturnKeySearch)
    {
        NSString* searchString = self.searchView.text;
        if(!([searchString isEqualToString:@""])){
            if(!([allSearches containsObject:searchString])){
                [allSearches insertObject:searchString atIndex:0];
            }
            if(!([searchRecord containsObject:searchString])){
                int count = [searchRecord count];
                if(count == 3){
                    if(!([searchString isEqualToString:@""])){
                        [searchRecord removeObjectAtIndex:2];
                    }
                }
                if(count <= 3 ){
                    [searchRecord insertObject:searchString atIndex:0];
                }

            }
            else{
                //The code for existing search, and only change indices.
                NSString* firstSearch = @"";
                NSString* secondSearch = @"";
                NSString* thirdSearch = @"";
                int count = [searchRecord count];
                if(count == 3){
                    if(!([searchString isEqualToString:@""])){
                        firstSearch  = searchRecord[0];
                        secondSearch = searchRecord[1];
                        thirdSearch  = searchRecord[2];
                        if(!([searchString isEqualToString:firstSearch])){
                            searchRecord[0] = searchString;
                            searchRecord[1] = firstSearch;
                            if([searchString isEqualToString:secondSearch]){
                                searchRecord[2] = thirdSearch;
                            }
                            else{
                                searchRecord[2] = secondSearch;
                            }
                        }
                    }
                }
                if(count < 3 ){
                    if(!([searchString isEqualToString:@""])){
                        firstSearch  = searchRecord[0];
                        if(count == 2){
                            secondSearch = searchRecord[1];
                        }
                        searchRecord[0] = searchString;
                        if(count == 2 ){
                            if(!([searchString isEqualToString:firstSearch])){
                                searchRecord[1] = firstSearch;
                            }
                        }
                    }
                }

            }
            
            [userinfo setValue:allSearches forKey:kuser_all_searches];
            [userinfo setValue:searchRecord forKey:kmost_recent_search];
            [userinfo saveUserInfo];

        }
        [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) hideView];
        [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) enableSearchBtn];

        [self.view removeFromSuperview];
            [userInfo setRecentSearch:self.searchView.text];
            [userInfo saveUserInfo];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:self.searchView.text forKey:kkeyword];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"search" object:nil userInfo:dict];
         [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) enableSearchBtn];
    }
    
        

     [textField resignFirstResponder];
    return YES;
}


- (IBAction)dismissView:(id)sender{
    [self.view endEditing:YES];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    [UIView animateWithDuration:1.0
                                               delay:0
                                             options:UIViewAnimationOptionOverrideInheritedOptions
                                          animations:^{
                                              [self.view endEditing:YES];
                                             
                                              [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) tView].alpha = 0.0;

                                              [self.view setFrame:CGRectMake(self.view.frame.origin.x, screenHeight,self.view.frame.size.width,self.view.frame.size.height)];
                                          }
                                          completion:^(BOOL finished) {
                                                 [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) hideView];
                                              [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) enableSearchBtn];
                                              [self.view removeFromSuperview];
                                              
                                            
                                          }];
       [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [displayedItems count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SearchTableViewCell";
    
    SearchTableViewCell *cell = (SearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    
    cell.searchText.text = [displayedItems objectAtIndex:indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SearchTableViewCell* cell = [_searchTableView cellForRowAtIndexPath:indexPath];
    NSString* str = cell.searchText.text;
    
    self.searchView.text = str;
    self.searchView.returnKeyType = UIReturnKeySearch;
    [self.searchView reloadInputViews];

}


//for searching...

- (void)updateSearchResultsForSearchController:(UISearchController *)aSearchController {
    NSLog(@"updateSearchResultsForSearchController");

    NSString *searchString = aSearchController.searchBar.text;
    NSLog(@"searchString=%@", searchString);
        // Check if the user cancelled or deleted the search term so we can display the full list instead.
    if (![searchString isEqualToString:@""]) {
        
        [filteredItems removeAllObjects];
        for (NSString *str in allSearches) {
            if ([searchString isEqualToString:@""] || [str hasPrefix:searchString]) {
                NSLog(@"str=%@", str);
                [filteredItems addObject:str];
            }
        }
        displayedItems = filteredItems;
    }
    else {
       
        displayedItems = [allSearches mutableCopy];
        if(isCancelButtonClicked == true){
            [displayedItems removeAllObjects];
            displayedItems = searchRecord;
            isCancelButtonClicked = false;
        }
    }
    [self.searchTableView reloadData];
}



- (IBAction)cancelBtnAction:(id)sender {
    [userInfo setRecentSearch:@""];
    [userInfo saveUserInfo];
     [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) enableSearchBtn];
    [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) hideView];
    [self.view removeFromSuperview];
    //[(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) hideView];
    if([UserSettings instance].isSubscribed)
        [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) searchUsers:@" ":subscriberSearchRange];
    else
        [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) searchUsers:@" ":nonSubscriberSearchRange];

}
@end
