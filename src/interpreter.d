module interpreter;

import std.stdio;
import std.range;
import std.algorithm;
import std.math;
import std.conv;
import std.format;

import compression;
import constants;
import library;
import math;

import types;
import helpers;
import error;


t[] interpret(t[] stack, string code, bool sflag, bool cflag, bool loop, bool do_print) {
    bool printed = false;
    // t[] stack = [];
    t pop_stack() {
        if(stack.length < 1) stack ~= input();
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
    while(loop || chars.length > 0) {
        if(loop) {
            if(stack.length > 0 && stack[$ - 1].errval == "LOOP_EXIT") {
                stack.popBack();
                return stack;
            }
            if (chars.length < 1) chars = code.split("");
        }
        string b = chars[0];
        chars.popFront();
        i++;
        // TODO: sort alphabetically
        if(b == " " || b == "\t" || b == "\n") continue; // whitespace
        else if(b == "!") {
            t v = pop_stack();
            if(!isNaN(v.nval)) stack ~= parse_t(to!int(!v.nval));
            else if(v.aval) stack ~= parse_t(to!int(v.aval.length == 0));
            else if(v.sval) stack ~= parse_t(to!int(v.sval.length == 0));
        }
        else if(b == "&") {
            t v = pop_stack();
            t v2 = pop_stack();
            bool bool_a = booleanize(v);
            bool bool_b = booleanize(v2);
            stack ~= parse_t(to!int(bool_a && bool_b));
        }
        else if(b == "|") {
            t v = pop_stack();
            t v2 = pop_stack();
            bool bool_a = booleanize(v);
            bool bool_b = booleanize(v2);
            stack ~= parse_t(to!int(bool_a || bool_b));
        }
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
        else if(b == "{") {
            if(!canFind(chars, "{")) kib_error(code, i, "Unmatched {");
            b = "";
            while(chars.length > 0 && chars[0] != "{") {
                b = b ~ chars[0];
                chars.popFront();
                i++;
            }
            chars.popFront();
            i++;
            stack ~= interpret(stack, b, sflag, cflag, true, false);
            continue;
        }
        else if(b == "}") {
            bool check = booleanize(pop_stack());
            
            if(!canFind(chars, "}")) kib_error(code, i, "Unmatched }");
            b = "";
            while(chars.length > 0 && chars[0] != "}") {
                b = b ~ chars[0];
                chars.popFront();
                i++;
            }
            chars.popFront();
            i++;
            if(check) stack ~= interpret(stack, b, sflag, cflag, false, false);
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
        else if(b == "d") {
            t v = pop_stack();
            stack ~= v;
            stack ~= v;
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
            writeln(print_array(stack, cflag));
            // t[] a = [parse_t("Hello"), parse_t("World!"), parse_t(1), parse_t(str_to_tarr("splitted string"))];
            // stack ~= parse_t(a);
        }
        else if(b == "v") {
            if(stack.length < 1) stack ~= input();
            t v = pop_stack();
            if(v.aval.length > 0) stack ~= v.aval;
            else stack ~= parse_t(str_to_tarr(v.sval));
        }
        else if(b == "x") {
            stack ~= gen_error("LOOP_EXIT");
            return stack;
        }
        else kib_error(code, i, "Unknown character: " ~ b);
        
    }
    if(sflag && do_print) writeln(print_array(stack, cflag));
    if(!printed && do_print && stack.length > 0) {
        pop_print(); writeln();
    }
            
    return stack;
}