//
//  ConversationalViewController.h
//  nearhero
//
//  Created by Irfan Malik on 6/13/16.
//  Copyright (c) 2016 TBoxSolutionz. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SWTableViewCell.h"

@protocol ConversationalViewControllerDelegate;
@interface ConversationalViewController : BaseViewController <SWTableViewCellDelegate,NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *fetchedResultsController;
    NSFetchedResultsController *latestChatFetchedResultsController;
}
//@property (weak, nonatomic) IBOutlet UIView *transperentView;
@property (weak, nonatomic) IBOutlet UITableView *tabel;
//@property (weak, nonatomic) IBOutlet UIView *topView;

- (IBAction)dismissView:(id)sender;

@end