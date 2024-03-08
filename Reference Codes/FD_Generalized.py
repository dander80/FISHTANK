# %% 
import numpy as np
import matplotlib.pyplot as plt
import sys
from tqdm import trange,tqdm
import tensorflow as tf
from tensorflow import keras
from keras import layers
from sklearn.preprocessing import MinMaxScaler
from sklearn.model_selection import train_test_split
from scipy.signal import savgol_filter
import scipy.io
import skfuzzy as fuzz 
import skfuzzy.membership as mf



# %% =========================================================================================
# ================================ functions for FISHTANK ===================================
# =========================================================================================

def NN_check(model=None, healthy_data=None):
    #  Purpose it to either pull in the NN model, or to train it based on healthy data 
    if model != None:
        trained_model = model
    elif healthy_data != None:
        # ..........
    return trained_model

def pull_in_data(data):
    return 

def norm_and_filter(data): 
    data_norm = np.zeros_like(data)
    data_norm = data / avg_vals

    for ii in range(normed_data.shape[0]):
        for i in range(normed_data.shape[2]):
            data = normed_data[ii,:,i]
            data_filtered[ii,:,i] = savgol_filter(data, window_size, poly_order)
    return normd_and_filtered 

def SST(residuals, thresholds, consecutive_threshold_SST):
    # 
    SST_results = (residuals[i,:,:] >= ones * thresholds) | (residuals[i,:,:] <= -1 * ones * thresholds)
    SST_fault_pred_yesno = np.any(SST_fault_pred, axis=2)

    file_length = residuals.shape[0] #####

    consec_length_SST = int((file_length-file_length%consecutive_threshold_SST)/consecutive_threshold_SST)

    fault_pred_SST = np.zeros([len(SST_fault_pred), consec_length_SST])

    for ii in range(consec_length_SST):

        index = ii * consecutive_threshold_SST
        sum_true = 0

        for iii in range(consecutive_threshold_SST):
            if SST_fault_pred_yesno[i,index+iii] == True:
                sum_true += 1

        if(sum_true >= consecutive_threshold_SST):
            fault_pred_SST[i, ii] = 1
        else:
            fault_pred_SST[i, ii] = 0




                # return yes/no which is the time length x num of vars, then the finalized yes/no
    return SST_results


def sprt(m, v, e, method='default', thresh=None):
    if method == 'default':
        alpha = 0.01  # Default false alarm probability
        beta = 0.1   # Default missed alarm probability
    elif method == 'chien':
        alpha = 0.01
        beta = 0.1
    else:
        raise ValueError("Invalid method. Supported methods: 'default', 'chien'")
    
    if thresh is None:
        thresh = 3 * np.sqrt(v)
    
    e = e - m
    
    A = np.log(beta / (1 - alpha))
    B = np.log((1 - beta) / alpha)
    
    mupshift = (thresh / v) * (e - thresh / 2)
    mdownshift = (thresh / v) * (-e - thresh / 2)
    
    sums = np.zeros(2)
    fhyp = np.zeros(e.shape)
    ischien = method.lower() == 'chien'

    for i in range(e.shape[0]):
        sums[0] += mupshift[i]
        sums[1] += mdownshift[i]
        
        if sums[0] > B:
            sums[0] = 0
            fhyp[i] = 1
        elif (sums[0] < A and not ischien) or (sums[0] < 0 and ischien):
            sums[0] = 0
        
        if sums[1] > B:
            sums[1] = 0
            fhyp[i] = 1
        elif (sums[1] < A and not ischien) or (sums[1] < 0 and ischien):
            sums[1] = 0
    
    return fhyp


def calc_fuzzy_membership(healthy_data, model, sum_time):
    # run the healthy data thru the model, calculate the residuals, check the cumulative sum over sum_time 
    # calculate the fuzzy membership range by calulating: min = mean-4*std, max = ....
    return fuzzy_membership_range


def fuzzy(input):

    input_HPT     = input[0]
    input_LPT     = input[1]
    input_TCVY    = input[2]
    input_TCVP    = input[3]
    input_CondInv = input[4]
    input_TCV1    = input[5]
    input_TCV2    = input[6]
    input_TCV3    = input[7]

    ##################################################################################

    # We need the activation of our fuzzy membership functions at these values.
    # The exact values of our inputs do not exist on our universes...
    # This is what fuzz.interp_membership exists for!

    HPT_normal_level = fuzz.interp_membership(fill_HPT, HPT_normal, input_HPT)
    HPT_low_level = fuzz.interp_membership(fill_HPT, HPT_low, input_HPT)

    LPT_normal_level = fuzz.interp_membership(fill_LPT, LPT_normal, input_LPT)
    LPT_low_level = fuzz.interp_membership(fill_LPT, LPT_low, input_LPT)

    TCVY_high_level = fuzz.interp_membership(fill_TCVY, TCVY_high, input_TCVY)
    TCVY_normal_level = fuzz.interp_membership(fill_TCVY, TCVY_normal, input_TCVY)
    TCVY_low_level = fuzz.interp_membership(fill_TCVY, TCVY_low, input_TCVY)

    TCVP_normal_level = fuzz.interp_membership(fill_TCVP, TCVP_normal, input_TCVP)
    TCVP_low_level = fuzz.interp_membership(fill_TCVP, TCVP_low, input_TCVP)

    CondInv_normal_level = fuzz.interp_membership(fill_CondInv, CondInv_normal, input_CondInv)
    CondInv_low_level = fuzz.interp_membership(fill_CondInv, CondInv_low, input_CondInv)

    TCV1_high_level = fuzz.interp_membership(fill_TCV1, TCV1_high, input_TCV1)
    TCV1_normal_level = fuzz.interp_membership(fill_TCV1, TCV1_normal, input_TCV1)
    TCV1_low_level = fuzz.interp_membership(fill_TCV1, TCV1_low, input_TCV1)

    TCV2_high_level = fuzz.interp_membership(fill_TCV2, TCV2_high, input_TCV2)
    TCV2_normal_level = fuzz.interp_membership(fill_TCV2, TCV2_normal, input_TCV2)
    TCV2_low_level = fuzz.interp_membership(fill_TCV2, TCV2_low, input_TCV2)

    TCV3_high_level = fuzz.interp_membership(fill_TCV3, TCV3_high, input_TCV3)
    TCV3_normal_level = fuzz.interp_membership(fill_TCV3, TCV3_normal, input_TCV3)
    TCV3_low_level = fuzz.interp_membership(fill_TCV3, TCV3_low, input_TCV3)

    ##################################################################################

    healthy_sum = HPT_normal_level + LPT_normal_level + TCVY_normal_level + TCVP_normal_level \
        + CondInv_normal_level + TCV1_normal_level + TCV2_normal_level + TCV3_normal_level
    
    leak_sum = HPT_low_level + LPT_low_level + TCVY_low_level + TCVP_low_level \
        + CondInv_low_level + TCV1_low_level + TCV2_low_level + TCV3_low_level 
    
    actuator_sum = HPT_normal_level + LPT_normal_level + TCVY_high_level + TCVP_normal_level \
        + CondInv_normal_level + TCV1_high_level + TCV2_high_level + TCV3_low_level

    max_sum = ''

    if healthy_sum > (leak_sum & actuator_sum):
        max_sum = 'Healthy'
    elif leak_sum > (healthy_sum & actuator_sum):
        max_sum = 'Leaking TCV'
    elif leak_sum > (healthy_sum & actuator_sum):
        max_sum = 'Actuator Failure'
    else:
        max_sum = 'Inconclusive'

    return failure



# %%
# ================================ normalize + filter data ===================================

def normalize(data):
    data_norm = np.zeros_like(data)
    data_norm = data / avg_vals
    return data_norm 

# initialize normed_data
normed_data = np.zeros_like(data_list)

for i in range(len(data_list)):
    normed_data[i] = normalize(data_list[i])

# turn normed_data to a np array for further use
normed_data = np.array(normed_data, dtype=object)
# un-doing the normalization for the TCV controller response
normed_data[:,:,2] = data_list[:,:,2]

# initialize data_filtered
data_filtered = np.zeros(normed_data.shape)

window_size = 49
poly_order = 2

for ii in range(normed_data.shape[0]):
    for i in range(normed_data.shape[2]):
        data = normed_data[ii,:,i]
        data_filtered[ii,:,i] = savgol_filter(data, window_size, poly_order)
# un-doing the normalization for the TCV controller response
data_filtered[:,:,2] = data_list[:,:,2]

training_data_normed = normalize(training_data)
validation_data_normed = normalize(validation_data)
residuals_data_normed = normalize(residuals_data)


training_data_filtered = np.zeros_like(training_data_normed)
validation_data_filtered = np.zeros_like(validation_data_normed)
residuals_data_filtered = np.zeros_like(residuals_data_normed)


for i in range(training_data.shape[1]):
    training_data_filtered[:,i] = savgol_filter(training_data_normed[:,i], window_size, poly_order)
    validation_data_filtered[:,i] = savgol_filter(validation_data_normed[:,i], window_size, poly_order)
    residuals_data_filtered[:,i] = savgol_filter(residuals_data_normed[:,i], window_size, poly_order)

training_data_filtered[:,:,2] = training_data[:,:,2]
validation_data_filtered[:,:,2] = validation_data[:,:,2]
residuals_data_filtered[:,:,2] = residuals_data[:,:,2]

print('Pre-Processing Finished: data normalized and filtered')

# %% train the model
# ================================ train the model ===================================

x_train = training_data_filtered

x_val = validation_data_filtered

model = keras.Sequential(
    [
        layers.Dense(4,input_shape=(9,),activation='selu'), # input layer\
        # layers.Dense(4, activation='selu'), # encoded layer
        layers.Dense(1, activation='sigmoid'), # encoded layer  
        layers.Dense(3, activation='selu'), # encoded layer
        layers.Dense(9, activation='selu')
    ])

model.compile(loss='mean_absolute_error', optimizer='adam') 

training_history = model.fit(x=x_train, y=x_train, validation_data=(x_val, x_val), epochs=50, verbose=1)

print('\nModel trained')

healthy_residuals = x_train - model(x_train)

residuals = np.zeros(normed_data.shape)

for i in range(len(data_list)):
    residuals[i] = data_filtered[i] - model(data_filtered[i])

# %% save model

keras.models.save_model(model, folder)


# %% plot costs

# test_loss, test_accuracy = model.evaluate(x_test, y_test, verbose=1);
# print("test accuracy = ", test_accuracy)

# # Plot the data for accuracy and cost as a function of epoch
# fig,ax = plt.subplots(2,1, sharex=True, figsize=(5,5))

# # summarize history for accuracy
# ax[0].plot(training_history['test'].history['accuracy'])
# ax[0].plot(training_history['test'].history['val_accuracy'], ls='--')
# ax[0].set_ylabel('model accuracy')
# ax[0].legend(['train', 'test'], loc='best')
# ax[0].set_ylim(0.9,1)

# # summarize history for loss
# ax[1].plot(training_history['test'].history['loss'])
# ax[1].plot(training_history['test'].history['val_loss'], ls='--')
# ax[1].set_ylabel('model loss')
# ax[1].set_xlabel('epoch')
# ax[1].legend(['train', 'test'], loc='best')
# ax[1].set_ylim(0,0.2)

# %% SST

res_file_residuals = residuals_data_filtered - model(residuals_data_filtered) 

# res_quantile = np.quantile(res_file_residuals[0:int(len(res_file_residuals)/2), :], 0.999, axis=0)
# res_quantile = np.array([0.00611176, 0.01042494, 0.00719185, 0.00496755, 0.02839175, 0.00338431,  0.00442679, 0.0034227,  0.00082512])
# print('Quantiles:', res_quantile)


SST_thresh = 4 * np.std(res_file_residuals, axis=0)

SST_fault_pred = np.zeros(normed_data.shape)
ones = np.ones(residuals[0,:,:].shape)

for i in range(len(data_list)):
    SST_fault_pred[i,:,:] = (residuals[i,:,:] >= ones * SST_thresh) | (residuals[i,:,:] <= -1 * ones * SST_thresh)

SST_fault_pred_yesno = np.any(SST_fault_pred, axis=2)

consecutive_threshold_SST = 1

consec_length_SST = int((file_length-file_length%consecutive_threshold_SST)/consecutive_threshold_SST)

fault_pred_SST = np.zeros([len(SST_fault_pred), consec_length_SST])


for i in range(len(data_list)):

    for ii in range(consec_length_SST):

        index = ii * consecutive_threshold_SST
        sum_true = 0

        for iii in range(consecutive_threshold_SST):
            if SST_fault_pred_yesno[i,index+iii] == True:
                sum_true += 1

        if(sum_true >= consecutive_threshold_SST):
            fault_pred_SST[i, ii] = 1
        else:
            fault_pred_SST[i, ii] = 0

m_size = 0.5
def plot_SST():
    fig, axs = plt.subplots(nrows=3, ncols=2, figsize=(10, 5)) 

    tt = np.arange(fault_pred_SST.shape[1])

    # t_pct = np.linspace(0, len(tt), pct_fault_calls.shape[1])


    # axs[0,0].plot(t_pct, pct_fault_calls[0,:], 'r-', alpha=0.5)
    axs[0,0].plot(tt, fault_pred_SST[0, :], 'bo', markersize=m_size)
    axs[0,0].title.set_text(data_ID[0])
    axs[0,0].set_ylim(-0.2,1.2)
    axs[0,0].set_yticks([0,1], labels=["Healthy", "Faulted"])

    # axs[0,1].plot(t_pct, pct_fault_calls[1,:], 'r-', alpha=0.5)
    axs[0,1].plot(tt, fault_pred_SST[1, :], 'bo', markersize=m_size)
    axs[0,1].title.set_text(data_ID[1])
    axs[0,1].set_ylim(-0.2,1.2)
    axs[0,1].set_yticks([0,1], labels=["H", "F"])

    # axs[1,0].plot(t_pct, pct_fault_calls[2,:], 'r-', alpha=0.5)
    axs[1,0].plot(tt, fault_pred_SST[2, :], 'bo', markersize=m_size)
    axs[1,0].title.set_text(data_ID[2])
    axs[1,0].set_ylim(-0.2,1.2)
    axs[1,0].set_yticks([0,1], labels=["Healthy", "Faulted"])

    # axs[1,1].plot(t_pct, pct_fault_calls[3,:], 'r-', alpha=0.5)
    axs[1,1].plot(tt, fault_pred_SST[3, :], 'bo', markersize=m_size)
    axs[1,1].title.set_text(data_ID[3])
    axs[1,1].set_ylim(-0.2,1.2)
    axs[1,1].set_yticks([0,1], labels=["H", "F"])

    # axs[2,0].plot(t_pct, pct_fault_calls[4,:], 'r-', alpha=0.5)
    axs[2,0].plot(tt, fault_pred_SST[4, :], 'bo', markersize=m_size)
    axs[2,0].title.set_text(data_ID[4])
    axs[2,0].set_ylim(-0.2,1.2)
    axs[2,0].set_yticks([0,1], labels=["Healthy", "Faulted"])

    # axs[2,1].plot(t_pct, pct_fault_calls[5,:], 'r-', alpha=0.5)
    axs[2,1].plot(tt, fault_pred_SST[5, :], 'bo', markersize=m_size)
    axs[2,1].title.set_text(data_ID[5])
    axs[2,1].set_ylim(-0.2,1.2)
    axs[2,1].set_yticks([0,1], labels=["H", "F"])

    fig.suptitle('Simple Signal Thresholding (SST)', fontsize = 25, y= 1.05)

    plt.subplots_adjust(left=0.1,
                        bottom=0.1,
                        right=0.9,
                        top=0.9,
                        wspace=0.1,
                        hspace=1.2)

    plt.show()

plot_SST()

# %% SPRT
# ================================ SPRT ===================================

def sprt(m, v, e, method='default', thresh=None):
    if method == 'default':
        alpha = 0.01  # Default false alarm probability
        beta = 0.1   # Default missed alarm probability
    elif method == 'chien':
        alpha = 0.01
        beta = 0.1
    else:
        raise ValueError("Invalid method. Supported methods: 'default', 'chien'")
    
    if thresh is None:
        thresh = 3 * np.sqrt(v)
    
    e = e - m
    
    A = np.log(beta / (1 - alpha))
    B = np.log((1 - beta) / alpha)
    
    mupshift = (thresh / v) * (e - thresh / 2)
    mdownshift = (thresh / v) * (-e - thresh / 2)
    
    sums = np.zeros(2)
    fhyp = np.zeros(e.shape)
    ischien = method.lower() == 'chien'

    for i in range(e.shape[0]):
        sums[0] += mupshift[i]
        sums[1] += mdownshift[i]
        
        if sums[0] > B:
            sums[0] = 0
            fhyp[i] = 1
        elif (sums[0] < A and not ischien) or (sums[0] < 0 and ischien):
            sums[0] = 0
        
        if sums[1] > B:
            sums[1] = 0
            fhyp[i] = 1
        elif (sums[1] < A and not ischien) or (sums[1] < 0 and ischien):
            sums[1] = 0
    
    return fhyp

mean        = np.mean(res_file_residuals, axis=0)
variance    = np.var(res_file_residuals, axis=0)
SPRT_thresh = 8*np.std(res_file_residuals, axis=0)

SPRT_fault_pred = np.zeros_like(data_list)

for i in range(len(data_list)):
    for var in range(len(var_list)):
        SPRT_fault_pred[i,:,var] = sprt(mean[var], variance[var], residuals[i,:,var], 'default', SPRT_thresh[var])

SPRT_fault_pred_yesno = np.any(SPRT_fault_pred, axis=2)

consecutive_threshold_SPRT = 1

consec_length_SPRT = int((file_length-file_length%consecutive_threshold_SPRT)/consecutive_threshold_SPRT)

SPRT_fault_pred_yesno_consec = np.zeros([len(SPRT_fault_pred), consec_length_SPRT])

for i in range(len(data_list)):
    for ii in range(consec_length_SPRT):
        index = ii * consecutive_threshold_SPRT
        sum_true = 0
        for iii in range(consecutive_threshold_SPRT):

            if SPRT_fault_pred_yesno[i,index+iii] == True:
                sum_true += 1

        if(sum_true >= consecutive_threshold_SPRT):
            SPRT_fault_pred_yesno_consec[i, ii] = 1

        else:
            SPRT_fault_pred_yesno_consec[i, ii] = 0



t_consec = np.arange(consec_length_SPRT)

fig, axs = plt.subplots(nrows=3, ncols=2, figsize=(10, 5)) 

axs[0,0].plot(t_consec, SPRT_fault_pred_yesno_consec[0,t_consec], 'bo', markersize=m_size)
axs[0,0].title.set_text(data_ID[0])
axs[0,0].set_ylim(-0.2,1.2)
axs[0,0].set_yticks([0,1], labels=["Healthy", "Faulted"])

axs[0,1].plot(t_consec, SPRT_fault_pred_yesno_consec[1,t_consec], 'bo', markersize=m_size)
axs[0,1].title.set_text(data_ID[1])
axs[0,1].set_ylim(-0.2,1.2)
axs[0,1].set_yticks([0,1], labels=["H", "F"])

axs[1,0].plot(t_consec, SPRT_fault_pred_yesno_consec[2,t_consec], 'bo', markersize=m_size)
axs[1,0].title.set_text(data_ID[2])
axs[1,0].set_ylim(-0.2,1.2)
axs[1,0].set_yticks([0,1], labels=["Healthy", "Faulted"])

axs[1,1].plot(t_consec, SPRT_fault_pred_yesno_consec[3,t_consec], 'bo', markersize=m_size)
axs[1,1].title.set_text(data_ID[3])
axs[1,1].set_ylim(-0.2,1.2)
axs[1,1].set_yticks([0,1], labels=["H", "F"])

axs[2,0].plot(t_consec, SPRT_fault_pred_yesno_consec[4,t_consec], 'bo', markersize=m_size)
axs[2,0].title.set_text(data_ID[4])
axs[2,0].set_ylim(-0.2,1.2)
axs[2,0].set_yticks([0,1], labels=["Healthy", "Faulted"])

axs[2,1].plot(t_consec, SPRT_fault_pred_yesno_consec[5,t_consec], 'bo', markersize=m_size)
axs[2,1].title.set_text(data_ID[5])
axs[2,1].set_ylim(-0.2,1.2)
axs[2,1].set_yticks([0,1], labels=["H", "F"])

fig.suptitle('Sequential Probability Ratio Testing (SPRT)', fontsize = 25, y= 1.05)

plt.subplots_adjust(left=0.1,
                    bottom=0.1,
                    right=0.9,
                    top=0.9,
                    wspace=0.1,
                    hspace=1.2)

plt.show()

# %% plot both

fig, axs = plt.subplots(nrows=3, ncols=2, figsize=(15, 9))

m_size=4

axs[0,0].plot(t_consec, 2 * fault_pred_SST[0, :], 'ro', markersize=m_size)
axs[0,0].plot(t_consec, SPRT_fault_pred_yesno_consec[0,t_consec], 'bo', markersize=m_size)
axs[0,0].title.set_text(data_ID[0])
axs[0,0].set_ylim(-0.2,2.2)
axs[0,0].set_yticks([0,1,2], labels=["Healthy", "Faulted: SPRT", "Faulted: SST"])

axs[0,1].plot(t_consec, 2 * fault_pred_SST[1, :], 'ro', markersize=m_size)
axs[0,1].plot(t_consec, SPRT_fault_pred_yesno_consec[1,t_consec], 'bo', markersize=m_size)
axs[0,1].title.set_text(data_ID[1])
axs[0,1].set_ylim(-0.2,2.2)
axs[0,1].set_yticks([0,1,2], labels=["H", "SPRT", "SST"])

axs[1,0].plot(t_consec, 2 * fault_pred_SST[2, :], 'ro', markersize=m_size)
axs[1,0].plot(t_consec, SPRT_fault_pred_yesno_consec[2,t_consec], 'bo', markersize=m_size)
axs[1,0].title.set_text(data_ID[2])
axs[1,0].set_ylim(-0.2,2.2)
axs[1,0].set_yticks([0,1,2], labels=["Healthy", "Faulted: SPRT", "Faulted: SST"])

axs[1,1].plot(t_consec, 2 * fault_pred_SST[3, :], 'ro', markersize=m_size)
axs[1,1].plot(t_consec, SPRT_fault_pred_yesno_consec[3,t_consec], 'bo', markersize=m_size)
axs[1,1].title.set_text(data_ID[3])
axs[1,1].set_ylim(-0.2,2.2)
axs[1,1].set_yticks([0,1,2], labels=["H", "SPRT", "SST"])

axs[2,0].plot(t_consec, 2 * fault_pred_SST[4, :], 'ro', markersize=m_size)
axs[2,0].plot(t_consec, SPRT_fault_pred_yesno_consec[4,t_consec], 'bo', markersize=m_size)
axs[2,0].title.set_text(data_ID[4])
axs[2,0].set_ylim(-0.2,2.2)
axs[2,0].set_yticks([0,1,2], labels=["Healthy", "Faulted: SPRT", "Faulted: SST"])

axs[2,1].plot(t_consec, 2 * fault_pred_SST[5, :], 'ro', markersize=m_size)
axs[2,1].plot(t_consec, SPRT_fault_pred_yesno_consec[5,t_consec], 'bo', markersize=m_size)
axs[2,1].title.set_text(data_ID[5])
axs[2,1].set_ylim(-0.2,2.2) 
axs[2,1].set_yticks([0,1,2], labels=["H", "SPRT", "SST"]) 

fig.suptitle('Fault Detection Results for both Simple Signal\nThresholding (SST) & Sequential Probability Ratio Testing (SPRT)', fontsize = 25, y= 1.04)




# time = [point[0] for point in power_profile]
# y_values = [point[1] for point in power_profile]


# for i, ax in enumerate(axs[:, 0]):  # Iterate over the first column of subplots
    
#     # Find periods with value changes
#     value_changes = [j for j in range(1, len(y_values)) if y_values[j] != y_values[j - 1]]
    
#     # Shade the periods with value changes
#     for k in range(0, len(value_changes), 2):
#         start_idx = value_changes[k]
#         end_idx = value_changes[k + 1] if k + 1 < len(value_changes) else len(y_values)
#         start_time = time[start_idx] / 100 -100
#         end_time = time[end_idx - 1] / 100 -100
#         ax.axvspan(start_time, end_time, alpha=0.3, color='gray')




plt.subplots_adjust(left=0.1,
                    bottom=0.1,
                    right=0.9,
                    top=0.9,
                    wspace=0.1,
                    hspace=1.2)

plt.show()

# %% TCV MASS FLOW PLOTS - RAW DATA

fig, axs = plt.subplots(nrows=3, ncols=2, figsize=(10, 5)) 

t_leak = np.arange(len(data_list[0, :, 5]))

axs[0,0].plot(t_leak, data_list[0, :, 5])#, 'r-')
axs[0,0].plot(t_leak, data_list[0, :, 6])#, 'b-')
axs[0,0].plot(t_leak, data_list[0, :, 7])#, 'g-')
axs[0,0].title.set_text(data_ID[0])

axs[0,1].plot(t_leak, data_list[1, :, 5])#, 'r-')
axs[0,1].plot(t_leak, data_list[1, :, 6])#, 'b-')
axs[0,1].plot(t_leak, data_list[1, :, 7])#, 'g-')
axs[0,1].title.set_text(data_ID[1])

axs[1,0].plot(t_leak, data_list[2, :, 5])#, 'r-')
axs[1,0].plot(t_leak, data_list[2, :, 6])#, 'b-')
axs[1,0].plot(t_leak, data_list[2, :, 7])#, 'g-')
axs[1,0].title.set_text(data_ID[2])

axs[1,1].plot(t_leak, data_list[3, :, 5])#, 'r-')
axs[1,1].plot(t_leak, data_list[3, :, 6])#, 'b-')
axs[1,1].plot(t_leak, data_list[3, :, 7])#, 'g-')
axs[1,1].title.set_text(data_ID[3])

axs[2,0].plot(t_leak, data_list[4, :, 5])#, 'r-')
axs[2,0].plot(t_leak, data_list[4, :, 6])#, 'b-')
axs[2,0].plot(t_leak, data_list[4, :, 7])#, 'g-')
axs[2,0].title.set_text(data_ID[4])

axs[2,1].plot(t_leak, data_list[5, :, 5])#, 'r-')
axs[2,1].plot(t_leak, data_list[5, :, 6])#, 'b-')
axs[2,1].plot(t_leak, data_list[5, :, 7])#, 'g-')
axs[2,1].title.set_text(data_ID[5])

plt.subplots_adjust(left=0.1,
                    bottom=0.1,
                    right=0.9,
                    top=0.9,
                    wspace=0.1,
                    hspace=1.2)

plt.show()

# %% TCV MASS FLOW PLOTS - NORMALIZED AND FILTERED 

fig, axs = plt.subplots(nrows=3, ncols=2, figsize=(10, 5)) 

t_leak = np.arange(len(data_list[0, :, 5]))

axs[0,0].plot(t_leak, data_filtered[0, :, 5])#, 'r-')
axs[0,0].plot(t_leak, data_filtered[0, :, 6])#, 'b-')
axs[0,0].plot(t_leak, data_filtered[0, :, 7])#, 'g-')
axs[0,0].title.set_text(data_ID[0])

axs[0,1].plot(t_leak, data_filtered[1, :, 5])#, 'r-')
axs[0,1].plot(t_leak, data_filtered[1, :, 6])#, 'b-')
axs[0,1].plot(t_leak, data_filtered[1, :, 7])#, 'g-')
axs[0,1].title.set_text(data_ID[1])

axs[1,0].plot(t_leak, data_filtered[2, :, 5])#, 'r-')
axs[1,0].plot(t_leak, data_filtered[2, :, 6])#, 'b-')
axs[1,0].plot(t_leak, data_filtered[2, :, 7])#, 'g-')
axs[1,0].title.set_text(data_ID[2])

axs[1,1].plot(t_leak, data_filtered[3, :, 5])#, 'r-')
axs[1,1].plot(t_leak, data_filtered[3, :, 6])#, 'b-')
axs[1,1].plot(t_leak, data_filtered[3, :, 7])#, 'g-')
axs[1,1].title.set_text(data_ID[3])

axs[2,0].plot(t_leak, data_filtered[4, :, 5])#, 'r-')
axs[2,0].plot(t_leak, data_filtered[4, :, 6])#, 'b-')
axs[2,0].plot(t_leak, data_filtered[4, :, 7])#, 'g-')
axs[2,0].title.set_text(data_ID[4])

axs[2,1].plot(t_leak, data_filtered[5, :, 5])#, 'r-')
axs[2,1].plot(t_leak, data_filtered[5, :, 6])#, 'b-')
axs[2,1].plot(t_leak, data_filtered[5, :, 7])#, 'g-')
axs[2,1].title.set_text(data_ID[5])

plt.subplots_adjust(left=0.1,
                    bottom=0.1,
                    right=0.9,
                    top=0.9,
                    wspace=0.1,
                    hspace=1.2)

plt.show()


# %% bar charts with sum of residuals for each variables

residuals_per_variables = np.sum((residuals), axis=1)


fig, axs = plt.subplots(nrows=3, ncols=2, figsize=(15, 5)) 

t_leak = np.arange(len(data_list[0, :, 5]))

axs[0,0].bar(var_list_abrv, residuals_per_variables[0])
axs[0,0].title.set_text(data_ID[0])

axs[0,1].bar(var_list_abrv, residuals_per_variables[1])
axs[0,1].title.set_text(data_ID[1])

axs[1,0].bar(var_list_abrv, residuals_per_variables[2])
axs[1,0].title.set_text(data_ID[2])

axs[1,1].bar(var_list_abrv, residuals_per_variables[3])
axs[1,1].title.set_text(data_ID[3])

axs[2,0].bar(var_list_abrv, residuals_per_variables[4])
axs[2,0].title.set_text(data_ID[4])

axs[2,1].bar(var_list_abrv, residuals_per_variables[5])
axs[2,1].title.set_text(data_ID[5])

plt.subplots_adjust(left=0.1,
                    bottom=0.1,
                    right=0.9,
                    top=0.9,
                    wspace=0.1,
                    hspace=1.2)

plt.show()

# %% PLOTS SHOWING CUM SUM OF THE RESIDUALS THRU THE SIMULATION

fig, axs = plt.subplots(nrows=4, ncols=2, figsize=(20, 8)) 

tt = np.arange(residuals.shape[1])

axs[0,0].plot(tt, np.cumsum(residuals[0,:,0]), label='HPT')
axs[0,0].plot(tt, np.cumsum(residuals[0,:,2]), label='TCV_Y')
axs[0,0].plot(tt, np.cumsum(residuals[0,:,-1]), label='SGP')
axs[0,0].title.set_text(data_ID[0])
axs[0,0].legend()

axs[0,1].plot(tt, np.cumsum(residuals[1,:,2]), label='TCV_Y')
axs[0,1].plot(tt, np.cumsum(residuals[1,:,4]), label='CONDENSER')
axs[0,1].title.set_text(data_ID[1])
axs[0,1].legend()

axs[1,0].plot(tt, np.cumsum(residuals[2,:,2]), label='TCV_Y')
axs[1,0].plot(tt, np.cumsum(residuals[2,:,4]), label='CONDENSER')
axs[1,0].title.set_text(data_ID[2])
axs[1,0].legend()

axs[1,1].plot(tt, np.cumsum(residuals[3,:,2]), label='TCV_Y')
axs[1,1].plot(tt, np.cumsum(residuals[3,:,4]), label='CONDENSER')
axs[1,1].title.set_text(data_ID[3])
axs[1,1].legend()

axs[2,0].plot(tt, np.cumsum(residuals[4,:,0]), label='HPT')
axs[2,0].plot(tt, np.cumsum(residuals[4,:,2]), label='TCV_Y')
axs[2,0].title.set_text(data_ID[4])
axs[2,0].legend()

axs[2,1].plot(tt, np.cumsum(residuals[5,:,0]), label='HPT')
axs[2,1].plot(tt, np.cumsum(residuals[5,:,2]), label='TCV_Y')
axs[2,1].title.set_text(data_ID[5])
axs[2,1].legend()

axs[3,0].plot(tt, np.cumsum(residuals[4,:,0]), label='TCV1')
axs[3,0].plot(tt, np.cumsum(residuals[4,:,2]), label='TCV2')
axs[3,0].plot(tt, np.cumsum(residuals[4,:,0]), label='TCV3')
axs[3,0].title.set_text(data_ID[4])
axs[3,0].legend()

axs[3,1].plot(tt, np.cumsum(residuals[5,:,0]), label='TCV1')
axs[3,1].plot(tt, np.cumsum(residuals[5,:,2]), label='TCV2')
axs[3,1].plot(tt, np.cumsum(residuals[5,:,0]), label='TCV3')
axs[3,1].title.set_text(data_ID[5])
axs[3,1].legend()

plt.subplots_adjust(left=0.1,
                    bottom=0.1,
                    right=0.9,
                    top=0.9,
                    wspace=0.1,
                    hspace=1.2)

plt.show()



# %% bar charts with # of fault calls on each variables

residuals_per_variables = np.sum((SST_fault_pred), axis=1)
var_list_abrv = var_list = ['HPT', 'LPT',
            'TCV_Y', 'TCV_P', 'Cond Inv', 
            'TCV_1', 'TCV_2 ', 'TCV_3 ','SGP']

fig, axs = plt.subplots(nrows=3, ncols=2, figsize=(15, 5)) 

t_leak = np.arange(len(data_list[0, :, 5]))

axs[0,0].bar(var_list_abrv, residuals_per_variables[0])
axs[0,0].title.set_text(data_ID[0])

axs[0,1].bar(var_list_abrv, residuals_per_variables[1])
axs[0,1].title.set_text(data_ID[1])

axs[1,0].bar(var_list_abrv, residuals_per_variables[2])
axs[1,0].title.set_text(data_ID[2])

axs[1,1].bar(var_list_abrv, residuals_per_variables[3])
axs[1,1].title.set_text(data_ID[3])

axs[2,0].bar(var_list_abrv, residuals_per_variables[4])
axs[2,0].title.set_text(data_ID[4])

axs[2,1].bar(var_list_abrv, residuals_per_variables[5])
axs[2,1].title.set_text(data_ID[5])

plt.subplots_adjust(left=0.1,
                    bottom=0.1,
                    right=0.9,
                    top=0.9,
                    wspace=0.1,
                    hspace=1.2)

plt.show()

# %% CONDENSER INVENTORY PLOTS 

fig, axs = plt.subplots(nrows=3, ncols=2, figsize=(10, 5)) 

t_leak = np.arange(len(data_list[0, :, 4]))

# axs[0,0].plot(t_leak, data_list[0, :, 4])
# axs[0,0].plot(t_leak, data_filtered[0, :, 4])
axs[0,0].plot(t_leak, data_filtered[0, :, 4]/data_filtered[0, :, 4])
axs[0,0].title.set_text(data_ID[0])

# axs[0,1].plot(t_leak, data_list[1, :, 4])
# axs[0,1].plot(t_leak, data_filtered[1, :, 4])
axs[0,1].plot(t_leak, data_filtered[1, :, 4]/ data_filtered[1, :, 4])
axs[0,1].title.set_text(data_ID[1])

# axs[1,0].plot(t_leak, data_list[2, :, 4])
# axs[1,0].plot(t_leak, data_filtered[2, :, 4])
axs[1,0].plot(t_leak, data_filtered[2, :, 4]/data_filtered[0, :, 4])
axs[1,0].title.set_text(data_ID[2])

# axs[1,1].plot(t_leak, data_list[3, :, 4])
# axs[1,1].plot(t_leak, data_filtered[3, :, 4])
axs[1,1].plot(t_leak, data_filtered[3, :, 4]/ data_filtered[1, :, 4])
axs[1,1].title.set_text(data_ID[3])

# axs[2,0].plot(t_leak, data_list[4, :, 4])
# axs[2,0].plot(t_leak, data_filtered[4, :, 4])
axs[2,0].plot(t_leak, data_filtered[4, :, 4]/data_filtered[0, :, 4])
axs[2,0].title.set_text(data_ID[4])

# axs[2,1].plot(t_leak, data_list[5, :, 4])
# axs[2,1].plot(t_leak, data_filtered[5, :, 4])
axs[2,1].plot(t_leak, data_filtered[5, :, 4]/ data_filtered[1, :, 4])
axs[2,1].title.set_text(data_ID[5])

plt.subplots_adjust(left=0.1,
                    bottom=0.1,
                    right=0.9,
                    top=0.9,
                    wspace=0.1,
                    hspace=1.2)

plt.show()





















# %% cumsum

residuals_cumsum = np.cumsum(residuals, axis=1)

# residual_diff_pct = np.diff(residuals_cumsum, axis=1)

# residual_diff_pct = np.zeros_like(residuals_cumsum)
# residual_first_time = np.zeros_like(residuals_cumsum)*residuals[:,:, 0]


# for data in range(residuals_cumsum.shape[0]):
#     for time in range(residuals_cumsum.shape[1]):
#         residual_diff_pct = residuals_cumsum[data, time, :] - residuals[data, time, 0]



t_res = np.arange(residuals_cumsum.shape[1])

for data in range(residuals_cumsum.shape[0]):
    plt.figure(data)
    plt.title(data_ID[data])
    for var in range(residuals_cumsum.shape[2]):
    
        plt.plot(t_res, residuals_cumsum[data,:,var], label = var_list[var])
    plt.legend()
    plt.show()

# %% plot individual variables to determine fuzzy def

fig, axs = plt.subplots(nrows=3, ncols=2, figsize=(20, 8)) 

tt = np.arange(residuals.shape[1])

desired_var = 2

axs[0,0].plot(tt, np.cumsum(residuals[0,:,desired_var]), label='HPT')
axs[0,0].title.set_text(data_ID[0])
axs[0,0].legend()

axs[0,1].plot(tt, np.cumsum(residuals[1,:,desired_var]), label='TCV_Y')
axs[0,1].title.set_text(data_ID[1])
axs[0,1].legend()

axs[1,0].plot(tt, np.cumsum(residuals[2,:,desired_var]), label='TCV_Y')
axs[1,0].title.set_text(data_ID[2])
axs[1,0].legend()

axs[1,1].plot(tt, np.cumsum(residuals[3,:,desired_var]), label='TCV_Y')
axs[1,1].title.set_text(data_ID[3])
axs[1,1].legend()

axs[2,0].plot(tt, np.cumsum(residuals[4,:,desired_var]), label='HPT')
axs[2,0].title.set_text(data_ID[4])
axs[2,0].legend()

axs[2,1].plot(tt, np.cumsum(residuals[5,:,desired_var]), label='HPT')
axs[2,1].title.set_text(data_ID[5])
axs[2,1].legend()

plt.subplots_adjust(left=0.1,
                    bottom=0.1,
                    right=0.9,
                    top=0.9,
                    wspace=0.1,
                    hspace=1.2)

plt.show()



# %% calculate residual slopes


residuals_slope = np.zeros_like(residuals)

for time in range(len(residuals[0,:,0])-2):
    
    # residuals_slope[:, time + 1, :] = (residuals[:, time + 1, :] - residuals[:, time, :]) / residuals[:, time, :]
    residuals_slope[:, time + 1, :] = (residuals[:, time + 1, :] - residuals[:, 0, :]) / residuals[:, 0, :]
    # print(time, residuals_slope[0, time, :])


t_res = np.arange(residuals_slope.shape[1])

for data in range(residuals_slope.shape[0]):
    plt.figure(data)
    for var in range(residuals_slope.shape[2]):
    
        plt.plot(t_res, residuals_slope[data,:,var], label = var_list[var])
        # plt.ylim(-10, 10)
    plt.legend()
    plt.show()

# %% plot residual variable values

for var in range(residuals_slope.shape[2]):
    plt.figure()
    title = 'Variable = ' + var_list[var]
    plt.title(title)
    for data_set in range(residuals_slope.shape[0]):
        plt.plot(t_res, residuals_slope[data_set, :, var], label = data_ID[data_set])
        # plt.ylim(-100, 100)
    plt.legend()
    plt.show()







# %% **** needs to go before new fuzzy **** + plotting

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

sum_of_prev_t_res = np.zeros_like(residuals)

num_files = 6
time = 11898
num_vars = 9

num_backtrack_steps = 1000

for t in range(time):
    # Calculate the start and end indices for the current summation
    start_index = max(0, t - num_backtrack_steps + 1)
    end_index = t + 1

    # Perform the cumulative sum for each file and variable
    for file_idx in range(num_files):
        for var_idx in range(num_vars):
            sum_of_prev_t_res[file_idx, t, var_idx] = np.sum(residuals[file_idx, start_index:end_index, var_idx])

fig, axs = plt.subplots(2, 3, figsize=(15, 8))  # 2 rows, 3 columns

# time = 11898

for file_idx, ax in enumerate(axs.flatten()):
    # Plot the data for the current file
    for i in range(num_vars):
        ax.plot(np.arange(time), sum_of_prev_t_res[file_idx, :, i], label = var_list_abrv[i])
    ax.set_title(data_ID[file_idx])
    
    ax.set_ylabel('Current Res Sum')

# Adjust subplot layout for better spacing
plt.tight_layout()
plt.legend(bbox_to_anchor=(1.0, 1.2))
# Show the plots
plt.show()

fig, axs = plt.subplots(3, 3, figsize=(15, 15))

for var_idx, ax in enumerate(axs.flatten()):
    # Plot the variable from each data file
    for file_idx in range(num_files):
        ax.plot(np.arange(time), sum_of_prev_t_res[file_idx, :, var_idx], label=data_ID[file_idx])
    ax.set_title(var_list[var_idx])
    ax.set_xlabel('Time')
    ax.set_ylabel('Value')

# Adjust subplot layout for better spacing
plt.tight_layout()
plt.legend(bbox_to_anchor=(1.0, 1.2))
plt.show()



#%% [NEW]       F U U U Z Z Z Z Z Y

fill_HPT     = np.arange(-300, 300, 0.1)
fill_LPT     = np.arange(-300, 300, 0.1)
fill_TCVY    = np.arange(-300, 300, 0.1)
fill_TCVP    = np.arange(-300, 300, 0.1)
fill_CondInv = np.arange(-300, 300, 0.1)
fill_TCV1    = np.arange(-300, 300, 0.1)
fill_TCV2    = np.arange(-300, 300, 0.1)
fill_TCV3    = np.arange(-300, 300, 0.1)

# Generate fuzzy membership functions
# format [extreme (0 or 1), top of trap 1, top of trap 2, extreme (0 or 1)]
HPT_pts = np.array([-0.5, -0.2])
HPT_normal = fuzz.trapmf(fill_HPT, [HPT_pts[0], HPT_pts[1], 300, 300])
HPT_low = fuzz.trapmf(fill_HPT, [-300, -300, HPT_pts[0], HPT_pts[1]])

LPT_pts = np.array([-1.5, -1.0])
LPT_normal = fuzz.trapmf(fill_LPT, [LPT_pts[0], LPT_pts[1], 300, 300])
LPT_low = fuzz.trapmf(fill_LPT, [-300, -300, LPT_pts[0], LPT_pts[1]])

TCVY_pts = np.array([-9, -7, -2, -1])
TCVY_high = fuzz.trapmf(fill_TCVY, [TCVY_pts[2], TCVY_pts[3], 300, 300])
TCVY_normal = fuzz.trapmf(fill_TCVY, [TCVY_pts[0], TCVY_pts[1], TCVY_pts[2], TCVY_pts[3]])
TCVY_low = fuzz.trapmf(fill_TCVY, [-300, -300, TCVY_pts[0], TCVY_pts[1]])

TCVP_pts = np.array([-0.5, 0.5])
TCVP_normal = fuzz.trapmf(fill_TCVP, [TCVP_pts[0], TCVP_pts[1], 300, 300])
TCVP_low = fuzz.trapmf(fill_TCVP, [-300, -300, TCVP_pts[0], TCVP_pts[1]])

CondInv_pts = np.array([-6, -4])
CondInv_normal = fuzz.trapmf(fill_CondInv, [CondInv_pts[0], CondInv_pts[1], 300, 300])
CondInv_low = fuzz.trapmf(fill_CondInv, [-300, -300, CondInv_pts[0], CondInv_pts[1]])

TCV_pts = np.array([-1, 0, 2, 3])
TCV1_high = fuzz.trapmf(fill_TCV1, [TCV_pts[2], TCV_pts[3], 300, 300])
TCV1_normal = fuzz.trapmf(fill_TCV1, [TCV_pts[0], TCV_pts[1], TCV_pts[2], TCV_pts[3]])
TCV1_low = fuzz.trapmf(fill_TCV1, [-300, -300, TCV_pts[0], TCV_pts[1]])

TCV2_high = fuzz.trapmf(fill_TCV1, [TCV_pts[2], TCV_pts[3], 300, 300])
TCV2_normal = fuzz.trapmf(fill_TCV1, [TCV_pts[0], TCV_pts[1], TCV_pts[2], TCV_pts[3]])
TCV2_low = fuzz.trapmf(fill_TCV1, [-300, -300, TCV_pts[0], TCV_pts[1]])

TCV3_high = fuzz.trapmf(fill_TCV1, [TCV_pts[2], TCV_pts[3], 300, 300])
TCV3_normal = fuzz.trapmf(fill_TCV1, [TCV_pts[0], TCV_pts[1], TCV_pts[2], TCV_pts[3]])
TCV3_low = fuzz.trapmf(fill_TCV1, [-300, -300, TCV_pts[0], TCV_pts[1]])

def fuzzy(input):

    input_HPT     = input[0]
    input_LPT     = input[1]
    input_TCVY    = input[2]
    input_TCVP    = input[3]
    input_CondInv = input[4]
    input_TCV1    = input[5]
    input_TCV2    = input[6]
    input_TCV3    = input[7]

    ##################################################################################

    # We need the activation of our fuzzy membership functions at these values.
    # The exact values of our inputs do not exist on our universes...
    # This is what fuzz.interp_membership exists for!

    HPT_normal_level = fuzz.interp_membership(fill_HPT, HPT_normal, input_HPT)
    HPT_low_level = fuzz.interp_membership(fill_HPT, HPT_low, input_HPT)

    LPT_normal_level = fuzz.interp_membership(fill_LPT, LPT_normal, input_LPT)
    LPT_low_level = fuzz.interp_membership(fill_LPT, LPT_low, input_LPT)

    TCVY_high_level = fuzz.interp_membership(fill_TCVY, TCVY_high, input_TCVY)
    TCVY_normal_level = fuzz.interp_membership(fill_TCVY, TCVY_normal, input_TCVY)
    TCVY_low_level = fuzz.interp_membership(fill_TCVY, TCVY_low, input_TCVY)

    TCVP_normal_level = fuzz.interp_membership(fill_TCVP, TCVP_normal, input_TCVP)
    TCVP_low_level = fuzz.interp_membership(fill_TCVP, TCVP_low, input_TCVP)

    CondInv_normal_level = fuzz.interp_membership(fill_CondInv, CondInv_normal, input_CondInv)
    CondInv_low_level = fuzz.interp_membership(fill_CondInv, CondInv_low, input_CondInv)

    TCV1_high_level = fuzz.interp_membership(fill_TCV1, TCV1_high, input_TCV1)
    TCV1_normal_level = fuzz.interp_membership(fill_TCV1, TCV1_normal, input_TCV1)
    TCV1_low_level = fuzz.interp_membership(fill_TCV1, TCV1_low, input_TCV1)

    TCV2_high_level = fuzz.interp_membership(fill_TCV2, TCV2_high, input_TCV2)
    TCV2_normal_level = fuzz.interp_membership(fill_TCV2, TCV2_normal, input_TCV2)
    TCV2_low_level = fuzz.interp_membership(fill_TCV2, TCV2_low, input_TCV2)

    TCV3_high_level = fuzz.interp_membership(fill_TCV3, TCV3_high, input_TCV3)
    TCV3_normal_level = fuzz.interp_membership(fill_TCV3, TCV3_normal, input_TCV3)
    TCV3_low_level = fuzz.interp_membership(fill_TCV3, TCV3_low, input_TCV3)

    ##################################################################################

    healthy_sum = HPT_normal_level + LPT_normal_level + TCVY_normal_level + TCVP_normal_level \
        + CondInv_normal_level + TCV1_normal_level + TCV2_normal_level + TCV3_normal_level
    
    leak_sum = HPT_low_level + LPT_low_level + TCVY_low_level + TCVP_low_level \
        + CondInv_low_level + TCV1_low_level + TCV2_low_level + TCV3_low_level 
    
    actuator_sum = HPT_normal_level + LPT_normal_level + TCVY_high_level + TCVP_normal_level \
        + CondInv_normal_level + TCV1_high_level + TCV2_high_level + TCV3_low_level

    max_sum = ''

    if healthy_sum > (leak_sum & actuator_sum):
        max_sum = 'Healthy'
    elif leak_sum > (healthy_sum & actuator_sum):
        max_sum = 'Leaking TCV'
    elif leak_sum > (healthy_sum & actuator_sum):
        max_sum = 'Actuator Failure'
    else:
        max_sum = 'Inconclusive'

    return healthy_sum, leak_sum, actuator_sum

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

time = 11898

fuzzy_results = np.zeros((num_files, time, 3))


for data_files in range(len(data_ID)): 
    for t in range(time): 
        fuzzy_input = sum_of_prev_t_res[data_files, t, :]
        fuzzy_results[data_files, t, :] = fuzzy(fuzzy_input)

time = 11898

fig, axs = plt.subplots(2, 3, figsize=(15, 10))  # 2 rows, 3 columns

# Names for the results
result_names = ["Healthy", "Leak", "Actuator"]

# Loop through the data files
for file_idx in range(num_files):
    # Loop through the results (Leak, Actuator, Healthy)
    for result_idx in range(3):
        ax = axs[file_idx // 3, file_idx % 3]  # Determine the subplot for this result

        # Plot the result from fuzzy_results
        ax.plot(np.arange(time), fuzzy_results[file_idx, :, result_idx], label=result_names[result_idx])

        # Set title for the subplot based on the data file
        ax.set_title(data_ID[file_idx])

        # Set labels for the x and y axes
        ax.set_xlabel('Time')
        ax.set_ylabel('Value')

# Adjust subplot layout for better spacing
plt.tight_layout()

# Show the plots
plt.legend(bbox_to_anchor=(1.0, 1.7))
plt.show()



# %% plot new MEMBERSHIP FUNCTIONS



def plot_membership(ax, title, x_range, *membership_functions):
    ax.set_title(title)
    ax.set_xlim(x_range)
    
    for mf, label in membership_functions:
        ax.plot(fill_HPT, mf, label=label)
    
    ax.legend()

fig, axs = plt.subplots(2, 4, figsize=(12, 6))

# Set the common x-axis range
x_range = (-5,5)

# Plot membership functions using the function
plot_membership(axs[0, 0], 'HPT', (-1, 1), (HPT_normal, 'Normal'), (HPT_low, 'Low'))
plot_membership(axs[0, 1], 'LPT', (-3, 1), (LPT_normal, 'Normal'), (LPT_low, 'Low'))
plot_membership(axs[0, 2], 'TCVY Position', (-12, 4), (TCVY_high, 'High'), (TCVY_normal, 'Normal'), (TCVY_low, 'Low'))
plot_membership(axs[0, 3], 'CondInv', (-8, -2), (CondInv_normal, 'Normal'), (CondInv_low, 'Low'))
plot_membership(axs[1, 0], 'TCV1', x_range, (TCV1_high, 'High'), (TCV1_normal, 'Normal'), (TCV1_low, 'Low'))
plot_membership(axs[1, 1], 'TCV2', x_range, (TCV2_high, 'High'), (TCV2_normal, 'Normal'), (TCV2_low, 'Low'))
plot_membership(axs[1, 2], 'TCV3', x_range, (TCV3_high, 'High'), (TCV3_normal, 'Normal'), (TCV3_low, 'Low'))
plot_membership(axs[1, 3], 'TCVP', x_range, (TCVP_normal, 'Normal'), (TCVP_low, 'Low'))

# Adjust spacing between subplots
plt.tight_layout()

# Display the subplots
plt.show()

# %%
