class FirestoreResources{


  // Related to registration

  // Player basic registration info related
  static final String userCollectionName = "/Players";
  static final String fieldPlayerId = 'membershipId';
  static final String fieldPlayerEmail = 'email';
  static final String fieldPlayerName = 'name';
  static final String fieldPlayerGender = 'gender';
  static final String fieldPlayerDOB = 'dob';
  static final String fieldPlayerCountry = 'country';
  static final String fieldPlayerPhoneNumber ='phoneNumber';
  static final String fieldPlayerAddress = 'address';
  static final String fieldPlayerProfileURL = 'profileImageURL';
  static final String fieldPlayerMembershipDate = 'membershipDate';

  /*****************************************************************/

  // Related to daily quiz challenge

  static final String collectionQuizName = '/quiz';
  static final String collectionQuestionAndAnswersList= 'quiz_q&a_list';
  static final String fieldQuizId = 'id';
  static final String fieldQuizGameAvailable = 'startGame';
  static final String fieldQuizPlay = 'isQuizOn';
  static final String fieldCurrentQuizId = "current_quiz_id";
  static final String fieldQuizQuestion = 'question';
  static final String fieldQuizAnswers = 'answers';
  static final String fieldQuizCorrectAnswer = 'correct_answer_value';

  /*****************************************************************/


  // Related to events collections
  static final String collectionEvent = "events";
  static final String fieldEventId = "eventId";
  static final String fieldEventPhoto  = "eventPhoto";
  static final String fieldEventTitle = "eventTitle";
  static final String fieldEventDesc = "eventDesc";
  static final String fieldEventTime = "eventTime";
}