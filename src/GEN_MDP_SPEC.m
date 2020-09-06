
function MDP = GEN_MDP_SPEC(lesion)
% ===========================================================================
% This function specifies the generative model (and process) for a simple
% speech repetition task.          
% ===========================================================================   

%Action selection precision:
alpha = 4;

% Precision (distribution)parameters:
z = 0.9;
w = 1;

% Preference log ratio:
c=  1/2;

t = 3; % number of epochs

% MODEL: 
% P(s)
D{1} = [10 10 10 10]';          % Content: what I said?:  {'red''square' 'triangle', 'blue'} 
D{2} = [10 10 10 10]';          % Target: what is the true context?:   { 'red' 'square' 'triangle', 'blue'} 
D{3} = [128 0 0]';                  % Time: {1, 2, 3}

% Preliminaries
e = 0;
Nf = numel(D); 
for f = 1:Nf
    Ns(f) = numel(D{f}); 
end
for f = 1:Nf
      B{f} = e*ones(Ns(f));
end
No = [2 3 4];       % Outcome modalities; 
                             % Proprioceptive: {'Other', 'Me'}; 
                             % Critic: {'Right', 'Wrong', 'Nothing'} 
                             % Auditory:   { 'red' 'square' 'triangle', 'blue'} 
Ng = numel(No); 
for g = 1:Ng
    A{g} = ones([No(g),Ns])*e; 
end

% P(o|s) ~ Cat(A)
for f1 = 1:Ns(1) 
    for f2 = 1:Ns(2)  
        for f3 = 1:Ns(3)  
             
                       if f3 == 1 
                            A{1}(1,:,:,f3) = 1;
                       else
                            A{1}(2,:,:,f3) = 1;
                       end 
                       
                        if f3 == 1 || f3 == 2 
                            A{2}(3,:,:,f3) = 1;
                        elseif (f2) == f1 
                            A{2}(1,f1,f2,3) = 1;
                        elseif (f2 ~= f1)
                            A{2}(2,f1,f2,3) = 1;                       
                        end   
                        
                        if f3 == 1 
                            A{3}(:,f1, :,f3) = [ones(4,4)*e+eye(4,4)];                   
                        else
                            A{3}(:,1:end,f2,f3) =[ones(4,4)*e+eye(4,4)];
                        end                             
        end
    end
end
              
% P(A|a) ~ Dir(a)
for g = 1:Ng
        a{g} = A{g}*10;
end

% Lesion to Dir(a_2):
if strcmp(lesion,'one')|| strcmp(lesion,'two') || strcmp(lesion,'three')
    for f1 = 1:Ns(1) 
        for f2 = 1:Ns(2)  
            for f3 = 1:Ns(3)                         
                  a{2}(:,:,f2,f3) =  spm_softmax(z*log(A{2}(:,:,f2,f3)+0.1));      
            end
        end
    end
end
   
% P(S_t| S_t-1, u) ~ Cat(B)
 for i = 1:4
    B{1}(i,:,i) = 1;
 end 
B{2} = eye(4);
B{3} = circshift(eye(3),1);
B{3}(:,3) = circshift(B{3}(:,3),2); 

% P(B|b) ~ Dir(b)
for f = 1:Nf
    b{f} = 10*B{f};
end

% Lesion to dir(B)
if  strcmp(lesion,'two')
    b{2} = spm_softmax(w*log(eye(4)+.01));
elseif  strcmp(lesion,'three')
    b{2} = spm_softmax(0.8*log(eye(4)+0.1));
end 

% P(o)
for g = 1:Ng
    C{g}  = zeros(No(g),t);
end
C{2}(1,:) =  c;  % does want to be right
C{2}(2,:) = -c; % does not want to be wrong


% P(pi|u) ~ V
V(:,:,1) =     [1 2 3 4; 
                    1 2 3 4];
V(:,:,2) = 1;
V(:,:,3) = 1;

% Defining model: 
mdp.alpha = alpha;   
mdp.T = t;                      % Time step
mdp.a = a;                     
mdp.A = A;                   
mdp.b = b;                      
mdp.B = B;                      
mdp.C = C;                      
mdp.D = D;                      
 mdp.V = V;    

% Labels:
mdp.Bname = {'Content', 'Context','Time'};
mdp.Aname = {'Proprioceptive', 'Feedback', 'Auditory'};
mdp.label.modality = {'Proprioceptive', 'Feedback', 'Auditory'};
mdp.label.name{1} = {'red' 'square' 'triangle', 'blue'} ;
mdp.label.name{2} = { 'red' 'square' 'triangle', 'blue'} ;
mdp.label.name{3} = { '1' '2' '3',} ;
mdp.label.outcome{1} = {'Other', 'Me'};
mdp.label.outcome{2} = {'Right', 'Wrong', 'None'};
mdp.label.outcome{3} =   { 'red' 'square' 'triangle', 'blue'} ;

% Checking model:
MDP  = spm_MDP_check(mdp);

%spm_MDP_factor_graph(mdp);
return 
