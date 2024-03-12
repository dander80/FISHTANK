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

print("packages loaded in successfully\n")

# DAC initialization commands
i2c = busio.I2C(board.SCL, board.SDA)
mcp4728 = adafruit_mcp4728.MCP4728(i2c)
print("DAC Initialized\n")


# ADC initialization commands
ads1015 = ADS1015()
chip_type = ads1015.detect_chip_type()
print("Found: {}".format(chip_type))
ads1015.set_mode("single")
ads1015.set_programmable_gain(2.048)
print("ADC Initialized; Found: {}".format(chip_type))



CV_1_setpoint = np.ones(1000) * 0.5
CV_2_setpoint = np.ones(1000) * 0.5
resistance_setpoint = np.ones(1000) * 0.5
leak_setpoint = np.ones(1000) * 0.5

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

if __name__ == "__main__":

    init_valve_pos = FISH.read_ADC(ads1015) # cv1, cv2, res, leak 

    data['time']['abs'].append(time.time())
    data['time']['rel'].append(0)

    data['cv1']['m'].append(init_valve_pos[0])
    data['cv1']['sp'].append(0.5)

    data['cv2']['m'].append(init_valve_pos[1])
    data['cv2']['sp'].append(0.5)

    data['res']['m'].append(init_valve_pos[2]) 
    data['res']['sp'].append(0.5)

    data['leak']['m'].append(init_valve_pos[3]) 
    data['leak']['sp'].append(0.5)

    data['tank1']['level']['m'].append(0) 
    data['tank1']['level']['sp'].append(0) 
    data['tank1']['mdot'].append(np.random.normal(0.3, 0.01, 1)) 

    data['tank2']['level']['m'].append(0) 
    data['tank2']['level']['sp'].append(0) 
    data['tank2']['mdot'].append(np.random.normal(0.3, 0.01, 1)) 

    data['pump']['mdot'].append(np.random.normal(0.6, 0.02, 1)) 

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
    # Display 
    print('a')
    plt.tight_layout(pad=2)

    print('plot initialized')

    # plt.ion()
    # axs1, axs2, axs3, axs4, axs5, axs6, axs7 = FISH.init_plot(fig, gs)

    # plt.show()

    try:
        print('start')
        i = 0
        while True:
            # Update time 
            data['time']['abs'].append(time.time())
            data['time']['rel'].append(time.time()-data['time']['abs'][0])

            # FAKE mass flow rates
            data['tank1']['mdot'].append(np.random.normal(0.3, 0.01, 1))
            data['tank2']['mdot'].append(np.random.normal(0.3, 0.01, 1))
            data['pump']['mdot'].append(np.random.normal(0.6, 0.02, 1))
            
            # FAKE tank levels
            data['tank1']['level']['m'].append(0) 
            data['tank1']['level']['sp'].append(0) 
            data['tank2']['level']['m'].append(0) 
            data['tank2']['level']['sp'].append(0) 

            # read in values from ADC 
            cur_valve_pos = FISH.read_ADC(ads1015) # cv1, cv2, res, leak 
            # append values to data
            data['cv1']['m'].append(cur_valve_pos[0])
            data['cv2']['m'].append(cur_valve_pos[1])
            data['res']['m'].append(cur_valve_pos[2])
            data['leak']['m'].append(cur_valve_pos[3])

            # controller calculation here: recieve the variables CV_1_setpoint[i], CV_2_setpoint[i], resistance_setpoint[i], leak_setpoint[i]
            FISH.set_DAC(mcp4728, CV_1_setpoint[i], CV_2_setpoint[i], resistance_setpoint[i], leak_setpoint[i])
            data['cv1']['sp'].append(CV_1_setpoint[i])
            data['cv2']['sp'].append(CV_2_setpoint[i])
            data['res']['sp'].append(resistance_setpoint[i])
            data['leak']['sp'].append(leak_setpoint[i])
            
            print('ab to update plot')

            FISH.update_plot(data, axs1, axs2, axs3, axs4, axs5, axs6, axs7)
            # plt.show()
            # time.sleep(1.0)
            print(data['time']['rel'][i])
            i += 1

    except KeyboardInterrupt:
        GPIO.cleanup()
        print("\n*********\ngame over\n*********\n")

        plt.ioff()  # Turn off interactive mode
        plt.show()
