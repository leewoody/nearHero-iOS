//
//  IAPHelper.m
//  In App Rage
//
//  Created by Ray Wenderlich on 9/5/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

// 1
#import "IAPHelper.h"
#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "Constants.h"
#import "Utility.h"
#import "UserSettings.h"

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";
NSString *const oneMonthProduct = @"com.tbox.nearhero.subscription";
NSString *const sixMonthProduct = @"com.tbox.nearhero.testproduct";
NSString *const oneYearProduct = @"com.tbox.nearhero.oneyearsubscription";

// 2
@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

// 3
@implementation IAPHelper {
    SKProductsRequest * _productsRequest;
    RequestProductsCompletionHandler _completionHandler;
    
    NSSet * _productIdentifiers;
    NSMutableSet * _purchasedProductIdentifiers;
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if ((self = [super init])) {
        
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            } else {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
        
        // Add self as transaction observer
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
    }
//   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetRemainingDays) name:kresetRemainingDays object:nil];
    return self;
    
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    
    
    // 1
    _completionHandler = [completionHandler copy];
    
    // 2
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
    
}

- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)product {
    
    NSLog(@"Buying %@...", product.productIdentifier);
    
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
    
}

#pragma mark SKPaymentTransactionOBserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}
-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    int totalNumberOfPurchaseToBeRestored = queue.transactions.count;
    
    if (totalNumberOfPurchaseToBeRestored == 0)
    {
        //No item found for Restore"
        NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
        [store setObject:nil forKey:kappState];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"No subscription is found to restore"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];


    }
    else
    {
        // Restore items
        NSDate *date;
        NSDate *exDate;
        NSArray *transactions = queue.transactions;
        for (int i=0; i < transactions.count; i++)
        {
            SKPaymentTransaction *transaction = transactions[i];
            if ([transaction.originalTransaction.payment.productIdentifier isEqualToString:oneMonthProduct])
            {
                date = transaction.originalTransaction.transactionDate;
                NSDateComponents *dateComponents = [NSDateComponents new];
                dateComponents.month = 1;
                exDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
                NSDate *today = [NSDate date];
                if ([exDate compare:today] == NSOrderedDescending) {
                    [self saveRestoredTransaction:date :exDate :oneMonthProduct];
                    [self saveRestoredTransaction:date :exDate :sixMonthProduct];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Congratulations " message:@"Your one month subscription is restored successfully"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                    [[NSNotificationCenter defaultCenter]  postNotificationName:kuserIsSubscribed object:self];

                    return;
                }
            }
            else if ([transaction.originalTransaction.payment.productIdentifier isEqualToString:sixMonthProduct])
            {
                date = transaction.originalTransaction.transactionDate;
                NSDateComponents *dateComponents = [NSDateComponents new];
                dateComponents.month = 6;
                exDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
                NSDate *today = [NSDate date];
                if ([exDate compare:today] == NSOrderedDescending) {
                    [self saveRestoredTransaction:date :exDate :sixMonthProduct];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Congratulations " message:@"Your six month subscription is restored successfully"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                    [[NSNotificationCenter defaultCenter]  postNotificationName:kuserIsSubscribed object:self];

                    return;

                }
            }
            else if ([transaction.originalTransaction.payment.productIdentifier isEqualToString: oneYearProduct])
            {
                date = transaction.originalTransaction.transactionDate;
                NSDateComponents *dateComponents = [NSDateComponents new];
                dateComponents.month = 12;
                exDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
                NSDate *today = [NSDate date];
                if ([exDate compare:today] == NSOrderedDescending) {
                    [self saveRestoredTransaction:date :exDate :sixMonthProduct];
                    [self saveRestoredTransaction:date :exDate :oneYearProduct];

                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Congratulations " message:@"Your one year Subscription is restored successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                    [[NSNotificationCenter defaultCenter]  postNotificationName:kuserIsSubscribed object:self];

                    return;
                }
            }

            
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"No subscription is found to restore"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];

    }
    [[NSNotificationCenter defaultCenter]  postNotificationName:kuserIsSubscribed object:self];

}
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");
    
    UserSettings *userSettings = [UserSettings instance];
    userSettings.isSubscribed = YES;
    [userSettings saveUserSettings];
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.month = 1;
    NSDate *expirationDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
    NSMutableDictionary *appState = [[NSMutableDictionary alloc] init];
    [appState setValue:[NSDate date] forKey:ksubscriptionDate];
    [appState setValue:expirationDate forKey:kExpireDate];
    [appState setValue:transaction.payment.productIdentifier forKey:kproductIdentifier];
    
    if (store) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Congratulations " message:@" Now, you can search and hire professionals from all over the world without the disturbance of advirtisement"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [alert show];
//
        
        [store setObject:appState forKey:kappState];
    }
    
    [[NSNotificationCenter defaultCenter]  postNotificationName:kuserIsSubscribed object:self];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
//    NSLog(@"restoreTransaction...");
//    UserSettings *userSettings = [UserSettings instance];
//    userSettings.isSubscribed = YES;
//    [userSettings saveUserSettings];
//    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
//    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//    
//    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
//    NSDateComponents *dateComponents = [NSDateComponents new];
//    dateComponents.month = 1;
//    NSDate *expirationDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:transaction.transactionDate options:0];
//    NSMutableDictionary *appState = [[NSMutableDictionary alloc] init];
//    [appState setValue:transaction.transactionDate forKey:ksubscriptionDate];
//    [appState setValue:expirationDate forKey:kExpireDate];
//    [appState setValue:transaction.payment.productIdentifier forKey:kproductIdentifier];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kcheckSubscription object:nil];
//
//    if (store) {
//        [store setObject:appState forKey:kappState];
//    }

    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
  //  [[NSNotificationCenter defaultCenter] postNotificationName:kenableOkButton object:nil];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
   
    [[NSNotificationCenter defaultCenter]  postNotificationName:kuserIsSubscribed object:self];


  //  [[NSNotificationCenter defaultCenter] postNotificationName:kenableOkButton object:nil];
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
   
    if(productIdentifier){
    [_purchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];}
    
}

- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}



- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter]  postNotificationName:kuserIsSubscribed object:self];

}



#pragma mark - Helper Methods

-(void) saveRestoredTransaction:(NSDate*)subDate:(NSDate*)exDate:(NSString*)product
{
    UserSettings *userSettings = [UserSettings instance];
    userSettings.isSubscribed = YES;
    [userSettings saveUserSettings];
    
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
    NSMutableDictionary *appState = [[NSMutableDictionary alloc] init];
    [appState setValue:subDate forKey:ksubscriptionDate];
    [appState setValue:exDate forKey:kExpireDate];
    [appState setValue:product forKey:kproductIdentifier];
    
    if (store) {
        [store setObject:appState forKey:kappState];
    }
}
@end
