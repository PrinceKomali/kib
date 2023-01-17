module kib.library;

import std.stdio;
import std.range;
import std.algorithm;
import std.math;
import std.conv;

import kib.types;
import kib.helpers;
import kib.error;
import kib.compression;

t[] get_builtin(t[] s) {
    t n = s[$ - 1];
    s.popBack();
    double index = n.nval;
    if(isNaN(index)) return [gen_error("Popped value is not a number")];
    if(library.length < index + 1) return [gen_error(to!string(index) ~ " exeeds length of builtins list")];
    s = library[to!ulong(index)](s);
    return s;
}

t[] function(t[])[] library = [
    &fibonacci,
    &compress_int_fn,
    &compress_string_fn
    
];

t[] fibonacci(t[] stack) {
    if(stack.length < 1) stack ~= input();
    t n = stack[$ - 1];
    stack.popBack();
    if(isNaN(n.nval)) return [gen_error("Popped value is not a number")];
    int a = 1;
    int b = 1;
    
    for(double i = n.nval; i >= 0; i--) {
        b += a;
        a = b - a;
    }
    stack ~= parse_t(b);
    return stack;
}
t[] compress_int_fn(t[] stack) {
    if(stack.length < 1) stack ~= input();
    t n = stack[$ - 1];
    if(isNaN(n.nval)) return [gen_error("Popped value is not a number")];
    stack.popBack();
    stack ~= compress_int(n);
    return stack;
}
t[] compress_string_fn(t[] stack) {
    if(stack.length < 1) stack ~= input();
    t s = stack[$ - 1];
    stack.popBack();
    t str = compress_string(s);
    if(str.sval == "\0") return [gen_error("Invalid character; all characters must be in base 27 (a-z and space)")];
    else stack ~= str;
    return stack;
}