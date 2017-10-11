/* cba_converter.c */
/* converts file from "change blindness app" into matlab-friendly
   subfiles */
/* pskirko 6.12.01 */

#define BUFFER_SIZE 512

#include <stdlib.h>
#include <stdio.h>

int
main(int argc, char** argv){

  /* data */

  char buffer[BUFFER_SIZE];
  char key;
  FILE* fid, *data_fid;
  char* data_filename, *filename;
  char* newline_ptr;
  int rc;

  /* parse params */
  float time;
  int ijunk[20];
  char color[BUFFER_SIZE];
  float fjunk[6];

  /* go! */
  if(argc !=2){
    fprintf(stderr, "usage: cba_converter <filename>\n");
    exit(1);
  }
  filename = argv[1];

  /* open file */
  fid = fopen(filename, "r");
  
  if(fid == NULL){
    fprintf(stderr, "file not found: %s", filename);
    exit(1);
  }
  
  /* open output files */
  data_filename = (char*) strdup(filename);
  strcat(data_filename, ".data");
  data_fid = fopen(data_filename, "w");
 
  if(data_fid == NULL){
    fprintf(stderr, "file not opened: %s", data_filename);
    exit(1);
  }
  
  while(fgets(buffer, BUFFER_SIZE, fid) != NULL){
    key = buffer[0];

    if(key == '#'){

    }
    else if(key == 'c'){
      
    }
    else if(key == 'd'){
      rc = sscanf(buffer, "%*s %f" 
		  "%d %d %d %d %d" "%d %d %d %d %d" "%d %d %d %d %d" "%d"
		  /* optional params */
		  "%d %d %d %d %s %f %f %f %f %f %f\n", 
		  &time, 
		  &ijunk[0], &ijunk[1], &ijunk[2], &ijunk[3], &ijunk[4],
		  &ijunk[5], &ijunk[6], &ijunk[7], &ijunk[8], &ijunk[9],
		  &ijunk[10], &ijunk[11], &ijunk[12], &ijunk[13], &ijunk[14],
		  &ijunk[15], &ijunk[16], &ijunk[17], &ijunk[18], &ijunk[19],
		  color, &fjunk[0], &fjunk[1], &fjunk[2], &fjunk[3], 
		  &fjunk[4], &fjunk[5]);

      if(rc == 17){ /* short line-- append line to end */

	/* strip newline */
	newline_ptr = (char*) strchr(buffer, (int) '\n');
	if(newline_ptr != NULL){
	  *newline_ptr = '\0'; /* replace newline with null string */	  
	}
	strcat(buffer, " 0 0 0 0 null_color 0 0 0 0 0 0\n");
      }

      fputs(buffer, data_fid);
    }
    else{
      fprintf(stderr, "unknown line:\n %s", buffer);
      fclose(fid);
      exit(1);
    }
  }

  return (0);
}
