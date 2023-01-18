module kib.types;

import std.bigint;

struct t {
    double nval;
    string sval;
    string errval;
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