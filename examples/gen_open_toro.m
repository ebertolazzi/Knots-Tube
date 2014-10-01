function gen_toro
  addpath('../matlab') ;

  [x,y,z] = htoro(16) ;
  x    = 2*x ;
  y    = 2*y ;
  z    = 2*z ;
  nr   = 4   ;
  R    = 0.5 ;
  type = 3   ;
  [pnts,conn] = generate_open_tube(type,R,nr,x,y,z) ;

  clf ;
  plot_cube([ 2*4  2*3  2*3],[-4 -3 -3],.0,[1 0 0]);
  plot_tube(pnts,conn,[],[]) ;
  hold on;
  plot3(x,y,z) ;
end

function [x,y,z] = htoro(npts)
  u = [pi*linspace(0,1,npts)]';
  x = cos(u) ;
  y = sin(u) ;
  z = zeros(size(u)) ;
end
