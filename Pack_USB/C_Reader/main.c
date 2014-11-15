#include <stdio.h>
#include <stdlib.h>

int main( int argc, char *argv[] )
{
    FILE* readFile = NULL;
    FILE* writeFile = NULL;

    char chars[4] = {0, 0, 0, 0};
    int val = 0;

    if( argc != 3 )
    {
        printf("2 arguments : nom du fichier a lire, nom du fichier a ecrire.\n");
    }
    else
    {
        readFile = fopen( argv[1], "rb" );
        writeFile = fopen( argv[2], "w" );
    }

    if ( (readFile != NULL) && ( writeFile != NULL) )
    {
        printf("Fichiers OK...\n");

        while ( 1 )
        {

            chars[0] = fgetc(readFile);
            chars[1] = fgetc(readFile);
            chars[2] = fgetc(readFile);
            chars[3] = fgetc(readFile);
            val  = chars[0] << 0;
            val += chars[1] << 8;
            val += chars[2] << 16;
            val += chars[3] << 24;

            if (chars[3] == EOF)
                return EXIT_SUCCESS;

            printf("%d\n", val);
            fprintf(writeFile, "%d ", val);

        }

        fclose(readFile);
        fclose(writeFile);
    }

    return 0;
}
