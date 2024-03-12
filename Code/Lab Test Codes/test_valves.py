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
    data['tank1']['mdot'].append(0) 

    data['tank2']['level']['m'].append(0) 
    data['tank2']['level']['sp'].append(0) 
    data['tank2']['mdot'].append(0) 

    data['pump']['mdot'].append(0) 

    fig, gs, axs1, axs2, axs3, axs4, axs5, axs6, axs7 = FISH.init_plot()

    try:
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

            FISH.update_plot(data, axs1, axs2, axs3, axs4, axs5, axs6, axs7)

            time.sleep(1.0)
            i += 1

    except KeyboardInterrupt:
        GPIO.cleanup()
        print("\n*********\ngame over\n*********\n")

        plt.ioff()  # Turn off interactive mode
        plt.show()
