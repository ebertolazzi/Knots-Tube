function gen_granny
  addpath('../matlab') ;
  [x,y,z] = granny(96) ;
  nr   = 4   ;
  R    = 0.3 ;
  type = 0   ;
  [pnts,conn,line1,line2] = generate_closed_tube(type,R,nr,x,y,z) ;

  clf ;
  plot_tube(pnts,conn,line1,line2) ;

end

function [x,y,z] = granny(npts)
  u = [2*pi*linspace(0,1,npts)]';
  x = -22*cos(u) - 128*sin(u) - 44*cos(3*u) - 78*sin(3*u) ;
  y = -10*cos(2*u) - 27*sin(2*u) + 38*cos(4*u) + 46*sin(4*u) ;
  z =  70*cos(3*u) - 40*sin(3*u) ;
  SCALE = 2/100 ;
  x = x*SCALE;
  y = y*SCALE;
  z = z*SCALE;
end
