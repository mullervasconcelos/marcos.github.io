% The purpose of this script is to randomly generate and solve an i.i.d. with 
% equal weightsinstance of a remote estimation problem with Aggregate 
% Probability of Estimation Error in the paper "Optimal remote estimation 
% of discrete random variables over the collision channel", by Marcos M. 
% Vasconcelos and Nuno C. Martins. 

clear all

clc

tic

% Number of sensors in the remote estimation system
N=8

Q = zeros(N,3);

q1 = rand;

if q1 <= 0.5 
    q2 = q1*rand;
else
    q2 = (1-q1)*rand;
end

for i=1:N

t = 1-q1-q2;

Q(i,1) = q1;

Q(i,2) = q2;

Q(i,3) = t;

end

Q

ETA = ones(N,1);

ETA = ETA/sum(ETA);

ETA


Jopt=inf;


for k=1:3^N
    
    U = zeros(N,1);
    
    U_char = dec2base(k-1,3,N);
    
    P = 1;
    
    for j=1:N
    
        U(j) = str2num(U_char(j));
        
        if U(j) == 0
            
            P = P*1;
            
        elseif U(j) == 1
            
            P = P*Q(j,1);
            
        elseif U(j) == 2
            
            P = P*(1-Q(j,2));
            
        end
        
    end
    
    
    P_error = zeros(N,1);
    
    for k=1:N
        
        if U(k) == 0
            
            P_error(k) = 1-Q(k,1);
            
        elseif U(k) == 1
            
            P_error(k) = Q(k,3)*(1-P/Q(k,1));
            
        elseif U(k) == 2
            
            P_error(k) = Q(k,3);
    
        end
        
    end
    
    J = ETA'*P_error;
    
    if J<=Jopt
        
        Jopt = J;
        
        Uopt = U;
        
    end
    
    
end
    
Jopt
Uopt
    
toc

length(find(Uopt==1))

% Close form solution predicted by Theorem 5
min(floor(q1/(1-q1-q2))+1,N)