# Hello! #

> 2048 is wayyyyy too fun

### This a rewrite of the game [2048](http://gabrielecirulli.github.io/2048/) in the [D](https://dlang.org) language ###

### I aim to have several different front-ends for the game ###

#### Versions ####

- Library
  + Not really a version, but the backend is totally separate from anything
	else
- Stdout **Almost Finished**
  + use the c standard input output streams to control the board
  + commands:
	+ *up* : **Moves the blocks up**
	+ *down* : **Moves blocks down**
	+ *left* : **Moves blocks left**
	+ *right* : **Moves blocks right**
	+ *quit* : **Quit the game**
- Ncurses **TODO**
  + colors?
- GTK+ **TODO**
  + Will require GTK+ libraries, which could be a little tricky to get on Windows/Mac
- Allegro **TODO**
  + I don't know how well this will work, but I think most values will be hardcoded in, along with a hardcoded font
  + font
	+ try to find bitmap font that works nicely


