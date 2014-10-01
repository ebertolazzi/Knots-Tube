function gen_trefoil
  addpath('../matlab') ;

  [x,y,z] = trefoil(40) ;
  nr   = 4   ;
  R    = 0.5 ;
  type = 0   ;
  [pnts,conn,line1,line2] = generate_closed_tube(type,R,nr,x,y,z,true) ;

  clf ;
  plot_tube(pnts,conn,[],[]) ;
  
  save_netgen('trefoil.geo','trefoil',pnts,conn) ;

end

function [x,y,z] = trefoil(npts)
  t = [2*pi*linspace(0,1,npts)]';
  x = sin(t)+2*sin(2*t) ;
  y = cos(t)-2*cos(2*t) ;
  z = -sin(3*t) ;
end
