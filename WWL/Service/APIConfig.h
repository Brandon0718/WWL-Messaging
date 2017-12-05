//
//  APIConfig.h
//  8a-ios
//
//  Created by Mobile on 21/04/2017.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#ifndef APIConfig_h
#define APIConfig_h

#define API_BASE_URL_DEV                    @"https://dev-api.wwl.tv"
#define API_BASE_URL_STAGING                @"http://staging-api.wwl.tv"

#pragma mark - APIs

#define API_CONFIRM_CODE            @"/api/v1/login/request-code"

#define API_LOGIN                   @"/api/v1/login"
#define API_PROFILE_CHECK           @"/api/v1/users/profile-fields/check"
#define API_PROFILE_FIELDS          @"/api/v1/users/profile-fields"
#define API_PROFILE_UPDATE          @"/api/v1/users/profile-fields/%ld"

#define API_CHANNELS                @"/api/v1/channels"
#define API_STREAM_TOKEN            @"/api/v1/streams/token"

#define API_CHANNELS                @"/api/v1/channels"
#define API_FAV_CHANNEL_IDS         @"/api/v1/channel-favorites"
#define API_CHANNEL_CONNECTIONS     @"/api/v1/channel-connections"
#define API_FAV_CHANNEL_OBJECTS     @"/api/v1/channels?search[filter]=favorite"
#define API_CHANNEL_CONNECTIONS_OBJ @"/api/v1/channels?search[filter]=connections"
#define API_NEAR_CHANNELS           @"/api/v1/channels?search[filter]=near"
#define API_RECENT_CHANNELS         @"/api/v1/channels?search[filter]=recently_used"
#define API_STREAM_ME               @"/api/v1/streams/me"
#define API_STREAM_ME_PAGE          @"/api/v1/streams/me?page=%d"
#define API_STREAM_TYPES            @"/api/v1/stream-types"
#define API_STREAM_TOKEN            @"/api/v1/streams/token"

#define API_STREAM_VOD              @"/api/v1/channels/streams?page=%d"

#define API_LOCATION                @"/api/v1/user-locations"
#define API_STREAM_VIDEO            @"/api/v1/streams/%d/watch-playback"

// Twilio
#define API_CHAT_ACCESS_TOKEN       @"/api/v1/chat/access-token"

#endif /* APIConfig_h */
