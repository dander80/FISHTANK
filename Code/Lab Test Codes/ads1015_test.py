import time
from ads1015 import ADS1015

CHANNELS = ["in0/gnd", "in1/gnd", "in2/gnd", "in3/gnd"] 
GAINS = [1, 1, 1, 3.3/2.048]
print(
    """read-all.py - read all four inputs of the ADC

Press Ctrl+C to exit!
"""
)

ads1015 = ADS1015()
chip_type = ads1015.detect_chip_type()

print("Found: {}".format(chip_type))

ads1015.set_mode("single")
ads1015.set_programmable_gain(2.048)

if chip_type == "ADS1015":
    ads1015.set_sample_rate(1600)
else:
    ads1015.set_sample_rate(860)

reference = ads1015.get_reference_voltage()


print("Reference voltage: {:6.3f}v \n".format(reference))

# print(ads1015.get_voltage(channel="in0/gnd")) # 
# print(ads1015.get_voltage(channel="in1/gnd"))
# print(ads1015.get_voltage(channel="in2/gnd")) # 
# print(ads1015.get_voltage(channel="in3/gnd")) # 1

# print(CHANNELS[0])

try:
    while True:
        # print(ads1015.get_voltage(channel="in0/in1"), "......", ads1015.get_voltage(channel="in2/in3"))
        print(ads1015.get_voltage(channel="in3/gnd"))
        time.sleep(0.5)

except KeyboardInterrupt:
    pass


