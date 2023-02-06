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


int interpret(string code, bool sflag, bool cflag) {
    bool printed = false;
    t[] stack = [];
    t pop_stack() {
        t v = stack[$ - 1];
        stack.popBack();
        return v;
    }
    void pop_print() {
        printed = true;
        t imp = pop_stack();
        if (!isNaN(imp.nval)) {
            if(imp.nval % 1 == 0) write(format("%.0f", imp.nval));
            else write(imp.nval);
        }
        else if(imp.aval.length > 0) write(print_array(imp.aval, cflag));
        else write(imp.sval);
         
    }
    string[] chars = code.split("");
    int i = 0;
    while(chars.length > 0) {
        string b = chars[0];
        chars.popFront();
        i++;
        // TODO: sort alphabetically
        if(b == " " || b == "\t" || b == "\n") continue; // whitespace
        else if(b == "`") {
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
        else if(b == "\'") {
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
        else if(b == "*") {
            t[] output = multiply_stack(stack);
            if(output.length == 1 && output[0].errval) kib_error(code, i, output[0].errval);
            stack = output;
            continue;
        }
        else if(b == "+") stack = add_stack(stack);
        else if(b == "-") stack = subtract_stack(stack);
        else if(b == "<") {
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
        else if(b == "?") {
            // bool has_else = canFind(chars, ":");
            // no idea how I'm gonna do else
            if(stack.length < 1) stack ~= input();
            t n = pop_stack();
            if(stack.length < 1) stack ~= input();
            t a = pop_stack();
            if(is_truthy(a)) stack ~= n;
        }
        else if(b == "\\") {
            b = chars[0];
            chars.popFront();
            i++;
            stack ~= parse_t(b);
            continue;
        }
        else if(b == "^") stack = exponent_stack(stack);
        else if(is_num(b)) {
            
            while(chars.length > 0 && is_num(chars[0])) {
                b = b ~ chars[0];
                chars.popFront();
                i++;
            }
            stack ~= parse_t(b);
            continue;
        }
        else if(b == "b") {
            if(stack.length < 1) stack ~= input();
            t[] output = get_builtin(stack);
            if(output.length == 1 && output[0].errval) kib_error(code, i, output[0].errval);
            else stack = output;
            continue;
        }
        else if(b == "c") {
            if(stack.length < 1) stack ~= input();
            t[] output = get_constant(stack);
            if(output.length == 1 && output[0].errval) kib_error(code, i, output[0].errval);
            else stack = output;
            continue;
        }
        else if(b == "g") {
            stack ~= input();
        }
        else if(b == "i") {
            stack ~= parse_t(1);
            stack = add_stack(stack);
            continue;
        }
        else if(b == "j") {
            t v = pop_stack();
            if(v.aval.length < 1) kib_error(code, i, "Popped value is not an array!");
            string o;
            foreach(t e; v.aval) o ~= e.sval;
            stack ~= parse_t(o);
        }
        else if(b == "p") pop_print(); 
        else if(b == "P") {
            pop_print(); writeln();
        }
        else if(b == "R") {
            if(stack.length < 3) stack ~= input();
            if(stack.length < 3) stack ~= input();
            if(stack.length < 3) stack ~= input();
            t r = pop_stack();
            t a = pop_stack();
            t s = pop_stack();
            stack ~= parse_t(s.sval.replace(a.sval, r.sval));
             continue;
        }
        else if(b == "s") stack = square_stack(stack);
        else if(b == "t") {
            t[] a = [parse_t("Hello"), parse_t("World!"), parse_t(1), parse_t(str_to_tarr("splitted string"))];
            stack ~= parse_t(a);
        }
        else if(b == "v") {
            if(stack.length < 1) stack ~= input();
            t v = pop_stack();
            if(v.aval.length > 0) stack ~= v.aval;
            else stack ~= parse_t(str_to_tarr(v.sval));
        }
        else kib_error(code, i, "Unknown character: " ~ b);

    }
    if(sflag) writeln(print_array(stack, cflag));
    if(!printed && stack.length > 0) {
        pop_print(); writeln();
    }
    return 0;
}