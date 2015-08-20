//
//  APTypes.h
//  AddressBook
//
//  Created by Alexey Belkevich on 1/11/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#ifndef AddressBook_APTypes_h
#define AddressBook_APTypes_h

@class USContact;

typedef enum
{
    APAddressBookAccessUnknown = 0,
    APAddressBookAccessGranted = 1,
    APAddressBookAccessDenied  = 2
} APAddressBookAccess;

typedef BOOL(^APContactFilterBlock)(USContact *contact);

typedef NS_OPTIONS(NSUInteger , APContactField)
{
    APContactFieldFirstName        = 1 << 0,
    APContactFieldLastName         = 1 << 1,
    APContactFieldCompany          = 1 << 2,
    APContactFieldPhones           = 1 << 3,
    APContactFieldEmails           = 1 << 4,
    APContactFieldPhoto            = 1 << 5,
    APContactFieldThumbnail        = 1 << 6,
    APContactFieldPhonesWithLabels = 1 << 7,
    APContactFieldCompositeName    = 1 << 8,
    APContactFieldAddresses        = 1 << 9,
    APContactFieldRecordID         = 1 << 10,
    APContactFieldCreationDate     = 1 << 11,
    APContactFieldModificationDate = 1 << 12,
    APContactFieldMiddleName       = 1 << 13,
    APContactFieldSocialProfiles   = 1 << 14,
    APContactFieldDefault          = APContactFieldFirstName | APContactFieldLastName |
                                        APContactFieldPhones,
    APContactFieldUnscrewed        = APContactFieldDefault | APContactFieldCompositeName | APContactFieldEmails |
                                        APContactFieldThumbnail | APContactFieldPhonesWithLabels | APContactFieldCompany ,
    APContactFieldUnscrewedEmails  = APContactFieldCompositeName | APContactFieldEmails |
                                        APContactFieldThumbnail | APContactFieldCompany ,
    APContactFieldAll              = 0xFFFF
};

#endif