function gen_trefoil
  addpath('../matlab') ;

  [x,y,z] = trefoil(80) ;
  nr   = 8   ;
  R    = 0.5 ;
  type = 0   ;
  [pnts,conn] = generate_open_tube(type,R,nr,x,y,z) ;

  clf ;
  plot_tube(pnts,conn,[],[]) ;

end

function [x,y,z] = trefoil(npts)
  t = [2*pi*linspace(0.05,0.95,npts)]';
  x = sin(t)+2*sin(2*t) ;
  y = cos(t)-2*cos(2*t) ;
  z = -sin(3*t) ;
end
