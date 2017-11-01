//
//  NHXMPPMessageArchivingCoreDataStorage.m
//  nearhero
//
//  Created by Dilawer Hussain on 8/31/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import "NHXMPPMessageArchivingCoreDataStorage.h"

@interface NHXMPPMessageArchivingCoreDataStorage ()

@end
static NHXMPPMessageArchivingCoreDataStorage *sharedInstance;

@implementation NHXMPPMessageArchivingCoreDataStorage

+ (instancetype)sharedInstance
{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            sharedInstance = [[NHXMPPMessageArchivingCoreDataStorage alloc] initWithDatabaseFilename:nil storeOptions:nil];
        });
        
        return sharedInstance;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSMutableArray*)loadArchiveMessage:(NSString*)otherJid:(int)index

{
    __block NSArray *messages_arc;
    static NSString *fetchRequest = @"fetchRequest";

 //   @synchronized (fetchRequest){


        XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    
        NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                             inManagedObjectContext:moc];
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
        
        NSString *predicateFrmt = @"bareJidStr like %@ ";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt,otherJid];
        request.predicate = predicate;
        NSArray *sortDescriptors = @[sd1];    [request setSortDescriptors:sortDescriptors];
        request.fetchLimit = index;
       // request.fetchOffset = index - 4;
        [request setEntity:entityDescription];
        __block NSError *error;
        [moc performBlockAndWait:^{
            messages_arc = [moc executeFetchRequest:request error:&error];
        }];

   // }
        return [[NSMutableArray alloc]initWithArray:messages_arc];

}

-(NSMutableArray*)loadLatestMessage:(int)limit

{
    __block NSArray *messages_arc;
    static NSString *fetchRequest = @"fetchRequest";
    
    //@synchronized (fetchRequest){
        XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];

        NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject"
                                                             inManagedObjectContext:moc];
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"mostRecentMessageTimestamp" ascending:NO];
        
        NSArray *sortDescriptors = @[sd1];    [request setSortDescriptors:sortDescriptors];
        if(limit != 0)
            [request setFetchLimit:limit];
        
        [request setEntity:entityDescription];
       __block NSError *error;
        [moc performBlockAndWait:^{
            messages_arc = [moc executeFetchRequest:request error:&error];
        }];
   // }
        return [[NSMutableArray alloc]initWithArray:messages_arc];
}


@end
