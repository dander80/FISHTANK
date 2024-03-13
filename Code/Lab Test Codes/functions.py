import board
import busio
import adafruit_mcp4728
import random 
import Jetson.GPIO as GPIO
from ads1015 import ADS1015
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.gridspec import GridSpec 

#*********************************************************************#
##################### Analog to Digital Converter #####################
#*********************************************************************#

def read_ADC(ads1015):
    Vref = 5
    # read values from ADC
    channel_a = ads1015.get_voltage(channel="in0/gnd") * 100 / Vref
    channel_b = ads1015.get_voltage(channel="in1/gnd") * 100 / Vref
    channel_c = ads1015.get_voltage(channel="in2/gnd") * 100 / Vref
    channel_d = ads1015.get_voltage(channel="in3/gnd") * 100 / Vref

    return([channel_a, channel_b, channel_c, channel_d]) 

#*********************************************************************#
##################### Digital to Analog Converter #####################
#*********************************************************************#

def set_DAC(mcp4728, pinA, pinB, pinC, pinD):
    # Set DAC values
    mcp4728.channel_a.value = int(65535 * pinA/100)
    mcp4728.channel_b.value = int(65535 * pinB/100)
    mcp4728.channel_c.value = int(65535 * pinC/100)
    mcp4728.channel_d.value = int(65535 * pinD/100)

#*********************************************************************#
############################## Flowmeter ##############################
#*********************************************************************#


#*********************************************************************#
################################ Relay ################################
#*********************************************************************#

# may not be necessary 

#*********************************************************************#
############################## Plotting ###############################
#*********************************************************************#
def init_plot(fig, gs):
    # Plot 1: Mass Flow Rates
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
    # Display 
    plt.tight_layout(pad=2)
    # plt.draw()
    return axs1, axs2, axs3, axs4, axs5, axs6, axs7

def update_plot(data, axs1, axs2, axs3, axs4, axs5, axs6, axs7): 

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
    axs4.set_ylim(-5, 105)

    axs5.clear()
    axs5.plot(t_array, cv2_setpoint, label='Set Point', color=LadyVolsBlue)
    axs5.plot(t_array, cv2_measurement, label='Measurement', color=UTorange)
    axs5.set_title('Control Valve #2 Position') 
    axs5.set_ylabel('% open') 
    axs5.legend(loc='upper left') 
    axs5.set_ylim(-5, 105)

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
    axs6.set_ylim(-5, 105)

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
    axs7.set_ylim(-5, 105)

    plt.tight_layout(pad=2)
    plt.draw()

#*********************************************************************#
############################## Valve Grab Data ###############################
#*********************************************************************#
def valve_test_grab_data(data):
    # FAKE mass flow rates
    data['tank1']['mdot'].append(np.random.normal(0.3, 0.01, 1))
    data['tank2']['mdot'].append(np.random.normal(0.3, 0.01, 1))
    data['pump']['mdot'].append(np.random.normal(0.6, 0.02, 1))
    
    # mass_flow_left = np.append(mass_flow_left, np.random.normal(0.3, 0.01, 1))
    # mass_flow_right = np.append(mass_flow_right, np.random.normal(0.3, 0.01, 1))
    # mass_flow_center = np.append(mass_flow_center, np.random.normal(0.6, 0.02, 1))

    # FAKE tank levels
    data['tank1']['level']['m'].append(0) 
    data['tank1']['level']['sp'].append(0) 
    data['tank2']['level']['m'].append(0) 
    data['tank2']['level']['sp'].append(0) 

    # old tank sp codes
    # left_sp = (np.cos(t_array[-1]/10)+1)*40
    # tank_height_left_setpoint = np.append(tank_height_left_setpoint, left_sp) 
    # tank_height_left_measurement = np.append(tank_height_left_measurement, left_sp + np.random.uniform(-3, 3, 1))
    # if t_array[-1] - last_update_time >= 20:
    #     # Update right_sp with a new random integer between 30 and 90
    #     right_sp = random.randint(30, 90)
    #     # Update the last update time
    #     last_update_time = t_array[-1]
    # tank_height_right_setpoint = np.append(tank_height_right_setpoint, right_sp)
    # tank_height_right_measurement = np.append(tank_height_right_measurement, right_sp + np.random.uniform(-3, 3, 1))

    ################## REAL DATA ##################

    data['cv1']['m'].append()
    data['cv1']['sp'].append()

    data['cv2']['m'].append()
    data['cv2']['sp'].append()

    data['res']['m'].append()
    data['res']['sp'].append()

    data['leak']['m'].append()
    data['leak']['sp'].append()

    return data 
