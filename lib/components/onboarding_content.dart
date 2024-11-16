class UnbordingContent {
  String image;
  String title;
  String description;

  UnbordingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'Never forget your medicine again!',
      image: 'lib/assets/icons/1.gif',
      description:
          "Remember what to take, when to take, when to refill. Never miss a dose again."),

  UnbordingContent(
      title: 'Track your progress!',
      image: 'lib/assets/icons/4.gif',
      description:
          "Take control of your medication. Never miss a dose again. Stay organized. Stay healthy!"),
];
