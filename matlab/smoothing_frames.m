%=============================================================================%
%  smoothing frames:  Given a sequence of frames return a sequence of frames  %
%                     which are "smoothed".                                   %
%                     Smoothing is obtained by minimizing the angles of the   %
%                     projection of a frames to the next frame in the         %
%                     sequence                                                %  
%                                                                             %
%  USAGE: [newN,newB,nstep] = smoothing frames(T,N,B,ndivangle) ;             %
%                                                                             %
%  On input:                                                                  %
%                                                                             %
%       T         = matrix 3 by N of the tangents of the frames               %
%       N         = matrix 3 by N of the normals of the frames                %
%       B         = matrix 3 by N of the binormals of the frames              %
%       ndivangle = projection of the last smoothed frame to the first frame  %
%                   must be an angle which is a multiple of 2*pi/ndivangle    %
%                                                                             %
%                                                                             %
%  On output:                                                                 %
%                                                                             %
%       smoothN   = matrix 3 by N of the normals of the smoothed frames       %
%       smoothB   = matrix 3 by N of the binormals of the smoothed frames     %
%       nstep     = projection of the last smoothed frame to the first frame  %
%                   must if the angle nstep*(2*pi/ndivangle) where nstep is   %
%                   an integer                                                %
%                                                                             %
%=============================================================================%
%                                                                             %
%  Autor: Enrico Bertolazzi                                                   %
%         Department of Industrial Engineering                                %
%         University of Trento                                                %
%         enrico.bertolazzi@unitn.it                                          %
%                                                                             %
%=============================================================================%
function [smoothN,smoothB,nstep] = smooth_frame(T,N,B,ndivangle)

  [theta,nstep] = smoothing_frame_by_projection(T,N,B,ndivangle) ;

  m            = size(N,2) ;
  smoothN      = zeros(3,m);
  smoothN(1,:) = N(1,:).*cos(theta) + B(1,:).*sin(theta) ;
  smoothN(2,:) = N(2,:).*cos(theta) + B(2,:).*sin(theta) ;
  smoothN(3,:) = N(3,:).*cos(theta) + B(3,:).*sin(theta) ;

  smoothB      = zeros(3,m);
  smoothB(1,:) = N(1,:).*cos(theta+pi/2) + B(1,:).*sin(theta+pi/2) ;
  smoothB(2,:) = N(2,:).*cos(theta+pi/2) + B(2,:).*sin(theta+pi/2) ;
  smoothB(3,:) = N(3,:).*cos(theta+pi/2) + B(3,:).*sin(theta+pi/2) ;

end
%
%
%
function [theta,nstep] = smoothing_frame_by_projection(T,N,B,ndivangle)
  m     = size(N,2) ;
  theta = zeros(1,m) ;
  % opt   = optimset( 'Display', 'off', 'TolX', 1e-5 ) ;

  %%%
  for k=1:m-1
    T1 = T(:,k) ;
    T2 = T(:,k+1) ;
    % rotate frame (T1,N1) by the previous computed angle theta(k)
    N1 = N(:,k).*cos(theta(k)) + B(:,k).*sin(theta(k)) ;
    th_min    = 0 ;
    min_angle = 1e6 ;
    % compute rotation of frame (T2,N2) in such a way the angle between
    % two consecutive frames is minimized
    FUN = @(th) abs(frame_angle( T1, N1, T2, N(:,k+1).*cos(th) + B(:,k+1).*sin(th) )) ;
    %[theta(k+1),val] = fminbnd( FUN, theta(k)-pi, theta(k)+pi ) ;
    theta(k+1) = fminsearch( FUN, theta(k)) ;
  end

  dangle = 2*pi/ndivangle ; % quantized angle for final frame

  %%% find angle dangle*nstep more close to theta(end)
  nstep  = round( theta(end)/dangle ) ;
  dth    = nstep*dangle - theta(end) ;
  
  %%% move rotation angles to match final angle = nstep*dangle 
  theta = theta+[0:m-1]*(dth/(m-1)) ;

end
%
% compute the angle between the frame (T1,N1) projected to the frame (T2,N2)
%
function angle = frame_angle( T1, N1, T2, N2 )
  % Rotate frame (T1,N1) in such a way rotated(T1) = T2

  V = cross( T1, T2 ) ;
  S = norm( V, 2 ) ;
  C = dot( T1, T2 ) ;

  Vmat = [    0   -V(3)   V(2) ; ...
            V(3)     0   -V(1) ; ...
           -V(2)   V(1)     0 ] ;

  % rotation matrix
  R = eye(3) + Vmat + Vmat^2*(1-C)/S^2 ;

  % rotate first frame
  T1 = R*T1 ;
  N1 = R*N1 ;

  % compute rotation along T2 suche that rotated(N1) = N2
  V = cross( N1, N2 ) ;
  S = dot( V,  T1 ) ;
  C = dot( N1, N2 ) ;

  % return the angle in the range [-pi,pi]
  angle = atan2( S, C ) ;

end
