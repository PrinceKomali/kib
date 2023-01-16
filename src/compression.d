module kib.compression;

import std.array;
import std.conv;
import std.algorithm;
import std.stdio;
import std.string;
import std.math;

import kib.types;
import kib.helpers;
import kib.error;

string matchbase = "\0 etaoinsrhdlucmfywgpbvkxqjz";
string codepage = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_abcdefghijklmnopqrstuvwxyz{|}~\n";
t compress_int(t num, string codebase = codepage) {
    string[] cp = codebase.split("");
    int[] p = [0];
    for(int i = 0; i < num.nval; i++) {
        p[0]++;
        while(canFind(p, cp.length)) {
            for(int j = 0; j < p.length; j++) {
                if(p[j] == cp.length) {
                    if(p.length < j) p ~= 0;
                    else p[j] = 0;
                    if(p.length > j + 1) p[j + 1]++;
                    else p ~= 1;
                }
            }
        }
    }
    string output = "";
    foreach(int i; p.reverse()) {
        output ~= cp[i];
    }
    return parse_t(output);
}
t compress_int(string num, string codebase = codepage) { return compress_int(parse_t(num), codebase); }
t compress_int(int num, string codebase = codepage) { return compress_int(parse_t(to!string(num)), codebase); }

t decompress_int(t num, string codebase = codepage) {
    string[] cp = codebase.split("");
    string[] s = num.sval.split("").reverse();
    int total = 0;
    for(int i = 0; i < s.length;i++) {
        total += pow(cp.length, i) * indexOf(codebase, s[i]);
    }
    return parse_t(to!string(total));
}
t decompress_int(string num, string codebase = codepage) { return decompress_int(parse_t(num), codebase); }




t mb_compress_int(string s) { return compress_int(parse_t(s), matchbase);}
t mb_compress_int(int s) { return mb_compress_int(to!string(s));}
t mb_decompress_int(string s) { return decompress_int(parse_t(s), matchbase);}
t mb_decompress_int(int s) { return mb_decompress_int(to!string(s));}
t compress_string(t s) {
    string str = s.sval;
    string[] nums = [];
    foreach(string c; str.split("")) nums ~= mb_compress_int(to!string(indexOf(matchbase, c))).sval;
    string[] arr = [];
    while(nums.length > 0) {
        string current = nums[0];
        nums.popFront();
        if(nums.length > 1 && mb_decompress_int(current ~ nums[0]).nval < codepage.length) {
            current ~= nums[0];
            nums.popFront();
        }
        arr ~= current;

    }
    string output = "";
    foreach(string c; arr) output ~= codepage[to!ulong(mb_decompress_int(c).nval)];
    return parse_t(output);
    
}
t decompress_string(t s) {
    string output = "";
    foreach(string c; s.sval.split("")) output ~= mb_compress_int(to!int(indexOf(codepage, c))).sval;
    return parse_t(output);
}