class Input {
  static Map<String, dynamic> values = {};

  static set(key, value) {
    values[key] = value;
  }

  static get(key) {
    return values[key];
  }
}
