import matplotlib.pyplot as plt
import numpy as np
from matplotlib.gridspec import GridSpec
import time 
import random 

# Function to grab new random data
def grab_data(): 
    global t_array, mass_flow_left, mass_flow_right, mass_flow_center, \
        tank_height_left_setpoint, tank_height_left_measurement, \
        tank_height_right_setpoint, tank_height_right_measurement, \
        left_control_valve, right_control_valve, actuator_degradation_valve, \
        leak_valve, last_update_time, right_sp
    
    mass_flow_left = np.append(mass_flow_left, np.random.normal(0.3, 0.04, 1))
    mass_flow_right = np.append(mass_flow_right, np.random.normal(0.3, 0.04, 1))
    mass_flow_center = np.append(mass_flow_center, np.random.normal(0.6, 0.06, 1))

    # tank_height_left_setpoint = np.append(tank_height_left_setpoint, np.random.uniform(0, 100, 1))
    # tank_height_left_measurement = np.append(tank_height_left_measurement, np.random.uniform(0, 100, 1))
    left_sp = (np.cos(t_array[-1]/10)+1)*40
    tank_height_left_setpoint = np.append(tank_height_left_setpoint, left_sp) 
    tank_height_left_measurement = np.append(tank_height_left_measurement, left_sp + np.random.uniform(-3, 3, 1))

    # if t_array[-1] > 0 and t_array[-1] < 40:
    #     right_sp = 80
    # elif t_array[-1] > 40 and t_array[-1] < 80:
    #     right_sp = 90
    # elif t_array[-1] > 80 and t_array[-1] < 120:
    #     right_sp = 80
    # elif t_array[-1] > 120 and t_array[-1] < 160:
    #     right_sp = 70
    # elif t_array[-1] > 120 and t_array[-1] < 180:
    #     right_sp = 95
    # else:
    #     right_sp = 80

    if t_array[-1] - last_update_time >= 20:
        # Update right_sp with a new random integer between 30 and 90
        right_sp = random.randint(30, 90)
        
        # Update the last update time
        last_update_time = t_array[-1]
    
    tank_height_right_setpoint = np.append(tank_height_right_setpoint, right_sp)
    tank_height_right_measurement = np.append(tank_height_right_measurement, right_sp + np.random.uniform(-3, 3, 1))

    left_control_valve = np.append(left_control_valve, left_sp)
    right_control_valve = np.append(right_control_valve, right_sp) 

    actuator_degradation_valve = np.append(actuator_degradation_valve, 100) 
    leak_valve = np.append(leak_valve, 0) 

# Function to update the plot
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
    plt.pause(0.01)


if __name__ == "__main__":
    global t_array, mass_flow_left, mass_flow_right, mass_flow_center, \
    tank_height_left_setpoint, tank_height_left_measurement, \
    tank_height_right_setpoint, tank_height_right_measurement, \
    left_control_valve, right_control_valve, actuator_degradation_valve, \
    leak_valve, last_update_time, right_sp 

    # Initial data generation
    last_update_time = 0
    t_min = 120 
    t_array = np.arange(0, 0, 1) 
    mass_flow_left = np.zeros(len(t_array))
    mass_flow_right = np.zeros(len(t_array))
    mass_flow_center = np.zeros(len(t_array))
    tank_height_left_setpoint = np.zeros(len(t_array))
    tank_height_left_measurement = np.zeros(len(t_array))
    tank_height_right_setpoint = np.zeros(len(t_array))
    tank_height_right_measurement = np.zeros(len(t_array))
    left_control_valve = np.zeros(len(t_array))
    right_control_valve = np.zeros(len(t_array))
    actuator_degradation_valve = np.zeros(len(t_array))
    leak_valve = np.zeros(len(t_array))
    right_sp = random.randint(30, 90)

    # Create GridSpec
    fig = plt.figure(figsize=(18, 15))
    gs = GridSpec(6, 2, figure=fig)

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

    plt.tight_layout(pad=2)

    try:
        curr_time = 0
        # Continuous update of data and plot
        while True:
            curr_time += 1
            t_array = np.append(t_array, curr_time)
            grab_data()
            update_plot()
    except KeyboardInterrupt:

        print("\n*********\ngame over\n*********\n")

        plt.ioff()  # Turn off interactive mode
        plt.close()