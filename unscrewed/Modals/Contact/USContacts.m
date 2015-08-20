//
//  USContacts.m
//  Unscrewed
//
//  Created by Robin on 9/19/14.
//  Copyright (c) 2014 AddVal. All rights reserved.
//

#import "USContacts.h"
#import "APAddressBook.h"

BOOL isAddressBookReloadRequried = YES;
void (^observerAddressBookExternalChanges)(void) = ^{ isAddressBookReloadRequried = YES; };

@interface USContacts ()
@property (nonatomic, strong) APAddressBook *addressBook;
@property (nonatomic, assign) BOOL isReloadRequired;
@end

@implementation USContacts

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (id)sharedObject {
    isAddressBookReloadRequried = YES; // setting it to yes cuz we want to load contacts everytime when we use sharedObject method
    static USContacts *contacts = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        contacts = [[self alloc] init];
    });
    return contacts;
}

- (void)loadDeviceContacts:(void (^)(NSError *error))callbackBlock isForInvite:(BOOL)forInvite {
    if (isAddressBookReloadRequried == NO) {
        if (callbackBlock) {
            callbackBlock(nil);
        }
        return;
    }
    APAddressBook *addressBook;
    if (!self.addressBook) {
        addressBook = [[APAddressBook alloc] init];
        [addressBook startObserveChangesWithCallback:observerAddressBookExternalChanges];
        self.addressBook = addressBook;
    } else {
        addressBook = self.addressBook;
    }
    
    addressBook.fieldsMask = (forInvite ? APContactFieldUnscrewed : APContactFieldUnscrewedEmails);
    addressBook.filterBlock = ^BOOL(USContact *contact) {
        return contact.emails.count > 0 || contact.phones.count > 0;
    };
    
    [addressBook loadContacts:^(NSArray *contacts, NSError *error) {
        if (!error) {
            isAddressBookReloadRequried = NO;
            self.arrContacts = nil;
            self.arrContacts = [[self sortContactsAlphabetically:contacts] mutableCopy];
        } else {
            LogError(@"Permission Denied");
        }
        if (callbackBlock) {
            callbackBlock(error);
        }
    }];
}

- (NSArray *)sortContactsAlphabetically:(NSArray *)contactsArray {
    NSArray *sortedContactsArray = [contactsArray sortedArrayUsingComparator:^NSComparisonResult(USContact *obj1, USContact *obj2) {
        NSString *name1;
        NSString *name2;
        if(ABPersonGetSortOrdering() == kABPersonSortByFirstName) {
            if(obj1.firstName) {
                name1 = obj1.firstName;
            } else {
                name1 = obj1.lastName;
            }
            if(obj2.firstName) {
                name2 = obj2.firstName;
            } else {
                name2 = obj2.lastName;
            }
        } else if (ABPersonGetSortOrdering() == kABPersonSortByLastName) {
            if(obj1.lastName) {
                name1 = obj1.lastName;
            } else {
                name1 = obj1.firstName;
            }
            if(obj2.lastName) {
                name2 = obj2.lastName;
            } else {
                name2 = obj2.firstName;
            }
        }
        name1 = [name1 lowercaseString];
        name2 = [name2 lowercaseString];
        return [name1 compare:name2];
    }];
    return sortedContactsArray;
}


- (NSArray *)sortContacts:(NSArray *)arrayContacts {
    NSMutableDictionary *allContactsDictionary = [NSMutableDictionary dictionary];
    NSArray *sortedKeysAllContacts = [NSArray array];
    
    for (USContact *person in arrayContacts) {
        //first letter based on sort order
        NSString *firstLetter;
        if(ABPersonGetSortOrdering() == kABPersonSortByFirstName) {
            if(person.firstName)
                firstLetter = [[person.firstName substringToIndex:1] uppercaseString];
            else
                firstLetter = [[person.lastName substringToIndex:1] uppercaseString];
        } else {
            if(person.lastName)
                firstLetter = [[person.lastName substringToIndex:1] uppercaseString];
            else
                firstLetter = [[person.firstName substringToIndex:1] uppercaseString];
        }
        NSMutableArray *letterList = [allContactsDictionary objectForKey:firstLetter];
        if (!letterList && firstLetter) {
            letterList = [NSMutableArray array];
            [allContactsDictionary setObject:letterList forKey:firstLetter];
        }
        [letterList addObject:person];
    }
    sortedKeysAllContacts = [[allContactsDictionary allKeys] sortedArrayUsingSelector: @selector(compare:)];
    return sortedKeysAllContacts;
}

- (void)dealloc {
    [self.addressBook stopObserveChanges];
}

@end
