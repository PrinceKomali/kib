module kib.math;

import std.math;
import std.algorithm;
import std.range;
import std.array;
import std.string;
import std.conv;

import kib.types;
import kib.error;
import kib.helpers;

t add(t a, t b) {
    if(isNaN(a.nval) || isNaN(b.nval)) {
        return parse_t(a.sval ~ b.sval);
    }
    return parse_t(a.nval + b.nval);
}
t[] add_stack(t[] s) {
    if(s.length < 2) s ~= input();
    if(s.length < 2) s ~= input();
    t b = s[$-1];
    s.popBack();
    t a = s[$-1];
    s.popBack();
    s ~= add(a,b);
    return s;
}
t subtract(t a, t b) {
    if(isNaN(a.nval) || isNaN(b.nval)) {
        return parse_t(a.sval.replace(b.sval, ""));
    }
    return parse_t(a.nval - b.nval);
}
t[] subtract_stack(t[] s) {
    if(s.length < 2) s ~= input();
    if(s.length < 2) s ~= input();
    t b = s[$-1];
    s.popBack();
    t a = s[$-1];
    s.popBack();
    s ~= subtract(a,b);
    return s;
}
t multiply(t a, t b) {
    if(isNaN(a.nval)) {
        return parse_t(replicate(a.sval, to!int(b.nval)));
    }
    return parse_t(a.nval * b.nval);
}
t[] multiply_stack(t[] s) {
    if(s.length < 2) s ~= input();
    if(s.length < 2) s ~= input();
    t b = s[$-1];
    if(isNaN(b.nval)) return [gen_error("2nd multiplication argument must be a number")];
    s.popBack();
    t a = s[$-1];
    s.popBack();
    s ~= multiply(a,b);
    return s;
}
t divide(t a, t b) {
    // if(isNaN(a.nval)) {
    //     return parse_t(replicate(s.sval, b.nval));
    // }
    // return parse_t(to!string(a.nval * b.nval));
    return parse_t("hi");
}
t[] divide_stack(t[] s) {
    return [gen_error("Arrays aren't implemented yet :P")];
    // if(s.length < 2) s ~= input();
    // if(s.length < 2) s ~= input();
    // t b = s[$-1];
    // if(isNaN(b.nval)) return [gen_error("2nd division argument must be a number")];
    // s.popBack();
    // t a = s[$-1];
    // s.popBack();
    // s ~= divide(a,b);
    // return s;
}
t exponent(t a, t b) {
    return parse_t(a.nval ^^ b.nval);
}
t[] exponent_stack(t[] s) {
    if(s.length < 2) s ~= input();
    if(s.length < 2) s ~= input();
    t b = s[$-1];
    if(isNaN(b.nval)) return [gen_error("Exponent arguments must be numbers")];
    s.popBack();
    t a = s[$-1];
    if(isNaN(b.nval)) return [gen_error("Exponent arguments must be numbers")];
    s.popBack();
    s ~= exponent(a,b);
    return s;
}
t[] square_stack(t[] s) {
    if(s.length < 1) s ~= input();
    t b = s[$-1];
    if(isNaN(b.nval)) return [gen_error("Exponent arguments must be numbers")];
    s.popBack();
    s ~= exponent(b,parse_t(2.0));
    return s;
}
t[] cube_stack(t[] s) {
    if(s.length < 1) s ~= input();
    t b = s[$-1];
    if(isNaN(b.nval)) return [gen_error("Exponent arguments must be numbers")];
    s.popBack();
    s ~= exponent(b,parse_t(3.0));
    return s;
}