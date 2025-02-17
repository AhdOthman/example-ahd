const String baseUrl = 'https://su-v2-backend.projecx.io/api';
const String signupLink = '$baseUrl/auth/register';
const String signinLink = '$baseUrl/auth/login';
const String getCountryLink = '$baseUrl/presets/countries';
const String getNotificationLink = '$baseUrl/notification/private/me';
const String acceptInviteLink = '$baseUrl/trainee/acceptInvitation';
const String rejectInviteLink = '$baseUrl/trainee/rejectInvitation';
const String getTenantLink = '$baseUrl/trainee/tenant/list';
const String getProfileLink = '$baseUrl/trainee/profile/editPersonalDetails';
const String editProfileLink = '$baseUrl/trainee/profile/editPersonalDetails';
const String sendKycLink = '$baseUrl/trainee/profile/sendKycRequest';
const String getTaskLink = '$baseUrl/trainee/task/list';
const String getProgramsLink = '$baseUrl/trainee/program/list';
const String getProgramsTasksLink = '$baseUrl/trainee/program/tasks';
const String getTaskDetailsLink = '$baseUrl/trainee/task/details';
const String editProfilePictureLink = '$baseUrl/trainee/profile/editPicture';
const String updatePasswordLink = '$baseUrl/trainee/profile/editPassword';
const String submitTaskLink = '$baseUrl/trainee/task/submit';
const String getWalletBalanceLink = '$baseUrl/trainee/wallet/get';
const String getPayoutMethodsLink =
    '$baseUrl/trainee/wallet/payout/method/list';
const String getPayoutMethodDetailsLink =
    '$baseUrl/trainee/wallet/payout/method/details';
const String addPaymentMethodLink =
    '$baseUrl/trainee/wallet/payout/method/update';
const String getTraineePaymentMethodLink =
    '$baseUrl/trainee/wallet/payout/methods/list';
const String createPayoutRequestLink = '$baseUrl/trainee/wallet/payout/request';
const String getPayoutHistoryLink = '$baseUrl/trainee/wallet/payout/history';
const String downloadPhoto = '$baseUrl/storage/download/';
const String deleteAccountLink = '$baseUrl/auth/delete/account';
const String getKycRequestLink = '$baseUrl/admin/kyc/request/get/details';
const String signinWithAppleLink = '$baseUrl/auth/apple/callback';
const String signinWithGoggleLink = '$baseUrl/auth/google/callback';
