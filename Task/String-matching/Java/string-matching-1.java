// For this task consider the following strings
String string = "string matching";
String suffix = "ing";
// The most idiomatic way of determining if a string starts with another is the String.startsWith method.
string.startsWith(suffix)
// Another way is to use a combination of String.substring and String.equals
string.substring(0, suffix.length()).equals(suffix)
// To determine if a string contains at least one occurrence of another string, use the String.contains method.
string.contains(suffix)
// A slightly more idiomatic approach is String.indexOf, which also returns the index of the first character.
string.indexOf(suffix) != -1
// The most idiomatic way of determining whether a string ends with another is the String.endsWith method.
string.endsWith(suffix);
//Similarly, a combination of String.substring and String.equals can be used.
string.substring(string.length() - suffix.length()).equals(suffix)
// If you're looking to find the index of each occurrence, you can use the following.
int indexOf;
int offset = 0;
while ((indexOf = string.indexOf(suffix, offset)) != -1) {
    System.out.printf("'%s' @ %d to %d%n", suffix, indexOf, indexOf + suffix.length() - 1);
    offset = indexOf + 1;
}
