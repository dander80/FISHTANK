import functions as FISH
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.gridspec import GridSpec
import time 
import board
import busio
import adafruit_mcp4728
import Jetson.GPIO as GPIO
from ads1015 import ADS1015


# DAC initialization commands
i2c = busio.I2C(board.SCL, board.SDA)
mcp4728 = adafruit_mcp4728.MCP4728(i2c)

# ADC initialization commands




CV_1_setpoint = np.ones(1000)
CV_1_setpoint = np.ones(1000)
resistance_setpoint = np.ones(1000)
leak_setpoint = np.zeros(1000)



if __name__ == "__main__":

    i = 0
    
    try:
        while True:
        
        FISH.set_DAC(mcp4728, CV_1_setpoint[i], CV_2_setpoint[i], resistance_setpoint[i], leak_setpoint[i])
        time.sleep(0.5)
        i += 1

    except KeyboardInterrupt:
        GPIO.cleanup()
        print("\n*********\ngame over\n*********\n")

        plt.ioff()  # Turn off interactive mode
        plt.show()
