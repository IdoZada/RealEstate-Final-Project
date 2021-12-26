class StringValue {
  String value;
  StringValue(this.value);
  bool hasValue() {
    if (value == null) return false;
    if (value == '') return false;
    return true;
  }

  StringValue deepCopy() {
    return new StringValue(value);
  }
}
