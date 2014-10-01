%=============================================================================%
%  generate_tube frames:  Given a 3D curve (x,y,z) build a tube as a mesh of  %  
%                         polygons (mainly triangles of quadrilateral)        %
%                                                                             %
%                                                                             %
%  USAGE: [pnts,conn,line1,line2] = generate_closed_tube(typ,R,nr,xyz) ;      %
%         [pnts,conn,line1,line2] = generate_closed_tube(typ,R,nr,x,y,z) ;    %
%                                                                             %
%  On input:                                                                  %
%                                                                             %
%       x,y,z     = vectors with N components coordinates of the 3D curves    %
%       xyz       = matrix 3 by N, N points on the 3D curve                   %
%       nr        = number or radial subdivision of the tube                  %
%       R         = Ray of the generated tube                                 %
%       typ       = type of generated mesh                                    %
%                   0 - quadrilateral mesh                                    %
%                   1 - triangular mesh (by split quadrilateral mode 1)       %
%                   2 - triangular mesh (by split quadrilateral mode 2)       %
%                   3 - triangular mesh (alternate mode 1 and mode 2)         %
%                   4 - triangular mesh (alternate mode 2 and mode 1)         %
%                                                                             %
%                          b --- d           b --- d                          %
%                   mode 1 |  /  |    mode 2 |  \  |                          %
%                          a --- c           a --- c                          %
%                                                                             %
%  On output:                                                                 %
%                                                                             %
%       pnts      = matrix 3 by Npoints of the points generated               %
%       conn      = cell array with the face connection                       %
%       line1     = integer vector with index of points connecting a radial   %
%                   curve near the initial point                              %
%       line2     = integer vector with index of points connecting a          %
%                   longitudinal curve passing near to the initial point      %    
%                                                                             %
%=============================================================================%
%                                                                             %
%  Autor: Enrico Bertolazzi                                                   %
%         Department of Industrial Engineering                                %
%         University of Trento                                                %
%         enrico.bertolazzi@unitn.it                                          %
%                                                                             %
%=============================================================================%
function [pnts,conn,line1,line2] = generate_closed_tube(typ,R,nr,varargin)

  narginchk(4,7) ;
  
  % check input
  if ~ (isreal(typ) && isscalar(typ) && typ >=0 && typ <= 4 )
    error('expected as first argument a scalar in the range [0,4]');
  else
    typ = fix(typ) ;
  end
  if ~ (isfloat(R) && isscalar(R) && R > 0 )
    error('expected as second argument a scalar greater than 0');
  end
  if ~ (isreal(nr) && isscalar(nr) && nr >= 3 )
    error('expected as third argument a scalar integer >= 3');
  else
    nr = fix(nr) ;
  end
  
  reverse = false ;
  if nargin == 4 || nargin == 5
    xyz = varargin{1};
    % check data
    if ~isfloat(xyz) || ~ismatrix(xyz) || size(xyz,1) ~= 3
      error('expected as fourth argument a matrix 3 by N');
    end
    % --> to column vector
    x = xyz(1,:).';
    y = xyz(2,:).';
    z = xyz(3,:).';
    if nargin == 5
      reverse = varargin{2} ;
    end
  elseif nargin == 6 || nargin == 7
    x = varargin{1}(:);
    y = varargin{2}(:);
    z = varargin{3}(:);
    % check data
    if ~isfloat(x) || ~isvector(x) || ~isfloat(y) || ~isvector(y) || ~isfloat(z) || ~isvector(z)
      error('expected real vector as argument N. 3,4, and 5 ');
    end
    % --> to column vector
    if nargin == 7
      reverse = varargin{4} ;
    end
  else
    error('expected less than 8 arguments');
  end
  
  nt = length(x) ;
  
  % --> speed
  dx = diff(x);
  dy = diff(y);
  dz = diff(z);
  
  dx = [1.5*dx(1)-0.5*dx(2);(dx(1:end-1)+dx(2:end))/2;1.5*dx(end)-0.5*dx(end-1)] ;
  dy = [1.5*dy(1)-0.5*dy(2);(dy(1:end-1)+dy(2:end))/2;1.5*dy(end)-0.5*dy(end-1)] ;
  dz = [1.5*dz(1)-0.5*dz(2);(dz(1:end-1)+dz(2:end))/2;1.5*dz(end)-0.5*dz(end-1)] ;  
  
  % TANGENT
  lens   = sqrt(dx.^2+dy.^2+dz.^2) ;
  T      = zeros(3,nt) ;
  T(1,:) = dx ./ lens ;
  T(2,:) = dy ./ lens ;
  T(3,:) = dz ./ lens ;
  
  % DERIVATIVE OF TANGENT
  dTx = diff(T(1,:)).';
  dTy = diff(T(2,:)).';
  dTz = diff(T(3,:)).';
  
  dTx = [1.5*dTx(1)-0.5*dTx(2);(dTx(1:end-1)+dTx(2:end))/2;1.5*dTx(end)-0.5*dTx(end-1)] ;
  dTy = [1.5*dTy(1)-0.5*dTy(2);(dTy(1:end-1)+dTy(2:end))/2;1.5*dTy(end)-0.5*dTy(end-1)] ;
  dTz = [1.5*dTz(1)-0.5*dTz(2);(dTz(1:end-1)+dTz(2:end))/2;1.5*dTz(end)-0.5*dTz(end-1)] ;  
  
  % NORMAL
  lens   = sqrt(dTx.^2+dTy.^2+dTz.^2) ;
  N      = zeros(3,nt) ;
  N(1,:) = dTx ./ lens ;
  N(2,:) = dTy ./ lens ;
  N(3,:) = dTz ./ lens ;
  
  % BINORMAL
  B = cross(T,N);
  
  % ciclic clousure
  TT = T(:,1)+T(:,end) ;
  TT = TT./norm(TT) ;
  NN = N(:,1)+N(:,end) ;
  NN = NN./norm(NN) ;
  
  BB = cross(TT,NN);
  
  T(:,1)   = TT ;
  T(:,end) = TT ;
  N(:,1)   = NN ;
  N(:,end) = NN ;
  B(:,1)   = BB ;
  B(:,end) = BB ;
  
  [N,B,nstep] = smoothing_frames(T,N,B,nr) ;
  
  %
  % list of points
  %
  pnts = zeros(3,(nt-1)*nr) ;
  tt = 2*pi*linspace(0,1,nr+1) ;
  ss = R*cos(tt+pi/4) ;
  rr = R*sin(tt+pi/4) ;
  kk = 0 ;
  for i=1:nt-1
    P = [x(i);y(i);z(i)] ;
    n = N(:,i) ;
    b = B(:,i) ;
    for k=1:nr
      kk = kk+1 ;
      pnts(:,kk) = P+ss(k)*b+rr(k)*n ;
    end
  end
  %
  conn  = generate_conn(typ,nr,nt,nstep) ;
  line1 = [ 1:nr:nr*(nt-1) mod(nr-nstep,nr)+1 ] ;
  line2 = [ 1:1:nr 1] ;

  if reverse
    for k=1:length(conn)
      conn{k}=conn{k}(end:-1:1);
    end
  end
end
%
%
%
function conn = generate_conn(typ,nr,nt,nstep)
  kk   = 0 ;
  ttyp = typ ;
  if typ > 3
    ttyp1 = 2 ;
    ttyp2 = 1 ;
    conn  = cell(2*nr*(nt-1),1) ;
  else
    ttyp1 = 1 ;
    ttyp2 = 2 ;
    conn  = cell(nr*(nt-1),1) ;
  end
  for i=1:nt-1
    bb = (i-1)*nr ;
    ii = (i-1)*nr+[1:nr 1] ;
    if i == nt-1
      jj = [mod(nr-nstep,nr)+1:nr 1:nr ] ;
    else
      jj = ii+nr ;
    end
    for k=1:nr
      ia = ii(k)   ;
      ic = ii(k+1) ;
      ib = jj(k)   ;
      id = jj(k+1) ;
      if typ > 2
        if mod(i+k,2) == 0
          ttyp = ttyp1 ;
        else
          ttyp = ttyp2 ;
        end
      end
  
      switch ttyp
      case 0
        kk = kk+1 ;
        % b --- d
        % |     |
        % a --- c
        conn{kk} = [ia,ic,id,ib] ;
      case 1
        % b --- d
        % |  /  |
        % a --- c
        conn{kk+1} = [ia,id,ic] ;
        conn{kk+2} = [ia,ib,id] ;
        kk = kk+2 ;
      case 2
        % b --- d
        % |  \  |
        % a --- c
        conn{kk+1} = [ia,ib,ic] ;
        conn{kk+2} = [ib,id,ic] ;
        kk = kk+2 ;
      end
    end
  end
end
