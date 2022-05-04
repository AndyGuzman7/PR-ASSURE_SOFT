class Server {
  static const protocol = "https://";
  static const host = "236c-177-222-123-18.sa.ngrok.io";
  // static const host = "da6d-186-2-94-223.ngrok.io";
  // static const host = "10.0.3.2:8086";
  static const baseEndpoint = "/app/api";

  // static const protocol = " http://";
  // static const host = "10.0.2.2";
  // // static const host = "10.0.3.2:8086";
  // static const baseEndpoint = "/backend/app/api";
  static const url = "$protocol$host$baseEndpoint";

  static const Map<String, int> RoleCodes = {
    'ADMIN': 26,
    'CLIENT': 27,
    'OWNER': 28,
  };

  static const Map<String, String> SignUpType = {
    'GOOGLE': 'go',
    'FACEBOOK': 'fb',
    'EMAIL': 'em',
  };
}
