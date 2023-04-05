module library;

import std.stdio;
import std.range;
import std.algorithm;
import std.math;
import std.conv;
import std.ascii;

import types;
import helpers;
import error;
import compression;

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
    &compress_string_fn,
    &initial_cap,
    &is_truthy_string,
    &greater_than,
    &less_than
];

t[] fibonacci(t[] stack) {
    if(stack.length < 1) stack ~= input();
    t n = stack[$ - 1];
    stack.popBack();
    if(isNaN(n.nval)) return [gen_error("Popped value is not a number")];
    int a = 0;
    int b = 1;
    
    for(double i = 0; i < n.nval; i++) {
        b += a;
        a = b - a;
    }
    stack ~= parse_t(a);
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
t[] initial_cap(t[] stack) {
    if(stack.length < 1) stack ~= input();
    t s = stack[$ - 1];
    stack.popBack();
    string[] words = s.sval.split(" ");
    for(int i = 0; i < words.length; i++) {
        string w = to!string(toUpper(words[i][0])); 
        words[i] = w ~ words[i][1..$];
    }
    stack ~= parse_t(words.join(" "));
    return stack;
}
t[] is_truthy_string(t[] stack) {
    if(stack.length < 1) stack ~= input();
    t s = stack[$ - 1];
    stack.popBack();
    stack ~= is_truthy(s) ? parse_t(1) : parse_t(0);
    return stack;
}
t[] greater_than(t[] stack) {
     if(stack.length < 1) stack ~= input();
    t s = stack[$ - 1];
    stack.popBack();
     if(stack.length < 1) stack ~= input();
    t s2 = stack[$ - 1];
    stack.popBack();

    stack ~= parse_t(to!int(s.nval < s2.nval));
    return stack;
}
t[] less_than(t[] stack) {
     if(stack.length < 1) stack ~= input();
    t s = stack[$ - 1];
    stack.popBack();
     if(stack.length < 1) stack ~= input();
    t s2 = stack[$ - 1];
    stack.popBack();

    stack ~= parse_t(to!int(s.nval < s2.nval));
    return stack;
}