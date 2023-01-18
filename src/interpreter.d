module kib.interpreter;

import std.stdio;
import std.range;
import std.algorithm;
import std.math;
import std.conv;
import std.format;

import kib.compression;
import kib.constants;
import kib.library;
import kib.math;

import kib.types;
import kib.helpers;
import kib.error;


int interpret(string code) {
    bool printed = false;
    t[] stack = [];
    void pop_print() {
        t imp = stack[$ - 1];
        stack.popFront();
        if (!isNaN(imp.nval)) {
            if(imp.nval % 1 == 0) write(format("%.0f", imp.nval));
            else write(imp.nval);
        }
        else write(imp.sval);
    }
    string[] chars = code.split("");
    int i = 0;
    while(chars.length > 0) {
        string b = chars[0];
        chars.popFront();
        i++;
        // TODO: sort alphabetically
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
        if(b == "\\") {
            b = chars[0];
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
        if(b == "p") pop_print(); 
        if(b == "P") {
            pop_print(); writeln();
        }
        if(b == "+") stack = add_stack(stack);
        if(b == "-") stack = subtract_stack(stack);
        if(b == "*") {
            t[] output = multiply_stack(stack);
            if(output.length == 1 && output[0].errval) kib_error(code, i, output[0].errval);
            stack = output;
            continue;
        }
        if(b == "^") stack = exponent_stack(stack);
        if(b == "s") stack = square_stack(stack);
        if(b == "c") {
            if(stack.length < 1) stack ~= input();
            t[] output = get_constant(stack);
            if(output.length == 1 && output[0].errval) kib_error(code, i, output[0].errval);
            else stack = output;
            continue;
        }
        if(b == "b") {
            if(stack.length < 1) stack ~= input();
            t[] output = get_builtin(stack);
            if(output.length == 1 && output[0].errval) kib_error(code, i, output[0].errval);
            else stack = output;
            continue;
        }
        if(b == "i") {
            stack ~= parse_t(1);
            stack = add_stack(stack);
            continue;
        }
        if(b == "R") {
            if(stack.length < 3) stack ~= input();
            if(stack.length < 3) stack ~= input();
            if(stack.length < 3) stack ~= input();
            t r = stack[$ - 1];
            stack.popFront();
            t a = stack[$ - 1];
            stack.popFront();
            t s = stack[$ - 1];
            stack.popFront();
            stack ~= parse_t(s.sval.replace(a.sval, r.sval));
             continue;
        }

    }
    if(!printed && stack.length > 0) {
        pop_print(); writeln();
    }
    return 0;
}