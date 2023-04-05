module error;
 
import std.stdio;
import std.range; 
import core.stdc.stdlib : exit;

import types;

void kib_error(string code, int i, string message) {
    writeln("\x1b[1mkib: \x1b[31mError\x1b[0m at position ", i, ": ", message);
    writeln(code[0..i - 1], "\x1b[1;31m", code[i - 1], "\x1b[0m", code[i..$]);
    writeln(replicate("~", i-1), "^");
    exit(1);
}
void other_error(string message) {
    writeln("\x1b[1mkib: \x1b[31mError\x1b[0m: ", message);
    exit(1);
}
t gen_error(string m) {
    t e;
    e.errval = m;
    return e;
}
