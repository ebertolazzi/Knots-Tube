%=============================================================================%
%  Given a tube (pnts,conn) write a file with a polyhedron definition to be   %
%  used with NETGEN mesh generator:                                           %
%                                                                             %
%    http://sourceforge.net/projects/netgen-mesher/                           %
%                                                                             %
%  USAGE: bbox = save_netgen(fileName,name,pnts,conn)                         %
%                                                                             %
%  On input:                                                                  %
%                                                                             %
%       fileName = name of the file to save the tube                          %
%       name     = string (or cell array of string) containing name of the    %
%                  object(S) to be saved                                      %
%       pnts     = matrix 3 by N, N points on the tube                        %
%                  (or a cell array of points)                                %
%       conn     = cell array of vectors with face connection                 %
%                  (or a cell array of cell array of vectors)                 %
%                                                                             %
%  On output:                                                                 %
%                                                                             %
%       bbox = bounding box of the tube                                       %
%                                                                             %
%=============================================================================%
%                                                                             %
%  Autor: Enrico Bertolazzi                                                   %
%         Department of Industrial Engineering                                %
%         University of Trento                                                %
%         enrico.bertolazzi@unitn.it                                          %
%                                                                             %
%=============================================================================%
function bbox = save_netgen(fileName,name,pnts,conn)
  if ~ (ischar(fileName) && isvector(fileName) )
    error('expected as first argument a string');
  end
  
  fileID = fopen(fileName,'w') ;

  % check input
  if fileID < 0
    error('error in opening file: %s',fileName);
  end
  
  fprintf(fileID,'algebraic3d\n\n') ;
  
  if iscell(name)
    if ~ (iscell(pnts) && iscell(conn))
      error('bad arguments, if second argument is cell array also 3rd and 4st must be!');  
    end
    if ~( length(name) == length(pnts) && length(name) == length(conn) )
      error('cell arrays (aruments n. 2,3 and 4) must be of the same length');      
    end
    bbox = save_one_tube(fileID,name{1},pnts{1},conn{1}) ;
    for k=2:length(name)
      bbox2     = save_one_tube(fileID,name{k},pnts{k},conn{k}) ;
      bbox.xmin = min(bbox2.xmin,bbox.xmin) ;
      bbox.ymin = min(bbox2.ymin,bbox.ymin) ;
      bbox.zmin = min(bbox2.zmin,bbox.zmin) ;
      bbox.xmax = max(bbox2.xmax,bbox.xmax) ;
      bbox.ymax = max(bbox2.ymax,bbox.ymax) ;
      bbox.zmax = max(bbox2.zmax,bbox.zmax) ;
    end
  else
    bbox = save_one_tube(fileID,name,pnts,conn) ;
  end

  dx = 0.05*(bbox.xmax-bbox.xmin) ;
  dy = 0.05*(bbox.ymax-bbox.ymin) ;
  dz = 0.05*(bbox.zmax-bbox.zmin) ;

  bbox.xmin = bbox.xmin - dx ;
  bbox.xmax = bbox.xmax + dx ;

  bbox.ymin = bbox.ymin - dy ;
  bbox.ymax = bbox.ymax + dy ;
  
  bbox.zmin = bbox.zmin - dz ;
  bbox.zmax = bbox.zmax + dz ;
  
  fprintf(fileID,'solid cube = orthobrick(%2.3g,%2.3g,%2.3g;%2.3g,%2.3g,%2.3g);\n\n', ...
                  bbox.xmin, bbox.ymin, bbox.zmin, ...
                  bbox.xmax, bbox.ymax, bbox.zmax ) ;

  if iscell(name)
    fprintf(fileID,'solid complementary = cube and not (%s ', name{1}) ;
    for k=2:length(name)
      fprintf(fileID,'or %s', name{k}) ;
    end
    fprintf(fileID,');\n\n') ;
    for k=1:length(name)
      fprintf(fileID,'tlo %s;\n', name{k}) ;
    end
  else
    fprintf(fileID,'solid complementary = cube and not %s;\n\n',name) ;
    fprintf(fileID,'tlo %s;\n', name) ;
    fprintf(fileID,'#tlo c%s;\n', name) ;
  end
  
  fclose(fileID) ;

end
%
%
%
function bbox = save_one_tube(fileID,name,pnts,conn)

  if ~ (ischar(name) && isvector(name) )
    error('expected as second argument a string');
  end
  if ~ (isreal(pnts) && ismatrix(pnts) && size(pnts,1) == 3 )
    error('expected as third argument a matrix 3 by N, found %d by %d', size(pnts,1), size(pnts,2) );
  end
  if iscell(conn)
    for k=1:length(conn)
      ele = conn{k} ;
      if ~ ( isreal(ele) && isvector(ele) && length(ele) >= 3 )
        error('cell array elements must be vector of size >= 3 for fourth argument');
      end
      conn{k} = fix(ele) ;
    end
  else
    error('expected a cell array as fourth argument');
  end

  fprintf(fileID,'solid %s = polyhedron(\n',name) ;
  x = pnts(1,1) ;
  y = pnts(2,1) ;
  z = pnts(3,1) ;
  if abs(x) < 1e-14 ; x = 0 ; end
  if abs(y) < 1e-14 ; y = 0 ; end
  if abs(z) < 1e-14 ; z = 0 ; end
  fprintf(fileID,'%.3g,%.3g,%.3g',x,y,z) ;
  for k=2:size(pnts,2)
    x = pnts(1,k) ;
    y = pnts(2,k) ;
    z = pnts(3,k) ;
    if abs(x) < 1e-14 ; x = 0 ; end
    if abs(y) < 1e-14 ; y = 0 ; end
    if abs(z) < 1e-14 ; z = 0 ; end
    if mod(k,5) == 0
      fprintf(fileID,';\n%.3g,%.3g,%.3g',x,y,z) ;
    else
      fprintf(fileID,';%.3g,%.3g,%.3g',x,y,z) ;
    end
  end
  fprintf(fileID,';') ;
  kk = 0 ;
  for k=1:length(conn)
    IDX = conn{k} ;
    for j=3:length(IDX)
      kk = kk + 1 ;
      if mod(kk,10) == 1
        fprintf(fileID,';\n%i,%i,%i',IDX(1),IDX(j-1),IDX(j)) ;
      else
        fprintf(fileID,';%i,%i,%i',IDX(1),IDX(j-1),IDX(j)) ;
      end
    end
  end
  fprintf(fileID,');\n\n') ;
  
  bbox.xmin = min(pnts(1,:)) ;
  bbox.ymin = min(pnts(2,:)) ;
  bbox.zmin = min(pnts(3,:)) ;
  bbox.xmax = max(pnts(1,:)) ;
  bbox.ymax = max(pnts(2,:)) ;
  bbox.zmax = max(pnts(3,:)) ;

end
