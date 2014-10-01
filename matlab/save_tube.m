%=============================================================================%
%  Given a tube (pnts,conn) write a file with a polyhedron definition         %
%  in a human readable form                                                   %
%                                                                             %
%  USAGE: save_tube(name,pnts,conn)                                           %
%                                                                             %
%  On input:                                                                  %
%                                                                             %
%       name = string containing name of the object to be saved               %
%       pnts = matrix 3 by N, N points on the tube                            %
%       conn = integer matrix Nconn by 3 or 4 with the face connection        %
%                                                                             %
%=============================================================================%
%                                                                             %
%  Autor: Enrico Bertolazzi                                                   %
%         Department of Industrial Engineering                                %
%         University of Trento                                                %
%         enrico.bertolazzi@unitn.it                                          %
%                                                                             %
%=============================================================================%
function bbox = save_tube(name,pnts,conn)

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
  
  fileID = fopen( [name '.txt'], 'w' ) ;
  if fileID < 0
    error('cannot open file: %s',[name '.txt']);
  end

  fprintf(fileID,'# file generated with save_tube by Enrico Bertolazzi\n') ;
  fprintf(fileID,'# index start with: 1\n1\n') ;

  npts   = size(pnts,2) ;
  nfaces = length(conn) ;
  fprintf(fileID,'# points for: %s\n%i\n',name,npts) ;
  for k=1:npts
    x = pnts(1,k) ;
    y = pnts(2,k) ;
    z = pnts(3,k) ;
    fprintf(fileID,'%.3g\t%.3g\t%.3g\n',x,y,z) ;
  end
  fprintf(fileID,'# faces for: %s\n%i\n',name,nfaces) ;
  for k=1:nfaces
    IDX = conn{k} ;
    fprintf(fileID,'%i',length(IDX)) ;
    for j=IDX
      fprintf(fileID,'\t%i',j) ;
    end
    fprintf(fileID,'\n') ;
  end
  fprintf(fileID,'# end of data for: %s\n',name) ;
  fclose(fileID) ;
end
