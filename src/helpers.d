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

t input() {
    string[] a = readln().split("");
    a.popBack();
    return parse_t(join(a));
}

t[] str_to_tarr(string s) {
    if(s.length < 2) return []; // temp fix; TODO: resolve this
    t[] v;
    foreach(string c; s.split("")) {
        v ~= parse_t(c);
    }
    return v;
}

string print_array(t[] stack, bool color) {
    string o = "";
    o ~= "{ ";
    foreach(t v; stack) {
        if(!isNaN(v.nval)) {
            o ~= ((color ? "\x1b[33m" : "") ~ to!string(v.nval) ~ (color ? "\x1b[0m" : "") ~ " ");
            continue;
        }
        if(v.aval.length > 0) {
            o ~= (print_array(v.aval, color) ~ " ");
            continue;
        }
        else {
            o ~= ((color ? "\x1b[32m" : "") ~ "'" ~ v.sval ~ "'" ~ (color ? "\x1b[0m" : "") ~ " ");
            
        }
    }

    o ~= "}";
    return o;
}
bool is_truthy(t s) {
    if(!isNaN(s.nval)) return to!bool(s.nval);
    if(s.aval) return s.aval.length > 0;
    else return s.sval.length > 0;
}