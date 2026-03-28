abstract class RouteConstant {

  /// Auth
  static final String logIn = "log_in";
  static final String logInPath = "/${RouteConstant.logIn}";
  static final String signUp = "sign_up";
  static final Set<String> nonAuthPaths = {
    "${RouteConstant.logInPath}/${RouteConstant.signUp}"
  };

  /// Guest
  static final String explore = "explore";
  static final String explorePath = "/";
  static final String saved = "saved";
  static final String savedPath = "/${RouteConstant.saved}";
  static final String trips = "trips";
  static final String tripsPath = "/${RouteConstant.trips}";
  static final String inbox = "inbox";
  static final String inboxPath = "/${RouteConstant.inbox}";
  /// Child of [inboxPath] / [hostInboxPath] — full path e.g. `/inbox/chat`.
  static final String chat = "chat";
  static final String account = "account";
  static final String accountPath = "/${RouteConstant.account}";
  static final String editProfile = "edit_profile";

  /// Explore
  static final String viewPosting = "view_posting";
  static final String bookPosting = "book_posting";
  static final String viewReview = "view_review";
  static final String viewProfile = "view_profile";

  /// Host
  static final String bookings = "bookings";
  static final String bookingsPath = "/${RouteConstant.bookings}";
  static final String myPostings = "myPostings";
  static final String myPostingsPath = "/${RouteConstant.myPostings}";
  static final String hostInbox = "host_inbox";
  static final String hostInboxPath = "/${RouteConstant.hostInbox}";
  static final String earnings = "earnings";
  static final String earningsPath = "/${RouteConstant.earnings}";
  static final String hostAccount = "host_account";
  static final String hostAccountPath = "/${RouteConstant.hostAccount}";

  /// My Postings
  static final String updatePosting = "update_posting";
  static final String searchPropertyLocation = "search_property_location";
}