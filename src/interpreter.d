module kib.interpreter;

import std.stdio;
import std.range;
import std.algorithm;
import std.math;
import std.conv;

import kib.compression;
import kib.constants;

import kib.types;
import kib.helpers;
import kib.error;

t add(t a, t b) {
    if(isNaN(a.nval) || isNaN(b.nval)) {
        return parse_t(a.sval ~ b.sval);
    }
    return parse_t(to!string(a.nval + b.nval));
}
t[] add_stack(t[] s) {
    t b = s[$-1];
    s.popBack();
    t a = s[$-1];
    s.popBack();
    s ~= add(a,b);
    return s;
}

int interpret(string code) {
    bool printed = false;

    t[] stack = [];
    string[] chars = code.split("");
    int i = 0;
    while(chars.length > 0) {
        string b = chars[0];
        chars.popFront();
        i++;

        if(is_num(b)) {
            
            while(chars.length > 0 && is_num(chars[0])) {
                
                b = b ~ chars[0];
                chars.popFront();
                i++;
            }
            stack ~= parse_t(b);
            continue;
        }
        if(b == "\'") {
            if(!canFind(chars, "\'")) kib_error(code, i, "Unmatched '");
            b = "";
            while(chars.length > 0 && chars[0] != "'") {
                b = b ~ chars[0];
                chars.popFront();
                i++;
            }
            chars.popFront();
            i++;
            stack ~= parse_t(b);
            continue;
        }
        if(b == "<") {
            if(!canFind(chars, "<")) kib_error(code, i, "Unmatched <");
            b = "";
            while(chars.length > 0 && chars[0] != "<") {
                b = b ~ chars[0];
                chars.popFront();
                i++;
            }
            chars.popFront();
            i++;
            stack ~= decompress_int(parse_t(b));
            continue;
        }
        if(b == "`") {
            if(!canFind(chars, "`")) kib_error(code, i, "Unmatched `");
            b = "";
            while(chars.length > 0 && chars[0] != "`") {
                b = b ~ chars[0];
                chars.popFront();
                i++;
            }
            chars.popFront();
            i++;
            stack ~= decompress_string(parse_t(b));
            continue;
        }
        if(b == "p") {
            if(stack.length < 1) stack ~= input();
            printed = true;
            write(stack[$ - 1].sval);
            stack.popBack();
        }
        if(b == "P") {
            if(stack.length < 1) stack ~= input();
            printed = true;
            writeln(stack[$ - 1].sval);
            stack.popBack();
        }
        if(b == "+") {
            if(stack.length < 2) stack ~= input();
            if(stack.length < 2) stack ~= input();
            stack = add_stack(stack);
        }
        if(b == "c") {
            if(stack.length < 1) stack ~= input();
            t[] output = get_constant(stack);
            if(output.length == 1 && output[0].errval) kib_error(code, i, output[0].errval);
            else stack = output;
        }
    }
    if(!printed && stack.length > 0) writeln(stack[$ - 1].sval);
    return 0;
}