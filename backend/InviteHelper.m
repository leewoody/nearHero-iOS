//
//  InviteHelper.m
//  nearhero
//
//  Created by APPLE on 19/09/2016.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import "InviteHelper.h"
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>

@implementation InviteHelper

NSMutableArray *contactList;
NSMutableArray *emails;
NSMutableArray *names;
NSMutableDictionary *dOfPerson;

//code for message sending...

//end

-(NSMutableArray*)getUserNames{
    contactList = [[NSMutableArray alloc] init];
    emails = [[NSMutableArray alloc]init];
    names = [[NSMutableArray alloc]init];
    dOfPerson=[NSMutableDictionary dictionary];
    //end
    ABAddressBookRef allPeople = ABAddressBookCreate();
    CFArrayRef allContacts = ABAddressBookCopyArrayOfAllPeople(allPeople);
    CFIndex numberOfContacts  = ABAddressBookGetPersonCount(allPeople);
    
    NSLog(@"numberOfContacts------------------------------------%ld",numberOfContacts);
    
    
    for(int i = 0; i < numberOfContacts; i++){
        NSString* name = @"";
        NSString* phone = @"";
        NSString* email = @"";
        
        ABRecordRef aPerson = CFArrayGetValueAtIndex(allContacts, i);
        ABMultiValueRef fnameProperty = ABRecordCopyValue(aPerson, kABPersonFirstNameProperty);
        ABMultiValueRef lnameProperty = ABRecordCopyValue(aPerson, kABPersonLastNameProperty);
        
        ABMultiValueRef phoneProperty = ABRecordCopyValue(aPerson, kABPersonPhoneProperty);\
        ABMultiValueRef emailProperty = ABRecordCopyValue(aPerson, kABPersonEmailProperty);
        
        NSArray *emailArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(emailProperty);
        NSArray *phoneArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phoneProperty);
        
        
        if (fnameProperty != nil) {
            name = [NSString stringWithFormat:@"%@", fnameProperty];
        }
        if (lnameProperty != nil) {
            name = [name stringByAppendingString:[NSString stringWithFormat:@" %@", lnameProperty]];
        }
        
        if ([phoneArray count] > 0) {
            if ([phoneArray count] > 1) {
                for (int i = 0; i < [phoneArray count]; i++) {
                    phone = [phone stringByAppendingString:[NSString stringWithFormat:@"%@\n", [phoneArray objectAtIndex:i]]];
                }
            }else {
                phone = [NSString stringWithFormat:@"%@", [phoneArray objectAtIndex:0]];
            }
        }
        
        if ([emailArray count] > 0) {
            if ([emailArray count] > 1) {
                for (int i = 0; i < [emailArray count]; i++) {
                    email = [email stringByAppendingString:[NSString stringWithFormat:@"%@\n", [emailArray objectAtIndex:i]]];
                }
            }else {
                email = [NSString stringWithFormat:@"%@", [emailArray objectAtIndex:0]];
            }
        }
        if(![phone isEqualToString:@""]){
            NSLog(@"username, %@" , name);
            NSLog(@"phone_no, %@" , phone);
            dOfPerson = [NSDictionary dictionaryWithObjectsAndKeys:
                         phone,  @"phone_no",
                         name, @"username",nil];
           
            
            [contactList addObject:dOfPerson];
            [names addObject:name];
            email = @"";
            phone = @"";
            
        }

        
        //my code
//        if((![email isEqualToString:@""]) && (![phone isEqualToString:@""])){
//            NSLog(@"Email, %@" , email);
//            NSLog(@"phone, %@" , phone);
//            dOfPerson = [NSDictionary dictionaryWithObjectsAndKeys:
//                         phone,  @"phone",
//                         email, @"email",nil];
//            
//            [contactList addObject:dOfPerson];
//            [names addObject:name];
//            email = @"";
//            phone = @"";
//            
//        }
    }
    
    NSLog(@"Contacts = %@",contactList);
    
    return contactList;

}


-(NSMutableArray*)getNamesAgainstEmails{
    //my code
    contactList = [[NSMutableArray alloc] init];
    emails = [[NSMutableArray alloc]init];
    dOfPerson=[NSMutableDictionary dictionary];
    //end
    ABAddressBookRef allPeople = ABAddressBookCreate();
    CFArrayRef allContacts = ABAddressBookCopyArrayOfAllPeople(allPeople);
    CFIndex numberOfContacts  = ABAddressBookGetPersonCount(allPeople);
    
    NSLog(@"numberOfContacts------------------------------------%ld",numberOfContacts);
    
    
    for(int i = 0; i < numberOfContacts; i++){
        NSString* name = @"";
        NSString* phone = @"";
        NSString* email = @"";
        
        ABRecordRef aPerson = CFArrayGetValueAtIndex(allContacts, i);
        ABMultiValueRef fnameProperty = ABRecordCopyValue(aPerson, kABPersonFirstNameProperty);
        ABMultiValueRef lnameProperty = ABRecordCopyValue(aPerson, kABPersonLastNameProperty);
        
        ABMultiValueRef phoneProperty = ABRecordCopyValue(aPerson, kABPersonPhoneProperty);\
        ABMultiValueRef emailProperty = ABRecordCopyValue(aPerson, kABPersonEmailProperty);
        
        NSArray *emailArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(emailProperty);
        NSArray *phoneArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phoneProperty);
        
        
        if (fnameProperty != nil) {
            name = [NSString stringWithFormat:@"%@", fnameProperty];
        }
        if (lnameProperty != nil) {
            name = [name stringByAppendingString:[NSString stringWithFormat:@" %@", lnameProperty]];
        }
        
        if ([phoneArray count] > 0) {
            if ([phoneArray count] > 1) {
                for (int i = 0; i < [phoneArray count]; i++) {
                    phone = [phone stringByAppendingString:[NSString stringWithFormat:@"%@\n", [phoneArray objectAtIndex:i]]];
                }
            }else {
                phone = [NSString stringWithFormat:@"%@", [phoneArray objectAtIndex:0]];
            }
        }
        
        if ([emailArray count] > 0) {
            if ([emailArray count] > 1) {
                for (int i = 0; i < [emailArray count]; i++) {
                    email = [email stringByAppendingString:[NSString stringWithFormat:@"%@\n", [emailArray objectAtIndex:i]]];
                }
            }else {
                email = [NSString stringWithFormat:@"%@", [emailArray objectAtIndex:0]];
            }
        }
        
        //my code
        if((![email isEqualToString:@""]) && (![phone isEqualToString:@""])){
            NSLog(@"Email, %@" , email);
            NSLog(@"phone, %@" , phone);
            dOfPerson = [NSDictionary dictionaryWithObjectsAndKeys:
                         name, email, nil];
            
            [contactList addObject:dOfPerson];
            [emails addObject:email];
            email = @"";
            phone = @"";
            
        }
        //end
        
        //        NSLog(@"NAME : %@",name);
        //        NSLog(@"PHONE: %@",phone);
        //        NSLog(@"EMAIL: %@",email);
        
        // NSLog(@"\n");
    }
    
    NSLog(@"Contacts = %@",contactList);
    
    return contactList;
}

-(NSMutableArray*)sendInvitation{
    
    //my code
    contactList = [[NSMutableArray alloc] init];
    emails = [[NSMutableArray alloc]init];
    dOfPerson=[NSMutableDictionary dictionary];
    //end
    ABAddressBookRef allPeople = ABAddressBookCreate();
    CFArrayRef allContacts = ABAddressBookCopyArrayOfAllPeople(allPeople);
    CFIndex numberOfContacts  = ABAddressBookGetPersonCount(allPeople);
    
    NSLog(@"numberOfContacts------------------------------------%ld",numberOfContacts);
    
    
    for(int i = 0; i < numberOfContacts; i++){
        NSString* name = @"";
        NSString* phone = @"";
        NSString* email = @"";
        
        ABRecordRef aPerson = CFArrayGetValueAtIndex(allContacts, i);
        ABMultiValueRef fnameProperty = ABRecordCopyValue(aPerson, kABPersonFirstNameProperty);
        ABMultiValueRef lnameProperty = ABRecordCopyValue(aPerson, kABPersonLastNameProperty);
        
        ABMultiValueRef phoneProperty = ABRecordCopyValue(aPerson, kABPersonPhoneProperty);\
        ABMultiValueRef emailProperty = ABRecordCopyValue(aPerson, kABPersonEmailProperty);
        
        NSArray *emailArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(emailProperty);
        NSArray *phoneArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phoneProperty);
        
        
        if (fnameProperty != nil) {
            name = [NSString stringWithFormat:@"%@", fnameProperty];
        }
        if (lnameProperty != nil) {
            name = [name stringByAppendingString:[NSString stringWithFormat:@" %@", lnameProperty]];
        }
        
        if ([phoneArray count] > 0) {
            if ([phoneArray count] > 1) {
                for (int i = 0; i < [phoneArray count]; i++) {
                    phone = [phone stringByAppendingString:[NSString stringWithFormat:@"%@\n", [phoneArray objectAtIndex:i]]];
                }
            }else {
                phone = [NSString stringWithFormat:@"%@", [phoneArray objectAtIndex:0]];
            }
        }
        
        if ([emailArray count] > 0) {
            if ([emailArray count] > 1) {
                for (int i = 0; i < [emailArray count]; i++) {
                    email = [email stringByAppendingString:[NSString stringWithFormat:@"%@\n", [emailArray objectAtIndex:i]]];
                }
            }else {
                email = [NSString stringWithFormat:@"%@", [emailArray objectAtIndex:0]];
            }
        }
        
        //my code
        if((![email isEqualToString:@""]) && (![phone isEqualToString:@""])){
            NSLog(@"Email, %@" , email);
            NSLog(@"phone, %@" , phone);
            dOfPerson = [NSDictionary dictionaryWithObjectsAndKeys:
                         name, email, nil];
            
            [contactList addObject:dOfPerson];
            [emails addObject:email];
            email = @"";
            phone = @"";
            
        }
        //end
        
        //        NSLog(@"NAME : %@",name);
        //        NSLog(@"PHONE: %@",phone);
        //        NSLog(@"EMAIL: %@",email);
        
        // NSLog(@"\n");
    }
    
    NSLog(@"Contacts = %@",contactList);
    
    return emails;
}


-(NSMutableArray*)getEmailAndNames{
    contactList = [[NSMutableArray alloc] init];
    emails = [[NSMutableArray alloc]init];
    names = [[NSMutableArray alloc]init];
    
    dOfPerson=[NSMutableDictionary dictionary];
    //end
    ABAddressBookRef allPeople = ABAddressBookCreate();
    CFArrayRef allContacts = ABAddressBookCopyArrayOfAllPeople(allPeople);
    CFIndex numberOfContacts  = ABAddressBookGetPersonCount(allPeople);
    
    NSLog(@"numberOfContacts------------------------------------%ld",numberOfContacts);
    
    
    for(int i = 0; i < numberOfContacts; i++){
        NSString* name = @"";
        NSString* phone = @"";
        NSString* email = @"";
        
        ABRecordRef aPerson = CFArrayGetValueAtIndex(allContacts, i);
        ABMultiValueRef fnameProperty = ABRecordCopyValue(aPerson, kABPersonFirstNameProperty);
        ABMultiValueRef lnameProperty = ABRecordCopyValue(aPerson, kABPersonLastNameProperty);
        
        ABMultiValueRef phoneProperty = ABRecordCopyValue(aPerson, kABPersonPhoneProperty);\
        ABMultiValueRef emailProperty = ABRecordCopyValue(aPerson, kABPersonEmailProperty);
        
        NSArray *emailArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(emailProperty);
        NSArray *phoneArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phoneProperty);
        
        
        if (fnameProperty != nil) {
            name = [NSString stringWithFormat:@"%@", fnameProperty];
        }
        if (lnameProperty != nil) {
            name = [name stringByAppendingString:[NSString stringWithFormat:@" %@", lnameProperty]];
        }
        
        if ([phoneArray count] > 0) {
            if ([phoneArray count] > 1) {
                for (int i = 0; i < [phoneArray count]; i++) {
                    phone = [phone stringByAppendingString:[NSString stringWithFormat:@"%@\n", [phoneArray objectAtIndex:i]]];
                }
            }else {
                phone = [NSString stringWithFormat:@"%@", [phoneArray objectAtIndex:0]];
            }
        }
        
        if ([emailArray count] > 0) {
            if ([emailArray count] > 1) {
                for (int i = 0; i < [emailArray count]; i++) {
                    email = [email stringByAppendingString:[NSString stringWithFormat:@"%@\n", [emailArray objectAtIndex:i]]];
                }
            }else {
                email = [NSString stringWithFormat:@"%@", [emailArray objectAtIndex:0]];
            }
        }
        
        //my code
        if((![email isEqualToString:@""]) && (![phone isEqualToString:@""])){
            NSLog(@"Email, %@" , email);
            NSLog(@"phone, %@" , phone);
            dOfPerson = [NSDictionary dictionaryWithObjectsAndKeys:
                         email, name, nil];
            
            [contactList addObject:dOfPerson];
            
        }
        //end
        
        //        NSLog(@"NAME : %@",name);
        //        NSLog(@"PHONE: %@",phone);
        //        NSLog(@"EMAIL: %@",email);
        
        // NSLog(@"\n");
    }
    
    NSLog(@"Contacts = %@",contactList);
    
    return contactList;
}


-(NSMutableArray*)getPhoneNumbers{
    contactList = [[NSMutableArray alloc] init];
    emails = [[NSMutableArray alloc]init];
    names = [[NSMutableArray alloc]init];
    
    dOfPerson=[NSMutableDictionary dictionary];
    //end
    ABAddressBookRef allPeople = ABAddressBookCreate();
    CFArrayRef allContacts = ABAddressBookCopyArrayOfAllPeople(allPeople);
    CFIndex numberOfContacts  = ABAddressBookGetPersonCount(allPeople);
    
    NSLog(@"numberOfContacts------------------------------------%ld",numberOfContacts);
    
    
    for(int i = 0; i < numberOfContacts; i++){
        NSString* name = @"";
        NSString* phone = @"";
        NSString* email = @"";
        
        ABRecordRef aPerson = CFArrayGetValueAtIndex(allContacts, i);
        ABMultiValueRef fnameProperty = ABRecordCopyValue(aPerson, kABPersonFirstNameProperty);
        ABMultiValueRef lnameProperty = ABRecordCopyValue(aPerson, kABPersonLastNameProperty);
        
        ABMultiValueRef phoneProperty = ABRecordCopyValue(aPerson, kABPersonPhoneProperty);\
        ABMultiValueRef emailProperty = ABRecordCopyValue(aPerson, kABPersonEmailProperty);
        
        NSArray *emailArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(emailProperty);
        NSArray *phoneArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phoneProperty);
        
        
        if (fnameProperty != nil) {
            name = [NSString stringWithFormat:@"%@", fnameProperty];
        }
        if (lnameProperty != nil) {
            name = [name stringByAppendingString:[NSString stringWithFormat:@" %@", lnameProperty]];
        }
        
        if ([phoneArray count] > 0) {
            if ([phoneArray count] > 1) {
                for (int i = 0; i < [phoneArray count]; i++) {
                    phone = [phone stringByAppendingString:[NSString stringWithFormat:@"%@\n", [phoneArray objectAtIndex:i]]];
                }
            }else {
                phone = [NSString stringWithFormat:@"%@", [phoneArray objectAtIndex:0]];
            }
        }
        
        if ([emailArray count] > 0) {
            if ([emailArray count] > 1) {
                for (int i = 0; i < [emailArray count]; i++) {
                    email = [email stringByAppendingString:[NSString stringWithFormat:@"%@\n", [emailArray objectAtIndex:i]]];
                }
            }else {
                email = [NSString stringWithFormat:@"%@", [emailArray objectAtIndex:0]];
            }
        }
        
        //my code
        if((![email isEqualToString:@""]) && (![phone isEqualToString:@""])){
            NSLog(@"Email, %@" , email);
            NSLog(@"phone, %@" , phone);
            dOfPerson = [NSDictionary dictionaryWithObjectsAndKeys:
                         phone, name, nil];
            
            [contactList addObject:dOfPerson];
            
        }
        //end
        
        //        NSLog(@"NAME : %@",name);
        //        NSLog(@"PHONE: %@",phone);
        //        NSLog(@"EMAIL: %@",email);
        
        // NSLog(@"\n");
    }
    
    NSLog(@"Contacts = %@",contactList);
    
    return contactList;
}





@end
