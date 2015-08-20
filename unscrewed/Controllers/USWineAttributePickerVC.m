//
//  USWineAttributePickerVC.m
//  unscrewed
//
//  Created by Gary Kipp Earle on 10/1/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USWineAttributePickerVC.h"

@interface USWineAttributePickerVC () <UIPickerViewDataSource,
                                       UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *arrayPickerValues;
@property (nonatomic, strong) UIPickerView *wineAttrPicker;
@property (nonatomic, strong) NSString *apiFilterName;

@end

@implementation USWineAttributePickerVC

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.wineAttrPicker = [[UIPickerView alloc] init];
  self.wineAttrPicker.dataSource = self;
  self.wineAttrPicker.delegate = self;
  self.wineAttrPicker.center = self.view.center;
  [self.view addSubview:self.wineAttrPicker];

  if ([self.pushedFromSegueName isEqualToString:@"styleSegue"])
  {
    self.apiFilterName = @"filter_styles";
    if ([self.wineColorSelected isEqualToString:@"Red"])
    {
      self.arrayPickerValues = [USWineAttributePickerVC redStyleAttributes];
    } else if ([self.wineColorSelected isEqualToString:@"White"]) {
      self.arrayPickerValues = [USWineAttributePickerVC whiteStyleAttributes];
    }
  } else if ([self.pushedFromSegueName isEqualToString:@"priceSegue"]) {
    self.apiFilterName = @"filter_price_ranges";
    if ([self.retailerTypeSelected isEqualToString:@"Stores"]
        || [self.retailerTypeSelected isEqualToString:@"Online"])
    {
      self.arrayPickerValues = [USWineAttributePickerVC bottlePriceAttributes];
    } else if ([self.retailerTypeSelected isEqualToString:@"Restaurants"]) {
      self.arrayPickerValues = [USWineAttributePickerVC glassPriceAttributes];
    }
  } else if ([self.pushedFromSegueName isEqualToString:@"distanceSegue"]) {
    self.apiFilterName = @"radius";
    self.arrayPickerValues = [USWineAttributePickerVC distanceAttributes];
  } else if ([self.pushedFromSegueName isEqualToString:@"sizeSegue"]) {
    self.apiFilterName = @"size";
    self.arrayPickerValues = [USWineAttributePickerVC sizeAttributes];
  } else if ([self.pushedFromSegueName isEqualToString:@"pairingSegue"]) {
    self.apiFilterName = @"filter_pairings";
    self.arrayPickerValues = [USWineAttributePickerVC pairingAttributes];
  } else if ([self.pushedFromSegueName isEqualToString:@"varietalSegue"]) {
    self.apiFilterName = @"filter_subtypes";
    if ([self.wineColorSelected isEqualToString:@"Red"])
    {
      self.arrayPickerValues = [USWineAttributePickerVC redVarietalAttributes];
    } else if ([self.wineColorSelected isEqualToString:@"White"]) {
      self.arrayPickerValues =
        [USWineAttributePickerVC whiteVarietalAttributes];
    }
  } else if ([self.pushedFromSegueName isEqualToString:@"regionSegue"]) {
    self.apiFilterName = @"filter_regions";
    self.arrayPickerValues = [USWineAttributePickerVC regionAttributes];
  } else if ([self.pushedFromSegueName isEqualToString:@"vintageSegue"]) {
    self.apiFilterName = @"year";
    self.arrayPickerValues = [USWineAttributePickerVC vintageAttributes];
  } else if ([self.pushedFromSegueName isEqualToString:@"expertRatingSegue"]) {
    self.apiFilterName = @"filter_expert_sources";
    self.arrayPickerValues = [USWineAttributePickerVC expertRatingAttributes];
  } else if ([self.pushedFromSegueName isEqualToString:@"reviewedBySegue"]) {
    self.apiFilterName = @"filter_reviewed_by";
    self.arrayPickerValues = [USWineAttributePickerVC reviewedByAttributes];
  } else if ([self.pushedFromSegueName isEqualToString:@"producerSegue"]) {
    self.apiFilterName = @"filter_producers";
    self.arrayPickerValues = [USWineAttributePickerVC producerAttributes];
  }
}

- (void)viewWillDisappear:(BOOL)animated
{

  NSInteger row = [self.wineAttrPicker selectedRowInComponent:0];
  NSString *filterAttributeValue = [self.arrayPickerValues objectAtIndex:row];

  USWineSearchFilter *wineSearchFilter =
    [[USWineSearchFilter alloc] initWithApiFilterName:self.apiFilterName
                              andFilterAttributeValue:filterAttributeValue];

  [self.delegate pickAttributeViewController:self
            didFinishPickingWineSearchFilter:wineSearchFilter];

  [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  if ([pickerView isEqual:self.wineAttrPicker])
  {
    return 1;
  }

  return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(
    NSInteger)component
{
  if ([pickerView isEqual:self.wineAttrPicker])
  {
    return [self.arrayPickerValues count];
  }

  return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
  if ([pickerView isEqual:self.wineAttrPicker])
  {
    return [self.arrayPickerValues objectAtIndex:row];
  }

  return nil;
}

+ (NSArray *)redStyleAttributes
{
  static NSArray *_redStyleAttributes;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    _redStyleAttributes = @[@"Any",
                            @"Light & Fruity",
                            @"Smooth & Easy",
                            @"Big & Bold"];
  });

  return _redStyleAttributes;
}

+ (NSArray *)whiteStyleAttributes
{
  static NSArray *_whiteStyleAttributes;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    _whiteStyleAttributes = @[@"Any",
                              @"Light & Crisp",
                              @"Full & Smooth"];
  });

  return _whiteStyleAttributes;
}

+ (NSArray *)glassPriceAttributes
{
  static NSArray *_glassPriceAttributes;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    _glassPriceAttributes = @[@"Any",
                              @"Under $10",
                              @"$10 - $20",
                              @"Over $20"];
  });

  return _glassPriceAttributes;
}

+ (NSArray *)bottlePriceAttributes
{
  static NSArray *_bottlePriceAttributes;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    _bottlePriceAttributes = @[@"Any",
                               @"Under $50",
                               @"$50 - $100",
                               @"Over $100"];
  });

  return _bottlePriceAttributes;
}

+ (NSArray *)distanceAttributes
{
  static NSArray *_distanceAttributes;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    _distanceAttributes = @[@"Any",
                            @"< 1 mile",
                            @"< 3 miles",
                            @"< 10 miles"];
  });

  return _distanceAttributes;
}

+ (NSArray *)sizeAttributes
{
  static NSArray *_sizeAttributes;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    _sizeAttributes = @[@"Any",
                        @"750mL",
                        @"350mL",
                        @"1.5L"];
  });

  return _sizeAttributes;
}

+ (NSArray *)pairingAttributes
{
  static NSArray *_pairingAttributes;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    _pairingAttributes = @[@"Any",
                           @"BBQ",
                           @"Beef",
                           @"Cheeses",
                           @"Chocolate",
                           @"Fish",
                           @"Fruit",
                           @"Lamb",
                           @"Pasta",
                           @"Pizza",
                           @"Pork",
                           @"Poultry",
                           @"Salad",
                           @"Shellfish",
                           @"Spicy",
                           @"Sushi",
                           @"Vanilla"];
  });

  return _pairingAttributes;
}

+ (NSArray *)redVarietalAttributes
{
  static NSArray *_redVarietalAttributes;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    _redVarietalAttributes = @[@"Any",
                               @"Bourdeaux Blends",
                               @"Cabernet Sauvignon",
                               @"Chianti",
                               @"Malbec",
                               @"Merlot",
                               @"Pinot Noir",
                               @"Rhone Blends",
                               @"Sangiovese",
                               @"Syrah/Shiraz",
                               @"Tempranillo",
                               @"Zinfandel",
                               @"Other Red"];
  });

  return _redVarietalAttributes;
}

+ (NSArray *)whiteVarietalAttributes
{
  static NSArray *_whiteVarietalAttributes;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    _whiteVarietalAttributes = @[@"Any",
                                 @"Chardonnay",
                                 @"Pinot Gris/Grigio",
                                 @"Riesling",
                                 @"Sauvignon Blanc",
                                 @"Viognier",
                                 @"Other White"];
  });

  return _whiteVarietalAttributes;
}

+ (NSArray *)regionAttributes
{
  static NSArray *_regionAttributes;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    _regionAttributes = @[@"Any",
                          @"California",
                          @"Washington",
                          @"Oregon",
                          @"Australia",
                          @"New Zealand",
                          @"France",
                          @"Italy",
                          @"Spain",
                          @"Argentina",
                          @"Chile",
                          @"Other South America",
                          @"South Africa",
                          @"Austria",
                          @"Germany",
                          @"Greece",
                          @"Hungary",
                          @"Portugal",
                          @"Other Regions"];
  });

  return _regionAttributes;
}

+ (NSArray *)vintageAttributes
{
  static NSArray *_vintageAttributes;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    _vintageAttributes = @[@"Any",
                           @"2014",
                           @"2013",
                           @"2012",
                           @"2011",
                           @"2010"];
  });

  return _vintageAttributes;
}

+ (NSArray *)expertRatingAttributes
{
  static NSArray *_expertRatingAttributes;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    _expertRatingAttributes = @[@"Any",
                                @"95 - 100",
                                @"90 - 95",
                                @"85 - 90",
                                @"80 - 85",
                                @"Below 80"];
  });

  return _expertRatingAttributes;
}

+ (NSArray *)reviewedByAttributes
{
  static NSArray *_reviewedByAttributes;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    _reviewedByAttributes = @[@"Any",
                              @"Wine Spectator",
                              @"Wine Advocate (Robert Parker)",
                              @"James Suckling",
                              @"Stephen Tanzer",
                              @"Wine & Spirits",
                              @"Wine Enthusiast"];
  });

  return _reviewedByAttributes;
}

+ (NSArray *)producerAttributes
{
  static NSArray *_producerAttributes;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    _producerAttributes = @[@"Any",
                            @"Dependent"];
  });

  return _producerAttributes;
}

@end
