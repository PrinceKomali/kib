module main;

import std.stdio;
import std.file;
import std.conv;
import std.array;
import std.math;
import std.format;
import std.algorithm;

import interpreter;
import helpers;
import types;
import compression;
import error;

string code = ">*e,%N%),+>";

void help_menu() {
    writeln(
        "\x1b[1mkib\x1b[0m v0.0\n" ~
        "    help               Shows this message\n" ~
        "    run                Run a file\n" ~
        "    eval               Evaluate the next argument\n\n" ~
        
        "\x1b[1mOptions:\x1b[0m\n" ~
        "    -n  --no-implicit-print    Do not implicitly print top of stack\n" ~
        "    -s  --print-stack          Print the final stack after execution"
    );   
}
bool color = true; 
void main(string[] args_raw) {
    string[] args = [];
    string[] flags = [];
    foreach(string arg; args_raw) {
        if(arg[0] != '-') {
            args ~= arg;
        } else {
            if(arg[1] == '-') {
                flags ~= arg[2..$];
            }
            else {
                foreach(string c; arg[1..$].split("")) {
                    flags ~= c;
                }
            }
        }
    }

    bool print_stack = false;
    bool imp_print = true;
    foreach(string c; flags) {
        switch(c) {
            case "s":
                print_stack = true;
                break;
            case "print-stack":
                print_stack = true;
                break;
            case "n": 
                imp_print = false;
                break;
            case "no-implicit-print":
                imp_print = false;
                break;
            default: 
                other_error("Unknown flag " ~ c);
        }
    }

    if(args.length == 1 || args[1] == "help") {
        help_menu();
        return;
    }

    t[] stack = [];
    if(args[1] == "run") {
        if(args.length < 3) other_error("Need a 3rd argument");
        if(!exists(args[2])) other_error("File not found: \x1b[1;31m" ~ args[2] ~ "\x1b[0m");
        interpret(stack, to!string(read(args[2])), print_stack, color, false, imp_print);
    }
    else if(args[1] == "eval") {
        if(args.length < 3) other_error("Need a 3rd argument");
        interpret(stack, args[2], print_stack, color, false, imp_print);
    }
    else if(args[1] == "test") {
        writeln("No tests at the moment...");
        
    }
    else {
        other_error("Unknown argument: \x1b[1;31m" ~ args[1] ~ "\x1b[0m");
    }

}