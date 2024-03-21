#%% PACKAGES + NOTES
from __future__ import division, print_function, unicode_literals, absolute_import
import os
from fmpy import simulate_fmu, read_model_description, extract, dump, instantiate_fmu, read_csv, write_csv
import fmpy
# import functions as FISH
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.gridspec import GridSpec
import time 
import random 
# import board
# import busio
# import adafruit_mcp4728
# import Jetson.GPIO as GPIO
# from ads1015 import ADS1015


print('This code is running a FMU model of the FISHTANK System')
print('Valve positions are inputted to the FMU, the resulting')
print('tank levels and mass flow rates are returned and plotted\n')

print("model exchange --> use FMpy as the solver ")
print('co-simulation --> use Dymola solver\n')
print("Packages loaded in successfully\n")
#%% FUNCTIONS
def update_plot(data): 
    global fig, gs, axs1, axs2, axs3, axs4, axs5, axs6, axs7

    t_min        = 120 
    t_array      = data['time']['rel']
    UTorange     = '#FF8200' 
    SmokeyGray   = '#58595B'
    LadyVolsBlue = '#0CA4DC'

    if data['time']['rel'][-1] > t_min:
        # time
        t_array = t_array[-t_min:]

        # mass flow rates
        mass_flow_left = data['tank1']['mdot'][-t_min:]
        mass_flow_right = data['tank2']['mdot'][-t_min:]
        mass_flow_center = data['pump']['mdot'][-t_min:]
        # tank 1
        tank_1_setpoint = data['tank1']['level']['m'][-t_min:]
        tank_1_measurement = data['tank1']['level']['m'][-t_min:]
        # tank 2
        tank_2_setpoint = data['tank2']['level']['m'][-t_min:]
        tank_2_measurement = data['tank2']['level']['m'][-t_min:]
        # cv 1
        cv1_setpoint = data['cv1']['sp'][-t_min:]
        cv1_measurement = data['cv1']['m'][-t_min:]
        # cv 2
        cv2_setpoint = data['cv2']['sp'][-t_min:]
        cv2_measurement = data['cv2']['m'][-t_min:]
        # res
        res_setpoint = data['res']['sp'][-t_min:]
        res_measurement = data['res']['m'][-t_min:]
        # leak
        leak_setpoint = data['leak']['sp'][-t_min:]
        leak_measurement = data['leak']['m'][-t_min:]

    else: 
        mass_flow_left = data['tank1']['mdot']
        mass_flow_right = data['tank2']['mdot']
        mass_flow_center = data['pump']['mdot']
        tank_1_setpoint = data['tank1']['level']['m']
        tank_1_measurement = data['tank1']['level']['m']
        tank_2_setpoint = data['tank2']['level']['m']
        tank_2_measurement = data['tank2']['level']['m']
        cv1_setpoint = data['cv1']['sp']
        cv1_measurement = data['cv1']['m']
        cv2_setpoint = data['cv2']['sp']
        cv2_measurement = data['cv2']['m']
        res_setpoint = data['res']['sp']
        res_measurement = data['res']['m']
        leak_setpoint = data['leak']['sp']
        leak_measurement = data['leak']['m']

    # Update the plots
    axs1.clear()
    axs1.plot(t_array, mass_flow_left, label='Left', color=UTorange)
    axs1.plot(t_array, mass_flow_right, label='Right', color=SmokeyGray)
    axs1.plot(t_array, mass_flow_center, label='Center', color=LadyVolsBlue)
    axs1.set_title('Mass Flow Rates')
    axs1.set_ylabel('kg/s')
    axs1.legend(loc='upper left')

    axs2.clear()
    axs2.plot(t_array, tank_1_setpoint, label='Set Point', color=LadyVolsBlue)
    axs2.plot(t_array, tank_1_measurement, label='Measurement', color=UTorange)
    axs2.set_title('Left Tank Height')
    axs2.set_ylabel('% Full')
    axs2.legend(loc='upper left')
    # axs2.set_ylim(-5, 105)

    axs3.clear()
    axs3.plot(t_array, tank_2_setpoint, label='Set Point', color=LadyVolsBlue)
    axs3.plot(t_array, tank_2_measurement, label='Measurement', color=UTorange)
    axs3.set_title('Right Tank Height')
    axs3.set_ylabel('% Full')
    axs3.legend(loc='upper left')
    # axs3.set_ylim(-5, 105)

    axs4.clear()
    axs4.plot(t_array, cv1_setpoint, label='Set Point', color=LadyVolsBlue)
    axs4.plot(t_array, cv1_measurement, label='Measurement', color=UTorange)
    axs4.set_title('Control Valve #1 Position') 
    axs4.set_ylabel('% open') 
    axs4.legend(loc='upper left') 
    # axs4.set_ylim(-5, 105)

    axs5.clear()
    axs5.plot(t_array, cv2_setpoint, label='Set Point', color=LadyVolsBlue)
    axs5.plot(t_array, cv2_measurement, label='Measurement', color=UTorange)
    axs5.set_title('Control Valve #2 Position') 
    axs5.set_ylabel('% open') 
    axs5.legend(loc='upper left') 
    # axs5.set_ylim(-5, 105)

    # axs6.clear()
    # # axs6.plot(t_array, actuator_degradation_valve, color=SmokeyGray)
    # if np.average(actuator_degradation_valve) == 100:
    #     axs6.plot(t_array, actuator_degradation_valve, color='green')
    # else:
    #     axs6.plot(t_array, actuator_degradation_valve, color='red')
    # axs6.set_title('Actuator Degradation Valve Openness')
    # axs6.set_ylabel('% open')
    # axs6.set_ylim(-5, 105)

    axs6.clear()
    axs6.plot(t_array, res_setpoint, label='Set Point', color=LadyVolsBlue)
    axs6.plot(t_array, res_measurement, label='Measurement', color=UTorange)
    axs6.set_title('Resistance Degradation Valve Position') 
    axs6.set_ylabel('% open') 
    axs6.legend(loc='upper left') 
    # axs6.set_ylim(-5, 105)

    # axs7.clear()Plotting
    # if np.average(leak_valve) == 0:
    #     axs7.plot(t_array, leak_valve, color='green')
    # else:
    #     axs7.plot(t_array, leak_valve, color='red')
    # axs7.set_title('Leak Valve Openness')
    # axs7.set_ylabel('% open')
    # axs7.set_ylim(-5, 105)

    axs7.clear()
    axs7.plot(t_array, leak_setpoint, label='Set Point', color=LadyVolsBlue)
    axs7.plot(t_array, leak_measurement, label='Measurement', color=UTorange)
    axs7.set_title('Leak Valve Position') 
    axs7.set_ylabel('% open') 
    axs7.legend(loc='upper left') 
    # axs7.set_ylim(-5, 105)

    plt.tight_layout(pad=2)
    plt.draw()
    plt.pause(0.01)
# use the step_finished callback to stop the simulation at pause_time
def step_finished(time, recorder):
    """ Callback function that is called after every step """
    return time < pause_time

def runFMU(start_time, fmu_instance, fmu_state):
    """ Run FMU for a single time step """
    # Run simulation for the current time step
    results = simulate_fmu(filename=settings['filename'],
                           start_time=start_time,
                           stop_time=start_time + step_time,
                           solver='Euler',
                           output_interval=step_time,
                           input=get_FMU_inputs(),
                           output=settings['outputs'],
                           fmu_instance=fmu_instance,
                           fmu_state=fmu_state,
                           terminate=False,
                           step_finished=step_finished,
                           debug_logging=True)
    
    # Retrieve the FMU state after simulation
    fmu_state = fmu_instance.getFMUState() 
    
    return results, fmu_state

def get_FMU_inputs():
    # Call this function to get the most up to date valve setpoints
    # dtype is to satisfy the FMU reader
    # Inputs are in the following order:
    # ['cv1_sp', 'cv2_sp', 'res_sp', 'leak_sp']
    dtype = [('cv1_sp', np.double), ('cv2_sp', np.double), ('res_sp', np.double), ('leak_sp', np.double)]
    inputs = np.array((data['cv1']['sp'][-1], data['cv2']['sp'][-1], data['res']['sp'][-1], data['leak']['sp'][-1]), dtype=dtype)
    return inputs

def process_FMU_data(results):
    # Process the 9 output variables into their respective dictionaries 
    # Order + names of ouputs: ['mdot_pump', 'mdot_t1', 'mdot_t2', ...
    # 't1_level', 't2_level', 'cv1_m', 'cv2_m', 'res_m', 'leak_m']
    data['tank1']['mdot'].append(results['mdot_t1'][-1])
    data['tank2']['mdot'].append(results['mdot_t2'][-1])
    data['pump']['mdot'].append(results['mdot_pump'][-1])

    data['tank1']['level']['m'].append(results['t1_level'][-1])
    data['tank2']['level']['m'].append(results['t2_level'][-1])

    data['cv1']['m'].append(results['cv1_m'][-1])
    data['cv2']['m'].append(results['cv2_m'][-1])
    data['res']['m'].append(results['res_m'][-1])
    data['leak']['m'].append(results['leak_m'][-1])

    data['time']['abs'].append(time.time())
    data['time']['rel'].append(time.time()-data['time']['abs'][0])

def controller(t1_sp, t2_sp):
    # in place of a real PID / MPC controller 
    # input the desired setpoints for tank 1 and 2
    # CV positions are returned
    cv1_sp = 1
    cv2_sp = 1
    new_cv_sps = [cv1_sp, cv2_sp]
    return new_cv_sps


print("Functions Read \n")
#%% DATA ARCHITECTURE + FMU LOADING
CV_1_setpoint = 1
CV_2_setpoint = 1
resistance_setpoint = 1
leak_setpoint = 0

data = {'time':     {'abs': [], 'rel': []},
        'cv1':      {'m': [], 'sp': []},
        'cv2':      {'m': [], 'sp': []},
        'res':      {'m': [], 'sp': []},
        'leak':     {'m': [], 'sp': []},
        'tank1':    {'level': {'m': [], 'sp': []},
                     'mdot': []},
        'tank2':    {'level': {'m': [], 'sp': []},
                     'mdot': []},
        'pump':     {'mdot': []}}

print('Data Structure Set\n')


# Get the current directory
current_directory = os.getcwd()

# Go two steps back
for _ in range(2):
    current_directory = os.path.dirname(current_directory)

# Navigate to "models/FMUs"; os.getcwd() = current directory 
new_directory = os.path.join(current_directory, "Models", "FMUs")

# Change the current working directory
os.chdir(new_directory)
print("Current directory:", os.getcwd())

# Get the list of files in the current directory
files_in_current_directory = os.listdir()

# Print the list of files
print("Files in the current directory:")
for file in files_in_current_directory:
    print(file)



# define which FMU file you will be running
fmu_path = new_directory + "\FISHTANK_w_degs_v2.fmu" 
fmuInputs = [] 
fmuOutputs = [] 

print('\nFMU locked and loaded\n')


if __name__ == "__main__":
    print('STARTING if __name__ == __main__')

    data['time']['abs'].append(time.time())
    data['time']['rel'].append(0)

    data['cv1']['m'].append(0)
    data['cv1']['sp'].append(1)

    data['cv2']['m'].append(0)
    data['cv2']['sp'].append(1)

    data['res']['m'].append(0) 
    data['res']['sp'].append(1)

    data['leak']['m'].append(0) 
    data['leak']['sp'].append(0)

    data['tank1']['level']['m'].append(0) 
    data['tank1']['level']['sp'].append(0) 
    data['tank1']['mdot'].append(0) 

    data['tank2']['level']['m'].append(0) 
    data['tank2']['level']['sp'].append(0) 
    data['tank2']['mdot'].append(0) 

    data['pump']['mdot'].append(0) 

    fig = plt.figure(figsize=(18, 15))
    gs = GridSpec(6, 2, figure=fig)

    axs1 = fig.add_subplot(gs[:2, :])
    axs1.set_title('Mass Flow Rates')
    axs1.set_ylabel('kg/s')
    # Plot 2: Left Tank Height
    axs2 = fig.add_subplot(gs[2:4, 0])
    axs2.set_title('Left Tank Height')
    axs2.set_ylabel('% Full')
    # Plot 3: Right Tank Height
    axs3 = fig.add_subplot(gs[2:4, 1])
    axs3.set_title('Right Tank Height')
    axs3.set_ylabel('% Full')
    # Plot 4: Left Control Valve
    axs4 = fig.add_subplot(gs[4, 0])
    axs4.set_title('Left Control Valve')
    axs4.set_ylabel('% open')
    # Plot 5: Right Control Valve
    axs5 = fig.add_subplot(gs[4, 1])
    axs5.set_title('Right Control Valve')
    axs5.set_ylabel('% open')
    # Plot 6: Actuator Degradation Valve Openness
    axs6 = fig.add_subplot(gs[5, 0])
    axs6.set_title('Actuator Degradation Valve Openness')
    axs6.set_ylabel('% open')
    # Plot 7: Leak Valve Openness
    axs7 = fig.add_subplot(gs[5, 1])
    axs7.set_title('Leak Valve Openness')
    axs7.set_ylabel('% open')

    plt.tight_layout(pad=2)
    print('Plot Initialized \n')

    # get the FMU file name
    fmu_filename = fmu_path

    # read and dump the FMU file
    dump(fmu_filename)
    model_description = read_model_description(fmu_filename)

    unzipdir = extract(fmu_filename)

    # instantiate the FMU before simulating it, so we can keep it alive
    fmu_instance = instantiate_fmu(
        unzipdir=unzipdir,
        model_description=model_description,
    )

    # Initialize FMU state
    fmu_state = fmu_instance.getFMUState()

    # # Initialize FMU
    # initialize_fmu(fmu_instance)

    # gather and print info for inputs + outputs
    for variable in model_description.modelVariables:
        if variable.causality == 'input':
            fmuInputs.append(variable.name)
        if variable.causality == 'output':
            fmuOutputs.append(variable.name)

    print("Correct variable input names")
    print("FMU Input variable list is ", fmuInputs)
    print("FMU Output variable list is ", fmuOutputs)


    #############################
    # define runtime parameters #
    #############################
    step_time  = 0.2           # time between FMU outputted data points (indiv. simulation lengths)
    start_time = 0              # Start time of the FMU in s
    stop_time  = 5000           # Stop time of the FMU in s
    pause_time = 1              # Initial pause time in s

    settings = {
                'filename':unzipdir,
                'start_time':start_time,
                'stop_time':stop_time,
                'output_interval':step_time, 
                'outputs':fmuOutputs
                }

    results = simulate_fmu(filename=settings['filename'],
                        start_time=settings['start_time'],
                        output_interval=settings['output_interval'],
                        input=get_FMU_inputs(),
                        output=settings['outputs'],
                        fmu_instance=fmu_instance,
                        fmu_state=fmu_state,
                        terminate=False,
                        step_finished=step_finished,
                        debug_logging=False)
                            
    # Log the results of the FMU for the initial run 
    # process_FMU_data(results)
    # print('initial results:\n', results)

    # retrieve the FMU state
    fmu_state = fmu_instance.getFMUState()
    start_time = pause_time

    # results = {}

    print("FMU ran for initial time, now starting primary loop.\n")


    try:
        print('Starting Loop \n')
        i = 0
        last_update_time = 0
        while True:
            # every 20 seconds, caluclate a new setpoint for the two control valves
            if data['time']['rel'][-1] - last_update_time >= 30:
                # calculate new random variables
                CV_1_setpoint = random.randint(5, 95) / 100
                CV_2_setpoint = random.randint(5, 95) / 100
                # Update the last update time
                last_update_time = data['time']['rel'][-1]
            
            # Add current valve setpoints to the data set
            data['cv1']['sp'].append(CV_1_setpoint)
            data['cv2']['sp'].append(CV_2_setpoint)
            data['res']['sp'].append(resistance_setpoint)
            data['leak']['sp'].append(leak_setpoint)

            # Add A JUNK zero sp for both tanks
            data['tank1']['level']['sp'].append(0) 
            data['tank2']['level']['sp'].append(0) 

            # Grab most recent valve positions from the data set, auto-formatted for running FMU
            inputs = get_FMU_inputs()
            print("inputs:\n", inputs, "\n")


            # truncate start time to 2 decimals
            start_time = round(start_time, 3)
            # Advance the pause time
            pause_time = start_time + step_time 

            # run FMU
            results, fmu_state = runFMU(start_time, fmu_instance, fmu_state)

            process_FMU_data(results)

            print('Start time = ', start_time, "results = ", results)

            start_time += step_time

            update_plot(data) 
            time.sleep(.01)
            i += 1

    except KeyboardInterrupt:
        # Clean up

        # GPIO.cleanup()

        print("\n*********\ngame over\n*********\n")

        plt.ioff()  # Turn off interactive mode
        plt.show()
        
# %%
