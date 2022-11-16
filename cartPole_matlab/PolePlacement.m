function K = PolePlacement(A,B,P)
%%% pole placement method 
%%% ref "Robust Pole Assignment in Linear State Feedback"
%%% 2011.10.16
%%% author Kubota kanade
%%% brief return K such that eig of (A-BK) equals to P

%%% A is a n*n matrix. B is a n*m matrix. x is n vector. G is a n*m matrix 
%%% which is coincide to -K'. 
%%% P is a eigenvalues vector. Whether vertical or frontal doesn't matter.

%  author : Kubota kanade

message = '';
prec = 15;

% Number of iterations for optimization
NTRY = 5;

[nA,mA] = size(A);
[nB,mB] = size(B);
P = P(:);
%{
if mA~=nA,
   error('A matrix must be square.')
elseif nA~=nB,
   error('B matrix must have as many rows as A.')
elseif length(P)~=nA,
   error('P must have the same number of states as A.')
elseif nA==0,
   K = [];
   return
end
%}

if(mB==1)
    sys = ss2sys(A,B,eye(nB),[]);
    K = place(sys, P);
    return ;
end;


% Check for a complex plant
if ~isreal(A)|~isreal(B)
   cmplx_sys = 1;
elseif ~isequal(sort(P(imag(P)>0)),sort(conj(P(imag(P)<0))))
   cmplx_sys = 1;
   warning('Desired poles are not given as complex conjugate pairs, complex controller gains required.')
else
   cmplx_sys = 0;
end

% Compute a reduced order B 
[Bu,Bs,Bv] = svd(B);
ns = min(mB,nB);
svB = diag(Bs(1:ns,1:ns));
mB = sum(svB > 100*eps*svB(1));

if mB==0
   error('Rank of B is zero')
end

% Compute sorted eigenvalue vector 
if cmplx_sys
   n_ccj=0;
else
   Pc = P(imag(P)>0);
   n_ccj = length(Pc);
   P = [P(~imag(P)) ; Pc ; conj(Pc)];
end

% Make sure there are more inputs than repeated poles:
ps = sort(P);
for i=1:nB-mB
   imax = min(nB,i+mB);
   if all(ps(i:imax) == ps(i))
      error('Can''t place poles with multiplicity greater than rank(B).')
   end
end

if (mB==nB),
   % Special case: (#inputs)==(#states) - efficient, but not clean
   if cmplx_sys
      As = A - diag(P);
   else
      Pcomp = zeros(2*length(Pc),1);
      Pcomp(1:2:end) = Pc;
      Pcomp(2:2:end) = conj(Pc);
      P = [Pcomp; P(~imag(P))]; 
      As = A - diag(real(P));
      for ct = 1 : 2 : 2*n_ccj            
         As(ct,ct+1) = As(ct,ct+1) + imag(P(ct));
         As(ct+1,ct) = As(ct+1,ct) - imag(P(ct));
      end 
   end
   
   K = diag(1./svB(1:mB))*Bu(:,1:mB)'*As;
   
else
   % Compute subspace Sr = {x: U1'x=0, U1'Ax = 0} (included in all S(P) subspaces)
   U1 = Bu(:,mB+1:nB);
   if n_ccj>0  % real data with complex poles
      [T,Gamma,Sr] = svd([U1' ; U1'*A]);
      nsv = min(nB,2*(nB-mB));
      r = sum(diag(Gamma(1:nsv,1:nsv)) > 100*eps*Gamma(1,1));
      Sr = Sr(:,r+1:nB);
   end
   
   % Compute assignable subspaces Sj = null(U1'*(A-pj*I)) for target eigenvalues
   I = eye(nB);
   S = cell(1,nB-n_ccj);
   for i=1:nB-n_ccj,
      if n_ccj>0 && imag(P(i))~=0
         % Compute the subspace of Sj orthogonal to Sr
         [T,Gamma,Sj] = svd([U1'*(P(i)*I-A) ; Sr']);
         nsv = min(nB,nB-mB+size(Sr,2));
         r = sum(diag(Gamma(1:nsv,1:nsv)) > 100*eps*Gamma(1,1));
         S{i} =  [Sj(:,r+1:nB) , Sr];
      else
         % Compute the subspace of Sj orthogonal to Sr
         [T,Gamma,Sj] = svd(U1'*(P(i)*I-A));
         nsv = nB-mB;
         r = sum(diag(Gamma(1:nsv,1:nsv)) > 100*eps*Gamma(1,1));
         S{i} =  Sj(:,r+1:nB);
      end
   end    
   
   % Choose basis set
   cnt = 1;
   for i=1:nB-n_ccj,
      if cnt > size(S{i},2), cnt = 1; end % Randomize e-vector selection
      X(:,i) = S{i}(:,1);  
      cnt = cnt + 1;
   end 
   X(:,nB-n_ccj+1:nB) = conj(X(:,nB-2*n_ccj+1:nB-n_ccj));
   
   % Orthogonalize e-vector matrix X
   if (mB>1),
      [Q,R] = qr(X);
      for k = 1:NTRY,           
         for j = 1:(nB-n_ccj),         % nB-n_ccj = # e-vals - # number of complex conj e-val pairs
            [Q,R] = qrdelete(Q,R,j);
            Yj = S{j}'*Q(:,nB);
            nu = norm(Yj);
            if nu>sqrt(eps)
               Yj = S{j}*Yj / nu;
               if n_ccj>0 && imag(P(j))~=0 && abs(Yj'*conj(Yj))>0.9
                  % If the projection Yj is close to Sr, it is nearly real 
                  % and (Yj,conj(Yj)) is nearly rank one. Add contribution 
                  % from orthogonal complement of Sr in Sj
                  idx = 1 + rem(k,size(S{j},2)-size(Sr,2));
                  Yj = (Yj + S{j}(:,idx))/sqrt(2);
               end
               X(:,j) = Yj;
            end
            [Q,R] = qrinsert(Q,R,j,X(:,j));
            
            % Need to enforce conjugacy of eigenmatrix in order to get a real K for real problems
            if j > nB-2*n_ccj         % If j is a e-val with a complex conjugate compute Xj+n_ccj
               [Q,R] = qrdelete(Q,R,j+n_ccj);
               X(:,j+n_ccj) = conj(X(:,j));
               [Q,R] = qrinsert(Q,R,j+n_ccj,X(:,j+n_ccj));
            end              
         end
      end
   end
   
   cnd = cond(X);
   if (cnd*eps >= 1.0),
      error('Can''t place eigenvalues there.')
   end
   
   % Compute feedback
   % If the system is not complex remove any complex terms from the computation
   % of Xf*diag(P,0)*Xf.
   if cmplx_sys
      K = diag(1./svB(1:mB))*Bu(:,1:mB)'*(A-X*diag(P,0)/X);
   else       
      K = diag(1./svB(1:mB))*Bu(:,1:mB)'*(A-real(X*diag(P,0)/X));
   end
   
end
K = Bv(:,1:mB) * K;

% Since sort orders by magnitude and doesn't care about the order 
% of complex conjugate pairs, explicitly check using the cmpeig local function instead
% Check results. Start by removing 0.0 pole locations.
cl = A-B*K;
Pc = eig(cl);
Pc = localcmpeig(P,Pc);
nz = find(P ~= 0);
P = P(nz);Pc = Pc(nz);

%{
if max(abs(P-Pc)./abs(P)+1e3*eps*norm(cl,1)) > .1
   message = 'Warning: Pole locations are more than 10% in error.';
   if nargout<3,
      disp(message)
   end
end
%}

% If the system is not complex check to see if the resulting K is real.
if ~cmplx_sys
   if ~isreal(K)
      disp('Warning: Plant is real and K is complex')
   end
end

% end place


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Local Function 
%
%   Pc_sorted = localcmpeig(P, Pc);
%
%   Sorts the vector Pc to be in the order of P.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Pc_sorted = localcmpeig(P, Pc);

nB = length(P);
Pc_sorted = zeros(size(P));

for i = 1:length(P)
   [diff, j] = min(abs(P(i,1) - Pc(:,1)));
   Pc_sorted(i,1) = Pc(j,1);Pc(j)=[];
end
