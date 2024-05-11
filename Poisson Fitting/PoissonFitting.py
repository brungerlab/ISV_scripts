import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import poisson
import matplotlib 

params = {'font.family': 'Arial','font.weight':'normal'} #set the basic parameters for figure
plt.rcParams["figure.dpi"] = 300
matplotlib.rcParams.update(params)

savefigure_dir = './'


allWT0 = np.array([2228])
allKO0 = np.array([927])
allWTExp =  np.array([945, 290, 72, 15, 4,0,0, 0])
allKOExp =  np.array([688 , 419, 218, 79,28, 11 ,6, 4])
x = np.array([1,2,3,4,5,6,7,8])


def fit_function(x, mu, coef):
    return coef*poisson.pmf(x, mu)

from scipy.optimize import curve_fit
############################################intact V-ATPase#####################################
#for WT data fitting 
if 1:

    popt, pcov = curve_fit(fit_function, x, allWTExp)
    mu_fit = popt[0]
    coef_fit =  popt[1]
    
    #R2
    meanWT = np.mean(allWTExp)
    ss_tot = np.sum((allWTExp - meanWT) ** 2)
    ss_res = np.sum((allWTExp - fit_function(x, mu_fit, coef_fit)) ** 2) 
    r_squared = 1 - (ss_res / ss_tot)
    print('intact V-ATPase fromr WT:')
    print('the scaled factor: %.2f, the lambda:%.2f'%(coef_fit, mu_fit))
    print('average residue %.2f'%(ss_res/len(x))**0.5)
    #print('R2 %.2f'%r_squared)
    plt.figure(dpi=300,figsize=(3,2))
    
    plt.bar(np.concatenate(([0],x)),    np.concatenate((allWT0, allWTExp)), color = 'lightgrey',edgecolor = 'grey')
    plt.plot(np.concatenate(([0],x)),     np.concatenate(([fit_function(0,mu_fit, coef_fit)],fit_function(x, mu_fit, coef_fit))), color = 'grey', lw=2, label='Fitted Poisson Distribution')
    plt.scatter(np.concatenate(([0],x)),     np.concatenate(([fit_function(0,mu_fit, coef_fit)],fit_function(x, mu_fit, coef_fit))), color = 'grey', lw=1)
    plt.title('intact V-ATPase from WT')
    plt.xticks(range(0,9),range(0,9))

    plt.tight_layout()
    plt.savefig(savefigure_dir + "intactWT.svg", dpi=300,format="svg")




#for KO data fitting 
if 1:
    popt, pcov = curve_fit(fit_function, x, allKOExp)
    mu_fit = popt[0]
    coef_fit =  popt[1]
    
    #R2
    meanKO = np.mean(allKOExp)
    ss_tot = np.sum((allKOExp - meanKO) ** 2)
    ss_res = np.sum((allKOExp - fit_function(x, mu_fit, coef_fit)) ** 2) 
    r_squared = 1 - (ss_res / ss_tot)
    print('')
    print('intact V-ATPase from syp-/-:')
    print('the scaled factor: %.2f, the lambda:%.2f'%(coef_fit, mu_fit))
    print('total residue %.2f'%(np.sum((allKOExp - fit_function(x, mu_fit, coef_fit)) ** 2)/len(x))**0.5)
    #print('R2 %.2f'%r_squared)
    plt.figure(dpi=300,figsize=(3,2))
    
    plt.bar(np.concatenate(([0],x)), np.concatenate((allKO0,allKOExp)), color = np.array([250,204,64])/255, edgecolor = np.array([250,82,35])/255)
    plt.plot(np.concatenate(([0],x)), np.concatenate(([fit_function(0,mu_fit, coef_fit)],fit_function(x, mu_fit, coef_fit))), color = 'grey', lw=2, label='Fitted Poisson Distribution')
    plt.scatter(np.concatenate(([0],x)),     np.concatenate(([fit_function(0,mu_fit, coef_fit)],fit_function(x, mu_fit, coef_fit))), color = 'grey', lw=1)
    plt.title('intact V-ATPase from syp-/-')
    plt.xticks(range(0,9),range(0,9))
    plt.tight_layout()
    plt.savefig(savefigure_dir + "intactSypKO.svg", dpi=300,format="svg")



# ############################################MPI WT#####################################
# ###for data from MPI
# if 0:
    
#     allWT0 = np.array([2686/2018*100])
#     allWTExp =  np.array([1529, 394, 79, 13, 2,0,0, 1])/2018*100

#     x = np.array([1,2,3,4,5,6,7,8])
#     popt, pcov = curve_fit(fit_function, x, allWTExp)
#     mu_fit = popt[0]
#     coef_fit =  popt[1]
    
#     #R2
#     meanWT = np.mean(allWTExp)
#     ss_tot = np.sum((allWTExp - meanWT) ** 2)
#     ss_res = np.sum((allWTExp - fit_function(x, mu_fit, coef_fit)) ** 2) 
#     r_squared = 1 - (ss_res / ss_tot)
#     print('for WT fitting, the factor: %.2f, the lambda:%.2f'%(coef_fit, mu_fit))
#     print('average residue %.2f'%(ss_res/len(x))**0.5)
#     print('R2 %.2f'%r_squared)
#     plt.figure(dpi=300,figsize=(3,2))
    
#     plt.bar(np.concatenate(([0],x)),    np.concatenate((allWT0, allWTExp)), color = np.array([184,220,142])/255,edgecolor = np.array([63,183,69])/255)
#     plt.plot(np.concatenate(([0],x)),     np.concatenate(([fit_function(0,mu_fit, coef_fit)],fit_function(x, mu_fit, coef_fit))), color = 'grey', lw=2, label='Fitted Poisson Distribution')
#     plt.scatter(np.concatenate(([0],x)),     np.concatenate(([fit_function(0,mu_fit, coef_fit)],fit_function(x, mu_fit, coef_fit))), color = 'grey', lw=1)
#     plt.xticks(range(0,9),range(0,9))
#     plt.tight_layout()
#     plt.savefig("C:/Users/DELL/Desktop/f1_mpi.svg", dpi=300,format="svg")


############################################v0-only#####################################
###for data for KO V0-only fitting 
if 1:  
    allKO0 = np.array([233])
    allKOExp =  np.array([130, 46, 11, 1, 0,0,0, 0])

    x = np.array([1,2,3,4,5,6,7,8])
    popt, pcov = curve_fit(fit_function, x, allKOExp)
    mu_fit = popt[0]
    coef_fit =  popt[1]
    
    #R2
    meanKO = np.mean(allKOExp)
    ss_tot = np.sum((allKOExp - meanKO) ** 2)
    ss_res = np.sum((allKOExp - fit_function(x, mu_fit, coef_fit)) ** 2) 
    r_squared = 1 - (ss_res / ss_tot)
    print('')
    print('V0-only from WT:')
    print('the scaled factor: %.2f, the lambda:%.2f'%(coef_fit, mu_fit))
    print('average residue %.2f'%(ss_res/len(x))**0.5)
    #print('R2 %.2f'%r_squared)
    plt.figure(dpi=300,figsize=(3,2))
    
    plt.bar(np.concatenate(([0],x)),    np.concatenate((allKO0, allKOExp)),  color = np.array([250,204,64])/255, edgecolor = np.array([250,82,35])/255)
    plt.plot(np.concatenate(([0],x)),     np.concatenate(([fit_function(0,mu_fit, coef_fit)],fit_function(x, mu_fit, coef_fit))), color = 'grey', lw=2, label='Fitted Poisson Distribution')
    plt.scatter(np.concatenate(([0],x)),     np.concatenate(([fit_function(0,mu_fit, coef_fit)],fit_function(x, mu_fit, coef_fit))), color = 'grey', lw=1)
    plt.title('V0-only from WT')
    plt.xticks(range(0,9),range(0,9))
    plt.tight_layout()
    plt.savefig(savefigure_dir + "V0WT.svg", dpi=300,format="svg")
    
    
###for data for WT V0-only fitting 
if 1:  
     allWT0 = np.array([197])
     allWTExp =  np.array([86, 18, 2, 0, 0,0,0, 0])

     x = np.array([1,2,3,4,5,6,7,8])
     popt, pcov = curve_fit(fit_function, x, allWTExp)
     mu_fit = popt[0]
     coef_fit =  popt[1]
     
     #R2
     meanWT = np.mean(allWTExp)
     ss_tot = np.sum((allWTExp - meanWT) ** 2)
     ss_res = np.sum((allWTExp - fit_function(x, mu_fit, coef_fit)) ** 2) 
     r_squared = 1 - (ss_res / ss_tot)
     print('')
     print('V0-only from syp-/-:')
     print('the scaled factor: %.2f, the lambda:%.2f'%(coef_fit, mu_fit))
     print('average residue %.2f'%(ss_res/len(x))**0.5)
     #print('R2 %.2f'%r_squared)
     plt.figure(dpi=300,figsize=(3,2))
     
     plt.bar(np.concatenate(([0],x)),    np.concatenate((allWT0, allWTExp)), color ='lightgrey',edgecolor = 'grey')
     plt.plot(np.concatenate(([0],x)),     np.concatenate(([fit_function(0,mu_fit, coef_fit)],fit_function(x, mu_fit, coef_fit))), color = 'grey', lw=2, label='Fitted Poisson Distribution')
     plt.scatter(np.concatenate(([0],x)),     np.concatenate(([fit_function(0,mu_fit, coef_fit)],fit_function(x, mu_fit, coef_fit))), color = 'grey', lw=1)
     plt.title('V0-only from syp-/-')
     plt.xticks(range(0,9),range(0,9))
     plt.tight_layout()
     
     plt.savefig(savefigure_dir + "V0sypKO.svg", dpi=300,format="svg")  
    