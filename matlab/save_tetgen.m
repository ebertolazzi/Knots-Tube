%=============================================================================%
%  Given a tube (pnts,conn) write a file with a polyhedron definition to be   %
%  used with TETGEN mesh generator:                                           %
%                                                                             %
%    http://wias-berlin.de/software/tetgen/index.html                         %
%                                                                             %
%  USAGE: bbox = save_tetgen(fileName,names,pin,pnts,conn)                    %
%                                                                             %
%  On input:                                                                  %
%                                                                             %
%       fileName = name of the file to save the tube                          %
%       names    = string with tube name (or a cell array of strings)         %
%       pin      = point inside a tube (or a cell array of point inside)      %
%       pnts     = matrix 3 by N, N points on the tube                        %
%                  (or a cell array of points)                                %
%       conn     = cell array of vectors with face connection                 %
%                  (or a cell array of cell array of vectors)                 %
%                                                                             %
%  On output:                                                                 %
%                                                                             %
%       bbox = bounding box of the tube(s)                                    %
%                                                                             %
%=============================================================================%
%                                                                             %
%  Autor: Enrico Bertolazzi                                                   %
%         Department of Industrial Engineering                                %
%         University of Trento                                                %
%         enrico.bertolazzi@unitn.it                                          %
%                                                                             %
%=============================================================================%
function bbox = save_tetgen(fileName,names,pin,pnts,conn)
  if ~ (ischar(fileName) && isvector(fileName) )
    error('expected as first argument a string');
  end
  
  fileID = fopen(fileName,'w') ;

  % check input
  if fileID < 0
    error('error in opening file: %s',fileName);
  end
  
  if iscell(pnts)
    npts = 0 ;
    for k=1:length(pnts)
      npts = npts + size(pnts{k},2) ;
    end
  else
    npts = size(pnts,2) ;
  end
  
  fprintf(fileID,'# Node list\n%i 3 0 0\n',npts) ;

  offs = cell( length(pnts), 1 ) ;
  
  if iscell(pnts)
    if ~ (iscell(names) && iscell(pin) && iscell(pnts) && iscell(conn) )
      error('bad arguments, if second argument is cell array also the following must be!');  
    end
    if length(names) ~= length(pin) || ...
       length(names) ~= length(pnts) || ...
       length(names) ~= length(conn)
      error('cell arrays (aruments n.2-5) must be of the same length');      
    end
    kk     = 0 ;
    nfaces = 0 ;
    for k=1:length(pnts)
      offs{k} = kk ;
      pts     = pnts{k} ;
      for j=1:size(pts,2)
        kk = kk + 1;
        fprintf(fileID,'%i\t%.3g\t%.3g\t%.3g\n',kk,pts(1,j),pts(2,j),pts(3,j)) ;
      end
      nfaces = nfaces + length(conn{k}) ;
    end
    bbox = get_bbox(pnts{1}) ;
    for k=2:length(pnts)
      bbox2     = get_bbox(pnts{k}) ;
      bbox.xmin = min(bbox2.xmin,bbox.xmin) ;
      bbox.ymin = min(bbox2.ymin,bbox.ymin) ;
      bbox.zmin = min(bbox2.zmin,bbox.zmin) ;
      bbox.xmax = max(bbox2.xmax,bbox.xmax) ;
      bbox.ymax = max(bbox2.ymax,bbox.ymax) ;
      bbox.zmax = max(bbox2.zmax,bbox.zmax) ;
    end
  else
    offs{1} = 0 ;
    for j=1:size(pnts,2)
      fprintf(fileID,'%i\t%.3g\t%.3g\t%.3g\n',j,pnts(1,j),pnts(2,j),pnts(3,j)) ;
    end
    nfaces = length(conn) ;
    bbox   = get_bbox(pnts) ;
  end
  
  fprintf(fileID,'#Face list\n%i 0\n',nfaces) ;
  
  if iscell(pnts)
    for k=1:length(conn)
      con = conn{k} ;
      for j=1:length(con)
        co = con{j} ;
        fprintf(fileID,'1\n%i',length(co)) ;
        for i=1:length(co)
          fprintf(fileID,'\t%i',co(i)+offs{k}) ;
        end
        fprintf(fileID,'\n') ;
      end
    end
  else
    for j=1:length(conn)
      co = conn{j} ;
      fprintf(fileID,'1\n%i',length(co)) ;
      for i=1:length(co)
        fprintf(fileID,'\t%i',co(i)) ;
      end
      fprintf(fileID,'\n') ;
    end
  end
  
  
  if iscell(pnts)
    fprintf(fileID,'# Hole list\n0 # no hole\n# Region list\n%i\n',length(conn)) ;
    for k=1:length(names)
      pt = pin{k} ;
      fprintf(fileID,'# %s\n%i\t%.3g\t%.3g\t%.3g\t%i\t%i\n',...
              names{k},k,pt(1),pt(2),pt(1),k,1000+k) ;
    end
  else
    fprintf(fileID,'# Hole list\n0 # no hole\n# Region list\n1\n') ;
    fprintf(fileID,'# %s\n%i\t%.3g\t%.3g\t%.3g\t%i\t%i\n',...
            names,1,pin(1),pin(2),pin(1),1,1001) ;
  end
 
  fclose(fileID) ;

  dx = 0.05*(bbox.xmax-bbox.xmin) ;
  dy = 0.05*(bbox.ymax-bbox.ymin) ;
  dz = 0.05*(bbox.zmax-bbox.zmin) ;

  bbox.xmin = bbox.xmin - dx ;
  bbox.xmax = bbox.xmax + dx ;

  bbox.ymin = bbox.ymin - dy ;
  bbox.ymax = bbox.ymax + dy ;
  
  bbox.zmin = bbox.zmin - dz ;
  bbox.zmax = bbox.zmax + dz ;

end
%
%
%
function bbox = get_bbox(pnts)
  bbox.xmin = min(pnts(1,:)) ;
  bbox.ymin = min(pnts(2,:)) ;
  bbox.zmin = min(pnts(3,:)) ;
  bbox.xmax = max(pnts(1,:)) ;
  bbox.ymax = max(pnts(2,:)) ;
  bbox.zmax = max(pnts(3,:)) ;
end
