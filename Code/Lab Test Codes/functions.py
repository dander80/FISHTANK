import board
import busio
import adafruit_mcp4728
import Jetson.GPIO as GPIO
from ads1015 import ADS1015
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.gridspec import GridSpec 

#*********************************************************************#
##################### Analog to Digital Converter #####################
#*********************************************************************#

def read_ADC(ads1015, gain=2.048):

    ads1015.set_mode("single")
    ads1015.set_programmable_gain(gain)

    channel_a = ads1015.get_voltage(channel="in0/gnd")
    channel_b = ads1015.get_voltage(channel="in1/gnd")
    channel_c = ads1015.get_voltage(channel="in2/gnd")
    channel_d = ads1015.get_voltage(channel="in3/gnd")

    return(channel_a, channel_b, channel_c, channel_d)

#*********************************************************************#
##################### Digital to Analog Converter #####################
#*********************************************************************#

def set_DAC(mcp4728, pinA, pinB, pinC, pinD):
    # Set DAC values
    mcp4728.channel_a.value = int(65535 * pinA)
    mcp4728.channel_b.value = int(65535 * pinB)
    mcp4728.channel_c.value = int(65535 * pinC)
    mcp4728.channel_d.value = int(65535 * pinD)

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
def update_plot():
    global t_array, mass_flow_left, mass_flow_right, mass_flow_center, \
    tank_height_left_setpoint, tank_height_left_measurement, \
    tank_height_right_setpoint, tank_height_right_measurement, \
    left_control_valve, right_control_valve, actuator_degradation_valve, \
    leak_valve, t_min

    UTorange = '#FF8200' 
    SmokeyGray = '#58595B'
    LadyVolsBlue = '#0CA4DC'

    if len(t_array) > t_min:
        t_array = t_array[-t_min:]
        mass_flow_left = mass_flow_left[-t_min:]
        mass_flow_right = mass_flow_right[-t_min:]
        mass_flow_center = mass_flow_center[-t_min:]
        tank_height_left_setpoint = tank_height_left_setpoint[-t_min:]
        tank_height_left_measurement = tank_height_left_measurement[-t_min:]
        tank_height_right_setpoint = tank_height_right_setpoint[-t_min:]
        tank_height_right_measurement = tank_height_right_measurement[-t_min:]
        left_control_valve = left_control_valve[-t_min:]
        right_control_valve = right_control_valve[-t_min:]
        actuator_degradation_valve = actuator_degradation_valve[-t_min:]
        leak_valve = leak_valve[-t_min:]

    # Update the plots
    axs1.clear()
    axs1.plot(t_array, mass_flow_left, label='Left', color=UTorange)
    axs1.plot(t_array, mass_flow_right, label='Right', color=SmokeyGray)
    axs1.plot(t_array, mass_flow_center, label='Center', color=LadyVolsBlue)
    axs1.set_title('Mass Flow Rates')
    axs1.set_ylabel('kg/s')
    axs1.legend(loc='upper left')

    axs2.clear()
    axs2.plot(t_array, tank_height_left_setpoint, label='Set Point', color=LadyVolsBlue)
    axs2.plot(t_array, tank_height_left_measurement, label='Measurement', color=UTorange)
    axs2.set_title('Left Tank Height')
    axs2.set_ylabel('% Full')
    axs2.legend(loc='upper left')
    axs2.set_ylim(-5, 105)

    axs3.clear()
    axs3.plot(t_array, tank_height_right_setpoint, label='Set Point', color=LadyVolsBlue)
    axs3.plot(t_array, tank_height_right_measurement, label='Measurement', color=UTorange)
    axs3.set_title('Right Tank Height')
    axs3.set_ylabel('% Full')
    axs3.legend(loc='upper left')
    axs3.set_ylim(-5, 105)

    axs4.clear()
    axs4.plot(t_array, left_control_valve, color=SmokeyGray)
    axs4.set_title('Left Control Valve')
    axs4.set_ylabel('% open')
    axs4.set_ylim(-5, 105)

    axs5.clear()
    axs5.plot(t_array, right_control_valve, color=SmokeyGray)
    axs5.set_title('Right Control Valve')
    axs5.set_ylabel('% open')
    axs5.set_ylim(-5, 105)

    axs6.clear()
    # axs6.plot(t_array, actuator_degradation_valve, color=SmokeyGray)
    if np.average(actuator_degradation_valve) == 100:
        axs6.plot(t_array, actuator_degradation_valve, color='green')
    else:
        axs6.plot(t_array, actuator_degradation_valve, color='red')
    axs6.set_title('Actuator Degradation Valve Openness')
    axs6.set_ylabel('% open')
    axs6.set_ylim(-5, 105)

    axs7.clear()
    if np.average(leak_valve) == 0:
        axs7.plot(t_array, leak_valve, color='green')
    else:
        axs7.plot(t_array, leak_valve, color='red')
    axs7.set_title('Leak Valve Openness')
    axs7.set_ylabel('% open')
    axs7.set_ylim(-5, 105)

    plt.tight_layout()
    plt.draw()

