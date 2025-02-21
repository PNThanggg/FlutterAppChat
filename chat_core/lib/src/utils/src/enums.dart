enum SStorageKeys {
  myProfile,
  vAccessToken,
  isLogin,
  appTheme,
  clintVersion,
  adminAccessPassword,
  isViewer,
  isFirstRun,
  appRootPath,
  appMetaData,
  appLanguageTitle,
  inAppAlerts,
  appLanguageCode,
  lastAppliedUpdate,
  lastSuccessFetchRoomsTime,
  vBaseUrl,
  appConfigModelData,
  mobileDataMediaDownloadOptions,
  wifiMediaDownloadOptions,
}

enum RegisterStatus {
  accepted,
  pending,
  notAccepted,
}

enum UserPrivacyType { forReq, public, none }

enum ApiI18nErrorRes {
  invalidLoginData,
  userEmailNotFound,
  yourAccountBlocked,
  yourAccountDeleted,
  userAlreadyRegister,
  codeHasBeenExpired,
  invalidCode,
  whileAuthCanFindYou,
  userRegisterStatusNotAcceptedYet,
  deviceHasBeenLogoutFromAllDevices,
  userDeviceSessionEndDeviceDeleted,
  noCodeHasBeenSendToYouToVerifyYourEmail,
  roomAlreadyInCall,
  peerUserInCallNow,
  callNotAllowed,
  peerUserDeviceOffline,
  emailMustBeValid,
  wait2MinutesToSendMail,
}

enum UserRoles { prime, admin, staff, hasBadge, none }

enum ChatRequestStatus { accepted, refused, canceled, pending }

enum RegisterMethod { email, phone, apple, google, facebook }
