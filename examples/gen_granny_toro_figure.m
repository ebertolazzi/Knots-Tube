
function gen_granny_toro_figure
  addpath('../matlab') ;
  addpath('../third-party') ;

  close all ;

  h = figure() ;
  hold off ;
  plot_cube([ 2*4  2*3  2*3],[-4 -3 -3],.0,[1 0 0]);
  hold on ;

  [x,y,z] = granny(64) ;
  nr = 6 ;
  R  = 0.3 ;
  [pnts,conn,line1,line2] = generate_closed_tube(0,R,nr,x,y,z) ;
  hold on ;
  plot_tube(pnts,conn,[],[],'FaceColor',[1 1 0.4]) ;
  
  [x,y,z] = toro(16) ;
  x = 2*x ;
  y = 2*y ;
  z = 2*z ;
  nr = 4   ;
  R  = 0.5 ;
  [pnts,conn,line1,line2] = generate_closed_tube(0,R,nr,x,y,z) ;

  hold on ;
  plot_tube(pnts,conn,[],[],'FaceColor',[0.5 1 0.1]) ;
  axis([-4,4,-3,3,-3,3]) ;
  view(40,50) ;
  save2pdf('toro_granny.pdf',h,600) ;
  
  h = figure() ;
  hold off ;
  plot_cube([ 2*4  2*3  2*3],[-4 -3 -3],.0,[1 0 0]);
  hold on ;
  
  [x,y,z] = toro(16) ;
  x = 2*x ;
  y = 2*y ;
  z = 2*z ;
  nr = 4   ;
  R  = 0.5 ;
  [pnts,conn,line1,line2] = generate_closed_tube(0,R,nr,x,y,z) ;

  hold on ;
  plot_tube(pnts,conn,[],[],'FaceColor',[0.5 1 0.1]) ;
  axis([-4,4,-3,3,-3,3]) ;
  view(40,50) ;
  
  save2pdf('toro.pdf',h,600) ;

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
