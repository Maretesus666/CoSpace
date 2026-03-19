class AnnouncementModel {
  final String id;
  final String text;
  final SurveyType? surveyType;
  final List<QuestionModel> questions;
  final DateTime createdAt;

  AnnouncementModel({
    required this.id,
    required this.text,
    this.surveyType,
    this.questions = const [],
    required this.createdAt,
  });
}

enum SurveyType { multipleChoice, openAnswer }

class QuestionModel {
  final String question;
  final List<String> options; // Solo para opción múltiple: A, B, C

  QuestionModel({
    required this.question,
    this.options = const [],
  });
}