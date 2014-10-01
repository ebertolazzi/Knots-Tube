addpath('../matlab') ;
[pnts,conn] = read_tube( 'granny_toro.txt' ) ;

clf ;
plot_tube(pnts,conn,[],[]) ;
