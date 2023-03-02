
// Extracted from: https://github.com/SimsOCallaghan/ArcaneDimensions/blob/master/dpextensions.qc
//FTE_STRINGS
//idea: many
//darkplaces implementation: KrimZon
//builtin definitions:
float(string str, string sub, float startpos) strstrofs = #221; // returns the offset into a string of the matching text, or -1 if not found, case sensitive
float(string str, float ofs) str2chr = #222; // returns the character at the specified offset as an integer, or 0 if an invalid index, or byte value - 256 if the engine supports UTF8 and the byte is part of an extended character
string(float c, ...) chr2str = #223; // returns a string representing the character given, if the engine supports UTF8 this may be a multi-byte sequence (length may be more than 1) for characters over 127.
string(float ccase, float calpha, float cnum, string s, ...) strconv = #224; // reformat a string with special color characters in the font, DO NOT USE THIS ON UTF8 ENGINES (if you are lucky they will emit ^4 and such color codes instead), the parameter values are 0=same/1=lower/2=upper for ccase, 0=same/1=white/2=red/5=alternate/6=alternate-alternate for redalpha, 0=same/1=white/2=red/3=redspecial/4=whitespecial/5=alternate/6=alternate-alternate for rednum.
string(float chars, string s, ...) strpad = #225; // pad string with spaces to a specified length, < 0 = left padding, > 0 = right padding
string(string info, string key, string value, ...) infoadd = #226; // sets or adds a key/value pair to an infostring - note: forbidden characters are \ and "
string(string info, string key) infoget = #227; // gets a key/value pair in an infostring, returns value or null if not found
float(string s1, string s2, float len) strncmp = #228; // compare two strings up to the specified number of characters, if their length differs and is within the specified limit the result will be negative, otherwise it is the difference in value of their first non-matching character.
float(string s1, string s2) strcasecmp = #229; // compare two strings with case-insensitive matching, characters a-z are considered equivalent to the matching A-Z character, no other differences, and this does not consider special characters equal even if they look similar
float(string s1, string s2, float len) strncasecmp = #230; // same as strcasecmp but with a length limit, see strncmp
//string(string s, float start, float length) substring = #116; // see note below
//description:
//various string manipulation functions
//note: substring also exists in FRIK_FILE but this extension adds negative start and length as valid cases (see note above), substring is consistent with the php 5.2.0 substr function (not 5.2.3 behavior)
//substring returns a section of a string as a tempstring, if given negative
// start the start is measured back from the end of the string, if given a
// negative length the length is the offset back from the end of the string to
// stop at, rather than being relative to start, if start is negative and
// larger than length it is treated as 0.
// examples of substring:
// substring("blah", -3, 3) returns "lah"
// substring("blah", 3, 3) returns "h"
// substring("blah", -10, 3) returns "bla"
// substring("blah", -10, -3) returns "b"

// Extracted from: https://github.com/SimsOCallaghan/ArcaneDimensions/blob/master/dpextensions.qc
//DP_QC_STRREPLACE
//idea: Sajt
//darkplaces implementation: Sajt
//builtin definitions:
string(string search, string replace, string subject) strreplace = #484;
string(string search, string replace, string subject) strireplace = #485;
//description:
//strreplace replaces all occurrences of 'search' with 'replace' in the string 'subject', and returns the result as a tempstring.
//strireplace does the same but uses case-insensitive matching of the 'search' term

// Extracted from: https://github.com/SimsOCallaghan/ArcaneDimensions/blob/master/dpextensions.qc
//FRIK_FILE
//idea: FrikaC
//darkplaces implementation: LordHavoc
//builtin definitions:
float(string s) stof = #81; // get numerical value from a string
float(string s) strlen = #114; // returns how many characters are in a string
string(string s1, string s2, ...) strcat = #115; // concatenates two or more strings (for example "abc", "def" would return "abcdef") and returns as a tempstring
vector(string s) stov = #117; // returns vector value from a string

/*
================
template_string
template_string_token
by: rijuma

Replaces a variable in a string. template_string_token() variant is to specify the token.

subject (string): The string template.
value (string): The value to be inserted in the string template.
token (string): The substring to be searched and replaced with the value. In template_string is ommited and defaulted to TEMPLATE_TOKEN.
================
*/
string	TEMPLATE_TOKEN = "%";

string(string subject, string value) template_string = { return template_string_token(subject, value, TEMPLATE_TOKEN); }
string(string subject, string value, string token) template_string_token = { return strreplace(token, value, subject); }
