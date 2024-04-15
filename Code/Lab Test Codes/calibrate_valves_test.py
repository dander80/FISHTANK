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
print("ADC Initialized; Found: {}".format(chip_type), "\n")


def set_DAC(mcp4728, Vref, pinA, pinB, pinC, pinD):
    # Set DAC values
    # Enter PIN values as a PERCENTAGE
    mcp4728.channel_a.value = int(Vref * pinA/100)
    mcp4728.channel_b.value = int(Vref * pinB/100)
    mcp4728.channel_c.value = int(Vref * pinC/100)
    mcp4728.channel_d.value = int(Vref * pinD/100)

def read_ADC(ads1015, Vref = 3.3):
    # Read values from ADC
    # Returns array containing percentages of Vref 
    # (i.e., 1.65V in while Vref=3.3V --> 50)
    
    channel_a = ads1015.get_voltage(channel="in0/gnd") * 100 / Vref
    channel_b = ads1015.get_voltage(channel="in1/gnd") * 100 / Vref
    channel_c = ads1015.get_voltage(channel="in2/gnd") * 100 / Vref
    channel_d = ads1015.get_voltage(channel="in3/gnd") * 100 / Vref

    return([channel_a, channel_b, channel_c, channel_d]) 

print("OG Functions Read \n")




# def calibrate_valves(mcp4728, ads1015):






if __name__ == "__main__":

    #looooooop
    print('set valves closed (0 V)')
    mcp4728.channel_a.value = int(0)
    mcp4728.channel_b.value = int(0)
    mcp4728.channel_c.value = int(0)
    mcp4728.channel_d.value = int(0)
    time.sleep(60)

    print('valve should be closed')
    min_CV1_value  = ads1015.get_voltage(channel="in0/gnd")
    min_CV2_value  = ads1015.get_voltage(channel="in1/gnd")
    min_res_value  = ads1015.get_voltage(channel="in2/gnd")
    min_leak_value = ads1015.get_voltage(channel="in3/gnd")

    print('open valves to max')
    mcp4728.channel_a.value = int(65535)
    mcp4728.channel_b.value = int(65535)
    mcp4728.channel_c.value = int(65535)
    mcp4728.channel_d.value = int(65535)

    time.sleep(60)


    print('valve should be open')
    max_CV1_value  = ads1015.get_voltage(channel="in0/gnd")
    max_CV2_value  = ads1015.get_voltage(channel="in1/gnd")
    max_res_value  = ads1015.get_voltage(channel="in2/gnd")
    max_leak_value = ads1015.get_voltage(channel="in3/gnd")



    print('min CV1:', min_CV1_value)
    print('max CV1:', max_CV1_value)

    print('min CV2:', min_CV1_value)
    print('max CV2:', max_CV1_value)

    print('min res:', min_res_value)
    print('max res:', max_res_value)

    print('min leak:', min_leak_value)
    print('max leak:', max_leak_value)

    