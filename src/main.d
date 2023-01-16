module kib.main;

import std.stdio;
import std.file;
import std.conv;
import std.array;

import kib.interpreter;
import kib.helpers;
import kib.types;
import kib.error;

string code = ">*e,%N%),+>";

void help_menu() {
    writeln(
        "\x1b[1mkib\x1b[0m v0.0\n" ~
        "    help               Shows this message\n" ~
        "    run                Run a file\n" ~
        "    eval               Evaluate the next argument"
    );   
}
void main(string[] args) {
    if(args.length == 1 || args[1] == "help") {
        help_menu();
        return;
    }
    else if(args[1] == "run") {
        if(args.length < 3) other_error("Need a 3rd argument");
        if(!exists(args[2])) other_error("File not found: \x1b[1;31m" ~ args[2] ~ "\x1b[0m");
        interpret(to!string(read(args[2])));
    }
    else if(args[1] == "eval") {
        if(args.length < 3) other_error("Need a 3rd argument");
        interpret(args[2]);
    }
    else if(args[1] == "test") {
        writeln(input());

    }
    else {
        other_error("Unknown argument: \x1b[1;31m" ~ args[1] ~ "\x1b[0m");
    }

}