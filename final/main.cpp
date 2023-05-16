//Author: William Sutanto
//Author: wsutanto@csu.fullerton.edu
//Course and section:  CPSC240-7
//Today’s date: May 15 2023


#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>

extern "C" double manager();           // Declare the external ASM function using the "C" directive to pass parameters in the CCC standard

int main(int argc, char* argv[])
{
  //output welcome message
  printf("Welcome to Electric Circuits programmed by William Sutanto.\n");

  // call the asm file and store the value returned from it
  double a = manager();

  //output the time of computation in nanoseconds and end message to console
  printf("\nThe main function has received %.8lf and will keep it.  A zero will be sent to the OS.\n", a);

  return 0;
}