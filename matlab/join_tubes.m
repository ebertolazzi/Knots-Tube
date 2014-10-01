%=============================================================================%
%  plot a tube                                                                %
%                                                                             %
%  USAGE: [PNTS,CONN] = join_tubes( pnts_cell, conn_cell )                    %
%                                                                             %
%  On input:                                                                  %
%                                                                             %
%       pnts_cell = cell array of matrix 3 by N, N points of the tube         %
%       conn_cell = cell array of cell array with the face connection         %
%                                                                             %
%=============================================================================%
%                                                                             %
%  Autor: Enrico Bertolazzi                                                   %
%         Department of Industrial Engineering                                %
%         University of Trento                                                %
%         enrico.bertolazzi@unitn.it                                          %
%                                                                             %
%=============================================================================%
function [PNTS,CONN] = join_tubes( pnts_cell, conn_cell )

  if ~ ( iscell(pnts_cell) && iscell(conn_cell) ) 
    error('expected two cell arrays as arguments');
  end
  if length(pnts_cell) ~= length(conn_cell)
    error('cell arrays must be of the same length');
  end
  
  PNTS = pnts_cell{1} ;
  CONN = conn_cell{1} ;
  offs = size(PNTS,2) ;
  for k=2:length(pnts_cell) ;
    pnts = pnts_cell{k} ;
    PNTS = [ PNTS pnts ] ;
    conn = conn_cell{k} ;
    for j=1:length(conn)
      conn{j} = conn{j}+offs ;
    end
    CONN = [ CONN ; conn ] ;
    offs = offs + size(pnts,2) ;
  end

end
