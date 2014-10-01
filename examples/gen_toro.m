function gen_toro
  addpath('../matlab') ;

  [x,y,z] = toro(16) ;
  x    = 2*x ;
  y    = 2*y ;
  z    = 2*z ;
  nr   = 4   ;
  R    = 0.5 ;
  type = 0   ;
  [pnts,conn,line1,line2] = generate_closed_tube(type,R,nr,x,y,z) ;

  clf ;
  plot_cube([ 2*4  2*3  2*3],[-4 -3 -3],.0,[1 0 0]);
  plot_tube(pnts,conn,line1,line2) ;

end

function [x,y,z] = toro(npts)
  u = [2*pi*linspace(0,1,npts)]';
  x = cos(u) ;
  y = sin(u) ;
  z = zeros(size(u)) ;
end
