function gen_23torus
  addpath('../matlab') ;
  [x,y,z] = pnts23torus(64) ;
  nr   = 4   ;
  R    = 0.5 ;
  type = 0   ;
  [pnts,conn,line1,line2] = generate_closed_tube(type,R,nr,x,y,z) ;

  clf ;
  plot_tube(pnts,conn,line1,line2) ;

end

function [x,y,z] = pnts23torus(npts)
  t = [2*pi*linspace(0,1,npts)]';
  x = (2+cos(3*t)).*cos(2*t) ;
  y = (2+cos(3*t)).*sin(2*t) ;
  z = sin(3*t) ;
end

