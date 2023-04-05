module constants;

import std.array;
import std.stdio; 
import std.math;
import std.conv; 

import types;
import error;
import helpers;

t[] get_constant(t[] s) {
    t n = s[$ - 1];
    s.popBack();
    double index = n.nval;
    if(isNaN(index)) return [gen_error("Popped value is not a number")];
    if(constants.length < index + 1) return [gen_error(to!string(index) ~ " exeeds length of constants list")];
    s ~= constants[to!ulong(index)];
    return s;
}
t[] constants = [
    parse_t("Hello, World!"),
    parse_t("Hello World"),
    parse_t("abdefghijklmnopqrstuvwxyz"),
    parse_t("ABDEFGHIJKLMNOPQRSTUVWXYZ"),
    parse_t(" `!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_abcdefghijklmnopqrstuvwxyz{|}~\n"),
    
];
