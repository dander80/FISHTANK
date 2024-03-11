import Jetson.GPIO as GPIO
import time

def count_callback_1(channel):
    global count_1 
    count_1 += 1

def count_callback_2(channel):
    global count_2
    count_2 += 1

flow_sensor_pin_1 = 7 
flow_sensor_pin_2 = 11
start_time = time.time()
GPIO.setmode(GPIO.BOARD)
GPIO.setup(flow_sensor_pin_1, GPIO.IN) 
GPIO.setup(flow_sensor_pin_2, GPIO.IN) 

if __name__ == "__main__": 
    global count_1
    global count_2
    try:
        while True: 
            count_1 = 0
            count_2 = 0
            GPIO.add_event_detect(flow_sensor_pin_1, GPIO.FALLING, count_callback_1, bouncetime=20)
            GPIO.add_event_detect(flow_sensor_pin_2, GPIO.FALLING, count_callback_2, bouncetime=20)
            t_diff = time.time() - start_time 
            
            print(int(t_diff), count_1, count_2)

            GPIO.remove_event_detect(flow_sensor_pin_1)
            GPIO.remove_event_detect(flow_sensor_pin_2)
            # time.sleep(0.05)

    except KeyboardInterrupt:
        GPIO.cleanup()
        print("\n*********\ngame over\n*********\n")
