//
//  APAddressBook.m
//  APAddressBook
//
//  Created by Alexey Belkevich on 1/10/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "APAddressBook.h"
#import "USContact.h"

void APAddressBookExternalChangeCallback(ABAddressBookRef addressBookRef, CFDictionaryRef info,
                                         void *context);

@interface APAddressBook ()
@property (nonatomic, readonly) ABAddressBookRef addressBook;
@property (nonatomic, readonly) dispatch_queue_t localQueue;
@property (nonatomic, copy) void (^changeCallback)();
@end

@implementation APAddressBook

#pragma mark - life cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        CFErrorRef *error = NULL;
        _addressBook = ABAddressBookCreateWithOptions(NULL, error);
        if (error)
        {
            NSLog(@"%@", (__bridge_transfer NSString *)CFErrorCopyFailureReason(*error));
            return nil;
        }
        NSString *name = [NSString stringWithFormat:@"com.alterplay.addressbook.%ld",
                                   (long)self.hash];
        _localQueue = dispatch_queue_create([name cStringUsingEncoding:NSUTF8StringEncoding], NULL);
        self.fieldsMask = APContactFieldDefault;
    }
    return self;
}

- (void)dealloc
{
    [self stopObserveChanges];
    if (_addressBook)
    {
        CFRelease(_addressBook);
    }
#if !OS_OBJECT_USE_OBJC
    dispatch_release(_localQueue);
#endif
}

#pragma mark - public

+ (APAddressBookAccess)access
{
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    switch (status)
    {
        case kABAuthorizationStatusDenied:
        case kABAuthorizationStatusRestricted:
            return APAddressBookAccessDenied;

        case kABAuthorizationStatusAuthorized:
            return APAddressBookAccessGranted;

        default:
            return APAddressBookAccessUnknown;
    }
}

- (void)loadContacts:(void (^)(NSArray *contacts, NSError *error))callbackBlock
{
    [self loadContactsOnQueue:dispatch_get_main_queue() completion:callbackBlock];
}

- (void)loadContactsOnQueue:(dispatch_queue_t)queue
                 completion:(void (^)(NSArray *contacts, NSError *error))completionBlock
{
    APContactField fieldMask = self.fieldsMask;
    NSArray *descriptors = self.sortDescriptors;
    APContactFilterBlock filterBlock = self.filterBlock;

	ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef errorRef)
	{
	    dispatch_async(self.localQueue, ^
        {
	        NSArray *array = nil;
	        NSError *error = nil;
            if (granted)
            {
                CFArrayRef peopleArrayRef = ABAddressBookCopyArrayOfAllPeople(self.addressBook);
                CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(kCFAllocatorDefault, CFArrayGetCount(peopleArrayRef),peopleArrayRef);
                CFArraySortValues(peopleMutable, CFRangeMake(0, CFArrayGetCount(peopleMutable)), (CFComparatorFunction) ABPersonComparePeopleByName,(void*) ABPersonGetSortOrdering());
                
                NSUInteger contactCount = (NSUInteger)CFArrayGetCount(peopleMutable);
                NSMutableSet *linkedPersonsToSkip = [[NSMutableSet alloc] init];
                NSMutableArray *contacts = [[NSMutableArray alloc] init];

                for (int i=0; i<contactCount; i++){
                    
                    ABRecordRef personRecordRef = CFArrayGetValueAtIndex(peopleMutable, i);
                    
                    // skip if contact has already been merged
                    //
                    if ([linkedPersonsToSkip containsObject:(__bridge id)(personRecordRef)]) {
                        continue;
                    }
                    
                    // Create object representing this person
                    //
                    USContact *thisPerson = [[USContact alloc] initWithRecordRef:personRecordRef fieldMask:fieldMask];
                    
                    // check if there are linked contacts & merge their contact information
                    //
                    CFArrayRef linked = ABPersonCopyArrayOfAllLinkedPeople(personRecordRef);
                    if (CFArrayGetCount(linked) > 1) {
                        [linkedPersonsToSkip addObjectsFromArray:(__bridge NSArray *)(linked)];
                        
                        // merge linked contact info
                        for (int m = 0; m < CFArrayGetCount(linked); m++) {
                            ABRecordRef iLinkedPerson = CFArrayGetValueAtIndex(linked, m);
                            // don't merge the same contact
                            if (iLinkedPerson == personRecordRef) {
                                CFRelease(iLinkedPerson);
                                continue;
                            }
                            [thisPerson mergeInfoFromPersonRef:iLinkedPerson];
                            CFRelease(iLinkedPerson);
                        }
                    }
                    
                    if (!filterBlock || filterBlock(thisPerson))
                    {
                        [contacts addObject:thisPerson];
                    }
                    CFRelease(linked);
                }

                CFRelease(peopleMutable);

//                for(USContact* contact in contacts) {
//                    [_users.arrContactsToImport addObject:contact.contactImport];
//                }


                
                
                
                
//                CFArrayRef peopleArrayRef = ABAddressBookCopyArrayOfAllPeople(self.addressBook);
//                NSUInteger contactCount = (NSUInteger)CFArrayGetCount(peopleArrayRef);
//                for (NSUInteger i = 0; i < contactCount; i++)
//                {
//                    ABRecordRef recordRef = CFArrayGetValueAtIndex(peopleArrayRef, i);
//                    USContact *contact = [[USContact alloc] initWithRecordRef:recordRef fieldMask:fieldMask];
//                    if (!filterBlock || filterBlock(contact)) {
//                        [contacts addObject:contact];
//                    }
//                }
                [contacts sortUsingDescriptors:descriptors];
                array = contacts.copy;
                CFRetain(peopleArrayRef);
                CFRelease(peopleArrayRef);
            }
            else if (errorRef)
            {
                error = (__bridge NSError *)errorRef;
            }

            dispatch_async(queue, ^
            {
                if (completionBlock)
                {
                    completionBlock(array, error);
                }
            });
		});
	});
}

- (void)startObserveChangesWithCallback:(void (^)())callback
{
    if (callback)
    {
        if (!self.changeCallback)
        {
            ABAddressBookRegisterExternalChangeCallback(self.addressBook,
                                                        APAddressBookExternalChangeCallback,
                                                        (__bridge void *)(self));
        }
        self.changeCallback = callback;
    }
}

- (void)stopObserveChanges
{
    if (self.changeCallback)
    {
        self.changeCallback = nil;
        ABAddressBookUnregisterExternalChangeCallback(self.addressBook,
                                                      APAddressBookExternalChangeCallback,
                                                      (__bridge void *)(self));
    }
}

#pragma mark - external change callback

void APAddressBookExternalChangeCallback(ABAddressBookRef __unused addressBookRef,
                                         CFDictionaryRef __unused info,
                                         void *context)
{
    APAddressBook *addressBook = (__bridge APAddressBook *)(context);
    addressBook.changeCallback ? addressBook.changeCallback() : nil;
}

@end
