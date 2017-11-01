//
//  NHXMPPMessageArchivingCoreDataStorage.h
//  nearhero
//
//  Created by Dilawer Hussain on 8/31/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPMessageArchivingCoreDataStorage.h"

@interface NHXMPPMessageArchivingCoreDataStorage : XMPPMessageArchivingCoreDataStorage
-(NSMutableArray*)loadArchiveMessage:(NSString*)otherJid:(int)index;
-(NSMutableArray*)loadLatestMessage:(int)limit;
@property (strong) NSString *messageEntityName;
@property (strong) NSString *contactEntityName;

@end
