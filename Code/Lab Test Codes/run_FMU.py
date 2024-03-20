print('This code is running a FMU model of the FISHTANK System')
print('Valve positions are inputted to the FMU, the resulting')
print('tank levels and mass flow rates are returned and plotted')

from __future__ import division, print_function, unicode_literals, absolute_import
import os
from fmpy import simulate_fmu, read_model_description, extract, dump, instantiate_fmu, read_csv, write_csv
import fmpy
import functions as FISH
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.gridspec import GridSpec
import time 
import random 
import board
import busio
import adafruit_mcp4728
import Jetson.GPIO as GPIO
from ads1015 import ADS1015

print("Packages loaded in successfully\n")

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

def runFMU(inputs, fmu_state, start_time):
    """ Run fmu every time step """
    results = simulate_fmu(filename=settings['filename'],
                           start_time=start_time,
                           stop_time=start_time+step_time,
                           output_interval=step_time,
                           input = get_inputs(),
                           output=settings['outputs'],
                           fmu_instance=fmu_instance,
                           fmu_state=fmu_state,
                           terminate=False,
                           step_finished=step_finished,
                           debug_logging=False)
    # retrieve the FMU state
    fmu_state = fmu_instance.getFMUState()
    return results, fmu_state

print("Functions Read \n")

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

file_name = 'run_FMU.py'
mypath = os.path.dirname(os.path.abspath(file_name))

# define which FMU file you will be running
fmu_path = "/Users/davidanderson/skoo/URSI/FMUs/simple_rxt_lookup.fmu" 
fmuInputs = []
fmuOutputs = [] 

if __name__ == "__main__":
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


    dtype = [('drum_angle_1', np.double), ('drum_angle_2', np.double)]

    inputs = np.array((received_inputs['drum1']['values'][-1], received_inputs['drum2']['values'][-1]), dtype=dtype)

    inputs = get_inputs()

    settings = {
                'filename':unzipdir,
                'start_time':start_time,
                'stop_time':stop_time,
                'output_interval':step_time, 
                'outputs':fmuOutputs
                }

    # Run the FMU for an initial time until pause time
    results = simulate_fmu(filename=settings['filename'],
                            start_time=settings['start_time'],
                            output_interval=settings['output_interval'],
                            input=get_inputs(),
                            output=settings['outputs'],
                            fmu_instance=fmu_instance,
                            terminate=False,
                            step_finished=step_finished,
                            debug_logging=False)
    
    # Log the results of the FMU for the initial run 
    # After this point, the FMU output gets sent to the MQTT broker (allows for weird transient to pass)
    resultSummary = results 

    # process_data saves the data and sents it to MQTT
    process_data(topic_output, {'output_dollars':resultSummary['output_dollars'][-1], 'output_dollars_2':resultSummary['output_dollars_2'][-1]})
    
    # retrieve the FMU state
    fmu_state = fmu_instance.getFMUState()
    start_time = pause_time
    print("FMU ran for initial time, now starting primary loop.")

    # While loop to run the FMU with a predefined timestep
    while start_time <= stop_time - 2 * step_time:
        inputs = np.array((received_inputs['drum1']['values'][-1], received_inputs['drum2']['values'][-1]), dtype=dtype)
        # truncate start time to 2 decimals
        start_time = round(start_time, 3)
        # Advance the pause time
        pause_time = start_time + step_time 
        # run FMU
        resultsApp, fmu_state = runFMU(inputs, fmu_state, start_time)
        resultsApp = resultsApp[0:]
        # publish 
        process_data(topic_output, {'output_dollars':resultsApp['output_dollars'][-1], 'output_dollars_2':resultsApp['output_dollars_2'][-1]})
        print('Start time = ', start_time, "input = ", get_inputs(), "results = ", resultsApp)
        # Append the results every time step
        resultSummary = np.concatenate((resultSummary, np.expand_dims(resultsApp[-1], axis=0)))
        # Advance the start time
        start_time += step_time
        time.sleep(.1)


    print("The FMU will terminate in 1 time step.")
    results = simulate_fmu(filename=settings['filename'],
                        start_time=round(start_time, 2),
                        stop_time=settings['stop_time'],
                        output_interval=step_time,
                        input=np.array((received_inputs['drum1']['values'][-1], received_inputs['drum2']['values'][-1]), dtype=dtype),
                        output=settings['outputs'],
                        fmu_instance=fmu_instance,
                        fmu_state=fmu_state,
                        terminate=True,
                        debug_logging=False)

    # Log the results of the FMU for the final run 
    process_data(topic_output, {'output_dollars':results['output_dollars'][-1], 'output_dollars_2':results['output_dollars_2'][-1]})
    resultSummary = np.concatenate((resultSummary, np.expand_dims(resultsApp[-1], axis=0)))
    
    # combine and output the results to a csv file
    # write_csv(os.path.join(mypath, '..', 'output','fmu_results.csv'), resultSummary, columns=None)
    print("Simulation finished")