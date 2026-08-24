class BookingConfirmRequestBody {
  final String quoteToken;

  BookingConfirmRequestBody({required this.quoteToken});

  Map<String, dynamic> toJson() {
    return {
      'quote_token': quoteToken,
    };
  }
}