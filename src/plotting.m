
function plotting

addpath ~/spm/toolbox/DEM/
addpath ~/spm/
addpath ~/src/

if ~exist('simulation','var'), sim=0; end
tr = 100;
sl = 80;
all = 1;
path = strcat('~\models_', num2str(tr), '\');

if ~exist(path, 'dir')
       mkdir(path)
end

% Run simulation:
if sim == 1
        disp(sl)
        simulations(path ,tr, sl, all);
end

d = dir(path);
model_names=d(~ismember({d.name},{'.','..'})); clear d;

m = 4;

models = cell(m,1);
performance = cell(m,1);

n = 1;
for i = [1,5,7,3]
    models{n} = load(strcat(path, model_names(i).name));
    performance{n} = load(strcat(path, model_names(i+1).name));
    n = n + 1;
end


% Physiological Predictions: 

model_n = {'CONTROL', 'SINGLE', 'DUAL #1', 'DUAL #2'};

for i = 1:4
    clear M
    M = models{i}.models{1:end}; 
    % calculate the gradient 
    subplot(4,1,i);
    spm_MDP_VB_LFPn(M,[],2,6); hold on
    if i == 1
        title('Local field potentials','FontSize',16)
    elseif i == 4
        xlabel('time (sec)','FontSize',16,'FontWeight','bold')
    end
    ylabel(model_n{i},'FontSize',16,'FontWeight','bold')
end
hold off

saveas(gcf, strcat('~\','lfps.tiff'))

runs = 50;
% KL Divergence for A & B + Free energy:
change_kl_a = zeros(tr,runs,m);
change_kl_b = zeros(tr,runs,m);
fa = zeros(tr, runs, m);
fb = zeros(tr, runs, m);

tr = 100;
for j = 1:m
    for z = 1:runs
        for i = 1:tr
            a = KLDir(models{j,1}.models{1,1}(1).a{2},models{j,1}.models{z,1}(i).a{2});
            b = KLDir(models{j,1}.models{1,1}(1).b{2},models{j,1}.models{z,1}(i).b{2});
            change_kl_a(i,z,j) = sum(sum(sum(a)));
            change_kl_b(i,z,j) = sum(b);
            faa =models{j,1}.models{z,1}(i).Fa ;
            fa(i,z,j) = sum(sum(faa));
            fbb =models{j,1}.models{z,1}(i).Fb ;
            fb(i,z,j) = sum(sum(fbb));
        end
    end
    tr = tr + 10;
end

% Extracting sensory precision:
entropy_a = zeros(tr,runs,m);
entropy_b = zeros(tr,runs,m);

for j = 1:m
    for z = 1:runs
        for i = 1:tr
            a = entropy(models{j,1}.models{z,1}(i).a{2});
            b = entropy(models{j,1}.models{z,1}(i).b{2});
            entropy_a(i,z,j) = a;
            entropy_b(i,z,j) = b;
        end
    end
end

% Mean and Std: 
me = zeros(tr, 3*m);


tr = 110;
  z= 1;
for i = 1:m    
    me(1:tr,z) =  median(performance{i}.x, 2);
    me(1:tr,z+1) = me(1:tr,z)  - std(performance{i}.x,0,2);
    me(1:tr,z+2) = me(1:tr,z)  + std(performance{i}.x,0,2);
    
    tr = tr + 10;
    z = z + 3;       
end


tr = 100;
faf = zeros(tr,3*m);
fbf = zeros(tr,3*m);
kla = zeros(tr, 3*m);
klb = zeros(tr,3*m);
ena =  zeros(tr, 3*m);
enb = zeros(tr, 3*m);
z= 1;

       
for i = 1:m  
    faf(:,z) =   median(fa(:,:,i),2);
    faf(:,z+1) = faf(:,z)  - std(fa(:,:,i),0,2);
    faf(:,z+2) = faf(:,z)  + std(fa(:,:,i),0,2);
    fbf(:,z) =   mean(fb(:,:,i),2);
    fbf(:,z+1) = fbf(:,z)  - std(fb(:,:,i),0,2);
    fbf(:,z+2) = fbf(:,z)  + std(fb(:,:,i),0,2);
    
    kla(:,z) =   median(change_kl_a(:,:,i),2);
    kla(:,z+1) = kla(:,z)  - std(change_kl_a(:,:,i),0,2);
    kla(:,z+2) = kla(:,z)  + std(change_kl_a(:,:,i),0,2);
    
    klb(:,z) =   median(change_kl_b(:,:,i),2);
    klb(:,z+1) = klb(:,z)  - std(change_kl_b(:,:,i),0,2);
    klb(:,z+2) = klb(:,z)  + std(change_kl_b(:,:,i),0,2);

    ena(:,z) =   median(entropy_a(:,:,i),2);
    ena(:,z+1) = ena(:,z)  - std(entropy_a(:,:,i),0,2);
    ena(:,z+2) = ena(:,z)  + std(entropy_a(:,:,i),0,2);
    
    enb(:,z) =   median(entropy_b(:,:,i),2);
    enb(:,z+1) = enb(:,z)  - std(entropy_b(:,:,i),0,2);
    enb(:,z+2) = enb(:,z)  + std(entropy_b(:,:,i),0,2);
    z = z + 3;
end

writematrix(me, strcat('~\mean_std_',  num2str(tr), '_', num2str(sl), '.csv'))
writematrix(faf, strcat('~\mean_std_faf_',  num2str(tr), '_', num2str(sl), '.csv'))
writematrix(fbf, strcat('~\mean_std_fbf_',  num2str(tr), '_', num2str(sl), '.csv'))
writematrix(kla, strcat('~\mean_std_kla_',  num2str(tr), '_', num2str(sl), '.csv'))
writematrix(klb, strcat('~\mean_std_klb_',  num2str(tr), '_', num2str(sl), '.csv'))
writematrix(ena, strcat('~\mean_std_ena2_',  num2str(tr), '_', num2str(sl), '.csv'))
writematrix(enb, strcat('~\mean_std_enb2_',  num2str(tr), '_', num2str(sl), '.csv'))


