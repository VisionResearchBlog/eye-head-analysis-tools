#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define BUFFER_SIZE 1024
char buffer[BUFFER_SIZE];

#define dist  718.7317676493492
#define pi 3.14159265358979

int 
main(int argc, char** argv){

  FILE* fid_in, *fid_out;
  static int first_time;

  float time;
  float head[6];
  float hand[6];
  int asl[3];
  float eih[2];
  float gaze[2];
  char string1[200], string2[200], string3[200];

  int i, fix;
  float tmp, vga[2];
  char file_in[256], file_out[256];
 
   /* print usage */
  if(argc == 1 || (argc == 2 && (strcmp(argv[1], "-h") == 0))){
    printf("usage: bfx_converter <files>\nbfx_converter [-h] prints this"
	   "message\n"
	   "ex: bfx_converter *.dat\n");
  }
  
  for(i=1; i<argc; i++){ /* convert file */ 
    first_time = 1;
    
    strcpy(file_in, argv[i]); 
    strcpy(file_out, file_in); 
    strcat(file_out, ".corrected");
      
    /* open input */
    fid_in = fopen(file_in, "r");
    if(fid_in == NULL){
      fprintf(stderr, "could not open input file: %s\n", file_in);
      continue;
    }
      
    /* open output */
    fid_out = fopen(file_out, "w");
    if(fid_out == NULL){
      fprintf(stderr, "could not open output file: %s\n", file_out);
      fclose(fid_in);
      continue;
    }
    
    /* determine if head angle need to be fixed */
    fix = 0;
    
    if(correct_head(fid_in)){
      printf("will correct head angle\n");
      fix = 1;
    }
    
    /* re-open file */
    fclose(fid_in);
    fid_in = fopen(file_in, "r");
    if(fid_in == NULL){
      fprintf(stderr, "could not re-open input file: %s\n", file_in);
      continue;
    }
    
    while(fgets(buffer, BUFFER_SIZE, fid_in) != NULL){
      if(first_time){
	first_time = 0;
	fputs(buffer, fid_out);
	continue;
      }
      
      sscanf(buffer, 
	     "%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f"
	     "\t%f\t%d\t%d\t%d\t%f\t%f\t%f\t%f\t%s\t%s\t%s\n",
	     &time, 
	     &head[0], &head[1], &head[2],
	     &head[3], &head[4], &head[5],
	     &hand[0], &hand[1], &hand[2],
	     &hand[3], &hand[4], &hand[5],
	     &asl[0], &asl[1], &asl[2],
	     &eih[0], &eih[1], 
	     &gaze[0], &gaze[1], 
	     string1,string2, string3);
      
      
      /* fix head_h */
      if(fix){
	tmp = head[3];
	if(tmp > 180.0){
	  tmp -= 360.0;
	}
	head[3] = tmp;
      }
      
      /* compute correct angles */
      
      /* asl -> vga */
      vga[0] = (41.8716 + 2.2018*asl[0]) - 320;
      vga[1] = (488 - 2.0*asl[1])- 243;

      /* vga -> eih*/
      
      eih[0] =  (180.0*atan2((double)vga[0],dist))/pi;
      eih[1] =  (180.0*atan2((double)vga[1],dist))/pi;     

      gaze[0] = eih[0] + head[3];
      gaze[1] = eih[1] + head[4];

      fprintf(fid_out,
	      "%.0f\t%.4f\t%.4f\t%.4f\t%.1f\t%.1f\t%.1f\t%.4f\t%.4f\t%.4f\t%.1f\t%.1f"
	      "\t%.1f\t%d\t%d\t%d\t%.2f\t%.2f\t%.2f\t%.2f\t%s\t%s\t%s\n",
	      time, 
	      head[0], head[1], head[2],
	      head[3], head[4], head[5],
	      hand[0], hand[1], hand[2],
	      hand[3], hand[4], hand[5],
	      asl[0], asl[1], asl[2],
	      eih[0], eih[1], 
	      gaze[0], gaze[1], 
	      string1, string2, string3);       
    }    
    fclose(fid_in); fclose(fid_out);
  }
  return (0);
}

/* determine if we should correct this file for heading angle:
  0, 360-> -180, 180 */

int
correct_head(FILE* fid){
  static int first_time = 1;
  float head_h;

  while(fgets(buffer, BUFFER_SIZE, fid) != NULL){
    if(first_time){ /* skip line*/
      first_time = 0;
      continue; 
    }

    sscanf(buffer, 
	   "%*f\t%*f\t%*f\t%*f\t%f\t%*f\t%*f\t%*f\t%*f\t%*f\t%*f\t%*f"
	   "\t%*f\t%*d\t%*d\t%*d\t%*f\t%*f\t%*f\t%*f\t%*s\t%*s\t%*s\n",
	   &head_h);
    
    if(head_h > (180.0 + 1e-8)){
      return 1;
    }
  }
  return 0;
}
