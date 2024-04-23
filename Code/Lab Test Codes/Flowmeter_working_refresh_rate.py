import Jetson.GPIO as GPIO
import time

# Flow Sensor:
flow_sensor_pin = 15  # flow sensor attached to pin 6 (pin must also be an interrupt ("int") pin)
flow_calibration_factor = 0.2  # Note: F=(0.2*Q)±2% for this flow sensor, Q=L/Min, and F is pulse freq in 1/s
flow_pulse_count = 0
old_time = 0

refresh_rate = 10 # Hz

def loop():
    flow_rate = read_flow_rate()
    print("Flow: ", flow_rate)


def read_flow_rate():
    global old_time, flow_pulse_count
    flow_rate_gph = 0.0
    A = time.time()
    if (time.time() - old_time) > 0.9/refresh_rate:
        B = time.time()
        # print("AB =", A-B) 
        GPIO.remove_event_detect(flow_sensor_pin, timeout=0.5/refresh_rate)  # Disable the interrupt while calculating flow rate
        C = time.time()
        # print("BC = ", B-C) 
        flow_rate_gph = (1000.0 / (time.time() - old_time)) * flow_pulse_count / flow_calibration_factor * 15.8503
        D = time.time()
        # print("CD = ", C-D)
        # Scale to frequency (pulses per second) and convert to flow rate 1 LPM = 15.8503 gph
        old_time = time.time()  # Reset the reading clock
        flow_pulse_count = 0  # Reset the pulse counter so we can start incrementing again
        GPIO.add_event_detect(flow_sensor_pin, GPIO.FALLING, callback=flow_pulse_counter, bouncetime=20, polltime=0.2/refresh_rate)  # Enable interrupt again
        E = time.time()
        # print('DE = ', D-E, "\n")
    return flow_rate_gph  # Return the flow rate for this reading


def flow_pulse_counter(channel):
    global flow_pulse_count
    flow_pulse_count += 1


if __name__ == "__main__":
    GPIO.setmode(GPIO.BOARD)
    GPIO.setup(flow_sensor_pin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
    GPIO.add_event_detect(flow_sensor_pin, GPIO.FALLING, callback=flow_pulse_counter, bouncetime=2)

    # Pin assignment for the flowmeter
    ch_flwmtr_t1 = 11

    # Setup the GPIO pin as input
    GPIO.setup(ch_flwmtr_t1, GPIO.IN)
    try:
        while True:
            start_time = time.time()
            loop()
            end_time = time.time()
            t_diff = (end_time - start_time)
            if t_diff < 1/refresh_rate:
                time.sleep(1/refresh_rate - t_diff)
                print(t_diff)
            else:
                print("t_diff = ",  t_diff)
    except KeyboardInterrupt:
        GPIO.cleanup()
