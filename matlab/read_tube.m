%=============================================================================%
%  read a tube                                                                %
%                                                                             %
%  USAGE: [pnts,conn] = read_tube( fname )                                    %
%                                                                             %
%  On input:                                                                  %
%                                                                             %
%       fname = name of the file containing tube description                  %
%                                                                             %
%  On output:                                                                 %
%                                                                             %
%       pnts  = matrix 3 by N, N points of the tube                           %
%       conn  = integer matrix Nconn by 3 or 4 with the face connection       %
%                                                                             %
%=============================================================================%
%                                                                             %
%  Autor: Enrico Bertolazzi                                                   %
%         Department of Industrial Engineering                                %
%         University of Trento                                                %
%         enrico.bertolazzi@unitn.it                                          %
%                                                                             %
%=============================================================================%
function [pnts,conn] = read_tube( fname ) 

  fid = fopen(fname);
  if fid==0
    error('read_tube: cannot open file: %s\n',fname); 
  end

  while true
    line = fgetl(fid) ;
    if length(line) > 0 && line(1) ~= '#'
      break ;
    end
  end

  [offs,count] = sscanf(line,'%i',1) ;
  if count ~= 1
    error('read_tube: error in reding offset (count=%i)\n',count) ;
  end
  offs = 1-offs ; % if offs = 1 --> add 0, if offs = 0 add 1 to index

  while true
    line = fgetl(fid) ;
    if length(line) > 0 && line(1) ~= '#'
      break ;
    end
  end

  [npts,count] = sscanf(line,'%i',1) ;
  if count ~= 1 || npts <= 0
    error('read_tube: error in reding number of point (count=%i,npts=%i)\n',count,npts) ;
  end

  % read points
  [pnts,count] = fscanf(fid,'%f',[3,npts]);
  if count ~= npts*3
    error('read_tube: error in parsing file: %s\n',fname) ;
  end

  while true
    line = fgetl(fid) ;
    if length(line) > 0 && line(1) ~= '#'
      break ;
    end
  end

  [nface,count] = sscanf(line,'%i',1) ;
  if count ~= 1
    error('read_tube: error in parsing file: %s\n',fname) ;
  end

  % read faces
  conn = cell(nface,1) ;
  for k=1:nface
    [n,count] = fscanf(fid,'%i',1);
    if count ~= 1
      error('read_tube: error in parsing file: %s\n',fname) ;
    end
    [idx,count] = fscanf(fid,'%i',[1,n]);
    if count ~= n
      error('read_tube: error in parsing file: %s\n',fname) ;
    end
    conn{k} = idx+offs ;
  end

end
