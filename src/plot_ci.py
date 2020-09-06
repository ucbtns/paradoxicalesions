

import os
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

sns.set(font_scale=2)

os.getcwd()
os.chdir('D:\\PhD\\Draft Papers\\Current\\manuscript_completed\\paradoxical_lesions\\paradox\\data')


path = ['mean_std_100_80.csv', 'mean_std_faf_100_80.csv', 'mean_std_fbf_100_80.csv','mean_std_kla_100_80.csv', 'mean_std_klb_100_80.csv' ,'mean_std_ena2_100_80.csv', 'mean_std_enb2_100_80.csv' ]
names = ['behaviour_perm_90.png', 'free_energya_90.png','free_energyb_90.png', 'kl_a_90.png', 'kl_b_90.png', 'en_a_90.png', 'en_b_90.png']
yl = ['Proportion Correct (%)', 'Free Energy (nats)','Free Energy (nats)',  'KL Divergence (nats)','KL Divergence (nats)', 'Entropy (nats)', 'Entropy (nats)' ]
lo = ['best', 'lower right', 'lower right','best','center right', 'best', 'best']

tr  = 100
for num,(x,y,z, i) in enumerate(zip(path, names,yl, lo)):
    if num == 0:
        df = pd.read_csv(path[0],header=None)
        df1 = df.div(df.index.values+1, axis=0)*100
    else:
        df1 = pd.read_csv(x,header=None)  
        
    sns.set(style="ticks")
    fig,a =  plt.subplots(1, 1)
    a.plot(range(1,tr+1),df1.iloc[0:tr,0], label='Control', linewidth=2 ,color = 'blue')
    a.fill_between(range(1,tr+1), df1.iloc[0:tr,1], df1.iloc[0:tr,2], alpha=0.3, color = 'blue')
    a.plot(range(1,tr+1),df1.iloc[0:tr,9], label='Dual Lesion #1', linewidth=2, color = 'g')
    a.fill_between(range(1,tr+1), df1.iloc[0:tr,10], df1.iloc[0:tr,11], alpha=0.3,color = 'g')   
    a.plot(range(1,tr+1),df1.iloc[0:tr,6], label='Dual Lesion #2', linewidth=2,color = 'magenta')
    a.fill_between(range(1,tr+1), df1.iloc[0:tr,7], df1.iloc[0:tr,8], alpha=0.3, color = 'magenta')
    a.plot(range(1,tr+1),df1.iloc[0:tr,3], label='Single Lesion', linewidth=2, color ='black')
    a.fill_between(range(1,tr+1), df1.iloc[0:tr,4], df1.iloc[0:tr,5], alpha=0.3,color ='black') 
    
    a.axvline(20, ls='--', color='grey')
    a.axvline(1, ls='--', color='black')
    
    handles,labels = a.get_legend_handles_labels()
    
    handles = [handles[0], handles[3], handles[1], handles[2]]
    labels = [labels[0], labels[3], labels[1], labels[2]]
    
    a.legend(handles,labels,loc=i, fontsize='small' )
    if num == 0:
        a.set(ylim=(0, 105))
    a.set(xlabel='Trial Number', ylabel=z)
    fig.tight_layout()
    fig.savefig(y, dpi=500)
    
tr  = 100
for num,(x,y,z, i) in enumerate(zip(path, names,yl, lo)):
    if num >=5:
        df1 = pd.read_csv(x,header=None)  

        sns.set(style="ticks")
        fig,a =  plt.subplots(1, 1)
        #a.plot(range(1,tr+1),df1.iloc[0:tr,0], label='Control', linewidth=2 ,color = 'blue')
        #a.fill_between(range(1,tr+1), df1.iloc[0:tr,1], df1.iloc[0:tr,2], alpha=0.3, color = 'blue')
        a.plot(range(1,tr+1),df1.iloc[0:tr,3], label='Single Lesion', linewidth=2, color ='black')
        a.fill_between(range(1,tr+1), df1.iloc[0:tr,4], df1.iloc[0:tr,5], alpha=0.3,color ='black') 
        a.plot(range(1,tr+1),df1.iloc[0:tr,9], label='Dual Lesion #2', linewidth=2, color = 'magenta')
        a.fill_between(range(1,tr+1), df1.iloc[0:tr,10], df1.iloc[0:tr,11], alpha=0.3,color = 'magenta')
        a.plot(range(1,tr+1),df1.iloc[0:tr,6], label='Dual Lesion #1', linewidth=2,color = 'g')
        a.fill_between(range(1,tr+1), df1.iloc[0:tr,7], df1.iloc[0:tr,8], alpha=0.3, color = 'g')   
        
        a.axvline(20, ls='--', color='grey')
        a.axvline(1, ls='--', color='black')
        handles,labels = a.get_legend_handles_labels()
    
        handles = [handles[0], handles[2], handles[1]]
        labels = [labels[0], labels[2], labels[1]]
        
        a.legend(handles,labels,loc=i, fontsize='small' )
        if num == 0:
            a.set(ylim=(0, 105))
        a.set(xlabel='Trial Number', ylabel=z)
        fig.tight_layout()
        fig.savefig(y, dpi=500)


cha = 10
df = pd.read_csv(path[3],header=None)
a1 = df
for i in range(12):
    a1.iloc[:,i] = df.iloc[:,i].pct_change(cha)
sns.set(style="ticks")
cha2 = 10
#plt.plot(a1.iloc[cha2:,0], label='Single Lesion', color ='blue')
plt.plot(a1.iloc[cha2:,3], label='Single Lesion', color ='black')
plt.plot(a1.iloc[cha2:,9], label='Dual Lesion #1', color = 'g')
plt.plot(a1.iloc[cha2:,6], label='Dual Lesion #2', color = 'magenta')

plt.legend(loc='best', fontsize='small' )
plt.xlabel('Trial Number' )
plt.ylabel('Gradient' )
plt.tight_layout()
plt.savefig('change_kla.png', dpi=500)


cha = 2
df = pd.read_csv(path[4],header=None)
b1 = df
b1= b1.fillna(0)
for i in range(12):
    b1.iloc[:,i] = b1.iloc[:,i].pct_change(cha)
sns.set(style="ticks")
#plt.plot(a1.iloc[cha2:,0], label='Single Lesion', color ='blue')
#plt.plot(b1.iloc[cha2:,3], label='Single Lesion', color ='orange')
plt.plot(b1.iloc[cha2:,9], label='Dual Lesion #1', color = 'g')
plt.plot(b1.iloc[cha2:,6], label='Dual Lesion #2', color = 'magenta')
plt.legend(loc='best', fontsize='small' )
plt.xlabel('Trial Number' )
plt.ylabel('Gradient' )
plt.tight_layout()
plt.savefig('change_klb.png', dpi=500)