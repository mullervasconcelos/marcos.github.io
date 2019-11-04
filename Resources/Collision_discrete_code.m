% The purpose of this script is to randomly generate and solve an instance of
% a remote estimation problem with Aggregate Probability of Estimation
% Error in the paper "Optimal remote estimation of discrete random
% variables over the collision channel", by Marcos M. Vasconcelos and Nuno
% C. Martins. The total time to find an optimal solution is given at the
% end of the procedure.

clear all

clc

tic

% Input the number of sensors in the remote sensing system
N=4

Q = zeros(N,3);

for i=1:N

q1 = rand;

if q1 <= 0.5 
    q2 = q1*rand;
else
    q2 = (1-q1)*rand;
end

t = 1-q1-q2;

Q(i,1) = q1;

Q(i,2) = q2;

Q(i,3) = t;

end

% Matrix with [q_{X_i}(1) q_{X_i}(2) t_{X_i}]
Q

ETA = zeros(N,1);

for i = 1:N
    
    ETA(i) = rand;
        
end

ETA = ETA/sum(ETA);

% Weight vector
ETA

Jopt=inf;

% Exhaustive search
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