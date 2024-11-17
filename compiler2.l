%{
#include <stdio.h>
#include <stdlib.h>

// Token count variables
int keyword_count = 0;
int identifier_count = 0;
int number_count = 0;
int symbol_count = 0;
int logical_op_count = 0;
int math_op_count = 0;
int unknown_count = 0;
int comment_count = 0;
int newline_count = 0;

// Error count variable
int error_count = 0;

// Error reporting function
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s at line %d\n", s, yylineno);
    error_count++;
}
%}

%%

// Single-line comment
"~" { 
    char c = input();
    while (c != '\n' && c != EOF) {
        c = input();
    }
    printf("This is a single line comment\n");
    comment_count++;
}

// Multi-line comment
"~~" {
    printf("This is for Multiple line comment start\n");
    char demo = input();
    
    while (1) {
        while (demo != '~' && demo != EOF) {
            demo = input();
        }
        demo = input();
        if (demo == '~') {
            break;
        }
        if (demo == EOF) { // Handle unexpected end of file
            yyerror("Unexpected EOF in multi-line comment");
            break;
        }
    }
    
    printf("Multiple Line comment End here\n");
    comment_count++;
}

// Keywords
"represent" { printf("KEYWORD: %s\n", yytext); keyword_count++; }
"yell" { printf("KEYWORD: %s\n", yytext); keyword_count++; }
"during" { printf("KEYWORD: %s\n", yytext); keyword_count++; }
"within" { printf("KEYWORD: %s\n", yytext); keyword_count++; }
"while" { printf("KEYWORD: %s\n", yytext); keyword_count++; }
"after" { printf("KEYWORD: %s\n", yytext); keyword_count++; }
"before" { printf("KEYWORD: %s\n", yytext); keyword_count++; }
"upon" { printf("KEYWORD: %s\n", yytext); keyword_count++; }
"through" { printf("KEYWORD: %s\n", yytext); keyword_count++; }
"around" { printf("KEYWORD: %s\n", yytext); keyword_count++; }
"against" { printf("KEYWORD: %s\n", yytext); keyword_count++; }
"among" { printf("KEYWORD: %s\n", yytext); keyword_count++; }
"beside" { printf("KEYWORD: %s\n", yytext); keyword_count++; }




// Newline
['\n'] { printf("Newline\n"); newline_count++; }

// Logical operators
"==" { printf("LOGICAL OPERATOR: EQUAL (==)\n"); logical_op_count++; }
"!=" { printf("LOGICAL OPERATOR: NOT EQUAL (!=)\n"); logical_op_count++; }
">=" { printf("LOGICAL OPERATOR: GREATER THAN OR EQUAL (>=)\n"); logical_op_count++; }
"<=" { printf("LOGICAL OPERATOR: LESS THAN OR EQUAL (<=)\n"); logical_op_count++; }
"&&" { printf("LOGICAL OPERATOR: AND (&&)\n"); logical_op_count++; }
"||" { printf("LOGICAL OPERATOR: OR (||)\n"); logical_op_count++; }
"!" { printf("LOGICAL OPERATOR: NOT (!)\n"); logical_op_count++; }

// Math operators
"+" { printf("MATH OPERATOR: PLUS (+)\n"); math_op_count++; }
"-" { printf("MATH OPERATOR: MINUS (-)\n"); math_op_count++; }
"*" { printf("MATH OPERATOR: MULTIPLY (*)\n"); math_op_count++; }
"/" { printf("MATH OPERATOR: DIVIDE (/)\n"); math_op_count++; }
"%" { printf("MATH OPERATOR: MODULO (%%)\n"); math_op_count++; }
"^" { printf("MATH OPERATOR: POWER (^)\n"); math_op_count++; }

// Symbols
[\{\}\(\)\[\];,] { printf("SYMBOL: %s\n", yytext); symbol_count++; }
"$" { printf("SYMBOL: Dollar ($)\n"); symbol_count++; }
"@" { printf("SYMBOL: At (@)\n"); symbol_count++; }

// Identifiers
[a-zA-Z_][a-zA-Z0-9_]* { printf("Identifier: %s\n", yytext); identifier_count++; }

// Numbers
[0-9]+\.[0-9]+ { printf("Floating-Point Number: %s\n", yytext); number_count++; }
[0-9]+ { printf("Integer: %s\n", yytext); number_count++; }

// Unknown characters
. { 
    printf("Unknown: %s\n", yytext);
    unknown_count++;
    yyerror("Unknown character");
}

%%

int main(int argc, char *argv[]) {
    FILE *input_file = fopen("input.txt", "r");
    FILE *output_file = fopen("output.txt", "w");

    if (!input_file) {
        fprintf(stderr, "Error opening input.txt\n");
        return 1;
    }

    if (!output_file) {
        fprintf(stderr, "Error opening output.txt\n");
        return 1;
    }

    yyin = input_file;
    yyout = output_file;

    printf("Starting lexical analysis...\n");
    yylex();

    // Print token counts to the output file
    fprintf(output_file, "\nToken Counts:\n");
    fprintf(output_file, "Keywords: %d\n", keyword_count);
    fprintf(output_file, "Identifiers: %d\n", identifier_count);
    fprintf(output_file, "Numbers: %d\n", number_count);
    fprintf(output_file, "Symbols: %d\n", symbol_count);
    fprintf(output_file, "Logical Operators: %d\n", logical_op_count);
    fprintf(output_file, "Math Operators: %d\n", math_op_count);
    fprintf(output_file, "New line: %d\n", newline_count);
    fprintf(output_file, "Comments: %d\n", comment_count);
    fprintf(output_file, "Unknowns: %d\n", unknown_count);
    fprintf(output_file, "Errors: %d\n", error_count); // Print error count

    fclose(input_file);
    fclose(output_file);

    return 0;
}

// Required by Flex to indicate the end of input
int yywrap() {
    return 1;
}
