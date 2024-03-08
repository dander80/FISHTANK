import functions as FISH
import numpy as np 
import time 
import board
import busio
import adafruit_mcp4728
from ads1015 import ADS1015

ads1015 = ADS1015()


# Initialize I2C bus
i2c = busio.I2C(board.SCL, board.SDA)

# Initialize MCP4728 DAC
mcp4728 = adafruit_mcp4728.MCP4728(i2c)

FISH.read_ADC()

if __name__ == "__main__":
    # GPIO.setmode(GPIO.BOARD)
    # GPIO.setup(flow_sensor_pin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
    # GPIO.add_event_detect(flow_sensor_pin, GPIO.FALLING, callback=flow_pulse_counter, bouncetime=50)

    # # Pin assignment for the flowmeter
    # ch_flwmtr_t1 = 11

    # # Setup the GPIO pin as input
    # GPIO.setup(ch_flwmtr_t1, GPIO.IN)
    # plt.ion()  # Turn on interactive mode
    # fig, ax = plt.subplots()
    # line, = ax.plot([], [])
    
    try:
        while True:
            # start_time = time.time()
            # loop()
            # end_time = old_time
            # t_diff = (end_time - start_time)
            
            # if t_diff < 1/refresh_rate:
            #     time.sleep(1/refresh_rate - t_diff)
            # else:
            #     print("t_diff = ",  t_diff)
            
            # time_array.append(start_time - og_start) 
            # # new_y = np.random.rand() * 10  # Random y-value
            # update_plot()

    except KeyboardInterrupt:
        # GPIO.cleanup()
        print("\n*********\ngame over\n*********\n")

        # plt.ioff()  # Turn off interactive mode
        # plt.show()