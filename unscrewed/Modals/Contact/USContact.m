//
//  APContact.m
//  APAddressBook
//
//  Created by Alexey Belkevich on 1/10/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import "USContact.h"
#import "APPhoneWithLabel.h"
#import "APAddress.h"
#import "APSocialProfile.h"
#import "USUsers.h"

@class USUsers;
@implementation USContact

#pragma mark - life cycle

- (id)initWithRecordRef:(ABRecordRef)recordRef fieldMask:(APContactField)fieldMask
{
    self = [super init];
    if (self)
    {
        NSMutableDictionary *contactImport = [[NSMutableDictionary alloc] init];
        
        _fieldMask = fieldMask;
        if (fieldMask & APContactFieldFirstName)
        {
            _firstName = [self stringProperty:kABPersonFirstNameProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldMiddleName)
        {
            _middleName = [self stringProperty:kABPersonMiddleNameProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldLastName)
        {
            _lastName = [self stringProperty:kABPersonLastNameProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldCompositeName)
        {
            _fullName = [self compositeNameFromRecord:recordRef];
            if (_fullName && _fullName.length) {
                [contactImport setObject:_fullName forKey:@"name"];
            }
        }
        if (fieldMask & APContactFieldCompany)
        {
            _company = [self stringProperty:kABPersonOrganizationProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldPhones)
        {
            _strippedPhones = [NSMutableArray new];
            _phones = [self arrayProperty:kABPersonPhoneProperty fromRecord:recordRef];
            [contactImport setObject:_strippedPhones forKey:@"phones"];
        }
        if (fieldMask & APContactFieldPhonesWithLabels)
        {
            _phonesWithLabels = [self arrayOfPhonesWithLabelsFromRecord:recordRef];
        }
        if (fieldMask & APContactFieldEmails)
        {
            _emails = [self arrayProperty:kABPersonEmailProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldPhoto)
        {
            _photo = [self imagePropertyFullSize:YES fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldThumbnail)
        {
            _thumbnail = [self imagePropertyFullSize:NO fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldAddresses)
        {
            NSMutableArray *addresses = [[NSMutableArray alloc] init];
            NSArray *array = [self arrayProperty:kABPersonAddressProperty fromRecord:recordRef];
            for (NSDictionary *dictionary in array)
            {
                APAddress *address = [[APAddress alloc] initWithAddressDictionary:dictionary];
                [addresses addObject:address];
            }
            _addresses = addresses.copy;
        }
        if (fieldMask & APContactFieldRecordID)
        {
            _recordID = [NSNumber numberWithInteger:ABRecordGetRecordID(recordRef)];
        }
        if (fieldMask & APContactFieldCreationDate)
        {
            _creationDate = [self dateProperty:kABPersonCreationDateProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldModificationDate)
        {
            _modificationDate = [self dateProperty:kABPersonModificationDateProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldSocialProfiles)
        {
            NSMutableArray *profiles = [[NSMutableArray alloc] init];
            NSArray *array = [self arrayProperty:kABPersonSocialProfileProperty fromRecord:recordRef];
            for (NSDictionary *dictionary in array)
            {
                APSocialProfile *profile = [[APSocialProfile alloc] initWithSocialDictionary:dictionary];
                [profiles addObject:profile];
            }
            
            _socialProfiles = profiles;
        }
        
        _isUnscrewedUser = NO;
        [[[USUsers sharedUser] arrContactsToImport] addObject:contactImport];
    }
    return self;
}

- (void)mergeInfoFromPersonRef:(ABRecordRef) recordRef {
    
    //merging 2 arrays adding only the unique elements.
    NSArray *mergedEmails = [self arrayProperty:kABPersonEmailProperty fromRecord:recordRef];
    _emails = [self mergeArrayNoDupes:_emails withArray:mergedEmails];
    
    _strippedPhones = [NSMutableArray new];
    NSArray *mergedPhones = [self arrayProperty:kABPersonPhoneProperty fromRecord:recordRef];
    _phones = [self mergeArrayNoDupes:_phones withArray:mergedPhones];
//    NSArray *strippedPhonesMerged = [self mergeArrayNoDupes:[_contactImport objectForKey:@"phones"] withArray:_strippedPhones];
//    [_contactImport setObject:strippedPhonesMerged forKey:@"phones"];
}

- (NSArray*) mergeArrayNoDupes:(NSArray*) array1 withArray:(NSArray*) array2 {
    NSPredicate *relativeComplementPredicate =
    [NSPredicate predicateWithFormat:@"NOT SELF IN %@", array2];
    NSArray *items = [array1 filteredArrayUsingPredicate:relativeComplementPredicate];
    items = [items arrayByAddingObjectsFromArray:array2];
    return items;
}


#pragma mark - private

- (NSString *)stringProperty:(ABPropertyID)property fromRecord:(ABRecordRef)recordRef
{
    CFTypeRef valueRef = (ABRecordCopyValue(recordRef, property));
    return (__bridge_transfer NSString *)valueRef;
}

- (NSArray *)arrayProperty:(ABPropertyID)property fromRecord:(ABRecordRef)recordRef
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self enumerateMultiValueOfProperty:property fromRecord:recordRef
                              withBlock:^(ABMultiValueRef multiValue, NSUInteger index)
    {
        CFTypeRef value = ABMultiValueCopyValueAtIndex(multiValue, index);
        NSString *string = (__bridge_transfer NSString *)value;
        if (string)
        {
            [array addObject:string];
            if(property == kABPersonPhoneProperty) {
                NSString *phoneNumber = [HelperFunctions stripNumber:string];
                if (phoneNumber.length>10) {
                    phoneNumber = [phoneNumber substringFromIndex:phoneNumber.length-10];
                }
                [_strippedPhones addObject:phoneNumber];
            }
        }
    }];
    return array.copy;
}


- (NSDate *)dateProperty:(ABPropertyID)property fromRecord:(ABRecordRef)recordRef
{
    CFDateRef dateRef = (ABRecordCopyValue(recordRef, property));
    return (__bridge_transfer NSDate *)dateRef;
}

- (NSArray *)arrayOfPhonesWithLabelsFromRecord:(ABRecordRef)recordRef
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self enumerateMultiValueOfProperty:kABPersonPhoneProperty fromRecord:recordRef
                              withBlock:^(ABMultiValueRef multiValue, NSUInteger index)
    {
        CFTypeRef rawPhone = ABMultiValueCopyValueAtIndex(multiValue, index);
        NSString *phone = (__bridge_transfer NSString *)rawPhone;
        if (phone)
        {
            NSString *label = [self localizedLabelFromMultiValue:multiValue index:index];
            APPhoneWithLabel *phoneWithLabel = [[APPhoneWithLabel alloc] initWithPhone:phone
                                                                                 label:label];
            [array addObject:phoneWithLabel];
        }
    }];
    return array.copy;
}

- (UIImage *)imagePropertyFullSize:(BOOL)isFullSize fromRecord:(ABRecordRef)recordRef
{
    ABPersonImageFormat format = isFullSize ? kABPersonImageFormatOriginalSize :
                                 kABPersonImageFormatThumbnail;
    NSData *data = (__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(recordRef, format);
    return [UIImage imageWithData:data scale:UIScreen.mainScreen.scale];
}

- (NSString *)localizedLabelFromMultiValue:(ABMultiValueRef)multiValue index:(NSUInteger)index
{
    NSString *label;
    CFTypeRef rawLabel = ABMultiValueCopyLabelAtIndex(multiValue, index);
    if (rawLabel)
    {
        CFStringRef localizedLabel = ABAddressBookCopyLocalizedLabel(rawLabel);
        if (localizedLabel)
        {
            label = (__bridge_transfer NSString *)localizedLabel;
        }
        CFRelease(rawLabel);
    }
    return label;
}

- (NSString *)compositeNameFromRecord:(ABRecordRef)recordRef
{
    CFStringRef compositeNameRef = ABRecordCopyCompositeName(recordRef);
    return (__bridge_transfer NSString *)compositeNameRef;
}

- (void)enumerateMultiValueOfProperty:(ABPropertyID)property fromRecord:(ABRecordRef)recordRef
                            withBlock:(void (^)(ABMultiValueRef multiValue, NSUInteger index))block
{
    ABMultiValueRef multiValue = ABRecordCopyValue(recordRef, property);
    NSUInteger count = (NSUInteger)ABMultiValueGetCount(multiValue);
    for (NSUInteger i = 0; i < count; i++)
    {
        block(multiValue, i);
    }
    CFRelease(multiValue);
}

@end
