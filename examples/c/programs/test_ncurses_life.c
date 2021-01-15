/******************************************************************************
The Game of Life, implemented in ncurses.
run it with a list of (x, y) pairs, for example, for the pairs
(3, 4), (3, 5), (3, 6), (4, 4), (4, 5), (4, 6) ,
run
$ ./test_ncurses_life 0 0 0 1 0 2 1 0 1 1 1 2 2 0 2 1 2 2 3 2 4 2 5 2 6 3 6 4

Copyright (c) 2003, Ben Hoskings <benhoskings@sourceforge.net>
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
    * Neither the author's name, nor the names of his contributors, may be used
    to endorse or promote products derived from this software without specific
    prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
******************************************************************************/

#include <ncurses.h>
#include <stdlib.h>
#include <unistd.h>

#define max(a, b) (a > b ? a : b)
#define min(a, b) (a < b ? a : b)

#define CELL_CHAR '@'

int dim_x, dim_y;
WINDOW *buf_1, *buf_2, *buf, *buf_off;

void flip_buf()
{
	(buf == buf_1) ? (buf = buf_2) : (buf = buf_1);
	(buf == buf_1) ? (buf_off = buf_2) : (buf_off = buf_1);
}

// loop through a 3x3 square around (x, y) and count the live neighbours (that
// is, ignoring the point (x, y) itself).
int get_live_nbs(int x, int y)
{
	int i, j, count = 0;

	for (i = max(x-1, 0); i <= min(x+1, dim_x - 1); i++)
	{
		for (j = max(y-1, 0); j <= min(y+1, dim_y - 1); j++)
		{
			if ((i == x) && (j == y))
				continue;

			if (mvwinch(buf, j, i) == CELL_CHAR)
				count++;
		}
	}
	return count;
}

int main(int argc, char **argv)
{
	int i, j, live_nbs, step = 1;
	bool equal = 0;

	if (argc % 2 == 0)
	{
		printf("Need an even number of arguments, for (x, y) pairs.\n");
		return 1;
	}

	initscr();
	nocbreak();
	timeout(0);
	noecho();

	getmaxyx(stdscr, dim_y, dim_x);

	buf = buf_1 = newwin(dim_y, dim_x, 0, 0);
	buf_off = buf_2 = newwin(dim_y, dim_x, 0, 0);

	for (i = 1; i < argc; i += 2)
		mvwaddch(buf, atoi(argv[i + 1]) + 1, atoi(argv[i]) + 1, CELL_CHAR);

	while (1)
	{
		if (!equal)
		{
			box(buf, 0, 0);
			mvwprintw(buf, dim_y - 1, 4, "%d", step++);
			mvwprintw(buf, 0, 4, "The Game of Life");
			mvwprintw(buf, 0, dim_x - 15, "\'q\' to quit");
			wrefresh(buf);
			equal = 1;

			for (i = 1; i < dim_x - 1; i++)
			{
				for (j = 1; j < dim_y - 1; j++)
				{
					live_nbs = get_live_nbs(i, j);

					if (live_nbs == 3)
						mvwaddch(buf_off, j, i, CELL_CHAR);
					else if (live_nbs != 2)
						mvwaddch(buf_off, j, i, ' ');
					else
						mvwaddch(buf_off, j, i, mvwinch(buf, j, i));

					if (mvwinch(buf, j, i) != mvwinch(buf_off, j, i))
						equal = 0;
				}
			}
			flip_buf();
		}
		usleep(100000);

		if (getch() == 'q')
		{
			delwin(buf_1);
			delwin(buf_2);
			erase();
			endwin();
			return 0;
		}
	}
}
