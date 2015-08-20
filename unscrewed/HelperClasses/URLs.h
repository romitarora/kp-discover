//
//  URLs.h
//  unscrewed
//
//  Created by Robin Garg on 14/01/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#ifndef unscrewed_URLs_h
#define unscrewed_URLs_h

#if DEBUG
//#define __URL @"http://localhost:3000"
//#define __URL @"http://192.168.1.196:8080"
#define __URL @"https://unscrewed-api-staging-2.herokuapp.com"
#else
#define __URL @"https://unscrewed-api-staging-2.herokuapp.com"            // live
#endif

#define appBaseURL __URL@"/api/"
#define DATA_PAGE_SIZE 25

#pragma mark - Urls
#define urlSignUp appBaseURL@"signup"
#define urlSignInWithEmail appBaseURL@"auth"

#define urlFacebook urlSignInWithEmail@"/facebook"
#define urlContacts urlSignInWithEmail@"/contacts"

#define urlFindFriends appBaseURL@"user/find_friends"
#define urlUsers appBaseURL@"users"
#define urlUserInfo appBaseURL@"user"
#define urlSearchUsers urlUserInfo@"/search"
#define urlUserWines urlUserInfo@"/wines"
#define urlFollowingUsers urlUserInfo@"/following"
#define urlFollowUser urlUserInfo@"/follow/%@"
#define urlFollowers urlUserInfo@"/followers"

#define urlExcludeWines urlUserInfo@"/exclude/%@"

//#define urlPosts appBaseURL@"posts"
#define urlPosts @"http://www.unscrewed.com/wp/wp-json/posts"

#define urlWines appBaseURL@"wines"
#define urlWineDetailsOfWineId urlWines@"/%@"
#define urlLikeUnlikeWinesWithWineId urlWines@"/%@/likes"
#define urlWantWineWithWineId urlWines@"/%@/wants"
#define urlReviewsForWineId urlWines@"/%@/reviews"
#define urlPostReviewForWineId urlWines@"/%@/comments"

#define urlSnappedWines urlWines@"/5555555555/photos"

#define urlPlaces appBaseURL@"places"
#define urlMyPlaces appBaseURL@"user/places"
#define urlPlaceDetails urlPlaces@"/%@"
#define urlStarPlacesWithID urlPlaces@"/%@/likes"
#define urlPostReviewForStoreId urlPlaces@"/%@/comments"

#define urlWineFilters appBaseURL@"filters/wine"

#pragma mark - Keys
#pragma mark Common Keys
// Request
#define emailKey @"email"
#define passwordKey @"password"
#define queryKey @"q"
#define autocompleteKey @"autocomplete"

// Response
#define idKey @"id"
#define authenticatedKey @"authenticated"
#define successKey @"success"
#define errorsKey @"errors"
#define messageKey @"message"
#define baseErrorsKey @"base"
#define latitudeKey @"lat"
#define longitudeKey @"lng"

// Photo
#define photoKey @"photo"
#define defaultKey @"default"
#define url_Key @"url" // need underscore since there a an existing property with the same name in APSocialProfile.m class
#define storeUrlKey @"product_url"

// Paging
#define pageKey @"page"
#define perPageKey @"per_page"
#define currentPageKey @"current_page"

// Following Users
#define usersKey @"users"
#define usersCountKey @"users_count"
#define usersTotalCountKey @"users_total"

#pragma mark Sign Up Api Keys
// Request
#define userNameKey @"username"
#define photoUrlKey @"photo_url"
// Response
#define userKey @"user"
#define authTokenKey @"auth_token"
#define authTokenExpiresKey @"auth_token_expires_at"
#define autoFollowKey @"auto_follow"
#define avatarKey @"avatar"
#define bioKey @"bio"
#define hasEmailPasswordKey @"has_email_password"
#define bookmarkedPlacesCountKey @"bookmarked_places_count"
#define bookmarkedWinesCountKey @"bookmarked_wines_count"
#define facebookConnectedKey @"facebook_connected"
#define twitterConnectedKey @"twitter_connected"
#define followerCountKey @"follower_count"
#define followingCountKey @"following_count"
#define likedPlacesCountKey @"liked_places_count"
#define likedWinesCountKey @"liked_wines_count"

#pragma mark Places
// Request
#define latitudeKey @"lat"
#define longitudeKey @"lng"
#define radiusKey @"radius"
#define placeTypesKey @"place_types"
#define placeSubTypesKey @"place_subtypes"
#define skipOnlineKey @"skip_online"
#define showOnlineKey @"show_online"
#define showOfflineKey @"show_offline"
// Response
#define placesKey @"places"
#define placesTotalCountKey @"places_total"
#define likesKey @"likes"
#define likesTotalCountKey @"likes_total"
#define nameKey @"name"
#define locationKey @"location"
#define addressKey @"street1"
#define cityKey @"city"
#define stateKey @"state"
#define countryKey @"country"
#define zipCodeKey @"zip_code"
#define bookmarksCountKey @"bookmarks_count"
#define commentsCountKey @"comments_count"
#define dealsCountKey @"deals_count"
#define likesCount @"likes_count"
#define photosCountKey @"photos_count"
#define placeIdKey @"place_id"
#define typeKey @"type"
#define subTypeKey @"subtype"
#define wantsCountKey @"wants_count"
#define wineCountsKey @"wine_counts"
#define placeKey @"place"
#define distanceKey @"distance_in_mi"

#define friendLikesKey @"friend_likes"
#define friendLikesCountKey @"friend_likes_total"
#define friendLikesPlaceKey @"friends_like_place_wines"

#define socialKey @"social"
#define socialCountKey @"social_total"

#pragma mark Posts/Blogs API
// Request

// Response
#define postsKey @"posts"
#define postsCountKey @"posts_count"

#define postTitleKey @"title"
#define postBodyKey @"excerpt"
#define postCreatedAtKey @"date_gmt"
#define postUpdatedAtKey @"modified_gmt"
#define postPhotoUrlsKey @"photo_urls"
#define blogUrlKey @"link"

#define postImageInfoKey @"featured_image"
#define postImageUrlKeyPath @"attachment_meta.sizes.et-pb-post-main-image-fullwidth.url"

#pragma mark Wines API
// Request
// Response
#define winesKey @"wines"
#define winesCountKey @"wines_total"
#define yearKey @"year"
#define averagePriceKey @"avg_price"
#define onlineAveragePriceKey @"online_avg_price"
#define restaurantAveragePriceKey @"restaurant_avg_price"
#define closestPlaceKey @"closest_place"
#define pricesKey @"prices"
#define photoSubjectKey @"subject_type"
#define minPriceKey @"min_price"

#pragma mark Wine
#define wineSizeKey @"750ml"
#define wineRatingsCountKey @"ratings_count"
#define wineAvgRatingsCountKey @"avg_rating"
#define wineValueKey @"wine_value"
#define wineExpertPts @"avg_expert_rating"
#define wineKey @"wine"
#define likedKey @"liked"
#define wantsKey @"wants"
#define ratedKey @"rated"
#define followingKey @"following"
#define myCommentKey @"my_comment"


#define inStockNearbyKey @"in_stock_nearby"
#define lowestPriceKey @"lowest_price"

#pragma mark Expert Reviews
#define expertRatingsKey @"expert_ratings"
#define ratingKey @"rating"
#define expertInfoKey @"expert_source"

#pragma mark User Reviews
#define userLikesKey @"user_likes"
#define userCommentsKey @"user_comments"
#define userCommentsTotalKey @"user_comments_total"
#define friendCommentsKey @"friend_comments"
#define friendCommentsTotal @"friend_comments_total"

#pragma mark Filter API
#define filterKey @"filter"

// Wine Filters
#define wineFiltersKey @"wine_filters"

#define filterTypesKey @"filter_types"
#define filterStylesKey @"filter_styles"
#define filterPairingsKey @"filter_pairings"
#define filterSubtypesKey @"filter_subtypes"
#define filterRegionsKey @"filter_regions"
#define filterSubRegionsKey @"filter_subregions"
#define filterPriceRangesKey @"filter_price_ranges"
#define filterExpertRatingRangesKey @"filter_expert_rating_ranges"
#define filterExpertSourcesKey @"filter_expert_sources"
#define filterProducerKey @"producer"

#pragma mark Review/Comment Wine
#define titleKey @"title"
#define bodyKey @"body"
#define commentKey @"comment"
#define ratingKey @"rating"
#define reviewTextKey @"review_text"
#define postedAtKey @"review_date"
#define createdAtKey @"created_at"
#endif
