#%% PACKAGES + NOTES
print('This code is running a FMU model of the FISHTANK System')
print('Valve positions are inputted to the FMU, the resulting')
print('tank levels and mass flow rates are returned and plotted\n')

print("model exchange --> use FMpy as the solver ")
print('co-simulation --> use Dymola solver\n')


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
    axs2.set_ylim(-5, 105)

    axs3.clear()
    axs3.plot(t_array, tank_2_setpoint, label='Set Point', color=LadyVolsBlue)
    axs3.plot(t_array, tank_2_measurement, label='Measurement', color=UTorange)
    axs3.set_title('Right Tank Height')
    axs3.set_ylabel('% Full')
    axs3.legend(loc='upper left')
    axs3.set_ylim(-5, 105)

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

# def runFMU(inputs, fmu_state, start_time):
#     """ Run fmu every time step """
#     results = simulate_fmu(filename=settings['filename'],
#                            start_time=start_time,
#                            stop_time=start_time+step_time,
#                            solver='Euler',
#                            output_interval=step_time,
#                            input = get_FMU_inputs(),
#                            output=settings['outputs'],
#                            fmu_instance=fmu_instance,
#                            fmu_state=fmu_state,
#                            terminate=False,
#                            step_finished=step_finished,
#                            debug_logging=False)
#     # retrieve the FMU state
#     fmu_state = fmu_instance.getFMUState()
#     return results, fmu_state

def runFMU(start_time, step_time, fmu_instance, fmu_state):
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
                           debug_logging=False)
    
    # Retrieve the FMU state after simulation
    fmu_state = fmu_instance.getFMUState()
    
    return results, fmu_state

def get_FMU_inputs():
    dtype = [('cv1_pos', np.double), ('cv2_pos', np.double), ('res_pos', np.double), ('lead_pos', np.double)]

    # inputs = [data['cv1']['sp'][-1], data['cv2']['sp'][-1], data['res']['sp'][-1], data['leak']['sp'][-1]]

    inputs = np.array((data['cv1']['sp'][-1], data['cv2']['sp'][-1], data['res']['sp'][-1], data['leak']['sp'][-1]), dtype=dtype)

    # ['cv1_pos', 'cv2_pos', 'res_pos', 'lead_pos']
    return inputs

def process_FMU_data(results):
    # ['mdot_pump', 'mdot_t1', 'mdot_t2', 't1_level', 't2_level']
    mdot_t1 = results[0]
    mdot_t2 = results[1]
    mdot_pump = results[2]
    t1_level = results[3]
    t2_level = results[4]
    data['tank1']['mdot'].append(mdot_t1)
    data['tank2']['mdot'].append(mdot_t2)
    data['pump']['mdot'].append(mdot_pump)
    data['tank1']['level']['m'].append(t1_level) 
    data['tank2']['level']['m'].append(t2_level) 


print("Functions Read \n")
#%% DATA ARCHITECTURE + FMU LOADING
CV_1_setpoint = 1
CV_2_setpoint = 1
resistance_setpoint = 1
leak_setpoint = 1

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
fmu_path = new_directory + "\FISHTANK_w_degs.fmu" 
fmuInputs = [] 
fmuOutputs = [] 

print('\nFMU locked and loaded\n')


if __name__ == "__main__":
    print('STARTING if __name__ == __main__')

    data['time']['abs'].append(time.time())
    data['time']['rel'].append(0)

    data['cv1']['m'].append(0)
    data['cv1']['sp'].append(0.5)

    data['cv2']['m'].append(0)
    data['cv2']['sp'].append(0.5)

    data['res']['m'].append(0) 
    data['res']['sp'].append(0.5)

    data['leak']['m'].append(0) 
    data['leak']['sp'].append(0.5)

    data['tank1']['level']['m'].append(0) 
    data['tank1']['level']['sp'].append(0) 
    data['tank1']['mdot'].append(np.random.normal(0.3, 0.01, 1)) 

    data['tank2']['level']['m'].append(0) 
    data['tank2']['level']['sp'].append(0) 
    data['tank2']['mdot'].append(np.random.normal(0.3, 0.01, 1)) 

    data['pump']['mdot'].append(np.random.normal(0.6, 0.02, 1)) 

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
    step_time  = 0.02           # time between FMU outputted data points (indiv. simulation lengths)
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

    # Run the FMU for an initial time until pause time
    # results = simulate_fmu(filename=settings['filename'],
    #                         start_time=settings['start_time'],
    #                         output_interval=settings['output_interval'],
    #                         input=get_FMU_inputs(),
    #                         output=settings['outputs'],
    #                         fmu_instance=fmu_instance,
    #                         terminate=False,
    #                         step_finished=step_finished,
    #                         debug_logging=False)

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
    process_FMU_data(results)
    print('initial results:\n', results)
    # retrieve the FMU state
    fmu_state = fmu_instance.getFMUState()
    start_time = pause_time
    print("FMU ran for initial time, now starting primary loop.\n")

    # While loop to run the FMU with a predefined timestep
    while start_time <= stop_time - 2 * step_time:
        print("Going into primary loop")
        inputs = get_FMU_inputs()
        print("inputs:\n", inputs)
        # truncate start time to 2 decimals
        start_time = round(start_time, 3)
        # Advance the pause time
        pause_time = start_time + step_time 
        # run FMU
        # resultsApp, fmu_state = runFMU(inputs, fmu_state, start_time)

        results, fmu_state = runFMU(start_time, step_time, fmu_instance, fmu_state)


        # print("resultsApp shape = ", resultsApp) 
        # resultsApp = resultsApp[0:]
        # publish 
        process_FMU_data(resultsApp[-1])
        print('Start time = ', start_time, "input = ", get_FMU_inputs(), "results = ", resultsApp)
        # # Append the results every time step
        # resultSummary = np.concatenate((resultSummary, np.expand_dims(resultsApp[-1], axis=0)))
        # Advance the start time
        start_time += step_time
        time.sleep(.1)


    print("The FMU will terminate in 1 time step.")
    results = simulate_fmu(filename=settings['filename'],
                        start_time=round(start_time, 2),
                        stop_time=settings['stop_time'],
                        output_interval=step_time,
                        input=get_FMU_inputs(),
                        output=settings['outputs'],
                        fmu_instance=fmu_instance,
                        fmu_state=fmu_state,
                        terminate=True,
                        debug_logging=False)

    # Log the results of the FMU for the final run 
    process_FMU_data(results)
    # process_data(topic_output, {'output_dollars':results['output_dollars'][-1], 'output_dollars_2':results['output_dollars_2'][-1]})
    # resultSummary = np.concatenate((resultSummary, np.expand_dims(resultsApp[-1], axis=0)))
    
    # combine and output the results to a csv file
    # write_csv(os.path.join(mypath, '..', 'output','fmu_results.csv'), resultSummary, columns=None)
    print("Simulation finished")
# %%
