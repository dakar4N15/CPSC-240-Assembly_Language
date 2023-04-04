
//Author: William Sutanto
//Author: wsutanto@csu.fullerton.edu
//Course and section:  CPSC240-7
//Today’s date: Mar 22, 2023
#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>

extern char* manager();

int main(int argc, char *argv[])
{
    //greet the user
    printf("Welcome to the great reverse by William Sutanto\n\n");

    //call the manager asm module and store the value returned from it
    char* a = manager();

    //output the magnitude of the combined array and end message to console
    printf("Good-bye %s\n", a);
    printf("Have a nice weekend. Zero will be returned to the operating system. Bye\n");
}