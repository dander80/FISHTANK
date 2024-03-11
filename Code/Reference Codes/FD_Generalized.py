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


def SPRT(m, v, e, method='default', thresh=None):
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

