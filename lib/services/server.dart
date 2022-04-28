class Server {
  static const protocol = "http://";
  static const host = "ec2-34-207-65-236.compute-1.amazonaws.com:81";
  // static const host = "172.22.32.1:8080";
  // static const host = "da6d-186-2-94-223.ngrok.io";
  // static const host = "10.0.3.2:8086";
  static const baseEndpoint = "/app/api";

  // static const protocol = " http://";
  // static const host = "10.0.2.2";
  // // static const host = "10.0.3.2:8086";
  // static const baseEndpoint = "/backend/app/api";
  static const url = "$protocol$host$baseEndpoint";

  static const Map<String, int> RoleCodes = {
    'ADMIN': 1,
    'CLIENT': 2,
    'OWNER': 3,
  };

  static const Map<String, String> SignUpType = {
    'GOOGLE': 'go',
    'FACEBOOK': 'fb',
    'EMAIL': 'em',
  };
}
