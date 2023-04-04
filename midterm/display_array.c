//Author: William Sutanto
//Author: wsutanto@csu.fullerton.edu
//Course and section:  CPSC240-7
//Today’s date: Mar 22, 2023

#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>

void display_array(double arr[], int arr_size) {
  for (int i = 0; i < arr_size; i++)
  {
    printf("%.1lf", arr[i]);
    printf("\n");
  }
  printf("\n");
}
