function  [qtmesh,ntri,nrec] = fncombinegrd( p0, e0, t0, maxang ) 
% Combine triangular grid
% given p, e, t

if ( nargin == 3 ) 
    MaxAngAllow = 7*pi/9 ;
else
    MaxAngAllow = maxang ;
end

[ir,ic] = size(t0) ; 
if ( ir <= 4 ) 
    p = p0' ;
    e = e0' ;
    t = t0' ;
else
    p = p0 ;
    e = e0 ;
    t = t0 ; 
end

% connection
[EToE,EToF] = Connect2D( t(:,1:3) ) ;
Nel = length(EToE) ;

for i = 1: Nel
    % Find length
    for l = 1: 3
        v = [mod(l,3) mod(l+1,3)] ;

        ii = find(v == 0) ;
        v(ii) = 3  ;

        x = [p(t(i,v),:)] ;

        elen(i,l) = sqrt((x(2,1)  - x(1,1))^2 + (x(2,2)- x(1,2))^2) ;
    end

    % Find angle
    d = elen(i,:) ;
    ang(i,1) = acos(-(d(2)^2 - d(1)^2 - d(3)^2)/(2*d(1)*d(3))) ;
    ang(i,2) = acos(-(d(3)^2 - d(1)^2 - d(2)^2)/(2*d(1)*d(2))) ;
    ang(i,3) = acos(-(d(1)^2 - d(2)^2 - d(3)^2)/(2*d(2)*d(3))) ;
end

tbang = [1 2
    2 3
    3 1] ;

c = 0 ;
opflag = zeros(Nel,1) ;
for i = 1: Nel
    if ( opflag(i) == 0 )
        cp = 0 ;
        for inb = 1: 3
            idEl = EToE(i,inb) ;

           
            if ( idEl ~= i & opflag(idEl) == 0)
                idc = inb ; % current
                idn = EToF(i,inb) ;  % neighbor

                idac = tbang(idc,:) ;
                idan = tbang(idn,:) ;

                an1 = ang(i,idac) ;
                an2 = ang(idEl,idan) ;

                aqq1 = an1(1) + an2(2) ;
                aqq2 = an1(2) + an2(1) ;

%----------------------------------------, detect error
%                 if ( i == 55 )
%                     
%                     idn
%                     idEl
%                     idac
%                     idan
%                     an1
%                     an2
%                     aqq1
%                     aqq2
%                     
%                     break ;
%                 end
%---------------------------------------

                if ( aqq1 < MaxAngAllow & aqq2 < MaxAngAllow )
                    cp = cp + 1 ;
                    aq(cp,1:2) = [aqq1 aqq2] ;

                    
                    rectemp(cp,1:2) = [i idEl] ;
                end
            end
        end
            
        if ( cp > 0 )
            if ( cp == 1 )
                c = c + 1 ;
                recel(c,1:2) = rectemp(1,1:2) ;
                opflag(i) = 1 ;
                opflag(rectemp(1,2)) = 1 ;
            else
                agerr(1:cp) = 0.0 ;
                for q = 1: cp
                    agerr(q) = sqrt((aq(q,1)  - (pi/2))^2 + (aq(q,2) - (pi/2))^2) ;
                end
                [val,idp] = min(agerr(1:cp)) ;
                c = c + 1 ;
                recel(c,1:2) = rectemp(idp,1:2) ;
                opflag(i) = 1 ;
                opflag(rectemp(idp,2)) = 1 ;
            end
        end

%---------------------------------
%        if ( i == 50 )
%            cp
%            rectemp
%            recel(c,:)
%            opflag(i)
%        end
%---------------------------------
    end
end

% Collect the element
triel = find( opflag == 0 ) ;
ntri = length( triel ) ; 
nrec = length( recel(:,1) ) ;

% Collect triangular element 
for i = 1: ntri
    qtmesh(i).con = t( triel(i), 1:3 ) ; 
end

% Collect 
vbb = [3 
       1
       2] ;
tbb = [2 3 1
       3 1 2
       1 2 3] ;
cp = ntri ; 
for i = 1: nrec
    cp = cp + 1 ;
    idx1 = recel(i,1) ;
    idx2 = recel(i,2) ;  
    
    iface1 = find( EToE(idx1,:) == idx2 )  ;
    iface2 = EToF(idx1,iface1) ;
    
    vtri = t(idx1,tbb(iface1,:)) ;
    vadd = t(idx2,vbb(iface2)) ;
    
    qtmesh(cp).con = [vtri vadd] ;
end
   
% p1 = 2*(p0 + 0.5) - 1 ;
%
% subplot(2,1,1) ;
% pdemesh(p1,e0,t0) ;
% axis image ; 
%
% max(max(p))
% min(min(p)) 

figure ; hold ; 
for i = 1: length(qtmesh)
    ll = length(qtmesh(i).con) ;
    for l = 1: ll
        sl = [mod(l,ll) mod(l+1,ll)] ;
        
        ii = find(sl == 0) ; 
        sl(ii) = ll ; 
        
        v1 = qtmesh(i).con(sl(1))  ;
        v2 = qtmesh(i).con(sl(2))  ;
        
        x1 = [p(v1,1) p(v2,1)] ; 
        x2 = [p(v1,2) p(v2,2)] ; 
        
        plot( x1, x2, 'k' ) ; 
    end
end
set(gca, 'FontName', 'Times', 'FontSize', 14 ) ; 
xlabel('x') ; 
ylabel('y') ; 

figure ; hold ; 
for i = 1: length(t)
    for l = 1: 3
        sl = [mod(l,3) mod(l+1,3)] ;
        
        ii = find(sl == 0) ; 
        sl(ii) = 3 ; 
        
        v1 = t(i,sl(1))  ;
        v2 = t(i,sl(2))  ;
        
        x1 = [p(v1,1) p(v2,1)] ; 
        x2 = [p(v1,2) p(v2,2)] ; 
        
        plot( x1, x2, 'k' ) ; 
    end
end
set(gca, 'FontName', 'Times', 'FontSize', 14 ) ; 
xlabel('x') ; 
ylabel('y') ; 


