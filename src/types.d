module types;

import std.conv;
import std.array;
import std.algorithm;

import helpers; 

struct t {
    double nval;
    string sval;
    string errval;
    t[] aval; // how is this legal
}


t parse_t(string c) {
    t v;
    v.sval = c;
    // v.aval = str_to_tarr(c);
    if(is_num(c)) v.nval = to!double(c); 
    return v;
}
t parse_t(double c) {
    t v;
    v.sval = to!string(c);
    // v.aval = str_to_tarr(to!string(c));
    v.nval = c; 
    return v;
}
t parse_t(int c) {
    t v;
    v.sval = to!string(c);
    v.nval = to!double(c); 
    return v;
}
t parse_t(t[] a) {
    t v;
    v.aval = a;
    return v;

}