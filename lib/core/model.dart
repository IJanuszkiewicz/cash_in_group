abstract class Model<T> {
  T fromJson(Map<String, Object> json);
  Map<String, Object> toJson();
}