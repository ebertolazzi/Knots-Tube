%=============================================================================%
%  plot a tube                                                                %
%                                                                             %
%  USAGE: plot_tube( pnts, conn, line1, line2, ... )                          %
%                                                                             %
%  On input:                                                                  %
%                                                                             %
%       pnts      = matrix 3 by N, N points of the tube                       %
%       conn      = cella array with the face connection                      %
%       line1     = integer vector with index of points connecting a radial   %
%                   curve near the initial point                              %
%       line2     = integer vector with index of points connecting a          %
%                   longitudinal curve passing near to the initial point      %
%                                                                             %
%  Optional parameters                                                        %
%                                                                             %
%       'FaceColor',  [r,g,b] = color of the faces                            %
%       'EdgeColor',  [r,g,b] = color of the edges                            %
%       'Line1Color', [r,g,b] = color of line 1                               %
%       'Line2Color', [r,g,b] = color of line 2                               %
%                                                                             %
%=============================================================================%
%                                                                             %
%  Autor: Enrico Bertolazzi                                                   %
%         Department of Industrial Engineering                                %
%         University of Trento                                                %
%         enrico.bertolazzi@unitn.it                                          %
%                                                                             %
%=============================================================================%
function plot_tube( pnts, conn, line1, line2, varargin )
  %   ____ _               _    
  %  / ___| |__   ___  ___| | __
  % | |   | '_ \ / _ \/ __| |/ /
  % | |___| | | |  __/ (__|   < 
  %  \____|_| |_|\___|\___|_|\_\
  %
  if ~ ( isreal(pnts) && ismatrix(pnts) && size(pnts,1) == 3 )
    error('expected a matrix 3 by N as first argument ');
  end
  if iscell(conn)
    for k=1:length(conn)
      ele = conn{k} ;
      if ~ ( isreal(ele) && isvector(ele) && length(ele) >= 3 )
        error('cell array elements must be vector of size >= 3 for second argument');
      end
      conn{k} = fix(ele) ;
    end
  else
    error('expected a cell array as second argument');
  end
  if ~ ( isreal(line1) && (isvector(line1) || (ismatrix(line1) && length(line1)==0)) )
    error('expected a vector as third argument');
  else
    line1 = fix(line1) ;
  end
  if ~ ( isreal(line2) && (isvector(line2) || (ismatrix(line2) && length(line2)==0)) )
    error('expected a vector as fourth argument');
  else
    line2 = fix(line2) ;
  end
  
  l1color = 'black' ;
  l2color = 'blue' ;
  fcolor  = [255, 255, 157]/255 ;
  ecolor  = [0, 128, 0]/255 ;

  %  ____                                   _   _                 
  % |  _ \ __ _ _ __ ___  ___    ___  _ __ | |_(_) ___  _ __  ___ 
  % | |_) / _` | '__/ __|/ _ \  / _ \| '_ \| __| |/ _ \| '_ \/ __|
  % |  __/ (_| | |  \__ \  __/ | (_) | |_) | |_| | (_) | | | \__ \
  % |_|   \__,_|_|  |___/\___|  \___/| .__/ \__|_|\___/|_| |_|___/
  %                                  |_|                          
  nopt = 0 ;
  OPTS = {} ;
  i    = 1 ;
  while i <= nargin-4
    arg = varargin{i} ; i = i + 1;
    if ~ischar(arg) % arg is NOT an option name
      error('plot_tube: expected string option as %d argument\n',i+2) ;
    end
    arg = upper(arg) ;
    if i > nargin-2
      error('plot_tube: expect one more argument\n') ;
    end
    arg1 = varargin{i} ; i = i + 1;
    if strcmpi('FaceColor',arg)
      if ~ ( (isreal(arg1) && isvector(arg1) && length(arg1) == 3) || isstring(arg1) )
        error('option FaceColor: Color value must be a 3 element numeric vector or a string') ;
      end
      fcolor = arg1 ;
    elseif strcmpi('EdgeColor',arg)
      if ~ ( (isreal(arg1) && isvector(arg1) && length(arg1) == 3 ) || isstring(arg1) )
        error('option EdgeColor: Color value must be a 3 element numeric vector or a string') ;
      end
      ecolor = arg1 ;
    elseif strcmpi('Line1Color',arg)
      if ~ ( (isreal(arg1) && isvector(arg1) && length(arg1) == 3 ) || isstring(arg1) )
        error('option Line1Color: Color value must be a 3 element numeric vector or a string') ;
      end
      l1color = arg1 ;
    elseif strcmpi('Line2Color',arg)
      if ~ ( (isreal(arg1) && isvector(arg1) && length(arg1) == 3 ) || isstring(arg1) )
        error('option Line2Color: Color value must be a 3 element numeric vector or a string') ;
      end
      l2color = arg1 ;
    else
      nopt = nopt+1 ; OPTS{nopt} = arg ;
      nopt = nopt+1 ; OPTS{nopt} = arg1 ;
    end
  end
  
  if length(line1) > 0
    X = pnts(1,line1) ; Y = pnts(2,line1) ; Z = pnts(3,line1) ;
    plot3( X, Y, Z, '-', 'LineWidth', 2, 'Color', l1color ) ;
    hold on
  end
  if length(line2) > 0
    X = pnts(1,line2) ; Y = pnts(2,line2) ; Z = pnts(3,line2) ;
    plot3( X, Y, Z, '-', 'LineWidth', 2, 'Color', l2color ) ;  
    hold on
  end
  for k=1:length(conn)
    patch('Faces',     conn{k}, ...
          'Vertices',  pnts', ...
          'FaceAlpha', 1, ...
          'FaceColor', fcolor, ...
          'EdgeColor', ecolor ) ;
  end
  axis equal
end
