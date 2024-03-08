#%% IMPORTS
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.gridspec import GridSpec
from tensorflow import keras
from keras import layers
from scipy.signal import savgol_filter
import scipy.io
import skfuzzy as fuzz 
import skfuzzy.membership as mf

#%% LOAD DATA
# ================================ load in data ===================================

file_names = ['healthy_LF', 'healthy_SS', 'leak_LF', 'leak_SS', 'actuator_LF', 'actuator_SS', 'fwp_LF', 'fwp_SS']

folder = '/Users/davidanderson/NUKE/UGR/NNAE/'

power_profile = np.loadtxt(folder+'data/power_profile.csv', delimiter=',')
power_profile = power_profile[0:-1,] 

training_data = scipy.io.loadmat(folder+'data/training_matlab.mat')
training_data = training_data['newdata']

validation_data = scipy.io.loadmat(folder+'data/validation_matlab.mat')
validation_data = validation_data['newdata']


residuals_data = scipy.io.loadmat(folder+'data/residuals_matlab.mat')
residuals_data = residuals_data['newdata']

# FWP_LF = scipy.io.loadmat(folder+'data/noisy_LF_FWP_5pct.mat')
# FWP_LF = FWP_LF['newdata']

# FWP_SS = scipy.io.loadmat(folder+'data/noisy_SS_FWP_5pct.mat')
# FWP_SS = FWP_SS['newdata']

FWP_LF  = np.loadtxt(folder+'data/noisy_LF_FWP_5pct_2.csv', delimiter=',')
FWP_SS  = np.loadtxt(folder+'data/noisy_SS_FWP_5pct_2.csv', delimiter=',')


leak_LF = scipy.io.loadmat(folder+'data/leak_LF_noisy.mat')
leak_LF = leak_LF['newdata']
actuator_LF = scipy.io.loadmat(folder+'data/__actuator_LF_noisy.mat')
actuator_LF = actuator_LF['newdata']

healthy_LF  = np.loadtxt(folder+'data/LF_healthy_new.csv', delimiter=',')
healthy_SS  = np.loadtxt(folder+'data/SS_healthy_new.csv', delimiter=',')
# leak_LF     = np.loadtxt('data/LF_leak_new.csv', delimiter=',')
leak_SS     = np.loadtxt(folder+'data/SS_leak_new.csv', delimiter=',')
# actuator_LF = np.loadtxt('data/LF_actuator_new.csv', delimiter=',')
actuator_SS = np.loadtxt(folder+'data/SS_actuator_new.csv', delimiter=',')

length = len(healthy_SS)-200
start_val = 300
file_length = length-start_val
t = np.arange(file_length)

healthy_LF  = healthy_LF[start_val:length, :]
healthy_SS  = healthy_SS[start_val:length, :]
leak_LF     = leak_LF[start_val:length, :]
leak_SS     = leak_SS[start_val:length, :]
actuator_LF = actuator_LF[start_val:length, :]
actuator_SS = actuator_SS[start_val:length, :]
FWP_LF     = FWP_LF[start_val:length, :]
FWP_SS     = FWP_SS[start_val:length, :]

training_data = training_data[start_val:, :]
validation_data = validation_data[start_val:, :]
residuals_data = residuals_data[start_val:, :]

print('Data loaded in')

# ================================ arrange data ===================================

data_list = np.stack([healthy_LF, healthy_SS, leak_LF, leak_SS, actuator_LF, actuator_SS, FWP_LF, FWP_SS])
# data_ID   = ['healthy_LF', 'healthy_SS', 'leak_LF', 'leak_SS', 'actuator_LF', 'actuator_SS']
data_ID   = ['Healthy LF', 'Healthy SS', 'Leak LF', 'Leak SS', 'Actuator LF', 'Actuator SS', 'FWP LF', 'FWP SS']

var_list = ['high pressure turbine power output', 'low pressure turbine power output',
            'turbine control valve controller', 'TCV pressure', 'condenser inventory', 
            'TCV 1 mass flow rate', 'TCV 2 mass flow rate', 'TCV 3 mass flow rate','SG Pressure']

var_list_abrv  = ['HPT', 'LPT',
            'TCV_Y', 'TCV_P', 'Cond Inv', 
            'TCV_1', 'TCV_2 ', 'TCV_3 ','SGP']

avg_vals = np.average(data_list[1,:,:], axis=0) 

print('Data sorted')

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

training_data_filtered[:,2] = training_data[:,2]
validation_data_filtered[:,2] = validation_data[:,2]
residuals_data_filtered[:,2] = residuals_data[:,2]

print('Pre-Processing Finished: data normalized and filtered')


#%% TRAIN THE MODEL
# ================================ train the model ===================================

x_train = training_data_filtered

x_val = validation_data_filtered

model = keras.Sequential(
    [
        layers.Dense(4,input_shape=(9,),activation='selu'), # input layer
        layers.Dense(1, activation='selu'), # encoded layer  
        layers.Dense(3, activation='selu'), # encoded layer
        layers.Dense(9, activation='selu')
        # 
        # layers.Dense(1,input_shape=(9,),activation='selu'),
        # layers.Dense(9, activation='selu')
        # 
        # layers.Dense(6,input_shape=(9,),activation='selu'),
        # layers.Dense(3, activation='selu'),
        # layers.Dense(1, activation='selu'),
        # # layers.Dense(6, activation='selu'),
        # layers.Dense(9, activation='selu')
    ])

model.compile(loss='mean_absolute_error', optimizer='adam') 

training_history = model.fit(x=x_train, y=x_train, validation_data=(x_val, x_val), epochs=25, verbose=1)

print('\nModel trained')

training_residuals = x_train - model(x_train)
validation_residuals = x_val - model(x_val)
residuals_residuals = residuals_data_filtered - model(residuals_data_filtered)

residuals = np.zeros(normed_data.shape)

# model.save("model.keras")
# loaded_model = tf.keras.saving.load_model("model.keras")

#%% FIND LOW/HIGH CUTOFFS FROM RESIDUALS DATA

num_backtrack_steps = 1000
res_cum_sum = np.zeros_like(residuals_residuals)
res_for_cum_sum = np.array(residuals_residuals)

for ii in t:
    start_index = max(0, ii - num_backtrack_steps + 1)
    end_index = ii + 1
    # Perform the cumulative sum for each file and variable
    for var_idx in range(len(var_list)):
        res_cum_sum[ii, var_idx] = np.sum(res_for_cum_sum[start_index:end_index, var_idx])

HPT_pts_mm     = [min(res_cum_sum[:, 0]), min(res_cum_sum[:, 0])+np.std(res_cum_sum[:, 0])/4, \
                    max(res_cum_sum[:, 0])-np.std(res_cum_sum[:, 0])/4, max(res_cum_sum[:, 0])]
LPT_pts_mm     = [min(res_cum_sum[:, 1]), min(res_cum_sum[:, 1])+np.std(res_cum_sum[:, 1])/4, \
                    max(res_cum_sum[:, 1])-np.std(res_cum_sum[:, 1])/4, max(res_cum_sum[:, 1])]
TCVY_pts_mm    = [min(res_cum_sum[:, 2]), min(res_cum_sum[:, 2])+np.std(res_cum_sum[:, 2])/4, \
                    max(res_cum_sum[:, 2])-np.std(res_cum_sum[:, 2])/4, max(res_cum_sum[:, 2])]
TCVP_pts_mm    = [min(res_cum_sum[:, 3]), min(res_cum_sum[:, 3])+np.std(res_cum_sum[:, 3])/4, \
                    max(res_cum_sum[:, 3])-np.std(res_cum_sum[:, 3])/4, max(res_cum_sum[:, 3])]
CondInv_pts_mm = [min(res_cum_sum[:, 4]), min(res_cum_sum[:, 4])+np.std(res_cum_sum[:, 4])/4, \
                    max(res_cum_sum[:, 4])-np.std(res_cum_sum[:, 4])/4, max(res_cum_sum[:, 4])]
TCV_pts_mm     = [min(res_cum_sum[:, 5]), min(res_cum_sum[:, 5])+np.std(res_cum_sum[:, 5])/4, \
                    max(res_cum_sum[:, 5])-np.std(res_cum_sum[:, 5])/4, max(res_cum_sum[:, 5])]

#%% DEFINE FUNCTIONS

##################################################################################
################################## SST ###########################################
##################################################################################

# SST_thresh = 3 * np.std(validation_residuals, axis=0)
SST_thresh = 5 * np.std(residuals_residuals, axis=0)
ones = np.ones([1,9])
def SST(input):
    return (input >= ones * SST_thresh) | (input <= -1 * ones * SST_thresh)

##################################################################################
################################## SPRT ##########################################
##################################################################################

# mean        = np.mean(validation_residuals, axis=0)
# variance    = np.var(validation_residuals, axis=0)
# SPRT_thresh = 6*np.std(validation_residuals, axis=0)
mean        = np.mean(residuals_residuals, axis=0)
variance    = np.var(residuals_residuals, axis=0)
SPRT_thresh = 8*np.std(residuals_residuals, axis=0)
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

def check_SPRT(input):
    fault_pred = np.zeros_like(input)
    for var in range(len(var_list)):
        fault_pred[var] = SPRT(mean[var], variance[var], input[var], 'default', SPRT_thresh[var])
    return fault_pred

##################################################################################
################################## FUZZY #########################################
##################################################################################

if __name__ == "__main__":
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

    # HPT_pts = np.array([-0.5, -0.2])
    HPT_pts = HPT_pts_mm[:2]
    HPT_normal = fuzz.trapmf(fill_HPT, [HPT_pts[0], HPT_pts[1], 300, 300])
    HPT_low = fuzz.trapmf(fill_HPT, [-300, -300, HPT_pts[0], HPT_pts[1]])

    # LPT_pts = np.array([-2.5, -1.0])
    LPT_pts = LPT_pts_mm[:2]
    LPT_normal = fuzz.trapmf(fill_LPT, [LPT_pts[0], LPT_pts[1], 300, 300])
    LPT_low = fuzz.trapmf(fill_LPT, [-300, -300, LPT_pts[0], LPT_pts[1]])

    # TCVY_pts = np.array([-9, -7, 0, 1])
    TCVY_pts = TCVY_pts_mm
    TCVY_high = fuzz.trapmf(fill_TCVY, [TCVY_pts[2], TCVY_pts[3], 300, 300])
    TCVY_normal = fuzz.trapmf(fill_TCVY, [TCVY_pts[0], TCVY_pts[1], TCVY_pts[2], TCVY_pts[3]])
    TCVY_low = fuzz.trapmf(fill_TCVY, [-300, -300, TCVY_pts[0], TCVY_pts[1]])

    # TCVP_pts    = np.array([-1.2, -0.5])
    TCVP_pts = TCVP_pts_mm[:2]
    TCVP_normal = fuzz.trapmf(fill_TCVP, [TCVP_pts[0], TCVP_pts[1], 300, 300])
    TCVP_low    = fuzz.trapmf(fill_TCVP, [-300, -300, TCVP_pts[0], TCVP_pts[1]])

    # CondInv_pts = np.array([-6, -4, 5.5, 7.5])
    CondInv_pts = CondInv_pts_mm
    CondInv_high   = fuzz.trapmf(fill_CondInv, [CondInv_pts[2], CondInv_pts[3], 300, 300])
    CondInv_normal = fuzz.trapmf(fill_CondInv, [CondInv_pts[0], CondInv_pts[1], CondInv_pts[2], CondInv_pts[3]])
    CondInv_low    = fuzz.trapmf(fill_CondInv, [-300, -300, CondInv_pts[0], CondInv_pts[1]])

    # TCV_pts = np.array([-2, -1, 2, 3])
    TCV_pts = TCV_pts_mm
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

    HPT_normal_level = fuzz.interp_membership(fill_HPT, HPT_normal, input_HPT)
    HPT_low_level = fuzz.interp_membership(fill_HPT, HPT_low, input_HPT)

    LPT_normal_level = fuzz.interp_membership(fill_LPT, LPT_normal, input_LPT)
    LPT_low_level = fuzz.interp_membership(fill_LPT, LPT_low, input_LPT)

    TCVY_high_level = fuzz.interp_membership(fill_TCVY, TCVY_high, input_TCVY)
    TCVY_normal_level = fuzz.interp_membership(fill_TCVY, TCVY_normal, input_TCVY)
    TCVY_low_level = fuzz.interp_membership(fill_TCVY, TCVY_low, input_TCVY)

    TCVP_normal_level = fuzz.interp_membership(fill_TCVP, TCVP_normal, input_TCVP)
    TCVP_low_level = fuzz.interp_membership(fill_TCVP, TCVP_low, input_TCVP)

    CondInv_high_level = fuzz.interp_membership(fill_CondInv, CondInv_high, input_CondInv)
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

    healthy_sum = (HPT_normal_level + LPT_normal_level + TCVY_normal_level + TCVP_normal_level \
        + CondInv_normal_level + TCV1_normal_level + TCV2_normal_level + TCV3_normal_level)/8
    
    leak_sum = (HPT_low_level + LPT_low_level + TCVP_low_level \
        + CondInv_low_level + TCV1_low_level + TCV2_low_level + TCV3_low_level)/7
    
    actuator_sum = (HPT_normal_level + LPT_normal_level + TCVY_high_level + TCVP_normal_level \
        + CondInv_normal_level + TCV1_high_level + TCV2_high_level + TCV3_low_level)/8

    FWP_sum = (HPT_low_level + CondInv_high_level + TCVY_low_level)/3

    return healthy_sum, leak_sum, actuator_sum, FWP_sum

##################################################################################
################################## PLOTTER #######################################
##################################################################################

def plot_data(SST, SPRT, fuzzy, data, plot_title, prev_res):

    fig = plt.figure(figsize=(17, 18))
    gs_fault = GridSpec(14, 3,top=1.0, hspace=0)  
    gs_fuzzy = GridSpec(14, 3, top=0.93, hspace=0) 
    gs = GridSpec(14, 3, top=0.87) #

    # fig.suptitle(plot_title, fontsize = 25, y= 1.04)

    FAULT = fig.add_subplot(gs_fault[0:2, :])
    PCT   = fig.add_subplot(gs_fault[2, :], sharex = FAULT)

    FUZZ  = fig.add_subplot(gs_fuzzy[3:5, :])
    FUZZ2 = fig.add_subplot(gs_fuzzy[5, :], sharex = FUZZ)

    HPT   = fig.add_subplot(gs[7:8, 0])
    LPT   = fig.add_subplot(gs[7:8, 1])
    CI    = fig.add_subplot(gs[7:8, 2])
    TCVY  = fig.add_subplot(gs[9:10, 0])
    TCVP  = fig.add_subplot(gs[9:10, 1])
    SGP   = fig.add_subplot(gs[9:10, 2])
    TCV1  = fig.add_subplot(gs[11:12, 0])
    TCV2  = fig.add_subplot(gs[11:12, 1])
    TCV3  = fig.add_subplot(gs[11:12, 2])
    BAR   = fig.add_subplot(gs[13, :])
    #############################################################
    UTorange = '#FF8200'
    SmokeyGray = '#58595B'
    m_size=4
    SST_faults  = np.any(SST, axis=1)
    SPRT_faults = np.any(SPRT, axis=1)
    FAULT.plot(t, 2 + SST_faults, 'o', markersize=m_size, color=UTorange)
    FAULT.plot(t, SPRT_faults, 'o', markersize=m_size, color=SmokeyGray)
    FAULT.title.set_text('FAULT DETECTION')
    FAULT.set_ylim(-0.2,3.2) 
    FAULT.set_yticks([0, 1, 2, 3], labels=["Healthy: SPRT", "Faulted: SPRT", "Healthy: SST", "Faulted: SST"])
    #############################################################
    percent_SST = np.zeros_like(t)
    percent_SPRT = np.zeros_like(t)
    num_backtrack_steps = 1000
    for time in t:
        start = max(0, time - num_backtrack_steps + 1)
        percent_SST[time]  = 100* np.sum(SST_faults[start:time])/(time+1-start)
        percent_SPRT[time] = 100* np.sum(SPRT_faults[start:time])/(time+1-start)
    max_SST_fault_pred = np.max(percent_SST)
    max_SPRT_fault_pred = np.max(percent_SPRT)
    PCT.plot(t, percent_SST, label="SST: Percent Faults", color=UTorange)
    PCT.plot(t, percent_SPRT, label="SPRT: Percent Faults", color=SmokeyGray)
    PCT.set_ylim(-0.5, 100)
    PCT.set_yticks([0,50,100])
    PCT.set_ylabel("Percent of Faults \nOver the Last\n" + str(num_backtrack_steps) + " Data Pts.", rotation=0)
    PCT.yaxis.set_label_coords(-0.074, .37)
    PCT.legend(loc='upper left')
    # PCT.set_title("Percentage of Fault Calls Over the Last " + str(num_backtrack_steps) + " Data Points")
    #############################################################
    FUZZ.set_title("FUZZY LOGIC")
    result_names = ["Healthy", "Leak", "Actuator", "FWP"]
    colors = [UTorange, SmokeyGray, '#0ca4dc', '#cc00ff']
    for result_idx in range(4):
        FUZZ.plot(t, fuzzy[:, result_idx], label=result_names[result_idx], color=colors[result_idx])
    FUZZ.legend()
    FUZZ.set_ylabel("Fuzzy Logic\nMemberships", rotation=0)
    FUZZ.yaxis.set_label_coords(-0.07, .5)
    FUZZ.tick_params(labelbottom=False)
    #############################################################
    fuzz2_array = np.zeros((len(t), 4))

    for i in t:
        if SST_faults[i] == 1 or SPRT_faults[i] == 1:
            index = np.array(fuzzy[i]).argmax()
            # print(index)
            # label=result_names[index]
            fuzz2_array[i, index] = 1
            FUZZ2.plot(i, 1, color=colors[index], marker="o", markersize=8)

    plt.setp(FUZZ.get_xticklabels(), visible=False)
    
    plt.subplots_adjust(hspace=0)
    FUZZ2.set_ylim(0.9, 1.1)
    FUZZ2.set_yticks([1], labels=['Fault \nClassification'])
    FUZZ2.legend()
    #############################################################
    green = '#42f578'
    yellow = '#fcf62d'
    red = '#f01a1a'
    m_size_plots = 1
    bkg_alpha = 0.5

    legend_elements = [
    plt.Line2D([0], [0], color=UTorange, alpha=bkg_alpha, lw=2, label='Normalized Data'),
    plt.Line2D([0], [0], color=colors[2], lw=2, label='Residual Sum'),
    plt.Line2D([0], [0], color=green, alpha=bkg_alpha, lw=15, label='Normal'),
    plt.Line2D([0], [0], color=yellow, alpha=bkg_alpha, lw=15, label='Transition Region'),
    plt.Line2D([0], [0], color=red, alpha=bkg_alpha, lw=15, linestyle='--', label='Abnormal')
    ]

    HPT.legend(handles=legend_elements, loc='upper center', bbox_to_anchor=(1.7, 2.0), ncol=5)

    HPT.plot(t, data[:, 0], color=UTorange, markersize = m_size_plots, alpha=bkg_alpha)
    HPT2 = HPT.twinx()
    HPT2.plot(t, prev_res[:, 0], color=colors[2], markersize = m_size_plots) 
    HPT_y_lines = np.average(HPT_pts)
    HPT2.set_yticks([HPT_y_lines])
    HPT2.axhspan(ymin=HPT_pts[1], ymax=max(1, max(prev_res[:, 0])), xmin=0.97, xmax=len(t), color=green, alpha=bkg_alpha)
    HPT2.axhspan(ymin=HPT_pts[0], ymax=HPT_pts[1], xmin=0.97, xmax=len(t), color=yellow, alpha=bkg_alpha)
    HPT2.axhspan(ymin=HPT_pts[0], ymax=min(-1, min(prev_res[:, 0])), xmin=0.97, xmax=len(t), color=red, alpha=bkg_alpha)
    # HPT2.hlines([HPT_y_lines], xmin=0, xmax=len(t), linestyles='dashed', alpha = 0.3)
    HPT.set_title('High Pressure Turbine')

    LPT.plot(t, data[:, 1], color=UTorange, alpha=bkg_alpha, markersize = m_size_plots)
    LPT2 = LPT.twinx()
    LPT_y_lines = np.average(LPT_pts)
    LPT2.set_yticks([LPT_y_lines])
    LPT2.plot(t, prev_res[:, 1], color=colors[2], markersize = m_size_plots) 
    LPT2.axhspan(ymin=LPT_pts[1], ymax=max(1, max(prev_res[:, 1])), xmin=0.97, xmax=len(t), color=green, alpha=bkg_alpha)
    LPT2.axhspan(ymin=LPT_pts[0], ymax=LPT_pts[1], xmin=0.97, xmax=len(t), color=yellow, alpha=bkg_alpha)
    LPT2.axhspan(ymin=LPT_pts[0], ymax=min(-1, min(prev_res[:, 1])), xmin=0.97, xmax=len(t), color=red, alpha=bkg_alpha)
    # LPT2.hlines([LPT_y_lines], xmin=0, xmax=len(t), linestyles='dashed', alpha = 0.3)
    LPT.set_title('Low Pressure Turbine')

    CI.plot(t, data[:, 4], color=UTorange, alpha=bkg_alpha, markersize = m_size_plots)
    CI2 = CI.twinx()
    CI2.plot(t, prev_res[:, 4], color=colors[2], markersize = m_size_plots) 
    CI_y_lines = np.average(CondInv_pts)
    CI2.set_yticks([CI_y_lines])
    CI2.axhspan(ymin=CondInv_pts[3], ymax=max(max(prev_res[:,4]), CondInv_pts[3]), xmin=0.97, xmax=len(t), color=red, alpha=bkg_alpha)
    CI2.axhspan(ymin=CondInv_pts[2], ymax=CondInv_pts[3], xmin=0.97, xmax=len(t), color=yellow, alpha=bkg_alpha)
    CI2.axhspan(ymin=CondInv_pts[1], ymax=CondInv_pts[2], xmin=0.97, xmax=len(t), color=green, alpha=bkg_alpha)
    CI2.axhspan(ymin=CondInv_pts[0], ymax=CondInv_pts[1], xmin=0.97, xmax=len(t), color=yellow, alpha=bkg_alpha)
    CI2.axhspan(ymin=min(CondInv_pts[0], min(prev_res[:,4])), ymax=CondInv_pts[0], xmin=0.97, xmax=len(t), color=red, alpha=bkg_alpha)
    # CI2.axhspan(ymin=CondInv_pts[1], ymax=max(1, max(prev_res[:, 4])), xmin=0.97, xmax=len(t), color=green, alpha=bkg_alpha)
    # CI2.axhspan(ymin=CondInv_pts[0], ymax=CondInv_pts[1], xmin=0.97, xmax=len(t), color=yellow, alpha=bkg_alpha)
    # CI2.axhspan(ymin=min(-7, min(prev_res[:, 4])), ymax=CondInv_pts[0], xmin=0.97, xmax=len(t), color=red, alpha=bkg_alpha)

    # CI2.hlines([CI_y_lines], xmin=0, xmax=len(t), linestyles='dashed', alpha = 0.3)
    CI.set_title("Condenser Inventory")
    #############################################################
    TCVY.plot(t, data[:, 2],  color=UTorange, alpha=bkg_alpha, markersize = m_size_plots)
    TCVY2 = TCVY.twinx()
    TCVY2.plot(t, prev_res[:,2], color=colors[2], markersize = m_size_plots)
    TCVY_y_lines = [np.average(TCVY_pts[0:2]), np.average(TCVY_pts[2:])]
    TCVY2.set_yticks(TCVY_y_lines)
    TCVY2.axhspan(ymin=TCVY_pts[3], ymax=max(max(prev_res[:,2]), 1), xmin=0.97, xmax=len(t), color=red, alpha=bkg_alpha)
    TCVY2.axhspan(ymin=TCVY_pts[2], ymax=TCVY_pts[3], xmin=0.97, xmax=len(t), color=yellow, alpha=bkg_alpha)
    TCVY2.axhspan(ymin=TCVY_pts[1], ymax=TCVY_pts[2], xmin=0.97, xmax=len(t), color=green, alpha=bkg_alpha)
    TCVY2.axhspan(ymin=TCVY_pts[0], ymax=TCVY_pts[1], xmin=0.97, xmax=len(t), color=yellow, alpha=bkg_alpha)
    TCVY2.axhspan(ymin=min(TCVY_pts[0], min(prev_res[:,2])), ymax=TCVY_pts[0], xmin=0.97, xmax=len(t), color=red, alpha=bkg_alpha)
    # TCVY2.hlines(TCVY_y_lines, xmin=0, xmax=len(t), linestyles='dashed', alpha = 0.3)
    TCVY.set_title('TCV Position')

    TCVP.plot(t, data[:, 3], color=UTorange, alpha=bkg_alpha, markersize = m_size_plots)
    TCVP2 = TCVP.twinx()
    TCVP2.plot(t, prev_res[:,3], color=colors[2], markersize = m_size_plots)
    TCVP_y_lines = np.average(TCVP_pts)
    TCVP2.set_yticks([TCVP_y_lines])
    TCVP2.set_ylim(bottom=min(prev_res[:,3]), top=max(prev_res[:,3]))
    TCVP2.axhspan(ymin=TCVP_pts[1], ymax=max(1, max(prev_res[:, 3])), xmin=0.97, xmax=len(t), color=green, alpha=bkg_alpha)
    TCVP2.axhspan(ymin=TCVP_pts[0], ymax=TCVP_pts[1], xmin=0.97, xmax=len(t), color=yellow, alpha=bkg_alpha)
    TCVP2.axhspan(ymin=TCVP_pts[0], ymax=min(-1, min(prev_res[:, 1])), xmin=0.97, xmax=len(t), color=red, alpha=bkg_alpha)
    # TCVP2.hlines([TCVP_y_lines], xmin=0, xmax=len(t), linestyles='dashed', alpha = 0.3)
    TCVP.set_title('TCV Pressure') 

    SGP.plot(t, data[:, 8],  color=UTorange, alpha=bkg_alpha, markersize = m_size_plots)
    SGP.set_title('Steam Generatory Pressure')
    #############################################################
    TCV1.plot(t, data[:, 5], color=UTorange, alpha=bkg_alpha, markersize = m_size_plots)
    TCV1_2 = TCV1.twinx()
    TCV1_2.plot(t, prev_res[:,5], color=colors[2], markersize = m_size_plots)
    TCV_y_lines = [np.average(TCV_pts[0:2]), np.average(TCV_pts[2:])]
    # TCV1_2.hlines(TCV_y_lines, xmin=0, xmax=len(t), linestyles='dashed', alpha = 0.3)
    TCV1_2.axhspan(ymin=TCV_pts[3], ymax=max(max(prev_res[:,5]), 2.5), xmin=0.97, xmax=len(t), color=red, alpha=bkg_alpha)
    TCV1_2.axhspan(ymin=TCV_pts[2], ymax=TCV_pts[3], xmin=0.97, xmax=len(t), color=yellow, alpha=bkg_alpha)
    TCV1_2.axhspan(ymin=TCV_pts[1], ymax=TCV_pts[2], xmin=0.97, xmax=len(t), color=green, alpha=bkg_alpha)
    TCV1_2.axhspan(ymin=TCV_pts[0], ymax=TCV_pts[1], xmin=0.97, xmax=len(t), color=yellow, alpha=bkg_alpha)
    TCV1_2.axhspan(ymin=min(min(prev_res[:,5]), -2.5), ymax=TCV_pts[0], xmin=0.97, xmax=len(t), color=red, alpha=bkg_alpha)
    # TCV1_2.set_ylim(bottom=min(TCV_pts[0], min(prev_res[:,5])), top=max(TCV_pts[-1], max(prev_res[:,5])))
    TCV1.set_title('TCV1 Mass Flow')

    TCV2.plot(t, data[:, 6],  color=UTorange, alpha=bkg_alpha, markersize = m_size_plots)
    TCV2_2 = TCV2.twinx()
    TCV2_2.plot(t, prev_res[:,6], color=colors[2], markersize = m_size_plots)
    TCV_y_lines = [np.average(TCV_pts[0:2]), np.average(TCV_pts[2:])]
    # TCV2_2.hlines(TCV_y_lines, xmin=0, xmax=len(t), linestyles='dashed', alpha = 0.3)
    TCV2_2.axhspan(ymin=TCV_pts[3], ymax=max(max(prev_res[:,6]), 2.5), xmin=0.97, xmax=len(t), color=red, alpha=bkg_alpha)
    TCV2_2.axhspan(ymin=TCV_pts[2], ymax=TCV_pts[3], xmin=0.97, xmax=len(t), color=yellow, alpha=bkg_alpha)
    TCV2_2.axhspan(ymin=TCV_pts[1], ymax=TCV_pts[2], xmin=0.97, xmax=len(t), color=green, alpha=bkg_alpha)
    TCV2_2.axhspan(ymin=TCV_pts[0], ymax=TCV_pts[1], xmin=0.97, xmax=len(t), color=yellow, alpha=bkg_alpha)
    TCV2_2.axhspan(ymin=min(min(prev_res[:,6]), -2.5), ymax=TCV_pts[0], xmin=0.97, xmax=len(t), color=red, alpha=bkg_alpha)
    TCV2.set_title('TCV2 Mass Flow')

    TCV3.plot(t, data[:, 7], color=UTorange, alpha=bkg_alpha, markersize = m_size_plots)
    TCV3_2 = TCV3.twinx()
    TCV3_2.plot(t, prev_res[:,7], color=colors[2], markersize = m_size_plots)
    TCV_y_lines = [np.average(TCV_pts[0:2]), np.average(TCV_pts[2:])]
    # TCV3_2.hlines(TCV_y_lines, xmin=0, xmax=len(t), linestyles='dashed', alpha = 0.3)
    TCV3_2.axhspan(ymin=TCV_pts[3], ymax=max(max(prev_res[:,7]), 2.5), xmin=0.97, xmax=len(t), color=red, alpha=bkg_alpha)
    TCV3_2.axhspan(ymin=TCV_pts[2], ymax=TCV_pts[3], xmin=0.97, xmax=len(t), color=yellow, alpha=bkg_alpha)
    TCV3_2.axhspan(ymin=TCV_pts[1], ymax=TCV_pts[2], xmin=0.97, xmax=len(t), color=green, alpha=bkg_alpha)
    TCV3_2.axhspan(ymin=TCV_pts[0], ymax=TCV_pts[1], xmin=0.97, xmax=len(t), color=yellow, alpha=bkg_alpha)
    TCV3_2.axhspan(ymin=min(min(prev_res[:,7]), -2.5), ymax=TCV_pts[0], xmin=0.97, xmax=len(t), color=red, alpha=bkg_alpha)
    TCV3.set_title('TCV3 Mass Flow')
    #############################################################
    x = np.arange(len(var_list_abrv))
    bar_width = 0.4
    BAR.bar(x - bar_width/2, np.sum(SST, axis=0), width = bar_width, label='SST', color=UTorange)
    BAR.bar(x + bar_width/2, np.sum(SPRT, axis=0), width = bar_width, label='SPRT', color=SmokeyGray)
    BAR.set_xticks(x)
    BAR.set_xticklabels(var_list_abrv)
    BAR.legend()
    BAR.set_title("Which Component Caused the Fault Calls?")
    BAR.set_ylabel("# of fault\npredictions", rotation = 0)
    BAR.yaxis.set_label_coords(-0.08, .5)
    #############################################################
    # Adjust spacing
    plt.tight_layout()

    # Show the plot
    plt.show()

    return max_SST_fault_pred, max_SPRT_fault_pred, fuzz2_array

#%% QUICK RUNS
# for i in range(1):
#     plot_data(SST_results[i], SPRT_results[i], fuzzy_results[i], data_filtered[i], data_ID[i], sum_of_prev_t_res[i])

#%% LOOP THROUGH THE DATA

residuals = np.zeros_like(data_filtered)
SST_results = np.zeros_like(data_filtered)
SPRT_results = np.zeros_like(data_filtered)
sum_of_prev_t_res = np.zeros_like(data_filtered)
fuzzy_results = np.zeros([len(data_ID), len(t), 4])
num_backtrack_steps = 1000 

# for i in range(1):
for i in range(len(data_list)):
# for i in range(len(data_list), 0, -1):
    for ii in t:
        residuals[i, ii, :] = data_filtered[i, ii, :] - model(data_filtered[i, ii:ii+1, :])
        SST_results[i, ii, :] = SST(residuals[i, ii, :])
        # SPRT_results[i, ii, :] = check_SPRT(residuals[i, ii, :])

        start_index = max(0, ii - num_backtrack_steps + 1)
        end_index = ii + 1
        # Perform the cumulative sum for each file and variable
        for var_idx in range(len(var_list)):
            sum_of_prev_t_res[i, ii, var_idx] = np.sum(residuals[i, start_index:end_index, var_idx])

        fuzzy_results[i, ii, :] = fuzzy(sum_of_prev_t_res[i, ii, :])

    # for var in range(len(var_list)):
    # SPRT_results[i, :, :] = check_SPRT(residuals[i, :, :])
    for var in range(len(var_list)):
        SPRT_results[i,:,var] = SPRT(mean[var], variance[var], residuals[i,:,var], 'default', SPRT_thresh[var])

    max_SST_fault_predi, max_SPRT_fault_predi, fuzz_array = plot_data(SST_results[i], SPRT_results[i], fuzzy_results[i], data_filtered[i], data_ID[i], sum_of_prev_t_res[i])
    # fname = file_names[i] + '.png'
    # plt.savefig(fname)
    print("*********** Info Here ***********")
    print(file_names[i])

    print("SST:")
    num_SST_faults_total = np.sum(np.any(SST_results[i], axis=1))
    print("total # faults = ", num_SST_faults_total)
    print("largest % faults over last ", num_backtrack_steps, "data points = ", max_SST_fault_predi, "%")
    print("total % faults = ", 100 * num_SST_faults_total / len(t), "%")

    print("SPRT:")
    num_SPRT_faults_total = np.sum(np.any(SPRT_results[i], axis=1))
    print("total # faults = ", num_SPRT_faults_total)
    print("largest # faults over last ", num_backtrack_steps, "data points = ", max_SPRT_fault_predi, "%")
    print("total % faults = ", 100 * num_SPRT_faults_total / len(t), "%")

    print("FUZZY <3")
    half_sim = int(len(t)/2)
    print("healthy % classifications 1st half: " , 100 * np.sum(fuzz_array[0:half_sim, 0]) / half_sim, "%")
    print("healthy % classifications 2nd half: " , 100 * np.sum(fuzz_array[half_sim:, 0]) / half_sim, "%")
    print("leak % classifications 1st half: "    , 100 * np.sum(fuzz_array[0:half_sim, 1]) / half_sim, "%")
    print("leak % classifications 2nd half: "    , 100 * np.sum(fuzz_array[half_sim:, 1]) / half_sim, "%")
    print("actuator % classifications 1st half: ", 100 * np.sum(fuzz_array[0:half_sim, 2]) / half_sim, "%")
    print("actuator % classifications 2nd half: ", 100 * np.sum(fuzz_array[half_sim:, 2]) / half_sim, "%")
    
#%%