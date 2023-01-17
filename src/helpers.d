module kib.helpers;

import std.array;
import std.conv;
import std.algorithm;
import std.stdio;
import std.string;
import std.math;

import kib.types;
import kib.error;

bool is_num(string c) {
    if(c == "") return false;
    foreach(string a; c.split("")) {
        if(!canFind([ "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" ],a)) return false;
    }
    return true;
}
t parse_t(string c) {
    t v;
    v.sval = c;
    if(is_num(c)) v.nval = to!double(c); 
    return v;
}
t parse_t(double c) {
    t v;
    v.sval = to!string(c);
    v.nval = c; 
    return v;
}
t parse_t(int c) {
    t v;
    v.sval = to!string(c);
    v.nval = to!double(c); 
    return v;
}

t input() {
    string[] a = readln().split("");
    a.popBack();
    return parse_t(join(a));
}