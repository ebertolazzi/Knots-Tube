function gen_granny_toro
  addpath('../matlab') ;
  [x,y,z] = granny(64) ;
  PIN{1} = [x(2),y(2),z(2)] ; % save point inside
  nr   = 4   ; % 6
  R    = 0.3 ;
  type = 0   ;
  [pnts,conn,line1,line2] = generate_closed_tube(type,R,nr,x,y,z) ;

  clf ;
  plot_tube(pnts,conn,line1,line2,'FaceColor',[1.000, 1.000, 0.5]) ;

  fileID = fopen( 'granny_toro.geo', 'w' ) ;
  fprintf(fileID,'algebraic3d\n\n') ;
  
  [x,y,z] = toro(16) ;
  PIN{2} = [x(2),y(2),z(2)] ; % save point inside
  x    = 2*x ;
  y    = 2*y ;
  z    = 2*z ;
  nr   = 4   ;
  R    = 0.5 ;
  type = 3   ;
  [pnts1,conn1,line1,line2] = generate_closed_tube(type,R,nr,x,y,z) ;

  plot_cube([ 2*4  2*3  2*3],[-4 -3 -3],.0,[1 0 0]);
  plot_tube(pnts,conn,line1,line2,'FaceColor',[1.000, 0.600, 1.000]) ;
  
  PNTS = { pnts, pnts1 } ;
  CONN = { conn, conn1 } ;
  NAME = { 'granny', 'toro' } ;
  save_netgen( 'granny_toro.geo', NAME, PNTS, CONN ) ;

  save_tetgen( 'granny_toro.poly', NAME, PIN, PNTS, CONN ) ;

  [pnts,conn] = join_tubes( PNTS, CONN ) ;
  save_tube('granny_toro',pnts,conn) ;

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

function [x,y,z] = toro(npts)
  u = [2*pi*linspace(0,1,npts)]';
  x = cos(u) ;
  y = sin(u) ;
  z = zeros(size(u)) ;
end
