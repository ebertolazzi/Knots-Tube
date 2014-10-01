function gen_5foil
  addpath('../matlab') ;
  [x,y,z] = pnts5foil(96) ;
  nr   = 6   ;
  R    = 0.5 ;
  type = 4   ;
  [pnts,conn,line1,line2] = generate_closed_tube(type,R,nr,x,y,z) ;

  clf ;
  plot_tube(pnts,conn,line1,line2) ;

  % use type > 0 if you want to use save_geo
  % fileID = fopen( '5foil.geo', 'w' ) ;
  % bbox = save_geo(fileID,'5foil',pnts,conn,true) ;
  % fclose(fileID) ;

end

function [x,y,z] = pnts5foil(npts)
  theta = [2*pi*linspace(0,1,npts)]';
  x     = (7/3)*sin(2*theta)-(2/3)*sin(3*theta) ;
  y     = (7/3)*cos(2*theta)+(2/3)*cos(3*theta) ;
  z     = 2*sin(5*theta) ;
end
