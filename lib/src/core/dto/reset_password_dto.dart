class ResetPasswordDto {
  final String newPassword;
  final String code;
  final String email;

  ResetPasswordDto(
    this.newPassword,
    this.code,
    this.email,
  );

  Map<String, dynamic> toMap() {
    return {
      'newPassword': newPassword,
      'code': code,
      'email': email,
    };
  }
}
