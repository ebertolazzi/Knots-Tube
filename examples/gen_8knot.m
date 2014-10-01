function gen_8knot
  addpath('../matlab') ;
  [x,y,z] = pnts8knots(64) ;
  nr   = 6    ;
  R    = 0.25 ;
  type = 4    ;
  [pnts,conn,line1,line2] = generate_closed_tube(type,R,nr,x,y,z,true) ;

  clf ;
  plot_tube(pnts,conn,line1,line2) ;
  
  save_tetgen('8knot.poly','eight_knot',[x(2),y(2),z(2)],pnts,conn) ;

end

function [x,y,z] = pnts8knots(npts)
  t = [2*pi*linspace(0,1,npts)]';
  x = (2+cos(2*t)).*cos(3*t);
  y = (2+cos(2*t)).*sin(3*t);
  z = 2*sin(4*t);
end
