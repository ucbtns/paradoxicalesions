
function  simulations(path, tr, sl, all)

    n = 1;
    total = 4;
    runs  = 50;
    
    if all == 1
        % Control:
        mdp = GEN_MDP_SPEC('none');
        models = cell(runs,1);
        x = zeros(tr,runs);

        for i = 1:runs 
            rng(i)
            [MDP(1:tr)] = deal(mdp);      
            M = spm_MDP_VB_X(MDP);
            x(:,i) = score(M,tr);
            models{i} = M;
            clear M MDP
        end
        save(strcat(path, 'control_model.mat'), 'models');
        save(strcat(path, 'control_score.mat'), 'x');
        clear x models mdp

        display(strcat('Getting warmed up:  ', num2str(round((n/total)*100)), '% completed.'))
        n= n + 1;

        % Single Lesion:
        mdp = GEN_MDP_SPEC('one');
        models = cell(runs,1);
        x = zeros(tr,runs);

        for i = 1:runs 
            rng(i)
            [MDP(1:tr)] = deal(mdp);      
            M = spm_MDP_VB_X(MDP);
            x(:,i) = score(M,tr);
            models{i} = M;
            clear M MDP
        end
        save(strcat(path, 'single_model.mat'), 'models');
        save(strcat(path, 'single_score.mat'), 'x');
        clear x models mdp

        display(strcat('Getting warmed up:  ', num2str(round((n/total)*100)), '% completed.'))
         n= n + 1;
    end
    
    % Dual Lesion:
    mdp_fi = GEN_MDP_SPEC('one');
    mdp_se = GEN_MDP_SPEC('two');
    models = cell(runs,1);
    x = zeros(tr+10+sl,runs);

    for i = 1:runs 
            rng(i)
            [MDP1(1:tr-sl)] = deal(mdp_fi);   
            M = spm_MDP_VB_X(MDP1);
            x(1:tr-sl,i) = score(M,tr-sl);

            % Introduce second lesion
            mdp.alpha = M(tr-sl).alpha;   
            mdp.T = M(tr-sl).T;                     
            mdp.a = M(tr-sl).a;                     
            mdp.A = M(tr-sl).A;                   
            mdp.b = mdp_se.b;                      
            mdp.B = M(tr-sl).B;                      
            mdp.C = M(tr-sl).C;                      
            mdp.D = M(tr-sl).D;                      
            mdp.V = M(tr-sl).V;    
            mdp.Bname = M(tr-sl).Bname;
            mdp.Aname = M(tr-sl).Aname;
            mdp.label = M(tr-sl).label;

            [MDP2(1:tr-(tr-sl))] = deal(mdp);     
            M2 = spm_MDP_VB_X(MDP2);
            x(tr-sl+1:end,i) = score(M2,tr-(tr-sl)) + x(tr-sl,i);

            models{i}(1:tr-sl) = M;
            models{i}(tr-sl+1:tr) = M2;
            clear M M2 MDP1 MDP2
    end
    save(strcat(path, 'dual_model.mat'), 'models');
    save(strcat(path, 'dual_score.mat'), 'x');
    clear x models mdp_fi mdp_se

    display(strcat('Getting warmed up:  ', num2str(round((n/total)*100)), '% completed.'))
    
    % (non) Dual Lesion
    mdp_fi = GEN_MDP_SPEC('one');
    mdp_se = GEN_MDP_SPEC('three');
    models = cell(runs,1);
    x = zeros(tr,runs);
    
    for i = 1:runs 
            rng(i)
            [MDP1(1:tr-sl)] = deal(mdp_fi);   
            M = spm_MDP_VB_X(MDP1);
            x(1:tr-sl,i) = score(M,tr-sl);

            % Introduce second lesion
            mdp.alpha = M(tr-sl).alpha;   
            mdp.T = M(tr-sl).T;                     
            mdp.a = M(tr-sl).a;                     
            mdp.A = M(tr-sl).A;                   
            mdp.b = mdp_se.b;                      
            mdp.B = M(tr-sl).B;                      
            mdp.C = M(tr-sl).C;                      
            mdp.D = M(tr-sl).D;                      
            mdp.V = M(tr-sl).V;    
            mdp.Bname = M(tr-sl).Bname;
            mdp.Aname = M(tr-sl).Aname;
            mdp.label = M(tr-sl).label;

            [MDP2(1:tr-(tr-sl))] = deal(mdp);     
            M2 = spm_MDP_VB_X(MDP2);
            x(tr-sl+1:end,i) = score(M2,tr-(tr-sl)) + x(tr-sl,i);

            models{i}(1:tr-sl) = M;
            models{i}(tr-sl+1:tr) = M2;
            clear M M2 MDP1 MDP2
    end
        save(strcat(path, 'third_model.mat'), 'models');
        save(strcat(path, 'third_score.mat'), 'x');
        clear x models mdp_se mdp_fi
    
    display(strcat('Finished:'))
return

