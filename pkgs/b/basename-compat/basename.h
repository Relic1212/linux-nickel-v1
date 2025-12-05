
#ifndef BASENAME_H
#define BASENAME_h

char *basename(char *path)
{
    int i = 0;
    int start = 0;
    int end;
    char c;
    while (1)
    {
        c = path[i];
        if (c == '\0')
        {
            end = i;
            break;
        }
        else if (c == '/')
        {
            start = i+1;
        }
        i++;
    }

    int base_size = end - start +1;
    char base_arr[base_size];
    for (int i = 0; i < base_size; i++)
    {
        base_arr[i] = path[i + start];
    }
    char *base = (char *)base_arr;
    return base;
}

#endif // BASENAME_H