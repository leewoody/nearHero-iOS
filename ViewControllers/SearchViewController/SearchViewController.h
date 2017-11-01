//
//  SearchViewController.h
//  nearhero
//
//  Created by APPLE on 26/09/2016.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"




@interface SearchViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchbarView;
@property (strong, nonatomic) IBOutlet UITableView *searchTableView;
//@property (strong, nonatomic) IBOutlet UITextField *searchView;

@property (strong, nonatomic) IBOutlet UILabel *suggestions;


//for searching...
@property (nonatomic, strong) UISearchController * searchController;
- (IBAction)cancelBtnAction:(id)sender;

//@property (strong, nonatomic) IBOutlet UIView *topView;
//end...
- (IBAction)searchClick:(id)sender;

@end
