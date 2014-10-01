### Knots & Tubes
**by Enrico Bertolazzi**

The scripts

  - `generate_closed_tube`
  - `generate_open_tube`

given a 3d curve as a sequence of points build a mesh of triangles
or polygons realizing a tube around the curve.

A closed tube is realized by the commands:

~~~~~~~~~~~~~~~~~~~
[pnts,conn,line1,line2] = generate_closed_tube(typ,R,nr,xyz) ;
[pnts,conn,line1,line2] = generate_closed_tube(typ,R,nr,x,y,z) ;
~~~~~~~~~~~~~~~~~~~

where R is the ray of the tube, nr is the number of edge used
to approximate the circle of ray R moving along the curve.
The points on the guiding curve are specified by using 
xyz a matrix 3 by N whose columns are the points, or by
using the vectors x, y and z.
typ is the kind of polygons are used to describe the tube

  - typ = 0       the mesh is composed by rectangles
  - typ = 1 to 4  the mesh is composed by triangles

return values are

  - pnts the points of the mesh os the tube as a matric 3 by npts
  - conn cell array where each element is a vector of integer with represents 
    the connection of the faces with the points
  - line1 and line2 are vectors of integer which reperesents the equator
    lines of the tube-torus. 

This command asssume that the curve is closed, otherwise use

~~~~~~~~~~~~~~~~~~~
[pnts,conn] = generate_open_tube(typ,R,nr,xyz) ;
[pnts,conn] = generate_open_tube(typ,R,nr,x,y,z) ;
~~~~~~~~~~~~~~~~~~~

which egenrate an open tube.
For typ = 0 there are two poligonal faces at teh begin and end
of the tube, For typ > 0 this poligon is splitted in triangles.

**Ploting**
to visualize a tube the utility function

~~~~~~~~~~~~~~~~~~~~
plot_tube( pnts, conn, line1, line2, ... ) ;
~~~~~~~~~~~~~~~~~~~~

can be used. As optional parameter you can use

  - 'FaceColor',  [r,g,b] = color of the faces
  - 'EdgeColor',  [r,g,b] = color of the edges
  - 'Line1Color', [r,g,b] = color of line 1
  - 'Line2Color', [r,g,b] = color of line 2

**Input Oouput**
A tube can be saved in a text file by using

~~~~~~~~~~~~~~~~~~~~
bbox = save_tube(name,pnts,conn) ;
~~~~~~~~~~~~~~~~~~~~

The file name+'.txt' is generated with a simple description of the tube
as a list of points followed by face connections.

To read an already saved tube use 

~~~~~~~~~~~~~~~~~~~~
[pnts,conn] = read_tube( fname ) ;
~~~~~~~~~~~~~~~~~~~~

with the obvious meaning.

It is possibile to save a tube or a list o tubes to files which can be used 
by a mesh generator like NETGEN or TETGEN.

For netgen use:

~~~~~~~~~~~~~~~~~~~~
bbox = save_netgen(fileName,name,pnts,conn) ;
~~~~~~~~~~~~~~~~~~~~

For tetgen use:

~~~~~~~~~~~~~~~~~~~~
bbox = save_tetgen(fileName,names,pin,pnts,conn);
~~~~~~~~~~~~~~~~~~~~

tetgen needs the knowlegde of an internal point of the tube
stored in `pin`.

**Examples**
In the directory `example` many examples shows as to use
the library to build knots and plot it. 

**Author:**
	
	Enrico Bertolazzi
	Department of Industrial Engineering
	University of Trento
	enrico.bertolazzi@unitn.it
