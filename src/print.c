#include <stdio.h>
#include <stdlib.h>

#include <sys/stat.h>

#include <texted/permissions.h>
#include <texted/insert.h>
#include <texted/fileio.h>
#include <texted/texted.h>

void ed_print(char** LineBuffer, int Lines, int LineNum)
{
	if (LineNum)
		LineNum = 1;

	for (int i = 0; i < Lines; i++)
	{
		if (LineNum)
			printf("%d   ", LineNum++); 	  // First prints the line, than increments the number
		fputs(LineBuffer[i], stdout);         // Line ends with \n, except the last one which ends with 0x00
	}
}

int ed_print_permissions(const char* Filename)
{
	finfo_s* fi;

	if(get_temp())
		fi = finfo(TMP_PATH);
	else
		fi = finfo(Filename);
	
	if(!fi) {
		perror(RED "Failed to read file infos" RESET);
		return ED_NULL_FILE_PTR;
	}

	printf(BOLD MAGENTA "%s\t%s %s\t%s\n" RESET,
		   fi->fi_permissions,
		   fi->fi_user,
		   fi->fi_group,
		   fi->fi_name);
	
	finfo_free(fi);
	return ED_SUCCESS;
}